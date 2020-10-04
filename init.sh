#!/bin/sh
./app/wait && java -Dspring.profiles.active=docker -jar /app/app.jar