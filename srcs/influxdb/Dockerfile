FROM alpine:latest

ENV INFLUXDB_VERSION 1.7.10

RUN wget --no-verbose https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz.asc && \
    wget --no-verbose https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    mkdir -p /usr/src && \
    tar -C /usr/src -xzf influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
    rm -f /usr/src/influxdb-*/influxdb.conf && \
    chmod +x /usr/src/influxdb*/* && \
    cp -a /usr/src/influxdb-*/* /usr/bin/

COPY influxdb.conf /etc/influxdb/influxdb.conf

COPY ./setdb.sh setdb.sh
COPY ./entrypoint.sh entrypoint.sh
RUN chmod 755 setdb.sh
RUN chmod 755 entrypoint.sh

EXPOSE 8086

CMD sh entrypoint.sh
CMD influxd