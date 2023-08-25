#!/bin/bash

set -e

CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Ensure that Docker is running...
if docker info -ne 0 >/dev/null 2>&1; then
  echo -e "${CYAN}Docker is not running."

  exit 1
fi

if [ -z "$(ls -A ./app)" ]; then 
  docker run -it --rm -v "$PWD"/:/app -w /app composer:2 create-project --prefer-dist laravel/laravel ./app
fi


chmod -R 777 ./app/bootstrap/cache ./app/storage

sed -i -e "s|APP_URL=http://localhost|APP_URL=http://localhost:80|" ./app/.env;
sed -i -e "s/DB_HOST=127.0.0.1/DB_HOST=mysql/" ./app/.env;
sed -i -e "s/DB_HOST=127.0.0.1/DB_HOST=mysql/" ./app/.env;

echo ""

if sudo -n true eq 0 2>/dev/null; then
  sudo chown -R "$USER": .
else
  echo -e "${WHITE}Please provide your password so we can make some final adjustments to your application's permissions.${NC}"
  echo ""
  sudo chown -R "$USER": .
  echo ""
  echo -e "${WHITE}Thank you! We hope you build something incredible. Dive in with:${NC} docker-compose up --build -d nginx"
fi

#sed -i.bak -e "s|BASE_NAME|${PWD##*/}|g" ./docker-compose.yml;

docker-compose up --build -d nginx

echo -e "=> ${WHITE}In order to create database tables:"
echo -e "=> ${LIGHT_CYAN}$ docker-compose run --rm artisan migrate"

while ! docker exec neireez_mysql mysqladmin --user=root --password=secret --host "127.0.0.1" ping --silent &> /dev/null ; do
    echo "Waiting for database connection..."
    sleep 3
done

docker-compose run --rm artisan migrate

echo ""
echo -e "=> ${CYAN}Hello World :)"
echo ""
echo -e "=> ${CYAN}By ${WHITE}Ali Alizade ${CYAN}[ali.alizade@outlook.com]"