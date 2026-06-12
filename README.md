### Organização
O diretório está organizado da seguinte forma, seguindo a lista de entrega definida nos slides (onde achar cada arquivo).<br>
``
- Fonte escolhida: `./ori.csv`
- Script de criação da tabela desnormalizada: `./src/step_01_create_and_load_raw.py`
- Script de criação das tabelas normalizadas: `./sql_files/create_normalized_tables.sql`
- Scripts sql de alimentação, códigos de extração: `./sql_files/insert_{step}.sql` + `./src/step_02_create_normalized_schema.py`
- Modelo ER: `./other_files/er_diagram.png`
- Modelo Relacional: `./other_files/modelo_relacional.pdf`
- Consultas elaboradas: `./sql_files/_consultas.sql`
- Apresentação final: `./other_files/apresentacao.pdf`




### Configuração

Utilizamos o `python 3.11` para o desenvolvimento deste código. O `python 3.12` também foi testado e funcionou.
As bibliotecas necessárias estão listadas no `requirements.txt`. <br>

#### Linux
```bash
source .venv/bin/activate
```

#### Windows
```bash
.venv\Scripts\Activate
```

Após entrar na `.venv`, instalar os requisitos.

```
pip install -r requirements.txt
```

Para conectar no banco de dados, é necessário criar um `.env` com o seguinte:
````
DB_USER=root
DB_PASSWORD=senha_do_banco
DB_HOST=localhost
DB_NAME=lol_matches_db
````