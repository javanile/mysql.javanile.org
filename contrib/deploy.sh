#!/usr/bin/env bash
set -e

[ ! -d /opt/mysql.javanile.org ] && echo "$1" | sudo -S git clone https://github.com/javanile/mysql.javanile.org /opt/mysql.javanile.org

cd /opt/mysql.javanile.org

git pull

make start
