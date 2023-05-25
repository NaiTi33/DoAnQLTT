use qlclb;
-- Function tính tổng điểm có được trong giải đấu La Liga để xếp hạng
DELIMITER $$
create function FUNC_TONGDIEM(TCLB varchar(30), NamBD int)
	returns int
	deterministic
begin
	declare CLB varchar(10);
    declare GDAU varchar(10);
    declare TONG int;
    select MaCLB into CLB from CLB where TenCLB=TCLB;
    select MaGD into GDAU from GIAIDAU where TenGD='La Liga' and year(NgBD)=NamBD;
    select sum(case 
		when left(TySo, 1)>right(TySo, 1) then 3
        when left(TySo, 1)=right(TySo, 1) then 1
        else 0
        end) into TONG
    from TRANDAU where CLB_A=CLB and MaGD=GDAU;
    return TONG;
end$$
DELIMITER ;
-- kiểm tra
set @TenCLB = 'Real Sociedad', @NamBD=2017;
select FUNC_TONGDIEM(@TenCLB, @NamBD) as 'Điểm';
-- Xóa
drop function FUNC_TONGDIEM;


-- Function tính ngày hết hạn hợp đồng của nhân viên: 
DELIMITER $$
CREATE FUNCTION FUNC_hethopdong (tennv varchar(30)) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE NGHH INT;
    SELECT TIMESTAMPDIFF(DAY, NOW(), NgKT) INTO NGHH
    FROM HOPDONG, NHANVIEN
	WHERE NHANVIEN.Ten=tennv AND HOPDONG.MaNV=NHANVIEN.MaNV;
    RETURN NGHH;
END$$
DELIMITER ;
-- kiểm tra
set @tennv ='alisson';
select FUNC_hethopdong(@tennv) as 'Số ngày còn lại trong hợp đồng';
-- Xóa
drop function FUNC_hethopdong;

-- Function nhập vào tên cầu thủ, mã trận đấu, trả về đánh giá hiệu suất cầu thủ trong trận đấu. Biết đạt 'S' khi ghi bàn >=2 và thi đấu hết trận, đạt 'A' khi ghi bàn <2 hoặc thi đấu hết trận, còn lại đạt 'B'
DELIMITER $$
CREATE FUNCTION danhgia (tenct varchar(30),mtd varchar(20)) 
	RETURNS VARCHAR(20)
    DETERMINISTIC
begin
	DECLARE mct VARCHAR(10);
	DECLARE danhgia VARCHAR(20);
	DECLARE ghiban INT;
	DECLARE tgiantrandau INT;
	DECLARE tgianthidau INT;
	SELECT NHANVIEN.MaNV into mct FROM NHANVIEN,CAUTHU WHERE CAUTHU.MaNV=NHANVIEN.MaNV AND Ten=tenct ;
	SELECT MAX(PhutTraSan), (PhutTraSan-PhutVaoSan) into tgiantrandau, tgianthidau
	FROM THAMGIATRANDAU 
	WHERE mct=MaNV AND MaTD=mtd GROUP BY PhutTraSan,PhutVaoSan;
	SELECT COUNT(*) into ghiban FROM THAMGIATRANDAU  
	WHERE mct=MaNV AND MaTD=mtd AND PhutGhiBan >-1;
	IF ghiban > 1 AND tgiantrandau=tgianthidau AND mct != NULL THEN
		SET danhgia='S';
	ELSEIF ghiban= 1 OR  tgiantrandau=tgianthidau AND mct != NULL THEN
		SET danhgia='A';
	ELSEIF (ghiban <1 OR  tgiantrandau>tgianthidau) AND mct != NULL THEN
		SET danhgia='B';
	ELSE SET danhgia ='nhập sai!';
	END IF;
	RETURN danhgia;
end$$
DELIMITER ;
	
-- Kiểm tra:
SELECT danhgia('Pep Guardiola','02EPL2122') AS 'đánh giá'; -- Nhap sai
SELECT danhgia('Heung-Min Son','02EPL2122') AS 'đánh giá'; -- A
-- Xóa: 
DROP FUNCTION danhgia;
