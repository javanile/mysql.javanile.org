#!/usr/bin/env bash
set -e

env=$1

sed -i '3s/.*/> **Last deploy**: $(shell date +"%Y-%m-%d %H:%M:%S")/' README.md

git add .
git commit -am "Deploy"
git push

