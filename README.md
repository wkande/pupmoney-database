# pupmoney-database
Database script and notes for PupMoney.

PostgreSQL version 11x. Production and Beta are run on ElephantSQL and development is localhost. The databases are manually sharded. The backend will connect to all databases listed in the DB_URLS array. 

Shard #0 holds the USERS, CODES and WALLETS tables plus a set of wallet child tables. Shards #1 (and up) hold only the wallet child tables.


## SEARCH_PATH
All databases must have the search path set to the "pupmoney" schema. This can be done on a permanent basis. Change for each shard.
```bash
#Change to the postgres database\
\c postgres
# Alter the paths
alter database "<db_name>"  set search_path to pupmoney;

# View the paths 
\c <db_name>
show search_path;
```

## PostgreSQL Mac Install
Using a local PostgreSQL development instance.
https://postgresapp.com/


## ElephantSQL
Both beta and production shards are hosted by ElephantSQL. Connection info is in the SECRECTS project.


## Start/Stop on Ubuntu Server

https://websiteforstudents.com/how-to-install-postgresql-11-on-ubuntu-16-04-18-04-servers/
https://computingforgeeks.com/install-postgresql-11-on-ubuntu-18-04-ubuntu-16-04/
https://chartio.com/resources/tutorials/how-to-change-a-user-to-superuser-in-postgresql/

sudo systemctl stop postgresql.service
sudo systemctl start postgresql.service
sudo systemctl restart postgresql.service
sudo systemctl enable postgresql.service
sudo systemctl status postgresql.service

sudo su - postgres
sudo nano /etc/postgresql/11/main/postgresql.conf

$ scp -r database warren@192.168.0.40:~