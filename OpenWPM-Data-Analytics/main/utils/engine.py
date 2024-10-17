
from sqlalchemy import Engine


class SingletonEngine():

    __engine: Engine

    @classmethod
    def set_engine(cls, engine: Engine) -> None:
        cls.__engine = engine

    @classmethod
    def get_engine(cls) -> Engine:
        return cls.__engine
