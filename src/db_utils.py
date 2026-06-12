import os
from dotenv import load_dotenv
from urllib.parse import quote_plus
from sqlalchemy import create_engine, text


def get_engine_no_db():
    load_dotenv()

    user = os.getenv("DB_USER")
    password = quote_plus(os.getenv("DB_PASSWORD"))
    host = os.getenv("DB_HOST")

    return create_engine(
        f"mysql+pymysql://{user}:{password}@{host}",
        pool_pre_ping=True
    )



def get_engine():
    load_dotenv()

    user = os.getenv("DB_USER")
    password = quote_plus(os.getenv("DB_PASSWORD"))
    host = os.getenv("DB_HOST")
    db = os.getenv("DB_NAME")

    return create_engine(
        f"mysql+pymysql://{user}:{password}@{host}/{db}",
        pool_pre_ping=True
    )


def read_sql_file(path):
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def execute_sql_script(engine, script):
    commands = script.split(";")

    with engine.begin() as conn:
        for command in commands:
            command = command.strip()
            if command:
                conn.execute(text(command))