FROM alpine:3.7

LABEL MAINTAINER="Aurelien PERRIER <a.perrier89@gmail.com>"

# Installing packages MariaDB
RUN apk add --no-cache mysql
RUN addgroup mysql mysql

# Work path
WORKDIR /scripts

# Copy of the MySQL startup script
COPY startup.sh startup.sh
COPY wordpressdb.sql wordpressdb.sql

COPY my.cnf /etc/mysql/my.cnf

# Creating the persistent volume
VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

ENTRYPOINT [ "./startup.sh" ]