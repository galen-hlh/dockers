FROM golang:1.13.1

MAINTAINER helinhan

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 安装软件
RUN apt-get update && apt-get install -y vim \
procps \
vim \
wget \
aptitude \
supervisor \
curl \
git \
net-tools

# 设置ENV
ENV GOROOT=/usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH