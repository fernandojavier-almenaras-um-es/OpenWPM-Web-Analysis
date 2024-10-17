
from abc import abstractmethod
import json
from sqlalchemy import text, CursorResult
from typing import Any, List, Tuple, Union

from analyzers.analyzer import Analyzer
from utils.engine import SingletonEngine

"""
Abstract Base Class for all cookies dynamic analyzers

See parent class 'Analyzer' for method descriptions
"""
class Cookie_Dynamic_Analyzer(Analyzer):

    def analyser_query(self) -> CursorResult[Any]:
        with SingletonEngine.get_engine().connect() as conn:
            return conn.execute(text(f"""
                SELECT JAVASCRIPT_COOKIES.visit_id, JAVASCRIPT_COOKIES.host AS script_url, JAVASCRIPT.top_level_url, SUM(JAVASCRIPT_COOKIES.is_host_only) AS host_only, SUM(JAVASCRIPT_COOKIES.is_http_only) AS http_only, SUM(JAVASCRIPT_COOKIES.is_secure) AS secure, SUM(JAVASCRIPT_COOKIES.is_session) as session
                FROM JAVASCRIPT_COOKIES
                JOIN JAVASCRIPT ON JAVASCRIPT.visit_id = JAVASCRIPT_COOKIES.visit_id
                GROUP BY JAVASCRIPT_COOKIES.visit_id, JAVASCRIPT_COOKIES.host, JAVASCRIPT.top_level_url
                ORDER BY JAVASCRIPT_COOKIES.visit_id, JAVASCRIPT_COOKIES.host, JAVASCRIPT.top_level_url, JAVASCRIPT.event_ordinal ASC
            """))

    def analysis_domain_size(self) -> int:
        with self.engine.connect() as conn:
            query_response: CursorResult[Tuple[int]] = conn.execute(text(f"""
                SELECT COUNT(*)
                FROM (
                    SELECT JAVASCRIPT_COOKIES.visit_id, JAVASCRIPT_COOKIES.host AS script_url, JAVASCRIPT.top_level_url
                    FROM JAVASCRIPT_COOKIES
                    JOIN JAVASCRIPT ON JAVASCRIPT.visit_id = JAVASCRIPT_COOKIES.visit_id
                )
            """))
        return query_response.__next__().tuple()[0]

    def analysis_domain(self) ->  List[ Tuple[str,str,str] ]:
        with self.engine.connect() as conn:
            query_response: CursorResult[Tuple[str,str,str]]= conn.execute(text(f"""
                SELECT DISTINCT JAVASCRIPT_COOKIES.visit_id, JAVASCRIPT_COOKIES.host AS script_url, JAVASCRIPT.top_level_url
                FROM JAVASCRIPT_COOKIES
                JOIN JAVASCRIPT ON JAVASCRIPT.visit_id = JAVASCRIPT_COOKIES.visit_id
            """))
        return [ tuple(row) for row in query_response.fetchall()]

    def _analyze(self) -> List[ Tuple[str,str,str,int] ]:
        self._reset()
        results : List[ Tuple[str,str,str,int] ] = []
        
        previous : Union[ Tuple[str,str,str], None]  = None
        for row in self.analyser_query().mappings(): # type: ignore
            id: Tuple[str, str, str]  = (row["visit_id"], row["script_url"], row["top_level_url"])
            if(previous == None):
                previous = id
            elif( previous != id ):
                result: int = int(self._classify())
                if result > 0:
                    self.logger.info(f"{previous} \n\tUsing: {self.fingerprinting_type()} ({result}) \n\tVia: {self.analysis_name()}")
                    results.append(previous + (result,))
                self._reset()
                previous = id
            self._read_row(row)
        if previous != None:
            result: int = int(self._classify())
            if result > 0:
                self.logger.info(f"{previous} \n\tUsing: {self.fingerprinting_type()} ({result}) \n\tVia: {self.analysis_name()}")
                results.append(previous + (result,))
        self._reset()
        return results

    @abstractmethod
    def _classify(self) -> int:
        """
        Based on the row's read via '_read_row' since the last call to '_reset',
        return's True if doing the fingerprinting_type, False if not
        """
        pass

    @abstractmethod
    def _reset(self) -> None:
        """
        reset any stored classification data from '_read_row' calls
        """
        pass

    @abstractmethod
    def _read_row(self, row : Any) -> None:
        """
        read a row from the 'javascript' table, stores needed information to later classify
        """
        pass



def parseArguments(arguments : None | str) -> List[Any]:
    """
    Parse a string from the 'arguments' column of the 'javascript' SQL table
    This value represents the list of arguments passed a JavaScript function
    """
    if arguments is None:
        return []
    return json.loads(arguments)
    