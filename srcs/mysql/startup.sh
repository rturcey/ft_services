#!/bin/sh

if [ ! -d "/run/mysqld" ]; then
  mkdir -p /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
  echo '[i] MySQL directory already present, skipping creation'
else
  echo "[i] MySQL data directory not found, creating initial DBs"

  # init database
  echo 'Initializing database'
  mysql_install_db --user=mysql > /dev/null
  echo 'Database initialized'

  echo "[i] MySql root password: $MYSQL_ROOT_PASSWORD"

  # create temp file
  tfile=`mktemp`
  if [ ! -f "$tfile" ]; then
      return 1
  fi

  # save sql
  echo "[i] Create temp file: $tfile"
  cat << EOF > $tfile

FLUSH PRIVILEGES;
CREATE DATABASE wordpressdb;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
EOF

  echo 'FLUSH PRIVILEGES;' >> $tfile

  # run sql in tempfile
  echo "[i] run tempfile: $tfile"
  /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
  rm -f $tfile
  ls -la
  mysql wordpressdb -u root --password=password  < wordpressdb.sql
fi

echo "[i] Sleeping 5 sec"
sleep 5

echo "Starting all process"
exec /usr/bin/mysqld --user=mysql --console

