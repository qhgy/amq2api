import sqlite3
import json

conn = sqlite3.connect('D:/000000000000aug/000mbd/amazonq2api/data.sqlite3')
cursor = conn.cursor()

# 查找有有效 refreshToken 的账号
cursor.execute('''
    SELECT id, label, clientId, enabled, success_count, last_refresh_status 
    FROM accounts 
    WHERE refreshToken IS NOT NULL AND refreshToken != ""
''')
rows = cursor.fetchall()

print("Available accounts with credentials:")
for row in rows:
    print(f"  - ID: {row[0]}")
    print(f"    Label: {row[1]}")
    print(f"    ClientId: {row[2][:20]}...")
    print(f"    Enabled: {row[3]}")
    print(f"    Success Count: {row[4]}")
    print(f"    Last Refresh: {row[5]}")
    print()

conn.close()
