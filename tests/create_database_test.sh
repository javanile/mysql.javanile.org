#!/bin/bash
set -e

make -s test-sql < lib/create_database.sql
echo "DROP USER 'test'@'%'; FLUSH PRIVILEGES;" | make -s test-sql

echo "==> Creating test database"
make -s test-sql < tests/create_database_test.sql | tee tests/tmp/create_database_test.out

echo
echo "==> Testing user access"
export MYSQL_PWD=$(grep "IDENTIFIED BY" < tests/tmp/create_database_test.out | cut -d' ' -f9 | tr -d "'")
mysql -u test -h 0.0.0.0 -e "SHOW DATABASES;"
