
select * from mysql.user;

FLUSH PRIVILEGES;
use qlclb;

SELECT * FROM mysql.role_edges;

SHOW GRANTS FOR 'ct02'@'localhost';
SHOW GRANTS FOR 'fifa';
FLUSH PRIVILEGES;

-- xoá role 
drop role fifa;
drop role clb;
drop role hlv;
drop role cauthu;


-- xoá user 
DROP USER 'chutichfifa'@'localhost' ;
drop user 'clb01'@'localhost';
drop user 'ct01'@'localhost';
drop user 'hlv01'@'localhost';




CREATE ROLE fifa;
GRANT SELECT ON qlclb.* TO 'fifa';
grant execute on procedure PROC_HSDD to 'fifa';
grant execute on procedure SP_TonggiatriHD to 'fifa';
GRANT INSERT, DELETE, UPDATE ON qlclb.GIAIDAU TO 'fifa';
GRANT INSERT, DELETE, UPDATE ON qlclb.DANHHIEU TO 'fifa';
GRANT INSERT, DELETE, UPDATE ON qlclb.TRANDAU TO 'fifa';
GRANT INSERT, DELETE, UPDATE ON qlclb.CTDH TO 'fifa';
GRANT INSERT, DELETE, UPDATE ON qlclb.CLB TO 'fifa';
CREATE USER 'chutichfifa'@'localhost' IDENTIFIED BY '123456';
GRANT 'fifa'@'%' TO 'chutichfifa'@'localhost';
SET DEFAULT ROLE 'fifa'@'%' TO
  'chutichfifa'@'localhost';
FLUSH PRIVILEGES;

CREATE ROLE clb;
GRANT SELECT ON qlclb.* TO 'clb';
grant execute on procedure SP_DH_DatDuoc to 'clb';
GRANT INSERT, DELETE, UPDATE ON qlclb.HOPDONG TO clb;
GRANT INSERT, DELETE, UPDATE ON qlclb.NHANVIEN TO clb;
GRANT INSERT, DELETE, UPDATE ON qlclb.SAN TO clb;
GRANT INSERT, DELETE, UPDATE ON qlclb.CAUTHU TO clb;
GRANT INSERT, DELETE, UPDATE ON qlclb.HLV TO clb;
CREATE USER 'clb01'@'localhost' IDENTIFIED BY '123456';
GRANT 'clb'@'%' TO 'clb01'@'localhost';
SET DEFAULT ROLE 'clb'@'%' TO
  'clb01'@'localhost';
FLUSH PRIVILEGES;


create role hlv;
GRANT SELECT ON qlclb.THAMGIATRANDAU TO 'hlv';
GRANT SELECT ON qlclb.CAUTHU TO 'hlv';
GRANT INSERT, DELETE, UPDATE ON qlclb.THAMGIATRANDAU TO hlv;
CREATE USER 'hlv01'@'localhost' IDENTIFIED BY '123456';
drop user 'hlv01'@'localhost';
GRANT 'hlv'@'%' TO 'hlv01'@'localhost';
SET DEFAULT ROLE 'hlv'@'%' TO
  'hlv01'@'localhost';
FLUSH PRIVILEGES;

create role cauthu;
use qlclb;
GRANT select ON qlclb.THAMGIATRANDAU TO cauthu;
grant execute on procedure SP_DHRaSan to cauthu;
CREATE USER 'ct01'@'localhost' IDENTIFIED BY '123456';
GRANT 'cauthu'@'%' TO 'ct01'@'localhost';
SET DEFAULT ROLE 'cauthu'@'%' TO
  'ct01'@'localhost';
FLUSH PRIVILEGES;


SELECT CURRENT_ROLE();


DELIMITER $$
CREATE PROCEDURE SP_createuser (
    IN p_username VARCHAR(30),
    IN p_password VARCHAR(30),
    IN p_role VARCHAR(30)
)
BEGIN
    DECLARE v_host VARCHAR(100);
    SET v_host = 'localhost';
    
    SET @sql = CONCAT('CREATE USER ''', p_username, '''@''', v_host, ''' IDENTIFIED BY ''', p_password, ''';');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    IF p_role = 'fifa' THEN
        SET @sql = CONCAT('GRANT fifa TO ''', p_username, '''@''', v_host, ''';');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET @default_role_query = CONCAT('SET DEFAULT ROLE fifa@''%'' TO ''', p_username, '''@''', v_host, '''');
        PREPARE default_role_stmt FROM @default_role_query;
        EXECUTE default_role_stmt;
        DEALLOCATE PREPARE default_role_stmt;
        
    ELSEIF p_role = 'clb' THEN
        SET @sql = CONCAT('GRANT clb TO ''', p_username, '''@''', v_host, ''';');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET @default_role_query = CONCAT('SET DEFAULT ROLE clb@''%'' TO ''', p_username, '''@''', v_host, '''');
        PREPARE default_role_stmt FROM @default_role_query;
        EXECUTE default_role_stmt;
        DEALLOCATE PREPARE default_role_stmt;
        
    ELSEIF p_role = 'hlv' THEN
        SET @sql = CONCAT('GRANT hlv TO ''', p_username, '''@''', v_host, ''';');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET @default_role_query = CONCAT('SET DEFAULT ROLE hlv@''%'' TO ''', p_username, '''@''', v_host, '''');
        PREPARE default_role_stmt FROM @default_role_query;
        EXECUTE default_role_stmt;
        DEALLOCATE PREPARE default_role_stmt;
        
	ELSEIF p_role = 'cauthu' THEN
        SET @sql = CONCAT('GRANT cauthu TO ''', p_username, '''@''', v_host, ''';');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET @default_role_query = CONCAT('SET DEFAULT ROLE cauthu@''%'' TO ''', p_username, '''@''', v_host, '''');
        PREPARE default_role_stmt FROM @default_role_query;
        EXECUTE default_role_stmt;
        DEALLOCATE PREPARE default_role_stmt;
	
	ELSE
        SELECT 'Invalid role';
    END IF;
    
END;

call SP_createuser ('ct03','123456','sai')
drop user ct03@'localhost'
drop procedure SP_createuser





