#!/usr/bin/env bash
set -e

echo "$1" | sudo -S git config --global --add safe.directory /opt/mysql.javanile.org

if [ ! -d /opt/mysql.javanile.org ]; then
   echo "$1" | sudo -S git config --global --add safe.directory /opt/mysql.javanile.org
   echo "$1" | sudo -S git clone https://github.com/javanile/mysql.javanile.org /opt/mysql.javanile.org
fi

cd /opt/mysql.javanile.org

git pull

make start
