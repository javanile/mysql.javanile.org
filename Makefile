
ssh:
	@sshpass -p $${SSH_PASSWORD} ssh contrib/remote-*.sh $${SSH_USER}@${SSH_HOST} -p $${SSH_PORT:-22}

deploy:
	@git add .
	@git commit -am "Deploy"
	@git push
	cat contrib/deploy.sh | make -s ssh
