FROM php:7.3.14-fpm

MAINTAINER helinhan

RUN set -xe \
    && buildDeps=" \
       $PHP_EXTRA_BUILD_DEPS \
       " \
	&& apt-get update \
	&& apt-get install -y --force-yes $buildDeps --no-install-recommends \
	zlib1g-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    net-tools \
    vim \
    cron \
    procps \
    net-tools \
    iputils-ping \
    automake \
    libtool \
    zip \
    unzip \
    openssl \
    libssl-dev \
    librabbitmq-dev \
    libxml2-dev \
    libzip-dev

RUN docker-php-source extract \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis-5.0.2 \
    && pecl install amqp-1.10.2 \
    && docker-php-ext-enable amqp \
    && docker-php-ext-enable redis \
    && docker-php-ext-install sockets \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install opcache \
    && docker-php-ext-install soap \
    && docker-php-ext-install zip \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && echo 'alias ll="ls -al"' > /root/.bashrc

COPY ./ini/php.ini /usr/local/etc/php/php.ini
COPY ./ini/www.conf /usr/local/etc/php-fpm.d/www.conf
RUN mkdir -p /opt/logs/php-fpm

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT /entrypoint.sh