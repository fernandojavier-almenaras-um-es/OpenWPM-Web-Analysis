from typing import Any, List
from analyzers.dynamic_analyzer import Dynamic_Analyzer, parseArguments
import re

class WebGL(Dynamic_Analyzer):

    CANVAS_REGEX : re.Pattern[str] = re.compile('webgl2?')

    @staticmethod
    def fingerprinting_type() -> str:
        return "WebGL"
    
    def _classify(self) -> int:
        return self.__parameter or self.__extensions or self.__attr or \
        ( self.__isCanvas and self.__canvasExtraction ) or \
        self.__extraction

    def _reset(self) -> None:
        # case 1
        self.__parameter : bool = False
        # case 2
        self.__extensions : bool = False
        # case 3
        self.__attr : bool = False
        # case 4
        self.__isCanvas : bool = False
        self.__canvasExtraction : bool = False
        # case 5
        self.__extraction : bool = False

    def _read_row(self, row : Any) -> None:
        parsedArguments: List[Any] = parseArguments(row["arguments"])
        try:
            match row["symbol"]:
                case 'WebGLRenderingContext.getParameter' | 'WebGL2RenderingContext.getParameter':
                    if row["operation"] == 'call' and len(parsedArguments) >= 1 and ( parsedArguments[0] == 37445 or parsedArguments[0] == 37446):
                        self.__parameter = True

                case 'WebGLRenderingContext.getSupportedExtensions' | 'WebGL2RenderingContext.getSupportedExtensions' | \
                    'WebGLRenderingContext.getExtension' | 'WebGL2RenderingContext.getExtension':
                    self.__extensions = True

                case 'WebGLRenderingContext.getContextAttributes' | 'WebGL2RenderingContext.getContextAttributes':
                    self.__attr = True

                case 'HTMLCanvasElement.getContext':
                    if row["operation"] == 'call' and len(parsedArguments) >= 1 and self.CANVAS_REGEX.match(parsedArguments[0]):
                        self.__isCanvas = True

                case 'HTMLCanvasElement.toDataURL' | 'HTMLCanvasElement.toBlob':
                    self.__canvasExtraction = True

                case 'WebGLRenderingContext.readPixels' | 'WebGL2RenderingContext.readPixels':
                    self.__extraction = True

                case _:
                    pass
                
        except Exception as e:
            self.logger.exception(f"Found Exception {e}, row: {row}")