#!/bin/sh
curl -s -H "Content-Type: application/json" \
    -XPOST http://MINIKUBE_IP:3000/api/datasources \
    -d @- << EOF
    {
        "name":"influxdb",
        "type":"influxdb",
        "url":"http://MINIKUBE_IP:8086",
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

pwd
cp ./srcs/originals/dashboard.json ./srcs/dashboards/dashboard_telegraf.json
sed -i '' "s/DASHBOARD_NAME/telegraf/g" ./srcs/dashboards/dashboard_telegraf.json
curl -s -H "Content-Type: application/json" \
    -XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
    -d @./srcs/dashboards/dashboard_telegraf.json

cp ./srcs/originals/dashboard.json ./srcs/dashboards/dashboard_mysql.json
sed -i '' "s/DASHBOARD_NAME/mysql/g" ./srcs/dashboards/dashboard_mysql.json
curl -s -H "Content-Type: application/json" \
    -XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
    -d @./srcs/dashboards/dashboard_mysql.json

cp ./srcs/originals/dashboard.json ./srcs/dashboards/dashboard_wordpress.json
sed -i '' "s/DASHBOARD_NAME/wordpress/g" ./srcs/dashboards/dashboard_wordpress.json
curl -s -H "Content-Type: application/json" \
    -XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
    -d @./srcs/dashboards/dashboard_wordpress.json

cp ./srcs/originals/dashboard.json ./srcs/dashboards/dashboard_nginx.json
sed -i '' "s/DASHBOARD_NAME/nginx/g" ./srcs/dashboards/dashboard_nginx.json
curl -s -H "Content-Type: application/json" \
    -XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
    -d @./srcs/dashboards/dashboard_nginx.json

cp ./srcs/originals/dashboard.json ./srcs/dashboards/dashboard_ingress.json
sed -i '' "s/DASHBOARD_NAME/ingress/g" ./srcs/dashboards/dashboard_ingress.json
curl -s -H "Content-Type: application/json" \
    -XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
    -d @./srcs/dashboards/dashboard_ingress.json

cp ./srcs/originals/dashboard.json ./srcs/dashboards/dashboard_grafana.json
sed -i '' "s/DASHBOARD_NAME/grafana/g" ./srcs/dashboards/dashboard_grafana.json
curl -s -H "Content-Type: application/json" \
    -XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
    -d @./srcs/dashboards/dashboard_grafana.json

cp ./srcs/originals/dashboard.json ./srcs/dashboards/dashboard_influxdb.json
sed -i '' "s/DASHBOARD_NAME/influxdb/g" ./srcs/dashboards/dashboard_influxdb.json
curl -s -H "Content-Type: application/json" \
    -XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
    -d @./srcs/dashboards/dashboard_influxdb.json

cp ./srcs/originals/dashboard.json ./srcs/dashboards/dashboard_phpmyadmin.json
sed -i '' "s/DASHBOARD_NAME/phpmyadmin/g" ./srcs/dashboards/dashboard_phpmyadmin.json
curl -s -H "Content-Type: application/json" \
    -XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
    -d @./srcs/dashboards/dashboard_phpmyadmin.json