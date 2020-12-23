#!/bin/sh
cd ../discovery-service
gradle build -x test
cd ../gateway-service
gradle build -x test
cd ../user-service
gradle build -x test
cd ../category-service
gradle build -x test
cd ../income-service
gradle build -x test
cd ../expense-service
gradle build -x test
cd ../budget-service
gradle build -x test
cd ../devops-utils
docker-compose build