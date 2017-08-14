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