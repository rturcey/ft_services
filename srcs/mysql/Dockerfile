FROM alpine:latest

WORKDIR /app
VOLUME /app
COPY startup.sh /startup.sh
# COPY wordpressdb.sql /wordpressdb.sql

RUN apk add --update mysql mysql-client && rm -f /var/cache/apk/*
COPY my.cnf /etc/mysql/my.cnf
COPY wordpressdb.sql .

EXPOSE 3306
CMD ["/startup.sh"]