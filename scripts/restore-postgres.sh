#!bin/sh
docker run -d --name postgres -p 5432:5432 -v postgres_data:/var/lib/postgresql/data -e "POSTGRES_USER=postgres" -e "POSTGRES_PASSWORD=123456" postgres:12-alpine
docker exec -it postgres mkdir /var/lib/postgresql/backup
docker cp ../latest.dump postgres:/var/lib/postgresql/backup 
docker exec -it postgres bash -c "psql -U postgres -c 'CREATE DATABASE finances'" 
docker exec -it postgres bash -c "pg_restore -U postgres -d finances -O -v /var/lib/postgresql/backup/latest.dump" 
