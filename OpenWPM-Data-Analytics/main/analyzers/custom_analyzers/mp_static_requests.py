from typing import List, Set, Tuple
from analyzers.static_request_analyzer import Static_Requests_Analyzer
from utils.grep_utils import grepForKeywords


class MetaPixel(Static_Requests_Analyzer):

    EVENTS : List[str] = [
        "AddPaymentInfo",
        "AddToCart",
        "AddToWishlist",
        "CompleteRegistration",
        "Contact",
        "CustomizeProduct",
        "Donate",
        "FindLocation",
        "InitiateCheckout",
        "Lead",
        "PageView",
        "Purchase",
        "Schedule",
        "Search",
        "StartTrial",
        "SubmitApplication",
        "Subscribe",
        "ViewContent"
    ]

    EVENTS_OR_EXPANDED : str = '|'.join(EVENTS)

    KEYWORDS : List[str] = [
        # facebook
        f"facebook\\.(com|net)/tr/?\\?id=[^&]*\\&ev=({EVENTS_OR_EXPANDED})",
    ]

    @staticmethod
    def fingerprinting_type() -> str:
        return "Meta Pixel"
    
    def _analyze_one(self, entry: Tuple[str,str,str]) -> int:
        results: Set[str] = grepForKeywords(self.KEYWORDS, entry[1], escaped=True) 

        return bool(results)