#!/bin/sh

echo "Clearing any old processes..."
rm -f /run/apache2/apache2.pid
rm -f /run/apache2/httpd.pid

echo "Updating HTTPD config"
sed -i "s/ErrorLog logs\/error.log/Errorlog \/dev\/stderr\nTransferlog \/dev\/stdout/" /etc/apache2/httpd.conf

echo "Starting all process ..."
exec httpd -DFOREGROUND