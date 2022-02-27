#!/bin/sh
pg_restore -h ec2-176-34-184-174.eu-west-1.compute.amazonaws.com -p 5432 -U htflozsrgqktdg -W -d d40e3dk5r0g1ho -a -F tar -O -v finances.dump