#!/bin/sh

export PGPASSWORD='pswd'

mkdir -p "$HOME/crg47"
mkdir -p "$HOME/tev64"
chmod 700 "$HOME/crg47" "$HOME/tev64"

psql -h localhost -p 9416 -U postgres7 -d postgres -c "CREATE TABLESPACE crg47 LOCATION '$HOME/crg47';"
psql -h localhost -p 9416 -U postgres7 -d postgres -c "CREATE TABLESPACE tev64 LOCATION '$HOME/tev64';"

psql -h localhost -p 9416 -U postgres7 -d postgres -c "CREATE DATABASE bestredarmy TEMPLATE template0 ENCODING 'KOI8R' LC_COLLATE 'C' LC_CTYPE 'C';"
