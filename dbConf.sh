#!/bin/sh

export PGDATA="$HOME/bem5"

psql -p 9416 -d postgres -c "ALTER SYSTEM SET max_connections = 150;"
psql -p 9416 -d postgres -c "ALTER SYSTEM SET shared_buffers = '512MB';"
psql -p 9416 -d postgres -c "ALTER SYSTEM SET temp_buffers = '32MB';"
psql -p 9416 -d postgres -c "ALTER SYSTEM SET work_mem = '51MB';"
psql -p 9416 -d postgres -c "ALTER SYSTEM SET checkpoint_timeout = '15min';"
psql -p 9416 -d postgres -c "ALTER SYSTEM SET effective_cache_size = '24GB';"
psql -p 9416 -d postgres -c "ALTER SYSTEM SET fsync = on;"
psql -p 9416 -d postgres -c "ALTER SYSTEM SET commit_delay = 1000;"

pg_ctl -D "$PGDATA" restart

psql -p 9416 -d postgres -c "
SHOW max_connections;
SHOW shared_buffers;
SHOW temp_buffers;
SHOW work_mem;
SHOW checkpoint_timeout;
SHOW effective_cache_size;
SHOW fsync;
SHOW commit_delay;
"