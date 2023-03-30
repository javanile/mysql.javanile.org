
include .env
export $(shell test -f .env && cut -d= -f1 .env)

ssh:
	@sshpass -p $${SSH_PASSWORD} ssh $${SSH_USER}@${SSH_HOST} -p $${SSH_PORT:-22} bash -s -- $${SSH_PASSWORD}

deploy:
	@git add .
	@git commit -am "Deploy"
	@git push
	cat contrib/deploy.sh | make -s ssh
