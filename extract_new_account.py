import sqlite3

conn = sqlite3.connect('D:/000000000000aug/000mbd/amazonq2api/data.sqlite3')
cursor = conn.cursor()

cursor.execute('''
    SELECT clientId, clientSecret, refreshToken 
    FROM accounts 
    WHERE id = ?
''', ('e9dca351-5c4e-4ae8-a300-86cdfae2bf98',))

row = cursor.fetchone()
if row:
    print(f"AMAZONQ_CLIENT_ID={row[0]}")
    print(f"AMAZONQ_CLIENT_SECRET={row[1]}")
    print(f"AMAZONQ_REFRESH_TOKEN={row[2]}")
else:
    print("Account not found")

conn.close()
