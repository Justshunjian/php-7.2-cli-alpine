FROM php:7.2-cli-alpine

LABEL Maintainer="Author" \
      Description="Lightweight php 7.2 container based on alpine with Swoole enabled, composer installed."

# dependence
RUN apk update \
    && apk add --no-cache supervisor nginx curl git mysql-client \
    icu libgd libpng libjpeg-turbo libmcrypt libmcrypt-dev pwgen \
    && apk add --no-cache --virtual build-dependencies icu-dev \
    libxml2-dev freetype-dev libpng-dev libjpeg-turbo-dev g++ make autoconf \
    && docker-php-source extract \
    && docker-php-ext-install bcmath gd pdo_mysql soap intl zip sockets opcache \
    && pecl install mongodb redis inotify \
    # enable debug/trace log support? [no]
    # enable sockets supports? [no]
    # enable openssl support? [no]
    # enable http2 support? [no]
    # enable async-redis support? [no]
    # enable mysqlnd support? [yes]
    # enable postgresql coroutine client support? [no]
    && printf "no\nno\nno\nno\nno\nyes\nno\n" | pecl install swoole \
    && docker-php-ext-enable mongodb redis swoole inotify \
    && docker-php-source delete \
    && curl -sS https://getcomposer.org/installer | php -- \
       --install-dir=/usr/local/bin --filename=composer \
    && apk del build-dependencies \
    && apk del libmcrypt-dev \
    && rm -rf /tmp/* \
    && mkdir -p /run/nginx
