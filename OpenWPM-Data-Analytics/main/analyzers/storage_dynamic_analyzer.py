
from abc import abstractmethod
import json
from sqlalchemy import text, CursorResult
from typing import Any, List, Tuple, Union

from analyzers.analyzer import Analyzer
from utils.engine import SingletonEngine

"""
Abstract Base Class for all storage dynamic analyzers

See parent class 'Analyzer' for method descriptions
"""
class Storage_Dynamic_Analyzer(Analyzer):
    
    @staticmethod
    def analyser_query() -> CursorResult[Any] | None:
        with SingletonEngine.get_engine().connect() as conn:
            return conn.execute(text("""
                SELECT visit_id, script_url, top_level_url, localStorage, sessionStorage, indexedDB
                FROM (
                    SELECT visit_id, script_url, top_level_url, COUNT(symbol) AS localStorage
                    FROM JAVASCRIPT
                    WHERE symbol == "window.localStorage"
                    GROUP BY visit_id, script_url, top_level_url
                )
                JOIN (
                    SELECT visit_id, script_url, top_level_url, COUNT(symbol) AS sessionStorage
                    FROM JAVASCRIPT
                    WHERE symbol == "window.sessionStorage"
                    GROUP BY visit_id, script_url, top_level_url
                ) USING (visit_id, script_url, top_level_url)
                JOIN (
                    SELECT visit_id, script_url, top_level_url, COUNT(symbol) AS indexedDB
                    FROM JAVASCRIPT
                    WHERE symbol == "window.indexedDB"
                    GROUP BY visit_id, script_url, top_level_url
                ) USING (visit_id, script_url, top_level_url)
                ORDER BY visit_id, script_url, top_level_url ASC
            """))

    def analysis_domain_size(self) -> int:
        with self.engine.connect() as conn:
            query_response: CursorResult[Tuple[int]] = conn.execute(text("""
                SELECT COUNT(*)
                FROM (
                    SELECT visit_id, script_url, top_level_url, localStorage, sessionStorage, indexedDB
                    FROM (
                        SELECT visit_id, script_url, top_level_url, COUNT(symbol) AS localStorage
                        FROM JAVASCRIPT
                        WHERE symbol == "window.localStorage"
                        GROUP BY visit_id, script_url, top_level_url
                    )
                    JOIN (
                        SELECT visit_id, script_url, top_level_url, COUNT(symbol) AS sessionStorage
                        FROM JAVASCRIPT
                        WHERE symbol == "window.sessionStorage"
                        GROUP BY visit_id, script_url, top_level_url
                    ) USING (visit_id, script_url, top_level_url)
                    JOIN (
                        SELECT visit_id, script_url, top_level_url, COUNT(symbol) AS indexedDB
                        FROM JAVASCRIPT
                        WHERE symbol == "window.indexedDB"
                        GROUP BY visit_id, script_url, top_level_url
                    ) USING (visit_id, script_url, top_level_url)
                )
            """))
        return query_response.__next__().tuple()[0]

    def analysis_domain(self) ->  List[ Tuple[str,str,str] ]:
        with self.engine.connect() as conn:
            query_response: CursorResult[Tuple[str,str,str]]= conn.execute(text("""
                SELECT DISTINCT visit_id, script_url, top_level_url
                FROM (
                    SELECT visit_id, script_url, top_level_url, COUNT(symbol) AS localStorage
                    FROM JAVASCRIPT
                    WHERE symbol == "window.localStorage"
                    GROUP BY visit_id, script_url, top_level_url
                )
                JOIN (
                    SELECT visit_id, script_url, top_level_url, COUNT(symbol) AS sessionStorage
                    FROM JAVASCRIPT
                    WHERE symbol == "window.sessionStorage"
                    GROUP BY visit_id, script_url, top_level_url
                ) USING (visit_id, script_url, top_level_url)
                JOIN (
                    SELECT visit_id, script_url, top_level_url, COUNT(symbol) AS indexedDB
                    FROM JAVASCRIPT
                    WHERE symbol == "window.indexedDB"
                    GROUP BY visit_id, script_url, top_level_url
                ) USING (visit_id, script_url, top_level_url)
            """))
        return [ tuple(row) for row in query_response.fetchall()]

    def _analyze(self) -> List[ Tuple[str,str,str,int] ]:
        self._reset()
        results : List[ Tuple[str,str,str,int] ] = []
        previous : Union[ Tuple[str,str,str], None]  = None
        for row in self.precalculated_query.mappings(): # type: ignore
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
    