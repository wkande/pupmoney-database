# pupmoney-database
Database script and notes for PupMoney.

PostgreSQL version 11x. Production and Stage are run on ElephantSQL and development is localhost. The
databases are manually sharded. The backend will connect to all databases listed in the DB_URLS array.
Shard #0 holds the USERS, CODES and WALLETS tables plus a set of wallet child tables. Shards #1 (and up hold only the wallet child tables.


## SEARCH_PATH
All databases must have the search path set to the "pupmoney" schema. This can be done on a permanent basis. Change for each shard.
```bash
# View the path
show search_path;
# Alter the path
alter database "pup-0"  set search_path to pupmoney;
```

## PostgreSQL Mac Install
Using a local PostgreSQL development instance.
https://postgresapp.com/


## ElephantSQL
Both stage and production shards are hosted by ElephantSQL. Connection info is in the SECRECTS project.