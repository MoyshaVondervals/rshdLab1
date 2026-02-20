#!/bin/sh


PGHOST=localhost
PGPORT=9416
ADMIN_USER=postgres7
ADMIN_PASS=pswd
DBNAME=bestredarmy

NEW_USER=data_user
NEW_PASS=1234

export PGPASSWORD="$ADMIN_PASS"

psql -h "$PGHOST" -p "$PGPORT" -U "$ADMIN_USER" -d postgres -v ON_ERROR_STOP=1 -c "CREATE ROLE $NEW_USER LOGIN PASSWORD '$NEW_PASS';"

psql -h "$PGHOST" -p "$PGPORT" -U "$ADMIN_USER" -d postgres -v ON_ERROR_STOP=1 -c "GRANT CONNECT ON DATABASE $DBNAME TO $NEW_USER;"

psql -h "$PGHOST" -p "$PGPORT" -U "$ADMIN_USER" -d "$DBNAME" -v ON_ERROR_STOP=1 -c "GRANT USAGE, CREATE ON SCHEMA public TO $NEW_USER;"

psql -h "$PGHOST" -p "$PGPORT" -U "$ADMIN_USER" -d "$DBNAME" -v ON_ERROR_STOP=1 -c "GRANT CREATE ON TABLESPACE crg47 TO $NEW_USER;"
psql -h "$PGHOST" -p "$PGPORT" -U "$ADMIN_USER" -d "$DBNAME" -v ON_ERROR_STOP=1 -c "GRANT CREATE ON TABLESPACE tev64 TO $NEW_USER;"

export PGPASSWORD="$NEW_PASS"

psql -h "$PGHOST" -p "$PGPORT" -U "$NEW_USER" -d "$DBNAME" -v ON_ERROR_STOP=1 -c "
CREATE TABLE table1 (
  id bigserial PRIMARY KEY,
  name text
) TABLESPACE crg47;

CREATE TABLE table2 (
  id bigserial PRIMARY KEY,
  value integer
) TABLESPACE tev64;

CREATE TABLE table3 (
  id bigserial PRIMARY KEY,
  info text
) TABLESPACE tev64;

INSERT INTO table1 (name)
SELECT 'Имя ' || g FROM generate_series(1, 100) g;

INSERT INTO table2 (value)
SELECT g * 10 FROM generate_series(1, 100) g;

INSERT INTO table3 (info)
SELECT 'Инфо ' || g FROM generate_series(1, 100) g;
"

unset PGPASSWORD

export PGPASSWORD="$ADMIN_PASS"

psql -h "$PGHOST" -p "$PGPORT" -U "$ADMIN_USER" -d "$DBNAME" -v ON_ERROR_STOP=1 -c "
SELECT spcname, pg_tablespace_location(oid)
FROM pg_tablespace
ORDER BY spcname;
"

psql -h "$PGHOST" -p "$PGPORT" -U "$ADMIN_USER" -d "$DBNAME" -v ON_ERROR_STOP=1 -c "
SELECT t.spcname, c.relname
FROM pg_class c
JOIN pg_tablespace t ON c.reltablespace = t.oid
WHERE c.relkind = 'r'
ORDER BY t.spcname, c.relname;
"

psql -h "$PGHOST" -p "$PGPORT" -U "$ADMIN_USER" -d "$DBNAME" -v ON_ERROR_STOP=1 -c "
SELECT
  c.relname,
  t.spcname AS tablespace
FROM pg_class c
JOIN pg_tablespace t ON c.reltablespace = t.oid
WHERE c.relname IN ('table1','table2','table3')
ORDER BY c.relname;
"

unset PGPASSWORD