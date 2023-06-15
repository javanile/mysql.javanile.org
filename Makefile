
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

dependencies:
	@apt-get install git make

clone: dependencies
	@git config --global --add safe.directory /opt/mysql.javanile.org
	@git clone https://github.com/javanile/mysql.javanile.org /opt/mysql.javanile.org

ssh:
	@sshpass -p $${SSH_PASSWORD} ssh $${SSH_USER}@${SSH_HOST} -p $${SSH_PORT:-22} bash -s -- $${SSH_PASSWORD}

deploy:
	@sed -i '3s/.*/> **Last deploy**: $(shell date +"%Y-%m-%d %H:%M:%S")/' README.md
	@git add .
	@git commit -am "Deploy"
	@git push
	@cat contrib/deploy.sh | make -s ssh

restart:
	@docker compose pull
	@docker compose up -d --force-recreate && sleep 15
	@docker compose logs mysql

expose-docker:
	@echo '{"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}' > /etc/docker/daemon.json
	@mkdir -p /etc/systemd/system/docker.service.d
	@printf "[Service]\nExecStart=\nExecStart=/usr/bin/dockerd\n" > /etc/systemd/system/docker.service.d/override.conf
	@systemctl daemon-reload
	@systemctl restart docker.service

## =====
## Tests
## =====

test:
	@docker compose up -d
	@docker compose exec mysql printenv

test-create-database:
	@docker compose exec -T -e MYSQL_PWD=$${MYSQL_ROOT_PASSWORD} mysql sh -c 'mysql -h 0.0.0.0 -u root' < lib/create_database.sql
	@docker compose exec -T -e MYSQL_PWD=$${MYSQL_ROOT_PASSWORD} mysql sh -c 'mysql -h 0.0.0.0 -u root' < tests/fixtures/create_database.sql

test-remote-create-database:
	@MYSQL_PWD=secret mysql -h $${SSH_HOST} -u root < lib/create_database.sql
	@MYSQL_PWD=secret mysql -h $${SSH_HOST} -u root -e "USE mysql; CALL create_database(test)"

test-backup:
	@docker compose exec -T -e MYSQL_PWD=$${MYSQL_ROOT_PASSWORD} mysql sh -c 'mysql -h 0.0.0.0 -u root' < tests/fixtures/create_test_databases.sql
	@docker compose up -d --force-recreate backup
	@docker compose logs -f backup

test-show-databases:
	@docker compose exec -T -e MYSQL_PWD=$${MYSQL_ROOT_PASSWORD} mysql sh -c 'mysql -h 0.0.0.0 -u root -e "SHOW DATABASES;"'
