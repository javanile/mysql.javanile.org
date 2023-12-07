#!/usr/bin/env bash
set -e

env=$1
date=$(date +"%Y-%m-%d %H:%M:%S")
sed -i "3s/.*/> **Last deploy**: ${date}/" README.md

git add .
git commit -am "Deploy" && true
git push

source ".env.$env"

export MYSQL_PWD=$MYSQL_ROOT_PASSWORD
mysql -h "$MYSQL_HOST" -u root < lib/create_database.sql
