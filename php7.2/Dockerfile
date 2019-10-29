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
        && pecl install -o swoole-4.3.3 \
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

# 安装python3.6p
RUN cd /home && wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
RUN cd /home && tar -xvf Python-3.7.0.tgz && chmod -R +x Python-3.7.0
RUN cd /home/Python-3.7.0/ && ./configure && make && make install

# 设置python的环境变量
#RUN rm -rf /usr/bin/python && ln -s /usr/local/bin/python3.6 /usr/bin/python
#RUN echo "alias python='/usr/local/bin/python3.7'" > ~/.bashrc
RUN ln -s /usr/local/bin/python3.7 /usr/local/bin/python
RUN ln -s /usr/local/bin/pip3 /usr/local/bin/pip

#安装python的包
ADD ./requirements.txt ./requirements.txt
RUN pip install -r requirements.txt

# 安装chrome
RUN apt-get -y install libxss1 libappindicator1 libindicator7
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; exit 0
RUN apt-get -y -f install
RUN dpkg -i google-chrome-stable_current_amd64.deb

# 安装chromedriver
RUN wget http://chromedriver.storage.googleapis.com/74.0.3729.6/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip && chmod +x chromedriver
RUN mv -f chromedriver /usr/local/share/chromedriver \
&& ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver \
&& ln -s /usr/local/share/chromedriver /usr/bin/chromedriver

# 安装golang
RUN wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz && tar -xvf go1.12.6.linux-amd64.tar.gz && mv go /usr/local \
&& rm -rf go1.12.6.linux-amd64.tar.gz && rm -rf go1.12.6.linux-amd64
ENV GOROOT=/usr/local/go
ENV GOPATH=/data/styd/gopath
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# 添加自启文件
ADD ./run.sh /run.sh
RUN chmod +x /run.sh

# 安装 PECL 拓展，这里我们安装的是Redis
COPY ./pkg/redis-4.1.1.tgz /home/redis.tgz
RUN pecl install /home/redis.tgz && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

# 安装 Composer
COPY ./pkg/composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer && composer config -g repo.packagist composer https://packagist.phpcomposer.com

# 安装protobuf
RUN pecl install /var/www/tmp/grpc-1.17.0.tgz && pecl install /var/www/tmp/protobuf-3.7.0.tgz && docker-php-ext-enable protobuf
RUN mkdir -p /data/styd/gopath/ && mkdir -p /data/logs/smart_gateway

RUN rm -f /home/redis.tgz

ADD supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-n"]

WORKDIR /