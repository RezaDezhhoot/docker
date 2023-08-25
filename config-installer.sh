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

# Install ide-helper
docker-compose run --rm composer require --dev barryvdh/laravel-ide-helper

### Create ide-helper files
docker-compose run --rm --entrypoint "/bin/sh" artisan \
  -c "php artisan ide-helper:generate && php artisan ide-helper:models -n && php artisan ide-helper:meta"

sed -i -e "s/.*package:discover.*/&, \"@php artisan ide-helper:generate\", \"@php artisan ide-helper:meta\" /" ./api/composer.json

## Install Laravel/Telescope
docker-compose run --rm composer require laravel/telescope

docker-compose run --rm artisan telescope:install
docker-compose run --rm artisan migrate

sed -i '' -e 's/.*dont-discover": \[/& "laravel\/telescope"/' ./api/composer.json
