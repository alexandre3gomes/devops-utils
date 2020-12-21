#!/bin/sh
cd $JAVA_HOME/jre/lib/security
keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias finances -file localhost.pem
./app/wait && java -Djava.security.egd=file:/dev/./urandom -Dspring.profiles.active=docker -jar /app/app.jar