
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






CREATE ROLE fifa;
GRANT SELECT ON qlclb.* TO 'fifa';
grant execute on procedure PROC_HSDD to 'fifa';
grant execute on procedure SP_TonggiatriHD to 'fifa';
grant execute on function FUNC_TONGDIEM to 'fifa';
GRANT INSERT, DELETE, UPDATE ON qlclb.GIAIDAU TO 'fifa';
GRANT INSERT, DELETE, UPDATE ON qlclb.DANHHIEU TO 'fifa';
GRANT INSERT, DELETE, UPDATE ON qlclb.TRANDAU TO 'fifa';
GRANT INSERT, DELETE, UPDATE ON qlclb.CTDH TO 'fifa';
GRANT INSERT, DELETE, UPDATE ON qlclb.CLB TO 'fifa';
FLUSH PRIVILEGES;

CREATE ROLE clb;
GRANT SELECT ON qlclb.* TO 'clb';
grant execute on procedure SP_DH_DatDuoc to 'clb';
grant execute on function FUNC_hethopdong to 'clb';
grant execute on procedure createcurList to 'clb';
GRANT INSERT, DELETE, UPDATE ON qlclb.HOPDONG TO clb;
GRANT INSERT, DELETE, UPDATE ON qlclb.NHANVIEN TO clb;
GRANT INSERT, DELETE, UPDATE ON qlclb.SAN TO clb;
GRANT INSERT, DELETE, UPDATE ON qlclb.CAUTHU TO clb;
GRANT INSERT, DELETE, UPDATE ON qlclb.HLV TO clb;
FLUSH PRIVILEGES;


create role hlv;
GRANT SELECT ON qlclb.THAMGIATRANDAU TO 'hlv';
GRANT SELECT ON qlclb.CAUTHU TO 'hlv';
GRANT INSERT, DELETE, UPDATE ON qlclb.THAMGIATRANDAU TO hlv;
grant execute on function danhgia to 'hlv';
FLUSH PRIVILEGES;

create role cauthu;
use qlclb;
GRANT select ON qlclb.THAMGIATRANDAU TO cauthu;
grant execute on procedure SP_DHRaSan to cauthu;
FLUSH PRIVILEGES;





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


call SP_createuser ('lm10','123456','cauthu');
call SP_createuser ('ctlv','123456','clb');
call SP_createuser ('ctfifa','123456','fifa');
call SP_createuser ('hlvcaan','123456','hlv');

drop procedure SP_createuser


DELIMITER $$
CREATE PROCEDURE SP_deleteuser (
	IN p_username VARCHAR(30),
    IN p_role VARCHAR(30)
)
BEGIN
	DECLARE v_host VARCHAR(100);
    SET v_host = 'localhost';

	SET @revoke_query = CONCAT('REVOKE ', p_role, ' FROM ''', p_username, '''@''', v_host, '''');
	PREPARE revoke_stmt FROM @revoke_query;
	EXECUTE revoke_stmt;
	DEALLOCATE PREPARE revoke_stmt;
    
	SET @drop_user_query = CONCAT('DROP USER ''', p_username, '''@''', v_host, '''');
	PREPARE drop_user_stmt FROM @drop_user_query;
	EXECUTE drop_user_stmt;
	DEALLOCATE PREPARE drop_user_stmt;
    
END;

call SP_deleteuser ('lm10','cauthu');
call SP_deleteuser ('ctlv','clb');
call SP_deleteuser ('ctfifa','fifa');
call SP_deleteuser ('hlvcaan','hlv');

drop procedure SP_deleteuser
