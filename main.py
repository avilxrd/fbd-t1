from dotenv import load_dotenv
import mysql.connector
import pandas as pd
import os


load_dotenv()

CSV_FILE           = 'ori.csv'
UNNORMALIZED_TABLE = 'raw_matches'

DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST     = os.getenv("DB_HOST")
DB_USER     = os.getenv("DB_USER")
DB_NAME     = os.getenv("DB_NAME")

df = pd.read_csv("ori.csv", encoding="gbk")

def mysql_type(dtype):
    if "int" in str(dtype):
        return "INT"

    elif "float" in str(dtype):
        return "FLOAT"

    elif "datetime" in str(dtype):
        return "DATETIME"

    else:
        return "TEXT"

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

# print(create_table_sql)

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

conn = mysql.connector.connect(
    host=DB_HOST,
    user=DB_USER,
    password=DB_PASSWORD,
    database=DB_NAME,
    use_pure=True
)

cursor = conn.cursor()

cursor.execute(create_table_sql)

cols = ", ".join([f"`{c}`" for c in df.columns])

placeholders = ", ".join(["%s"] * len(df.columns))

insert_sql = f"""
    INSERT INTO {UNNORMALIZED_TABLE}
    ({cols})
    VALUES ({placeholders})
"""

for _, row in df.iterrows():

    values = tuple(
        None if pd.isna(v) else v
        for v in row
    )
    cursor.execute(insert_sql, values)

conn.commit()

conn.close()