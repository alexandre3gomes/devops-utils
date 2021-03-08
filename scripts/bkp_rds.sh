#!/bin/sh
pg_dump --dbname postgres://postgres:2c6fadf796fd0163e4b6a992fd4a8d57bde8e159816c4d7fd2a19c8463004130@finances-db.capfvbhu8jfa.eu-west-1.rds.amazonaws.com:5432/finances -F t -f bkp.tar.gz