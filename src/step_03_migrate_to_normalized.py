from db_utils import get_engine, read_sql_file, execute_sql_script


def run_sql_step(engine, sql_path, success_msg=None):
    try:
        script = read_sql_file(sql_path)
        execute_sql_script(engine, script)

        if success_msg:
            print(success_msg)

    except Exception as e:
        print(f"Erro ao executar {sql_path}: {e}")
        raise


def normalize():
    engine = get_engine()

    steps = [
        "tournaments", "champions", "teams",
        "players", "matches", "games",
        "games_teams", "player_game_stats"
    ]

    for step in steps:
        run_sql_step(engine, f"../sql_files/insert_{step}.sql", f"[{step}] Ok.")


if __name__ == "__main__":
    normalize()