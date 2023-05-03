DELIMITER $$

USE `mysql`$$

DROP PROCEDURE IF EXISTS `create_database`$$

CREATE PROCEDURE `create_database` (IN `database_name` VARCHAR(34))
BEGIN
    DECLARE `database_host` CHAR(14) DEFAULT '@\'localhost\'';
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
    PREPARE `stmt` FROM @`create_user_sql`;
    EXECUTE `stmt`;

    -- Create Database --
    SET @`sql` := CONCAT('CREATE DATABASE IF NOT EXISTS ', `database_name`);
    SELECT @`sql`;
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    -- Grant Privileges --
    SET @`sql` := CONCAT('GRANT ALL PRIVILEGES ON *.* TO ', `database_quoted_name`, `database_host`);
    SELECT @`sql`;
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    DEALLOCATE PREPARE `stmt`;

    FLUSH PRIVILEGES;
END$$

DELIMITER ;
