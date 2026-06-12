### Organização
O diretório está organizado da seguinte forma, seguindo a lista de entrega definida nos slides (onde achar cada arquivo).




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