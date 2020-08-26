FROM php:7.3.14-fpm

MAINTAINER helinhan

RUN set -xe \
    && buildDeps=" \
       $PHP_EXTRA_BUILD_DEPS \
       " \
	&& apt-get update \
	&& apt-get install -y zlib1g-dev \
	&& apt-get install -y --force-yes $buildDeps --no-install-recommends \
	&& apt-get install -y libfreetype6-dev \
    && apt-get install -y libjpeg62-turbo-dev \
    && apt-get install -y libpng-dev \
	&& apt-get install -y net-tools \
	&& apt-get install -y vim \
	&& apt-get install -y procps \
	&& apt-get install -y net-tools \
	&& apt-get install -y iputils-ping \
	&& apt-get install -y automake \
	&& apt-get install -y libtool \
	&& apt-get install -y zip \
	&& apt-get install -y unzip \
	&& apt-get install -y openssl \
	&& apt-get install -y libssl-dev \
	&& apt-get install -y librabbitmq-dev \
	&& apt-get install -y libxml2-dev \
    && docker-php-source extract \
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
    && docker-php-ext-install zip \
    && docker-php-ext-install opcache \
    && docker-php-ext-install soap \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && echo 'alias ll="ls -al"' > /root/.bashrc

WORKDIR /data
CMD ["php-fpm","-D"]