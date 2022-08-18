#!/bin/sh
export HOST=
export USER=
export DB=
psql -h $HOST -p 5432 -U $USER -W -d $DB -c 'TRUNCATE app_users, category, income, expense, budget, budget_periods, budget_categories, savings, databasechangelog, databasechangeloglock'
pg_restore -h $HOST -p 5432 -U $USER -W -d $DB -a -O -v latest.dump