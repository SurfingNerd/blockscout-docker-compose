#!/bin/sh
# this file is designed to get executed in the root of blockscout 
# within the docker container.

echo $(pwd)

set -e

echo "waiting 5 seconds for DB..."
sleep 5

# echo "verifying database availability..."


# bash-5.0# nc -vzw1 172.17.0.1 5432
# 172.17.0.1 (172.17.0.1:5432) open

#until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_USER" -U "postgres" -c '\q'; do
#  >&2 echo "Postgres is unavailable - sleeping"
#  sleep 1
#done

echo "Creating DB...."
mix ecto.create
echo "DB created!"
echo "Creating Tables...."
mix ecto.migrate
echo "Tables created!"

echo "Starting Server...."
mix phx.server