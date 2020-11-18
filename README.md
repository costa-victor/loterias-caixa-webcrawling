# Loterias Caixa - Data mining
Data mining in Loterias Caixa (Lotofácil/Megasena)

## Requirements
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

## Announcements

Project under development, the v1.0 will come soon.
