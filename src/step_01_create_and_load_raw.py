import os
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import text
from db_utils import get_engine, get_engine_no_db

CSV_FILE = "../ori.csv"
TABLE_NAME = "raw_matches"


def load_csv():
    return pd.read_csv(CSV_FILE, encoding="gbk")


def create_database_if_not_exists(engine, db_name):
    with engine.begin() as conn:
        conn.execute(text(f"CREATE DATABASE IF NOT EXISTS {db_name}"))


def create_raw_table(engine, df):
    def mysql_type(dtype):
        if "int" in str(dtype):
            return "INT"
        elif "float" in str(dtype):
            return "FLOAT"
        elif "datetime" in str(dtype):
            return "DATETIME"
        else:
            return "TEXT"

    columns = [
        f"`{col}` {mysql_type(dtype)}"
        for col, dtype in df.dtypes.items()
    ]

    sql = f"""
    CREATE TABLE IF NOT EXISTS {TABLE_NAME} (
        {", ".join(columns)}
    ) CHARACTER SET utf8mb4;
    """

    with engine.begin() as conn:
        conn.execute(text(sql))


def insert_data(engine, df):
    with engine.begin() as conn:
        conn.execute(text(f"TRUNCATE TABLE {TABLE_NAME}"))

    df.to_sql(
        TABLE_NAME,
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000
    )


def main():
    load_dotenv()

    engine = get_engine_no_db()
    create_database_if_not_exists(engine, os.getenv("DB_NAME"))

    engine = get_engine()
    df = load_csv()

    create_database_if_not_exists(engine, os.getenv("DATABASE_NAME"))
    create_raw_table(engine, df)
    insert_data(engine, df)


if __name__ == "__main__":
    main()