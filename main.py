from sqlalchemy import create_engine, text
from urllib.parse import quote_plus
from dotenv import load_dotenv
import mysql.connector
import pandas as pd
import os

CSV_FILE           = 'ori.csv'
UNNORMALIZED_TABLE = 'raw_matches'

load_dotenv()
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST     = os.getenv("DB_HOST")
DB_USER     = os.getenv("DB_USER")
DB_NAME     = os.getenv("DB_NAME")

df = pd.read_csv("ori.csv", encoding="gbk")

# traducao

from argostranslate import package
from tqdm import tqdm
from argostranslate import translate

def install_translation_package():
    package.update_package_index()

    available_packages = package.get_available_packages()

    package_to_install = next(
        filter(
            lambda x: x.from_code == "zh" and x.to_code == "en",
            available_packages
        )
    )

    download_path = package_to_install.download()
    package.install_from_path(download_path)

def translate_column():
    TRANSLATE = "matchType"

    tqdm.pandas()

    installed_languages = translate.get_installed_languages()

    from_lang = next(lang for lang in installed_languages if lang.code == "zh")
    to_lang = next(lang for lang in installed_languages if lang.code == "en")

    translator = from_lang.get_translation(to_lang)

    valores_unicos = df[TRANSLATE].dropna().unique()

    mapa_traducoes = {}

    for texto in tqdm(valores_unicos):
        texto = str(texto)
        try:
            traducao = translator.translate(texto)
        except Exception as e:
            print(f"Erro: {e}")
            traducao = texto
        mapa_traducoes[texto] = traducao

    df[TRANSLATE] = df[TRANSLATE].map(mapa_traducoes)

def mysql_type(dtype):
    if "int" in str(dtype):
        return "INT"
    elif "float" in str(dtype):
        return "FLOAT"
    elif "datetime" in str(dtype):
        return "DATETIME"
    else:
        return "TEXT"

def create_db_if_not_exist():
    conn = mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        use_pure=True
    )

    cursor = conn.cursor()

    cursor.execute(f"CREATE DATABASE IF NOT EXISTS {DB_NAME}")

    cursor.close()
    conn.close()
    return 0

def create_tables_if_not_exists():
    columns = []

    for col, dtype in df.dtypes.items():
        sql_type = mysql_type(dtype)

        columns.append(f"`{col}` {sql_type}")

    create_table_sql = f"""
        CREATE TABLE IF NOT EXISTS {UNNORMALIZED_TABLE} (
            {", ".join(columns)}
        )
        CHARACTER SET utf8mb4;
    """

    conn = mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        use_pure=True,
        allow_local_infile=True
    )

    cursor = conn.cursor()
    cursor.execute(create_table_sql)

def populate_db():
    password = quote_plus(DB_PASSWORD)

    engine = create_engine(
        f"mysql+mysqlconnector://{DB_USER}:{password}@{DB_HOST}/{DB_NAME}?charset=utf8mb4"
    )

    with engine.connect() as conn:
        conn.execute(text("TRUNCATE TABLE raw_matches"))

    df.to_sql(
        name="raw_matches",
        con=engine,
        if_exists="append",
        index=False,
        chunksize=1000
    )

def main():
    create_db_if_not_exist()
    create_tables_if_not_exists()
    populate_db()

if __name__ == "__main__":
    main()