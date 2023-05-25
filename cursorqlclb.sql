-- Tạo thêm thuộc tính chỉ số lương vào nhân viên. Dựa vào thời gian trong hợp đồng, cập nhật chỉ số lương là 1.2 dối với nhân viên làm việc tính đến hiện tại là dưới 3 năm,1.8 là từ 3 đến 5 năm, 2.0 là trên 5 năm
DELIMITER $$
CREATE PROCEDURE createcurList (
	INOUT nameList varchar(4000)
)
BEGIN
DECLARE finished INTEGER DEFAULT 0;
ALTER TABLE NHANVIEN ADD chisoluong FLOAT ;
DECLARE CONTINUE HANDLER 
FOR NOT FOUND SET finished = 1;
DECLARE cur CURSOR FOR SELECT NgBD,NgKT,MaNV FROM dbo.HOPDONG ;
DECLARE ngbd DATE DEFAULT "";
DECLARE ngkt DATE DEFAULT "";
DECLARE mnv VARCHAR(10) DEFAULT "";
OPEN cur;
cur: LOOP
FETCH cur INTO ngbd,ngkt,mnv;
IF finished = 1 THEN 
LEAVE cur;
END IF;
UPDATE dbo.NHANVIEN SET chisoluong= 1.2 WHERE TIMESTAMPDIFF(YEAR,ngbd,GETDATE()) < 3 AND ngkt>GETDATE() AND mnv=MaNV;
UPDATE dbo.NHANVIEN SET chisoluong= 1.8 WHERE (TIMESTAMPDIFF(YEAR,ngbd,GETDATE()) BETWEEN 3 AND 5)  AND ngkt>GETDATE() AND mnv=MaNV;
UPDATE dbo.NHANVIEN SET chisoluong= 2.0 WHERE TIMESTAMPDIFF(YEAR,ngbd,GETDATE()) > 5 AND ngkt>GETDATE() AND mnv=MaNV;
END LOOP cur;
CLOSE cur;
END$$
DELIMITER ;

