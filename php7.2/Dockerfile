FROM php:7.2.12-fpm

MAINTAINER helinhan

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 更新安装依赖包和PHP核心拓展
RUN apt-get update && apt-get install -y \
        aptitude \
        supervisor \
        wget \
        vim \
        zip \
        net-tools \
        curl \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        nginx \
        procps \
        libxml2-dev \
        libmcrypt-dev \
        libbz2-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
        && pecl install mcrypt-1.0.1 \
        && pecl install -o swoole-4.4.12 \
        && docker-php-ext-install zip \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache \
        && docker-php-ext-install mysqli \
        && docker-php-ext-install soap \
        && docker-php-ext-install bz2 \
        && docker-php-ext-install bcmath \
        && docker-php-ext-enable swoole \
        && docker-php-ext-enable opcache \
        && docker-php-ext-enable mcrypt \
        && aptitude -y install gcc make zlib1g-dev libffi-dev libssl-dev

# 添加自启文件
ADD ./run.sh /run.sh
RUN chmod +x /run.sh

# 拷贝扩展
COPY ./software/* /var/www/tmp/

# 安装 Composer
RUN mv /var/www/tmp/composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer && composer config -g repo.packagist composer https://packagist.phpcomposer.com

# grpc protobuf
RUN pecl install /var/www/tmp/grpc-1.17.0.tgz \
&& pecl install /var/www/tmp/protobuf-3.7.0.tgz \
&& docker-php-ext-enable protobuf

# redis
RUN pecl install /var/www/tmp/redis-4.2.0.tgz \
&& docker-php-ext-enable redis

ADD supervisord.conf /etc/supervisord.conf

RUN rm -rf /var/www/tmp/*

CMD ["/usr/bin/supervisord", "-n"]

WORKDIR /