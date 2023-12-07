#!/usr/bin/env bash
set -e

env=$1

sed -i '3s/.*/> **Last deploy**: $(shell date +"%Y-%m-%d %H:%M:%S")/' README.md

git add .
git commit -am "Deploy" && true
git push

source ".env.$env"

echo $MYSQL_ROOT_PASSWORD