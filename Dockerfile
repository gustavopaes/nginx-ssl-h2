FROM debian:jessie

MAINTAINER Gustavo Paes "gustavo.paes@gmail.com"

ENV NGINX_VERSION 1.10.1
ENV OPENSSL_VERSION 1.0.2h

# remove native openssl and upgrade system
RUN apt-get update && apt-get upgrade -y

RUN useradd -ms /bin/bash nginx

# install dependencies to compile openssl and nginx
RUN apt-get install -y \
      ca-certificates \
      build-essential \
      libpcre3 \
      libpcre3-dev \
      zlib1g \
      zlib1g-dev \
      libssl-dev \
      wget

# download openssl source
RUN wget -q http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
  && tar -xvzf openssl-${OPENSSL_VERSION}.tar.gz \
  && mv openssl-${OPENSSL_VERSION} /usr/local/src/openssl-${OPENSSL_VERSION}

# download and install nginx
RUN wget -q http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar -xzvf nginx-${NGINX_VERSION}.tar.gz \
  && cd nginx-${NGINX_VERSION} \
  && ./configure \
    --prefix=/usr/local/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-openssl=/usr/local/src/openssl-${OPENSSL_VERSION} \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --with-threads \
    --with-ipv6 \
  && make \
  && make install

# default nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# remove no neede more packages
RUN apt-get purge build-essential wget -y \
  && apt-get autoremove -y

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# clean downloaded sources
RUN rm nginx-${NGINX_VERSION}.tar.gz
RUN rm openssl-${OPENSSL_VERSION}.tar.gz

VOLUME /var/www

EXPOSE 80 443
