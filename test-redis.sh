#!/bin/bash

APP_NAME=patrocinio-bluemix-chatter


# Parameters
# $1: app name
# $2: name
check_url () {
# Grab URL
URL=`cf app $APP_NAME | grep urls | awk '{print $2}'`

# Check response
LINE=`wget --server-response --content-on-error=off ${URL} 2>&1 | grep HTTP`

# Prints result
if [[ "$LINE" == *"200"* ]]; then
echo Postgres working great!
else
echo Postgres failed :-/
fi
}

rm -rf bluechatter
git clone https://github.com/IBM-Bluemix/bluechatter.git
cd bluechatter
cf push $APP_NAME --no-start --random-route
cf bs $APP_NAME redis
cf start $APP_NAME

cd ..
rm -rf bluechatter

check_url $APP_NAME "Redis"
