import importlib
import logging
from sqlalchemy.engine import Engine
from types import ModuleType
from typing import Any, Dict, List, Tuple, Type
from analyzers.analyzer import Analyzer
import analyzers


Canvas_1M_Static : Type[Analyzer] = analyzers.Canvas_1M_Static
Canvas_Basic_Static : Type[Analyzer] = analyzers.Canvas_Basic_Static
Canvas_Basic_Static_2 : Type[Analyzer] = analyzers.Canvas_Basic_Static_2
Canvas_Font_1M_Static : Type[Analyzer] = analyzers.Canvas_Font_1M_Static
WebRTC_1M_Static : Type[Analyzer] = analyzers.WebRTC_1M_Static
WebGL_Static : Type[Analyzer] = analyzers.WebGL_Static
Media_Queries_Static : Type[Analyzer] = analyzers.Media_Queries_Static
Navigator_Properties_Static : Type[Analyzer] = analyzers.Navigator_Properties_Static



Canvas_1M_Dynamic : Type[Analyzer] = analyzers.Canvas_1M_Dynamic
Canvas_Basic_Dynamic: Type[Analyzer] = analyzers.Canvas_Basic_Dynamic
Canvas1MDynamicND : Type[Analyzer] = analyzers.Canvas1MDynamicND
Canvas_Font_1M_Dynamic : Type[Analyzer] = analyzers.Canvas_Font_1M_Dynamic
WebRTC_1M_Dynamic : Type[Analyzer] = analyzers.WebRTC_1M_Dynamic
WebGL_Dynamic : Type[Analyzer] = analyzers.WebGL_Dynamic
Media_Queries_Dynamic : Type[Analyzer] = analyzers.Media_Queries_Dynamic
Navigator_Properties_Dynamic : Type[Analyzer] = analyzers.Navigator_Properties_Dynamic



AudioContext_Custom : Type[Analyzer] = analyzers.AudioContext
Canvas_Custom : Type[Analyzer] = analyzers.Canvas
CanvasFont_Custom : Type[Analyzer] = analyzers.CanvasFont
JSEnum_Custom : Type[Analyzer] = analyzers.JSEnum
WebGL_Custom : Type[Analyzer] = analyzers.WebGL
WebRTC_Custom : Type[Analyzer] = analyzers.WebRTC

GA_Custom : Type[Analyzer] = analyzers.GoogleAnalytics
MP_Custom : Type[Analyzer] = analyzers.MetaPixel
MUET_Custom : Type[Analyzer] = analyzers.MicrosoftUET
Hotjar_Custom : Type[Analyzer] = analyzers.Hotjar

CookieFirstTotal_Custom : Type[Analyzer] = analyzers.CookieFirstPartyTotal
CookieThirdTotal_Custom : Type[Analyzer] = analyzers.CookieThirdPartyTotal
CookieFirstSecure_Custom : Type[Analyzer] = analyzers.CookieFirstPartySecure
CookieThirdSecure_Custom : Type[Analyzer] = analyzers.CookieThirdPartySecure
CookieFirstHost_Custom : Type[Analyzer] = analyzers.CookieFirstPartyHost
CookieThirdHost_Custom : Type[Analyzer] = analyzers.CookieThirdPartyHost
CookieFirstSession_Custom : Type[Analyzer] = analyzers.CookieFirstPartySession
CookieThirdSession_Custom : Type[Analyzer] = analyzers.CookieThirdPartySession

LocalStorage_Custom : Type[Analyzer] = analyzers.LocalStorage
SessionStorage_Custom : Type[Analyzer] = analyzers.SessionStorage
IndexedDB_Custom : Type[Analyzer] = analyzers.IndexedDB


Static_Analyzers : List[Type[Analyzer]] = [
    Canvas_1M_Static,Canvas_Basic_Static,Canvas_Basic_Static_2,Canvas_Font_1M_Static,
    WebRTC_1M_Static,WebGL_Static,Media_Queries_Static,Navigator_Properties_Static
]

Dynamic_Analyzers : List[Type[Analyzer]] = [
    Canvas_1M_Dynamic,Canvas_Basic_Dynamic,Canvas1MDynamicND,Canvas_Font_1M_Dynamic,
    WebRTC_1M_Dynamic,WebGL_Dynamic,Media_Queries_Dynamic,Navigator_Properties_Dynamic
]

Custom_Analyzers : List[Type[Analyzer]] = [
    AudioContext_Custom,Canvas_Custom,CanvasFont_Custom,JSEnum_Custom,WebGL_Custom,WebRTC_Custom,
    GA_Custom,MP_Custom,MUET_Custom,Hotjar_Custom,
    CookieFirstTotal_Custom,CookieThirdTotal_Custom,CookieFirstSecure_Custom,CookieThirdSecure_Custom,CookieFirstHost_Custom,CookieThirdHost_Custom,CookieFirstSession_Custom,CookieThirdSession_Custom,
    LocalStorage_Custom,SessionStorage_Custom,IndexedDB_Custom
]

Analyzers : List[Type[Analyzer]] = Static_Analyzers + Dynamic_Analyzers + Custom_Analyzers


def all_analyzers(db : Any, logger : logging.Logger) -> List[Analyzer]:
    return [ analyzer(db,logger) for analyzer in Analyzers ]

def all_static_analyzers(db : Any, logger : logging.Logger) -> List[Analyzer]:
    return [ analyzer(db,logger) for analyzer in Static_Analyzers ]

def all_dynamic_analyzers(db : Any, logger : logging.Logger) -> List[Analyzer]:
    return [ analyzer(db,logger) for analyzer in Dynamic_Analyzers ]

def all_custom_analyzers(db : Any, logger : logging.Logger) -> List[Analyzer]:
    return [ analyzer(db,logger) for analyzer in Custom_Analyzers ]

def analyzers_from_module_names(module_names : List[str], db : Any, logger : logging.Logger)-> List[Analyzer]:
        mods_classes: List[Tuple[str, str, str]] = \
        [c.rpartition('.') for c in module_names]
        analyzer_objects : List[Analyzer] = []
        for mc in mods_classes:
            logger.info(mc)
            if mc[0] != '':
                m: ModuleType = importlib.import_module(mc[0])
                analyzer_objects.append(
                    getattr(m, mc[2])(db, logger)
                )
            else:
                analyzer_objects.append(globals()[mc[2]](db, logger))
        return analyzer_objects

def analyzers_from_class_names(class_names : List[str], db : Any, logger : logging.Logger)-> List[Analyzer]:
    d : Dict[str, Type[Analyzer]] = { a.analysis_name() : a for a in Analyzers}
    for class_name in class_names:
        if class_name not in d:
            raise LookupError(f"no such analyzer object: {class_name}")
    return [ d[class_name](db,logger) for class_name in class_names ]

def run_analyzers(analyzer_objects : List[Analyzer]) -> None:
    for analyzer  in analyzer_objects:
        analyzer.run_analysis()

def all_analyzers_strings() -> List[str]:
    return [ analyzer.analysis_name() for analyzer in Analyzers ]

def all_static_analyzers_strings() -> List[str]:
    return [ analyzer.analysis_name() for analyzer in Static_Analyzers ]

def all_dynamic_analyzers_strings() -> List[str]:
    return [ analyzer.analysis_name() for analyzer in Dynamic_Analyzers ]

def all_custom_analyzers_strings() -> List[str]:
    return [ analyzer.analysis_name() for analyzer in Custom_Analyzers ]






