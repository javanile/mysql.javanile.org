
USE mysql;

DROP USER test@'%';
FLUSH PRIVILEGES;

SELECT User, Host FROM mysql.user;

CALL create_database('test');

SELECT User, Host FROM mysql.user;