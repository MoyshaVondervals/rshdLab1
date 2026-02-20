#!/bin/sh

set -eu

export PGDATA="$HOME/bem5"

cat >> "$PGDATA/postgresql.conf" <<'EOC'
listen_addresses = '*'
port = 9416
EOC

cat > "$PGDATA/pg_hba.conf" <<'EOC'
# TYPE  DATABASE        USER            ADDRESS                 METHOD

local   all             all                                     peer

host    all             all             0.0.0.0/0               scram-sha-256
host    all             all             ::/0                    scram-sha-256


local   replication     all                                     reject
host    replication     all             0.0.0.0/0               reject
host    replication     all             ::/0                    reject
EOC

pg_ctl -D "$PGDATA" -l "$PGDATA/server.log" start

psql -p 9416 -d postgres -c "ALTER ROLE postgres7 WITH PASSWORD 'pswd';"