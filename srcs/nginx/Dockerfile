FROM nginx:alpine

RUN mkdir -p /run/nginx

# install SSL
RUN apk add openrc --no-cache
RUN apk add acf-openssl
RUN apk update && apk upgrade

# conf & generate SSL
COPY nginx.conf /etc/nginx/nginx.conf  
RUN mkdir -p /var/lib/nginx/html/
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=IDF/L=Paris/O=42/CN=rturcey' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.pem

# add user for nginx
RUN set -x \
	&& adduser -u 82 -D -S -G www-data www-data
RUN chown -R www-data:www-data /var/lib/nginx/html/ \
&& chmod -R 755 /var/lib/nginx/html/

# config SSH
RUN apk update && apk add openssh && \
    rm -rf /var/cache/apk/*
COPY id_rsa /etc/ssh/ssh_host_rsa_key
COPY sshd_config /etc/ssh/
RUN chmod 600 -R /etc/ssh/*

EXPOSE 80 443 400

COPY setssh.sh .
RUN chmod +x /setssh.sh
CMD ./setssh.sh