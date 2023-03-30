#!/usr/bin/env bash

[ ! -d /opt/mysql.javanile.org ] && git clone https://github.com/javanile/mysql.javanile.org /opt/mysql.javanile.org

cd /opt/mysql.javanile.org

git pull

make start
