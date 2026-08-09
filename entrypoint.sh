#!/bin/bash
set -e

# Remove a stale PID file left behind after an unclean shutdown.
rm -f /app/tmp/pids/server.pid

# Ensure gems are present even if the named volume was recreated.
bundle check || bundle install

# Make sure helper scripts are executable on Windows bind mounts.
chmod +x bin/* 2>/dev/null || true

exec "$@"
