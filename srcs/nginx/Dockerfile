FROM nginx:alpine 

COPY nginx.conf /etc/nginx/nginx.conf

RUN apk add openssl --no-cache

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=rturcey' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

EXPOSE 80 443