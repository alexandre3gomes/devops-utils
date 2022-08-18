#!/bin/sh
export HOST=
export USER=
export DB=
pg_dump -h $HOST -p 5432 -U $USER -W -d $DB -a -F tar -O -v -f finances.dump