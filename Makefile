
include .env
export $(shell test -f .env && cut -d= -f1 .env)

##

ssh:
	@sshpass -p $${SSH_PASSWORD} ssh $${SSH_USER}@${SSH_HOST} -p $${SSH_PORT:-22} bash -s -- $${SSH_PASSWORD}

deploy:
	@date > contrib/RELEASE
	@git add .
	@git commit -am "Deploy"
	@git push
	@cat contrib/deploy.sh | make -s ssh

restart:
	@docker compose pull
	@docker compose up -d --force-recreate && sleep 15
	@docker compose logs mysql

## =====
## Tests
## =====

test:
	@docker compose up -d
	@docker compose exec mysql printenv