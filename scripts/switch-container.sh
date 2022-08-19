#!/bin/bash

DOCKER_APP_NAME=app
EXIST_GREEN=$(docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml ps | grep running)

TARGET_PORT=0

TARGET_COLOR=""

if [ -z "$EXIST_GREEN" ]; then
    echo "> Start Green Container..."
    TARGET_PORT=3001
    TARGET_COLOR="blue"
    docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml up -d
else
    echo "> Start Blue Container..."
    TARGET_PORT=3002
    TARGET_COLOR="green"
    docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml up -d
fi

echo "> Start health check of Server at 'http://127.0.0.1:${TARGET_PORT}'..."

for RETRY_COUNT in `seq 1 10`
do
    echo "> Retrying... (${RETRY_COUNT})"

    RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:${TARGET_PORT})
    
    if [ ${RESPONSE_CODE} -eq 200 ]; then
        echo "> New Server successfully running" 
        echo "> Close Old Server"
        docker-compose -p ${DOCKER_APP_NAME}-${TARGET_COLOR} -f docker-compose.${TARGET_COLOR}.yml down
        break

    elif [ ${RETRY_COUNT} -eq 10 ]; then 
        echo "> Health check failed."
        exit 1 
    fi
    sleep 10
done


echo "Prune Docker System"
docker system prune -af

exit 0