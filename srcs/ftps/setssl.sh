#!/bin/sh
mkdir -p /ftps/$FTP_USER

# create SSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj '/C=FR/ST=IDF/L=Paris/O=42/CN=rturcey' \
	-keyout /etc/ssl/private/pure-ftpd.pem \
	-out /etc/ssl/private/pure-ftpd.pem

chmod 600 /etc/ssl/private/*.pem

# add user
adduser -h /ftps/$FTP_USER -D $FTP_USER
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

# starting FTPS
/usr/sbin/pure-ftpd -j -Y 2 -p 21000:21000 -P "192.168.99.152"
