use qlclb;

--  Thực thi

insert into NHANVIEN values
	('011111','Chủ tịch','Richard Arnold', '2022-01-06', NULL, 'Manchester, United Kingdom', '46168989', NULL, 'MUN'); -- Thành công 


insert into GIAIDAU values
	('EPL212211','English Premier League','2021-08-13','2022-05-22','United Kingdom','MCI'); -- Từ chối


CALL SP_DH_DatDuoc('Manchester City','English Premier League',2021); -- Thành công
CALL SP_DH_DatDuoc('MC','English Premier League',2021); -- CLB ko tồn tại
CALL SP_DH_DatDuoc('Manchester City','EPL',2021); -- GIAIDAU ko tồn tại


set @tennv ='alisson';
select FUNC_hethopdong(@tennv) as 'Số ngày còn lại trong hợp đồng';

-- Kiểm tra
select * from NHANVIEN;
-- Khôi phục  
delete from NHANVIEN where MaNV='011111';

    
