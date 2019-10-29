FROM php:5.6-fpm

MAINTAINER helinhan

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
libfreetype6-dev \
libjpeg62-turbo-dev \
libmcrypt-dev \
libpng-dev \
libmemcached-dev \
zlib1g-dev \
libbz2-dev \
libgmp-dev \
libedit-dev \
libxml2-dev \
libxslt-dev \
openssl \
libssl-dev \
libpq-dev \
nginx \
procps \
vim \
curl \
wget \
supervisor \
net-tools \
&& docker-php-ext-install -j$(nproc) iconv \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd  \
bcmath \
mysqli \
pdo_mysql \
bz2 \
calendar \
exif \
gettext \
intl \
pcntl \
readline \
pgsql \
pdo_pgsql \
shmop \
sockets \
wddx \
xsl \
zip \
opcache \
mcrypt \
&& pecl install igbinary-1.2.1 && docker-php-ext-enable igbinary \
&& echo "\n" | pecl install redis && docker-php-ext-enable redis \
&& echo "\n" | pecl install memcache && docker-php-ext-enable memcache \
&& echo "\n" | pecl install memcached-2.2.0  && docker-php-ext-enable memcached \
&& pecl install mongodb && docker-php-ext-enable mongodb \
&& echo "\n" | pecl install mongo && docker-php-ext-enable mongo \
&& docker-php-source delete \
&& apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# 安装 Composer
COPY ./pkg/composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer && composer config -g repo.packagist composer https://packagist.phpcomposer.com

# 设置日志文件夹权限
RUN mkdir -p /data && chmod -R 777 /data

# protobuf redis grpc
COPY ./software/* /var/www/tmp/

RUN pecl install protobuf && docker-php-ext-enable protobuf
#RUN pecl install /var/www/tmp/protobuf-3.7.0.tgz && docker-php-ext-enable protobuf
#RUN pecl install /var/www/tmp/grpc-1.17.0.tgz && docker-php-ext-enable grpc
RUN pecl install /var/www/tmp/redis-4.2.0.tgz && docker-php-ext-enable redis

# 设置php的时区
RUN touch /usr/local/etc/php/conf.d/docker-php-ext-timezone.ini \
&& echo "date.timezone = Asia/Shanghai" > /usr/local/etc/php/conf.d/docker-php-ext-timezone.ini

RUN apt-get update && apt-get install -y git

ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-n"]
WORKDIR /