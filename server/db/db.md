**1. Install postgresql**
```
sudo apt-get install postgresql
```

**2. Login use account _postgres_**
```
sudo su - postgres
```

**'pssql' login**
```
psql
```
**Set password for postgres**
```
\password postgres
```

**Create new user**
```
CREATE USER alab WITH PASSWORD 'Q19870816q';
```
**Create db for user alab**
```
CREATE DATABASE alab-web OWNER alab;

GRANT ALL PRIVILEGES ON DATABASE alab-web to alab;
```

**Exit**
```
\q
```

The problem is still your pg_hba.conf file (/etc/postgresql/9.1/main/pg_hba.conf). This line:

local   all             postgres                                peer
Should be

local   all             postgres                                md5
After altering this file, don't forget to restart your PostgreSQL server. If you're on Linux, that would be sudo service postgresql restart.

## pgadmin desktop
For pgAdmin 4 v1.4 on Ubuntu 16.04, according to the download page and desktop deployment:

Install dependencies, create a virtual environment, download, install & configure
```
sudo apt-get install virtualenv python-pip libpq-dev python-dev

cd
virtualenv pgadmin4
cd pgadmin4
source bin/activate
```
```
wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v1.5/pip/pgadmin4-1.5-py2.py3-none-any.whl
```
```
pip install pgadmin4-1.5-py2.py3-none-any.whl
```
Configure

Write the SERVER_MODE = False in lib/python2.7/site-packages/pgadmin4/config_local.py to configure to run in single-user mode:
```
echo "SERVER_MODE = False" >> lib/python2.7/site-packages/pgadmin4/config_local.py
```
Run
```
python lib/python2.7/site-packages/pgadmin4/pgAdmin4.py
```
Access at [http://localhost:5050](http://localhost:5050)


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