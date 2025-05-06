import os

import duckdb
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import Engine
from sqlalchemy.sql.expression import text

load_dotenv()


def get_alchemy_connection() -> Engine:
    """A template for forming a connection to the Delphi database.

    Assumes that you are set to tunnel data over SSH. See private docs.

    These will run in the background until you use Ctrl + C to end it. You can
    add a -v flag so it sends messages, so you don't forget about it.
    """
    user = os.environ.get("MYSQL_USER")
    password = os.environ.get("MYSQL_PWD")
    host = os.environ.get("MYSQL_HOST")
    port = os.environ.get("MYSQL_TCP_PORT")
    database = "covid"

    connection_string = f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}"
    return create_engine(connection_string)


def example_query(e: Engine) -> list:
    """An example query to the Delphi database."""
    test_query = text("SELECT COUNT(*) FROM covidcast c WHERE c.`signal` = 'confirmed_cumulative_num'")
    with e.connect() as c:
        result = c.execute(test_query)
        return list(result)


def duckdb_connection() -> None:
    """An example of how to connect to DuckDB.

    Relies on environment variables to connect to a MySQL database:
    MYSQL_HOST, MYSQL_TCP_PORT, MYSQL_DATABASE, MYSQL_USER, MYSQL_PWD
    https://duckdb.org/docs/stable/extensions/mysql.html
    """

    # Create a DuckDB connection
    con = duckdb.connect()
    con.execute("INSTALL mysql;")
    con.execute("LOAD mysql;")
    con.execute("ATTACH '' AS mysqldb (TYPE mysql); USE mysqldb;")

    # Query the table
    df = con.execute("SELECT COUNT(*) FROM covidcast c WHERE c.`signal` = 'confirmed_cumulative_num'").df()
    print(df)
