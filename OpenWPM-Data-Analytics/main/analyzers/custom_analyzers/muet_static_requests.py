from typing import List, Set, Tuple
from analyzers.static_request_analyzer import Static_Requests_Analyzer
from utils.grep_utils import grepForKeywords


class MicrosoftUET(Static_Requests_Analyzer):

    KEYWORDS : List[str] = [
        # bing
        "bing\\.net/.",
        # clarity
        "clarity\\.ms/.",
    ]

    @staticmethod
    def fingerprinting_type() -> str:
        return "Microsoft UET"
    
    def _analyze_one(self, entry: Tuple[str,str,str]) -> int:
        results: Set[str] = grepForKeywords(self.KEYWORDS, entry[1], escaped=True) 

        return bool(results)