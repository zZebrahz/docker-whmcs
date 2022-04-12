FROM    ajoergensen/baseimage-ubuntu

LABEL	maintainer="RXWatcher"

ARG     TARGETARCH
ENV     TA=${TARGETARCH}

ENV     PHP_VERSION=7.4 \
        VIRTUAL_HOST=$DOCKER_HOST \
        HOME=/var/www/whmcs \
        PUID=1000 \
        PGID=1000 \
        TZ=Asia/Jakarta \
        WHMCS_SERVER_IP=172.17.0.1 \
        REAL_IP_FROM=172.17.0.0/16 \
        SSH_PORT=2222

COPY    build/ /build

RUN     build/${TA}_setup.sh && rm -rf /build

COPY    root/app /app
COPY    root/etc/cron.d/ /etc/cron.d/
COPY    root/etc/my_init.d/ /etc/my_init.d/
COPY    root/etc/nginx/ /etc/nginx/
COPY    root/etc/service/nginx/ /etc/service/nginx/
COPY    root/etc/service/php-fpm/ /etc/service/php-fpm/
COPY    root/etc/ssh/ /etc/ssh/
COPY    --from=ajoergensen/baseimage-ubuntu /etc/service/. /etc/service/

RUN     chmod -v +x /etc/my_init.d/*.sh /etc/service/*/run
RUN     chmod -v 700 /etc/cron.d/app
RUN     dpkg-reconfigure openssh-server

# Set default php-cli version to match $PHP_VERSION
RUN     update-alternatives --set php /usr/bin/php7.4

EXPOSE  80

WORKDIR /var/www/whmcs
