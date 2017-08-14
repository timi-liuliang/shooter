import os
import time

# configure
username = "postgres"
port = '5432'
dbName = 'td'
backupdir = os.getcwd() + '/backup/'
date = time.strftime('%Y.%m.%d-%H:%M:%S')
backupFullPath = backupdir + dbName + '-' + date + '.snapshot'
backupCMD      = r'pg_dump -U postgres -h localhost --format=p --file=' + backupFullPath + ' ' + dbName

# create directory if not exist
if not os.path.exists(backupdir):
        os.makedirs(backupdir)
        print('create dir : ' + backupdir)

# execute backup
os.system(backupCMD)
print(backupCMD + ' succeed')
