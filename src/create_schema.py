from db_utils import get_engine, read_sql_file, execute_sql_script


def create_schema():
    engine = get_engine()

    try:
        script = read_sql_file("../sql_files/create_normalized_tables.sql")
        execute_sql_script(engine, script)

    except Exception as e:
        print(f"Erro ao executar: {e}")
        raise


if __name__ == "__main__":
    create_schema()