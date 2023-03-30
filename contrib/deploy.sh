#!/usr/bin/env bash
set -e

if [ ! -d /opt/mysql.javanile.org ]; then
   echo "$1" | sudo -S git config --global --add safe.directory /opt/mysql.javanile.org
   echo "$1" | sudo -S git clone https://github.com/javanile/mysql.javanile.org /opt/mysql.javanile.org
fi

cd /opt/mysql.javanile.org

echo "==> Update"
echo "$1" | sudo -S git pull

echo "==> Restart"
echo "$1" | sudo -S make start
