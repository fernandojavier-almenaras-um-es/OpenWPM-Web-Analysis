from typing import Any
from analyzers.dynamic_analyzer import Dynamic_Analyzer


class AudioContext(Dynamic_Analyzer):
    
    @staticmethod
    def fingerprinting_type() -> str:
        return "AudioContext"
    
    def _classify(self) -> int:
        return ( self.__oscillator or self.__dynamicCompressor or self.__analyser or self.__worklet or self.__gain or self.__scriptProcessor ) and \
        ( self.__extraction or self.__enumeration )

    def _reset(self) -> None :
        # condition 1
        self.__oscillator : bool = False
        self.__dynamicCompressor : bool = False
        self.__analyser : bool = False
        self.__worklet : bool = False
        self.__gain : bool = False
        self.__scriptProcessor : bool = False
        # condition 2
        self.__extraction : bool = False
        self.__enumeration : bool = False


    def _read_row(self, row : Any) -> None:
        #parsedArguments: List[Any] = parseArguments(row["arguments"])
        try:
            match row["symbol"]:
                case 'AudioContext.createOscillator' | 'OfflineAudioContext.createOscillator':
                    self.__oscillator = True

                case 'AudioContext.createDynamicCompressor' | 'OfflineAudioContext.createDynamicCompressor':
                    self.__dynamicCompressor = True

                case 'AudioContext.createAnalyser' | 'OfflineAudioContext.createAnalyser':
                    self.__analyser = True

                case 'AudioContext.audioWorklet' | 'OfflineAudioContext.audioWorklet':
                    self.__worklet = True

                case 'AudioContext.createGain' | 'OfflineAudioContext.createGain':
                    self.__gain = True

                case 'AudioContext.createScriptProcessor' | 'OfflineAudioContext.createScriptProcessor':
                    self.__scriptProcessor = True

                case 'AudioBuffer.getChannelData' | 'AudioBuffer.copyFromChannel' | \
                    'AnalyserNode.getFloatFrequencyData' | 'AnalyserNode.getByteFrequencyData':
                    self.__extraction = True

                case 'AudioContext.destination' | 'OfflineAudioContext.destination' | \
                    'AudioContext.listener' | 'OfflineAudioContext.listener':
                    self.__enumeration = True

                case _:
                    pass
                
        except Exception as e:
            self.logger.exception(f"Found Exception {e}, row: {row}")