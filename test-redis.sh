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
echo $2 working great!
else
echo $2 failed :-/
fi
}

rm -rf bluechatter
git clone https://github.com/IBM-Bluemix/bluechatter.git
cd bluechatter
cf push $APP_NAME --random-route

if [[ $? -ne 0 ]]
then
   echo Ensure you have a service called 'redis-chatter'
else
    cd ..
    rm -rf bluechatter

    check_url $APP_NAME "Redis"
fi
