import psycopg2
try:
    conn = psycopg2.connect('postgresql://postgres:postgres@127.0.0.1:5432/postgres')
    print('SUCCESS')
except Exception as e:
    print('FAIL:', e)