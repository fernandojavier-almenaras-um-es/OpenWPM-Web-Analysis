from typing import Any, Dict, List, Set
from analyzers.dynamic_analyzer import Dynamic_Analyzer, parseArguments


class CanvasFont(Dynamic_Analyzer):
    
    @staticmethod
    def fingerprinting_type() -> str:
        return "Canvas Font"
    
    def _classify(self) -> int:
        return len( self.__fonts ) >= 50 and ( max(self.__textMeasured.values(), default=0) >= 50 )

    def _reset(self) -> None:
        # condition 1
        self.__fonts : Set[str] = set()
        # condition 2
        self.__textMeasured : Dict[str, int] = dict()

    def _read_row(self, row : Any) -> None:
        parsedArguments: List[Any] = parseArguments(row["arguments"])
        try:
            match row["symbol"]:
                case 'CanvasRenderingContext2D.font':
                    if row["operation"] == 'set' and row["value"]:
                        self.__fonts.add(row["value"])

                case 'CanvasRenderingContext2D.measureText':
                    if row["operation"] == 'call' and len(parsedArguments) > 0:
                        if parsedArguments[0] in self.__textMeasured:
                            self.__textMeasured[parsedArguments[0]] += 1
                        else:
                            self.__textMeasured[parsedArguments[0]] = 1

                case _:
                    pass

        except Exception as e:
            self.logger.exception(f"Found Exception {e}, row: {row}") 