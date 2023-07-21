#!/bin/bash
DB_NAME=cexplorer

tip=$(psql ${DB_NAME} -qbt -c "select extract(epoch from time)::integer from block order by id desc limit 1;" | xargs)

if [[ $(( $(date +%s) - tip )) -gt 300 ]]; then
  echo "$(date +%F_%H:%M:%S) Skipping as database has not received a new block in past 300 seconds!" && exit 1
fi

echo "$(date +%F_%H:%M:%S) Running epoch info cache update..."
psql ${DB_NAME} -qbt -c "SELECT GREST.EPOCH_INFO_CACHE_UPDATE();" 1>/dev/null 2>&1
echo "$(date +%F_%H:%M:%S) Job done!"
