from pathlib import Path
import re
import sqlite3
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
CSV_PATH = ROOT / "data" / "processed" / "boston_airbnb_cleaned.csv"
SQL_PATH = ROOT / "sql" / "analysis_queries.sql"

df = pd.read_csv(CSV_PATH)
conn = sqlite3.connect(":memory:")
df.to_sql("boston_airbnb", conn, index=False, if_exists="replace")

sql_text = SQL_PATH.read_text(encoding="utf-8")
blocks = re.split(r"-- QUERY: ([A-Z0-9_]+)\s*\n", sql_text)[1:]
queries = list(zip(blocks[0::2], blocks[1::2]))

for name, query in queries:
    query = query.strip()
    if not query:
        continue
    print(f"\n{'=' * 80}\n{name}\n{'=' * 80}")
    result = pd.read_sql_query(query, conn)
    print(result.to_string(index=False))

conn.close()
