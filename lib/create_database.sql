DELIMITER $$

USE `mysql`$$

DROP PROCEDURE IF EXISTS `create_database`$$

CREATE PROCEDURE `create_database` (IN `database_name` VARCHAR(34))
BEGIN

    -- --------- --
    -- Variables --
    -- --------- --
    DECLARE `database_host` CHAR(14) DEFAULT '@\'%\'';
    DECLARE `database_password` CHAR(40) DEFAULT '';
    DECLARE `database_quoted_name` CHAR(40) DEFAULT '';

    SET `database_password` := MD5(RAND());
    SET `database_quoted_name` := CONCAT('\'', REPLACE(TRIM(`database_name`), CHAR(39), CONCAT(CHAR(92), CHAR(39))), '\'');
    SET `database_password` := CONCAT('\'', REPLACE(`database_password`, CHAR(39), CONCAT(CHAR(92), CHAR(39))), '\'');

    -- ----------- --
    -- Create User --
    -- ----------- --
    SET @`create_user_sql` := CONCAT('CREATE USER IF NOT EXISTS ', `database_quoted_name`, `database_host`, ' IDENTIFIED BY ', `database_password`);
    SELECT @`create_user_sql`;
    PREPARE `statement_sql` FROM @`create_user_sql`;
    EXECUTE `statement_sql`;

    -- --------------- --
    -- Create Database --
    -- --------------- --
    SET @`create_database_sql` := CONCAT('CREATE DATABASE IF NOT EXISTS ', `database_name`);
    SELECT @`create_database_sql`;
    PREPARE `statement_sql` FROM @`create_database_sql`;
    EXECUTE `statement_sql`;

    -- ---------------- --
    -- Grant Privileges --
    -- ---------------- --
    SET @`grant_privileges_sql` := CONCAT('GRANT ALL PRIVILEGES ON ', `database_name`, '.* TO ', `database_quoted_name`, `database_host`);
    SELECT @`grant_privileges_sql`;
    PREPARE `statement_sql` FROM @`grant_privileges_sql`;
    EXECUTE `statement_sql`;

    DEALLOCATE PREPARE `statement_sql`;

    FLUSH PRIVILEGES;
END$$

DELIMITER ;
