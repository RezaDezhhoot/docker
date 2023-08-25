#!/bin/bash

set -e

echo "🟡 Deploying application..."
cd ./api

echo "🟡 Enter the maintenance mode"
php artisan down

    echo "🟡 Update code base"
    git pull origin main

    echo "🟡 Install dependency based on lock file"
    composer install --no-interaction --prefer-dist --optimize-autoloader

    echo "🟡 Migrate database"
    php artisan migrate --force

    echo "🟡 Clear Cache"
    php artisan optimize

    echo "🟡 Reload supervisord"
#    supervisorctl reread
#    supervisorctl update
#    supervisorctl reload

echo "🟡 Exit maintenance mode"
php artisan up

echo "🚀 Application deployed!"



