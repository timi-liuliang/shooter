import psycopg2
import sys

dbName   = "shooter"
userName = 'postgres'
userPW   = 'Q19870816q'

def createDB():
    conn = psycopg2.connect(user=userName, password=userPW)
    cursor  = conn.cursor()
    cursor.execute("CREATE DATABASE " + dbName + "_ OWNER " + userName + ";")
    tableExists = cursor.fetchone()[0]

    conn.commit()
    conn.close()
    return

# connect to db server
def connectDB():
    # connect to db
    conn = None
    conn = psycopg2.connect(database=dbName, user=userName, password=userPW)
    return conn

# is table exist
def isTableExist(tableName):
    conn = connectDB()
    cursor  = conn.cursor()
    cursor.execute("SELECT EXISTS (SELECT 1 AS result FROM pg_tables WHERE schemaname = 'public' AND tablename = '%s');" % tableName)
    tableExists = cursor.fetchone()[0]

    conn.commit()
    conn.close()

    return tableExists

def dropTable(tableName):
    conn = connectDB()
    cursor  = conn.cursor()
    cursor.execute("DROP TABLE %s;" % tableName)
    conn.commit()
    conn.close()
    return    

# create table
def createTable(tableName, sqlCMD):
    if False == isTableExist(tableName):
        # connect to db
        conn = connectDB()
        cur  = conn.cursor()
        cur.execute("CREATE TABLE %s%s" % (tableName, sqlCMD))
        conn.commit()
        conn.close()

        print('create table [%s] succeed' % tableName)
    else:
        print('create table [%s] failed, it has existed.' % tableName)

    return

# create db
#createDB()

# create table pageView if not exist
#createDB()
createTable('account', '(account BIGSERIAL PRIMARY KEY, password VARCHAR(128), info JSONB)')
createTable('player', '(player BIGSERIAL PRIMARY KEY, account BIGINT, info JSONB)')
createTable('global', '(key VARCHAR(128) PRIMARY KEY, value JSONB)')
