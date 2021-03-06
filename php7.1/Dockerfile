FROM php:7.1-fpm

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
	&& apt-get install -y nginx \
	&& apt-get install -y git \
	&& apt-get install -y net-tools \
	&& apt-get install -y vim \
	&& apt-get install -y procps \
	&& apt-get install -y net-tools \
	&& apt-get install -y iputils-ping \
	&& apt-get install -y automake \
	&& apt-get install -y libtool \
    && docker-php-source extract \
    && pecl install /var/www/tmp/grpc-1.17.0.tgz \
    && pecl install /var/www/tmp/protobuf-3.7.0.tgz \
    && pecl install /var/www/tmp/redis-4.2.0.tgz \
    && pecl install /var/www/tmp/swoole-1.10.2.tgz \
    && pecl install xdebug \
# swoole和grpc扩展有冲突，会导致worker阻塞, 必须先在配置文件启用swoole扩展, 代码中在onWorkerStart回调中dl动态加载grpc扩展
#    && docker-php-ext-enable grpc \
    && docker-php-ext-enable protobuf \
    && docker-php-ext-enable swoole \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install bcmath \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && echo 'alias ll="ls -al"' > /root/.bashrc

ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-n"]
WORKDIR /