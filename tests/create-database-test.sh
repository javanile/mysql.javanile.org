#!/bin/bash
set -e

make -s test-file < lib/create_database.sql

create_database_output=$(make -s test-file < tests/fixtures/create_database.sql)
echo "$create_database_output"

echo "--> Testing user access"
export MYSQL_PWD=$(echo "$create_database_output" | grep "IDENTIFIED BY" | cut -d' ' -f9 | tr -d "'")
mysql -u test -h 0.0.0.0 -e "SHOW DATABASES;"


