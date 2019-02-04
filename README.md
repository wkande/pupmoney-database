# Pupmoney Database
Database script and notes for PupMoney.


## SEARCH_PATH
All databases must have the search path set to the "pupmoney" schema. This can be done on a permanent basis.
```bash
alter database "pup-0"  set search_path to pupmoney;
```


## Gandi.net

#### Original DNS setup

@ 10800 IN SOA ns1.gandi.net. hostmaster.gandi.net. 1540820791 10800 3600 604800 10800
@ 10800 IN A 217.70.184.38
@ 10800 IN MX 10 spool.mail.gandi.net.
@ 10800 IN MX 50 fb.mail.gandi.net.
@ 10800 IN TXT "v=spf1 include:_mailcust.gandi.net ?all"
blog 10800 IN CNAME blogs.vip.gandi.net.
webmail 10800 IN CNAME webmail.gandi.net.
www 10800 IN CNAME webredir.vip.gandi.net.


## PostgreSQL Mac Install
https://postgresapp.com/


## ElephantSQL
Connection info is in the SECRECTS project.