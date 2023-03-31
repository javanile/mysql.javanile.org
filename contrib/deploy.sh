#!/usr/bin/env bash
set -e

#echo "$1" | sudo -S rm -fr /opt/mysql.javanile.org

if [ ! -d /opt/mysql.javanile.org ]; then
  echo "$1" | sudo -S apt-get install make
  echo "$1" | sudo -S git config --global --add safe.directory /opt/mysql.javanile.org
  echo "$1" | sudo -S git clone https://github.com/javanile/mysql.javanile.org /opt/mysql.javanile.org

fi


cd /opt/mysql.javanile.org

echo "==> Update"
echo "$1" | sudo -S git pull

if [ ! -f .env ]; then
  echo "$1" | sudo -S cp .env.prod .env
fi

echo "$1" | sudo -S make expose-docker


echo "==> Restart"
echo "$1" | sudo -S make restart
