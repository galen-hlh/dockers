FROM php:7.2
# --build-arg timezone=Asia/Shanghai
ARG timezone
# app env: prod pre test dev
ARG app_env=prod
# default use www user
ARG work_user=www
ENV APP_ENV=${app_env:-"prod"} \
    TIMEZONE=${timezone:-"Asia/Shanghai"} \
    PHPREDIS_VERSION=5.1.0 \
    RABBITMQ_VERSION=0.8.0 \
    AMQP_VERSION=1.9.4 \
    SWOOLE_VERSION=4.4.8 \
    COMPOSER_ALLOW_SUPERUSER=1
# Libs -y --no-install-recommends
RUN apt-get update \
    && apt-get install -y \
        curl wget zip unzip less vim openssl \
        libz-dev \
        libssl-dev \
        libnghttp2-dev \
        libpcre3-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        librabbitmq-dev \
# Install PHP amqp
    && pecl install amqp && docker-php-ext-enable amqp \
# Install composer
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update --clean-backups \
# Install PHP extensions
    && docker-php-ext-install \
       bcmath gd pdo_mysql mbstring sockets zip sysvmsg sysvsem sysvshm \
# Install redis extension
    && wget http://pecl.php.net/get/redis-${PHPREDIS_VERSION}.tgz -O /tmp/redis.tar.tgz \
    && pecl install /tmp/redis.tar.tgz \
    && rm -rf /tmp/redis.tar.tgz \
    && docker-php-ext-enable redis \
# Install swoole extension
    && wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz -O swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm swoole.tar.gz \
    && ( \
        cd swoole \
        && phpize \
        && ./configure --enable-mysqlnd --enable-sockets --enable-openssl --enable-http2 \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r swoole \
    && docker-php-ext-enable swoole \
# Clear dev deps
    && apt-get clean \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
# Timezone
    && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && echo "[Date]\ndate.timezone=${TIMEZONE}" > /usr/local/etc/php/conf.d/timezone.ini
EXPOSE 80