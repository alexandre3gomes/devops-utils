#!/bin/sh
pg_restore -h finances-db.capfvbhu8jfa.eu-west-1.rds.amazonaws.com -U postgres -d finances -O -v -W $1