FROM php:7.2-fpm

MAINTAINER helinhan

RUN mkdir -p /var/www/tmp
RUN mkdir -p /var/www/tmp/data

COPY ./software/* /var/www/tmp/

RUN set -xe \
    && buildDeps=" \
       $PHP_EXTRA_BUILD_DEPS \
       " \
	&& apt-get update \
	&& apt-get install -y zlib1g-dev \
	&& apt-get install -y --force-yes $buildDeps --no-install-recommends \
	&& apt-get install -y supervisor \
	&& apt-get install -y libfreetype6-dev \
    && apt-get install -y libjpeg62-turbo-dev \
    && apt-get install -y libpng-dev \
	&& apt-get install -y git \
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
    && docker-php-source extract \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install /var/www/tmp/grpc-1.17.0.tgz \
    && pecl install /var/www/tmp/protobuf-3.7.0.tgz \
    && pecl install /var/www/tmp/redis-4.2.0.tgz \
    && docker-php-ext-enable grpc \
    && docker-php-ext-enable protobuf \
    && docker-php-ext-enable redis \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && echo 'alias ll="ls -al"' > /root/.bashrc

RUN apt-get install -y wget
RUN cd /tmp && wget https://pecl.php.net/get/swoole-4.4.12.tgz && \
    tar zxvf swoole-4.4.12.tgz && \
    cd swoole-4.4.12  && \
    phpize  && \
    ./configure  --enable-openssl && \
    make && make install

RUN touch /usr/local/etc/php/conf.d/swoole.ini && \
    echo 'extension=swoole.so' > /usr/local/etc/php/conf.d/swoole.ini

RUN pecl install /var/www/tmp/rabbitmq-c-0.8.0.tar.gz && docker-php-ext-enable amqp

ADD supervisord.conf /etc/supervisord.conf

WORKDIR /app
CMD ["/usr/bin/supervisord", "-n"]