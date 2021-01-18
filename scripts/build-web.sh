#!/bin/sh
cd ~/desenv/projects/personal/finances-easy/finances-easy-web
ng build --prod
docker build -t alexandre3gomes/finances-easy-web .