
include .env
export $(shell test -f .env && cut -d= -f1 .env)

## ======
## Docker
## ======

up:
	@docker compose up -d

## ======
## Deploy
## ======

deploy:
	@bash scripts/deploy.sh $(env)

## =====
## Tests
## =====

test:
	@docker compose up -d
	@docker compose exec mysql printenv

test-init:
	@mkdir -p tests/tmp

test-sql:
	@docker compose exec -T -e MYSQL_PWD=$${MYSQL_ROOT_PASSWORD} mysql sh -c 'mysql -h 0.0.0.0 -u root'

test-create-database: test-init
	@bash tests/create_database_test.sh

test-remote-create-database:
	@MYSQL_PWD=secret mysql -h $${SSH_HOST} -u root < lib/create_database.sql
	@MYSQL_PWD=secret mysql -h $${SSH_HOST} -u root -e "USE mysql; CALL create_database(test)"

test-backup:
	@docker compose exec -T -e MYSQL_PWD=$${MYSQL_ROOT_PASSWORD} mysql sh -c 'mysql -h 0.0.0.0 -u root' < tests/fixtures/create_test_databases.sql
	@docker compose up -d --force-recreate backup
	@docker compose logs -f backup

test-show-databases:
	@docker compose exec -T -e MYSQL_PWD=$${MYSQL_ROOT_PASSWORD} mysql sh -c 'mysql -h 0.0.0.0 -u root -e "SHOW DATABASES;"'
