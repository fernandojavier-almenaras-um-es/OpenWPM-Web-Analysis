from typing import Any, Set
from analyzers.cookie_dynamic_analyzer import Cookie_Dynamic_Analyzer
from utils.grep_utils import isFirstParty


class CookieFirstPartySession(Cookie_Dynamic_Analyzer):
    
    @staticmethod
    def fingerprinting_type() -> str:
        return "Cookie FirstParty Session"

    def _classify(self) -> int:
        return len(self.__session)

    def _reset(self) -> None :
        self.__session : Set[str] = set()


    def _read_row(self, row : Any) -> None:
        #parsedArguments: List[Any] = parseArguments(row["arguments"])
        try:
            if isFirstParty(row["script_url"], row["top_level_url"]) and row["is_session"] == 1:
                self.__session.add(row["name"])

        except Exception as e:
            self.logger.exception(f"Found Exception {e}, row: {row}")