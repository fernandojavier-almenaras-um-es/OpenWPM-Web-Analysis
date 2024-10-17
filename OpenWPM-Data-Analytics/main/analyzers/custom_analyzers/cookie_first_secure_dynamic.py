from typing import Any, Set
from analyzers.cookie_dynamic_analyzer import Cookie_Dynamic_Analyzer
from utils.grep_utils import isFirstParty


class CookieFirstPartySecure(Cookie_Dynamic_Analyzer):
    
    @staticmethod
    def fingerprinting_type() -> str:
        return "Cookie FirstParty Secure"

    def _classify(self) -> int:
        return len(self.__secure)

    def _reset(self) -> None :
        self.__secure : Set[str] = set()

    def _read_row(self, row : Any) -> None:
        #parsedArguments: List[Any] = parseArguments(row["arguments"])
        try:
            if isFirstParty(row["script_url"], row["top_level_url"]):
                if row["is_http_only"] == 1 or row["is_secure"] == 1:
                    self.__secure.add(row["name"])

        except Exception as e:
            self.logger.exception(f"Found Exception {e}, row: {row}")