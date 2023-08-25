FROM php:8.1-fpm-alpine

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat git bash zip curl-dev \
     freetype libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libwebp-dev \
    && apk add $PHPIZE_DEPS \
    && pecl install xdebug \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install pdo_mysql \
    && addgroup -g 1000 --system app \
    && adduser -G app --system -D -s /bin/sh -u 1000 app \
    && sed -i "s/user = www-data/user = api/g; s/group = www-data/group = app/g" /usr/local/etc/php-fpm.d/www.conf \
    && echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp \
    && docker-php-ext-install -j$(nproc) gd

WORKDIR /home/public_html
USER app

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
