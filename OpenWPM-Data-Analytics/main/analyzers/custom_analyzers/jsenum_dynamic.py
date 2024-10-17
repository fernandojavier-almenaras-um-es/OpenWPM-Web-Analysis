from typing import Any, Set, List
from analyzers.dynamic_analyzer import Dynamic_Analyzer


class JSEnum(Dynamic_Analyzer):

    PROPERTIES : List[str] = [
        "window.name",
        "window.localStorage",
        "window.sessionStorage",
        "window.indexedDB"
        "window.devicePixelRatio",
        "window.openDatabase",
        "window.matchMedia",
        "window.history",
        "window.performance",
        "window.crypto.subtle",
        "window.screen.pixelDepth",
        "window.screen.colorDepth",
        "window.Notification.permission"
    ] # 13

    PROPERTIES_STARTS_WITH : List[str] = [
        "window.navigator",         # 44
        "window.Intl",              # 11
        "window.performance.timing" # 22
    ] # 77

    @staticmethod
    def fingerprinting_type() -> str:
        return "JSEnum"
    
    def _classify(self) -> int:
        return len(self.__found) >= ( (13 + 77) / 8 )

    def _reset(self) -> None :
        self.__found : Set[str] = set()

    def _read_row(self, row : Any) -> None:
        try:
            if self.PROPERTIES.__contains__(row["symbol"]):
                self.__found.add(row["symbol"])

            else:
                for prop in self.PROPERTIES_STARTS_WITH:
                    if row["symbol"].startswith(prop):
                        self.__found.add(row["symbol"])
                        
        except Exception as e:
            self.logger.exception(f"Found Exception {e}, row: {row}") 