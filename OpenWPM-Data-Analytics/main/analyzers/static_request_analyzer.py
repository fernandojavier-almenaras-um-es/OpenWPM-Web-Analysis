from abc import abstractmethod
from sqlalchemy import text, CursorResult
from typing import Any, List, Set, Tuple

from analyzers.analyzer import Analyzer

"""
Abstract Base Class for all static request analyzers

See parent class 'Analyzer' for method descriptions
"""
class Static_Requests_Analyzer(Analyzer):

    def analyser_query(self) -> CursorResult[Any]:
        return super().analyser_query()

    def analysis_domain_size(self) -> int:
        with self.engine.connect() as conn:
            query_response: CursorResult[Tuple[int]] = conn.execute(text("""
                SELECT COUNT(*)
                FROM (
                    SELECT DISTINCT visit_id, url AS script_url, top_level_url
                    FROM HTTP_REQUESTS
                )
            """))
        return query_response.__next__().tuple()[0]
    
    def analysis_domain(self) ->  List[ Tuple[str,str,str] ]:
        with self.engine.connect() as conn:
            query_response: CursorResult[Tuple[str,str,str]] = conn.execute(text("""
                SELECT DISTINCT visit_id, url AS script_url, top_level_url
                FROM HTTP_REQUESTS
            """))
        return [ tuple(row) for row in query_response.fetchall()]

    def _analyze(self) -> List[ Tuple[str,str,str,int] ]:
        results : List[ Tuple[str,str, str, int] ] = []
        domains : Set[str] = set()

        for entry in self.analysis_domain():  # type: ignore
            if not domains.__contains__(entry[2]):
                result: int = int(self._analyze_one(entry))
                if result > 0:
                    self.logger.info(f"{entry} \n\tUsing: {self.fingerprinting_type()} \n\tVia: {self.analysis_name()}")
                    results.append(entry + (result,))
                    domains.add(entry[2])
        
        return results



    @abstractmethod
    def _analyze_one(self,entry : Tuple[str,str,str]) -> int:
        """
        Given a database key entry
        return's True if doing the fingerprinting_type, False if not
        """
        pass


    

    