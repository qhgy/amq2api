import sqlite3
import json

conn = sqlite3.connect('data.sqlite3')
cursor = conn.cursor()

# 查看所有表
cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
tables = cursor.fetchall()
print("Tables:", tables)

# 查看每个表的数据
for table in tables:
    table_name = table[0]
    print(f"\n=== Table: {table_name} ===")
    cursor.execute(f"SELECT * FROM {table_name}")
    rows = cursor.fetchall()
    
    # 获取列名
    cursor.execute(f"PRAGMA table_info({table_name})")
    columns = [col[1] for col in cursor.fetchall()]
    print(f"Columns: {columns}")
    
    for row in rows:
        print(dict(zip(columns, row)))

conn.close()
