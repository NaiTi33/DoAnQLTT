use qlclb;
-- Thực thi 
select * from CAUTHU; -- Thành công
select * from THAMGIATRANDAU; -- Thành công  

insert into THAMGIATRANDAU values
	('02EPL2122','barc', 'frjo21', 0, 77, -1,'Tiền vệ cánh trái',0); -- thành công

insert into CLB values
	('rema1', 'Real Madrid', 'Madrid, Tây Ban Nha', '1902-03-06','Real Madrid Club de Fútbol', NULL); -- Từ chối     

-- Kiểm tra 
 select * from THAMGIATRANDAU;   
 -- Khôi phục dữ liệu
 delete from THAMGIATRANDAU where MaTD='02EPL2122' AND MaNV='frjo21';

