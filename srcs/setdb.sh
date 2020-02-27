#!/bin/sh
curl -s -H "Content-Type: application/json" \
    -XPOST http://192.168.99.103:3000/api/datasources \
    -d @- << EOF
    {
        "name":"influxdb",
        "type":"influxdb",
        "url":"http://192.168.99.103:8086",
        "password":"password",
        "user":"root",
        "access":"proxy",
        "basicAuth":false,
        "database":"influxdb",
        "isDefault":true,
        "jsonData": {
            "timeInterval":"10s"
        }
    }
EOF

cp ./srcs/originals/dashboard.json ./srcs/dashboard_telegraf.json
sed -i '' "s/DASHBOARD_NAME/telegraf/g" ./srcs/dashboard_telegraf.json
curl -s -H "Content-Type: application/json" \
    -XPOST http://192.168.99.103:3000/api/dashboards/db \
    -d @./srcs/dashboard_telegraf.json