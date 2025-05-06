# %% Inserting data
# https://duckdb.org/docs/api/python/overview
# DuckDB is faster on some analytics queries than Pandas
# https://duckdb.org/2021/05/14/sql-on-pandas.html
import duckdb
import pandas as pd

# Insert manually
# Not efficient for large data sets
con = duckdb.connect("test.db")
con.execute("CREATE TABLE IF NOT EXISTS test_manual (a INTEGER, b INTEGER)")
con.executemany("INSERT INTO test_manual VALUES (?, ?)", [[1, 2], [3, 4]])
df = con.execute("SELECT * FROM test_manual").df()
df

# %% Insert from df
df = pd.DataFrame({"a": [1, 2, 3], "b": [4, 5, 6]})
con = duckdb.connect("test.db")
con.execute("CREATE TABLE IF NOT EXISTS test_df_table AS SELECT * FROM df")
con.execute("SELECT * FROM test_df_table").df()

# %% Select from loaded df directly
df = pd.DataFrame({"a": [1, 2, 3], "b": [4, 5, 6]})
con = duckdb.connect("test.db")
con.execute("SELECT * from df").df()

# %% Insert from csv file(s)
con = duckdb.connect("test.db")
sql = """
SELECT COUNT(*)
FROM read_csv(
    'confirmed_cumulative_num_01_counties.csv',
    header=True,
    dateformat='%Y%m%d',
    columns={
        'geo_value': 'text',
        'signal': 'text',
        'source': 'text',
        'geo_type': 'text',
        'time_type': 'text',
        'time_value': 'date',
        'direction': 'int4',
        'issue': 'date',
        'lag': 'int4',
        'missing_value': 'int4',
        'missing_stderr': 'int4',
        'missing_sample_size': 'int4',
        'value': 'float8',
        'stderr': 'float8',
        'sample_size': 'float8'
        },
    filename=True
)
"""
con.execute(sql).df()

# %% Try generating a date range
con = duckdb.connect("test.db")
con.execute("""select * from range(date '1991-01-01', date '1991-03-01', interval '1' day);""").df()

# %% A way to do moving average
con.execute("""
SELECT
    a,
    sum(b) OVER (
        ORDER BY a ASC
        RANGE BETWEEN INTERVAL 4 DAYS PRECEDING
                  AND INTERVAL 0 DAYS FOLLOWING
    ) AS "Moving Average"
FROM df
""").df()


# %% A way to do diff; it gets the edge case half-right: where there is no preceding day, it's 0
con.execute("""
SELECT
    a,
    first_value(b) OVER two as 'first',
    last_value(b) OVER two as 'last',
    last - first as 'diff'
FROM df
WINDOW two as (
        ORDER BY a ASC
        RANGE BETWEEN INTERVAL 1 DAYS PRECEDING
                  AND INTERVAL 0 DAYS FOLLOWING
        )
""").df()

# %% CASE WHEN example (output not different from above)
# Also demonstrates DuckDB prefix syntax
con.execute("""
SELECT
    a,
    first: first_value(b) OVER two,
    last: last_value(b) OVER two,
    diff: CASE WHEN count(b) OVER two > 1 THEN last - first ELSE 0 END
FROM df
WINDOW two as (
        ORDER BY a ASC
        RANGE BETWEEN INTERVAL 1 DAYS PRECEDING
                  AND INTERVAL 0 DAYS FOLLOWING
        )
""").df()

# %% A way to do smooth diff
con.execute("""
SELECT a, smoothdiff: avg(diffv) OVER seven
FROM (
    SELECT
    a,
    first_value(b) OVER two as 'first',
    last_value(b) OVER two as 'last',
    last - first as 'diffv'
    FROM df
    WINDOW two as (
            ORDER BY a ASC
            RANGE BETWEEN INTERVAL 1 DAYS PRECEDING
                      AND INTERVAL 0 DAYS FOLLOWING
    )
)
WINDOW seven as (
    ORDER BY a ASC
    RANGE BETWEEN INTERVAL 6 DAYS PRECEDING
              AND INTERVAL 0 DAYS FOLLOWING
)
""").df()

# %% A reasonable way and very simple way to do diff
con.execute("""
SELECT
    a,
    b,
    b - LAG(b, 1, 0) OVER (ORDER by a ASC) as 'diff'
FROM df
""").df()
