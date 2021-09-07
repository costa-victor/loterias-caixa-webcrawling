# Loterias Caixa - Web crawling
Web crawling at Loterias Caixa (Lotofácil/Megasena) for downloading and filtering data for storage in PostgreSQL

## Requirements
* Python3
* PostgreSQL

## How to use
Create database with extension btree_gin
```
$ sudo -u postgres psql
postgres=# create database loteria;
postgres=# \c loteria
loteria=# create extension btree_gin;
```
Create all tables, index and functions in *database.sql*.

Then run **get_data.py** inside data folder.
## Announcements

Project under development, the v1.0 will come soon.
