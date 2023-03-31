#!/usr/bin/env bash
set -e

#echo "$1" | sudo -S rm -fr /opt/mysql.javanile.org

if [ ! -d /opt/mysql.javanile.org ]; then
  echo "$1" | sudo -S make clone
  echo "$1" | sudo -S make expose-docker
fi

cd /opt/mysql.javanile.org

echo "==> Update"
echo "$1" | sudo -S git pull

if [ ! -f .env ]; then
  echo "$1" | sudo -S cp .env.prod .env
fi

echo "==> Restart"
echo "$1" | sudo -S make restart
