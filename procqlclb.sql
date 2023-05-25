use qlclb;
-- Procedure tìm CLB hơn về hiệu số đối đầu giữa 2 CLB trong giải La Liga để xếp hạng trong trường hợp bằng điểm
DELIMITER $$
create procedure PROC_HSDD(
	in TenCLBA varchar(30),
    in TenCLBB varchar(30),
    in NamBD int)
begin
	declare CLBA varchar(10);
    declare CLBB varchar(10);
    declare GDAU varchar(10);
    declare TS1 varchar(3);
    declare TS2 varchar(3);
	select MaCLB into CLBA from CLB where TenCLB=TenCLBA;
    select MaCLB into CLBB from CLB where TenCLB=TenCLBB;
    select MaGD into GDAU from GIAIDAU where TenGD='La Liga' and year(NgBD)=NamBD;
    select TySo into TS1 from TRANDAU where CLB_A=CLBA and CLB_B=CLBB and MaGD=GDAU;
    select TySo into TS2 from TRANDAU where CLB_A=CLBB and CLB_B=CLBA and MaGD=GDAU;
    if left(TS1, 1) + right(TS2, 1)>right(TS1, 1) + left(TS2, 1) then
		select concat('CLB ', TenCLBA, ' hơn về hiệu số đối đầu') as 'Kết quả';
    elseif left(TS1, 1) + right(TS2, 1)<right(TS1, 1) + left(TS2, 1) then
		select concat('CLB ', TenCLBB, ' hơn về hiệu số đối đầu') as 'Kết quả';
    else 
		if right(TS2, 1)>right(TS1, 1) then
			select concat('CLB ', TenCLBA, ' hơn về hiệu số đối đầu') as 'Kết quả';
        elseif right(TS2, 1)<right(TS1, 1) then
			select concat('CLB ', TenCLBB, ' hơn về hiệu số đối đầu') as 'Kết quả';
		else
			select 'Cần phải xét các chỉ số fairplay hay trận đấu phụ để xác định được CLB' as 'Kết quả';
        end if;
    end if;
end$$
DELIMITER ;
-- Kiểm tra
set @TenCLBA='Real Madrid', @TenCLBB='Barcelona', @NamBD='2021';
call PROC_HSDD(@TenCLBA, @TenCLBB, @NamBD);
-- Xóa
drop procedure PROC_HSDD;


-- 1.Store Procedure đưa vào tên giải đấu, Mã clb A, Mã CLB B, Ngày thi đấu, cho ra đội hình ra sân của 2 đội 
DELIMITER $$
CREATE  PROCEDURE SP_DHRaSan(
    IN TGD varchar(30),
    IN CLBA varchar(10),
    IN CLBB varchar(10),
    IN NgayThiDau datetime
)
BEGIN
    DECLARE MGD varchar(10);
    DECLARE MTD varchar(20);

		SELECT MaGD INTO MGD
    FROM GIAIDAU
    WHERE TenGD = TGD AND year(NgBD) <= year(NgayThiDau) and year(NgKT) >= year(NgayThiDau);
		
    SELECT MaTD INTO MTD
    FROM TRANDAU
    WHERE CLB_A = CLBA AND CLB_B = CLBB AND MaGD = MGD AND date(TGThiDau)=NgayThiDau;
		
		if MGD is NULL then 
			SELECT  CONCAT('Giải đấu ', TGD, ' không tồn tại') AS 'ERROR';
		ELSEIF MTD is NULL then
			SELECT  CONCAT('Trận đấu không tồn tại') AS 'ERROR';
		else 
			
		SELECT NHANVIEN.Ten, CAUTHU.SoAo, THAMGIATRANDAU.ChucVu
    FROM NHANVIEN
    INNER JOIN CAUTHU ON NHANVIEN.MaNV = CAUTHU.MaNV
    INNER JOIN THAMGIATRANDAU ON NHANVIEN.MaNV = THAMGIATRANDAU.MaNV
    WHERE THAMGIATRANDAU.MaTD = MTD AND THAMGIATRANDAU.PhutVaoSan = 0 AND THAMGIATRANDAU.MaCLB = CLBA ;

    SELECT NHANVIEN.Ten, CAUTHU.SoAo, THAMGIATRANDAU.ChucVu 
    FROM NHANVIEN
    INNER JOIN CAUTHU ON NHANVIEN.MaNV = CAUTHU.MaNV
    INNER JOIN THAMGIATRANDAU ON NHANVIEN.MaNV = THAMGIATRANDAU.MaNV
    WHERE THAMGIATRANDAU.MaTD = MTD AND THAMGIATRANDAU.PhutVaoSan = 0 AND THAMGIATRANDAU.MaCLB = CLBB ;
		end if;
END$$
DELIMITER ;

-- Kiểm tra
call  SP_DHRaSan ('English Premier League','ARS','CHE','2021-08-22'); -- thành công
call  SP_DHRaSan ('English ','ARS','CHE','2021-08-22'); -- giải đấu không tồn tại
call  SP_DHRaSan ('English Premier League','A','CHE','2021-08-22'); -- trận đấu không tồn tại

-- 2.Store Procedure đưa vào tên CLB, tên giải đấu, năm, cho ra các danh hiệu đạt được
DELIMITER $$
CREATE PROCEDURE SP_DH_DatDuoc(IN ten_clb VARCHAR(30), IN ten_gd VARCHAR(30), in nambd int)
BEGIN
		declare ma_gd varchar(10);
		select GD.MaGD into ma_gd
		from GIAIDAU GD
		where GD.TenGD=ten_gd and year(NgBD)=nambd;
		if ma_gd is null THEN
			SELECT  CONCAT('Giải đấu ', ten_gd, ' không tồn tại') AS 'ERROR';
		ELSEIF not exists (select * from CLB where TenCLB=ten_clb) then
			SELECT  CONCAT('CLB ', ten_clb, ' không tồn tại') AS 'ERROR';
		else 
    SELECT DISTINCT(DH.TenDH) As 'Danh hiệu đạt được'
    FROM DANHHIEU DH
    INNER JOIN CTDH ON DH.MaDH = CTDH.MaDH
    INNER JOIN GIAIDAU GD ON CTDH.MaGD = GD.MaGD
		INNER JOIN CLB on CLB.MaCLB=CTDH.MaCLB
    WHERE CLB.TenCLB = ten_clb AND GD.MaGD = ma_gd;
		end if;
END$$
DELIMITER ;
-- Kiểm tra
CALL SP_DH_DatDuoc('Manchester City','English Premier League',2021); -- Thành công
CALL SP_DH_DatDuoc('MC','English Premier League',2021); -- CLB ko tồn tại
CALL SP_DH_DatDuoc('Manchester City','EPL',2021); -- GIAIDAU ko tồn tại

select * from GIAIDAU
select * from CTDH
select * from GIAI

drop PROCEDURE SP_DH_DatDuoc

-- 3.Store Procedure đưa vào tên CLB,cho ra tổng trị giá đội hình
DELIMITER $$
CREATE PROCEDURE SP_TonggiatriHD(IN TCLB varchar(30), OUT total FLOAT)
BEGIN
	declare countCLB int;
	set countCLB=(select count(*) from CLB where TenCLB=TCLB);
	if countCLB > 0 THEN
		select SUM(GiaTri) into total 
		from HOPDONG,CLB 
		where TCLB=TenCLB AND CLB.MaCLB=HOPDONG.MaCLB;
	else 
		SELECT  CONCAT('CLB ', TCLB, ' không tồn tại') AS 'ERROR';
	end if;
END$$
DELIMITER ;
-- Kiểm tra
call SP_TonggiatriHD ('Manchester City', @total);
SELECT @total as Tong_Gia_Tri_Hop_Dong;
-- xoá 
drop PROCEDURE SP_TonggiatriHD






