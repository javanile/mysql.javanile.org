DELIMITER $$

USE `mysql`$$

DROP PROCEDURE IF EXISTS `create_database`$$

CREATE PROCEDURE `create_database`(IN `p_Name` VARCHAR(45), IN `p_Passw` VARCHAR(200))
BEGIN
    DECLARE `_HOST` CHAR(14) DEFAULT '@\'localhost\'';
    SET `p_Name` := CONCAT('\'', REPLACE(TRIM(`p_Name`), CHAR(39), CONCAT(CHAR(92), CHAR(39))), '\''),
    `p_Passw` := CONCAT('\'', REPLACE(`p_Passw`, CHAR(39), CONCAT(CHAR(92), CHAR(39))), '\'');
    SET @`sql` := CONCAT('CREATE USER ', `p_Name`, `_HOST`, ' IDENTIFIED BY ', `p_Passw`);
PREPARE `stmt` FROM @`sql`;
EXECUTE `stmt`;
SET @`sql` := CONCAT('GRANT ALL PRIVILEGES ON *.* TO ', `p_Name`, `_HOST`);
PREPARE `stmt` FROM @`sql`;
EXECUTE `stmt`;
DEALLOCATE PREPARE `stmt`;
FLUSH PRIVILEGES;
END$$

DELIMITER ;
