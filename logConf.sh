#!/bin/sh

set -eu

export PGDATA="$HOME/bem5"

mkdir -p "$PGDATA/log"
chmod 700 "$PGDATA/log"

cat >> "$PGDATA/postgresql.conf" <<'EOC'

log_destination = 'stderr'
logging_collector = on
log_directory = 'log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'

log_min_messages = NOTICE
log_connections = on
log_disconnections = on
EOC

pg_ctl -D "$PGDATA" restart

psql -p 9416 -d postgres -c "
SHOW log_destination;
SHOW logging_collector;
SHOW log_directory;
SHOW log_filename;
SHOW log_min_messages;
SHOW log_connections;
SHOW log_disconnections;
"