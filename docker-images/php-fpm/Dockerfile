FROM php:7.2-fpm

LABEL Simon Bustamante <simon.bustamante@gmail.com>

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libicu-dev \
    && docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir \
    && docker-php-ext-install -j$(nproc) gd zip iconv pdo pdo_mysql intl

COPY php.ini-development /usr/local/etc/php/php.ini-development
COPY php.ini-production /usr/local/etc/php/php.ini-production

WORKDIR /html

#RUN apt-get install git -y \
#    && git clone -b php7 https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis \
#    && docker-php-ext-install -j$(nproc) redis

#Adding MySQL configuration
#COPY redis.ini /etc/php/mods-available/redis.ini
