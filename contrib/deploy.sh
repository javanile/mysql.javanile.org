#!/usr/bin/env bash

echo "$1" | sudo -S su

[ ! -d /opt/mysql.javanile.org ] && git clone https://github.com/javanile/mysql.javanile.org /opt/mysql.javanile.org

cd /opt/mysql.javanile.org

git pull

make start
