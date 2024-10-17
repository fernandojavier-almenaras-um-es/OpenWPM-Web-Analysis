from typing import Any
from analyzers.dynamic_analyzer import Dynamic_Analyzer


class WebRTC(Dynamic_Analyzer):
    
    @staticmethod
    def fingerprinting_type() -> str:
        return "WebRTC"
    
    def _classify(self) -> int:
        return self.__dataCh and self.__offer and self.__onIce

    def _reset(self) -> None:
        # condition 1
        self.__dataCh : bool = False
        # condition 2
        self.__offer : bool = False
        # condition 3
        self.__onIce : bool = False

    def _read_row(self, row : Any) -> None:
        try:
            match row["symbol"]:
                case 'RTCPeerConnection.createDataChannel':
                    self.__dataCh = True

                case 'RTCPeerConnection.createOffer':
                    self.__offer = True

                case 'RTCPeerConnection.onicecandidate':
                    self.__onIce = True

                case _:
                    pass
                
        except Exception as e:
            self.logger.exception(f"Found Exception {e}, row: {row}")