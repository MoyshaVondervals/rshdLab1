#!/bin/sh

PGDATA="$HOME/bem5"
PGENCODE="KOI8-R"
PGLOCALE="POSIX"

mkdir -p "$PGDATA"
chmod 700 "$PGDATA"

initdb -D "$PGDATA" --encoding="$PGENCODE" --locale="$PGLOCALE"