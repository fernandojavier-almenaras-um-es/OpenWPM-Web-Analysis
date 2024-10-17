from typing import Any, List, Set
from analyzers.dynamic_analyzer import Dynamic_Analyzer, parseArguments


class Canvas(Dynamic_Analyzer):
    
    @staticmethod
    def fingerprinting_type() -> str:
        return "Canvas"
    
    def _classify(self) -> int:
        return ( self.__heightORwidthTooSmall or self.__hidden ) and \
        ( len(self.__colors) > 2 or self.__textLenght or self.__rect) and \
        self.__extraction

    def _reset(self) -> None:
        # condition 1
        self.__heightORwidthTooSmall : bool = False
        self.__hidden : bool = False
        # condition 2
        self.__colors : Set[str] = set()
        self.__textLenght : bool = False
        self.__rect : bool = False
        # condition 3
        self.__extraction : bool = False

    def _read_row(self, row : Any) -> None:
        parsedArguments: List[Any] = parseArguments(row["arguments"])
        try:
            match row["symbol"]:
                case 'HTMLCanvasElement.height':
                    if row["operation"] == 'set' and row["value"]:
                        self.__heightORwidthTooSmall |= int(row["value"]) <= 16
                        
                case 'HTMLCanvasElement.width':
                    if row["operation"] == 'set' and row["value"]:
                        self.__heightORwidthTooSmall |= int(row["value"]) <= 16

                case 'HTMLCanvasElement.setAttribute':
                    if row["operation"] == "call" and parsedArguments[1] == "visibility:hidden":
                        self.__hidden = True

                case 'CanvasRenderingContext2D.fillText' | 'CanvasRenderingContext2D.strokeText':
                    if row["operation"] == 'call' and len(parsedArguments) >= 1:
                        self.__textLenght |= len(parsedArguments[0]) > 10

                case 'CanvasRenderingContext2D.fillStyle':
                    if row["operation"] == 'set' and row["value"]:
                        self.__colors.add(row["value"])

                case 'CanvasRenderingContext2D.fillRect' | 'CanvasRenderingContext2D.rect':
                    if row["operation"] == 'call' and len(parsedArguments) >= 4:
                        self.__rect = True

                case 'HTMLCanvasElement.toDataURL' | 'HTMLCanvasElement.toBlob':
                    self.__extraction = True

                case 'CanvasRenderingContext2D.getImageData':
                    if row["operation"] == 'call' and len(parsedArguments) >= 4:
                        if abs( int(parsedArguments[2]) ) <= 16 and abs( int(parsedArguments[3]) ) <= 16:
                            self.__extraction = True

                case _:
                    pass

        except Exception as e:
            self.logger.exception(f"Found Exception {e}, row: {row}")