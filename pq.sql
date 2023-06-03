
select * from mysql.user;


SHOW GRANTS FOR ;
SHOW GRANTS FOR ;
FLUSH PRIVILEGES;

-- xoá role 
drop role fifa;
drop role clb;
drop role hlv;
drop role cauthu;


CREATE ROLE LienDoan;
GRANT SELECT ON qlclb.* TO 'LienDoan';
grant execute on procedure PROC_HSDD to 'LienDoan';
grant execute on procedure SP_TonggiatriHD to 'LienDoan';
grant execute on function FUNC_TONGDIEM to 'LienDoan';
GRANT INSERT, DELETE, UPDATE ON qlclb.GIAIDAU TO 'LienDoan';
GRANT INSERT, DELETE, UPDATE ON qlclb.DANHHIEU TO 'LienDoan';
GRANT INSERT, DELETE, UPDATE ON qlclb.TRANDAU TO 'LienDoan';
GRANT INSERT, DELETE, UPDATE ON qlclb.CTDH TO 'LienDoan';
GRANT INSERT, DELETE, UPDATE ON qlclb.CLB TO 'LienDoan';
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

	SET @sql = CONCAT('GRANT ', p_role, ' TO ''', p_username, '''@''', v_host, ''';');
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
        
	SET @default_role_query = CONCAT('SET DEFAULT ROLE ', p_role, '@''%'' TO ''', p_username, '''@''', v_host, '''');
	PREPARE default_role_stmt FROM @default_role_query;
	EXECUTE default_role_stmt;
	DEALLOCATE PREPARE default_role_stmt;
    
END;


call SP_createuser ('lm10','123456','cauthu');
call SP_createuser ('ctlv','123456','clb');
call SP_createuser ('ctfifa','123456','LienDoan');
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
call SP_deleteuser ('ctfifa','LienDoan');
call SP_deleteuser ('hlvcaan','hlv');

drop procedure SP_deleteuser
