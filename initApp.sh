#!/bin/sh
export MONGO_URI=mongodb+srv://finances:finances@cluster0.1n7zl.mongodb.net/$2
cd ../$1/build/libs
java -jar $1*.jar