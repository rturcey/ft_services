FROM alpine:latest

WORKDIR /app
VOLUME /app
COPY setdb.sh /setdb.sh

#install MySQL & conf & db
RUN apk add --update mysql mysql-client && rm -f /var/cache/apk/*
COPY my.cnf /etc/mysql/my.cnf
COPY wordpressdb.sql .

EXPOSE 3306
CMD ["/setdb.sh"]