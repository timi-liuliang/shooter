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
createTable('account', '(account bigserial PRIMARY KEY, password VARCHAR(128), info jsonb)')
createTable('player', '(player bigserial PRIMARY KEY, account bigint, info jsonb)')


# 玩家可以三种方式创建账号
# 1.osid 操作系统id,其中ios android 平台拥有唯一标识。以此种方式注册无需密码
# 2.email 邮箱,以邮箱注册需提供密码
# 3.phone num 手机号，以手机号注册需提供密码

# 玩家可通过四种方式登录账号
# 1.以osid登录,无需密码
# 2.以account 登录，需要密码
# 3.以邮箱登录，需要密码
# 4.以手机号登录，需要密码 

# 注，osid与account_id绑定关系一旦确定，无法更改。不过，此机器还可通过 account_id, email, phone_num 登录非此机器对应os_id的账号。

# 账号转正方式：设置密码，绑定邮箱，绑定手机号。