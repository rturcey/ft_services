FROM alpine:3.4

RUN apk update && apk add php5-cli php5-mysql php5-mysqli php5-pdo_mysql wget openssl php5-ctype php5-xml php5-mcrypt php5-gd php5-pdo php5-zlib php5-openssl php5-curl php5-opcache php5-json

RUN mkdir /www/

RUN wget --no-verbose https://files.phpmyadmin.net/phpMyAdmin/4.6.5.2/phpMyAdmin-4.6.5.2-all-languages.tar.gz && \
    tar zxvf phpMyAdmin-4.6.5.2-all-languages.tar.gz && \
    mv phpMyAdmin-4.6.5.2-all-languages/* /www/

COPY config.inc.php /www/config.inc.php
COPY ./start.sh start.sh

EXPOSE 5000

CMD ./start.sh