#!/bin/sh
pg_dump -h finances-db.capfvbhu8jfa.eu-west-1.rds.amazonaws.com -p 5432 -U postgres -W -d finances -a -F tar -O -v -f finances.dump