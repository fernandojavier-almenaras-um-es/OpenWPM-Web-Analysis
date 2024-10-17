from typing import Any
from analyzers.dynamic_analyzer import Dynamic_Analyzer


class SessionStorage(Dynamic_Analyzer):

    @staticmethod
    def fingerprinting_type() -> str:
        return "Session Storage"
    
    def _classify(self) -> int:
        return self.__found

    def _reset(self) -> None :
        self.__found : int = 0

    def _read_row(self, row : Any) -> None:
        try:
            if row["symbol"] == "window.sessionStorage":
                self.__found += 1

        except Exception as e:
            self.logger.exception(f"Found Exception {e}, row: {row}") 