
use qlclb;

select * from san;

-- Thực thi 
insert into SAN values
	('sabe1','Santiago Bernabéu', 'Madrid, Tây Ban Nha','81044', 'rema'); -- Từ chối 
    
insert into GIAIDAU values
	('EPL2223','English Premier League','2021-08-13','2022-05-22','United Kingdom','MCI');  -- Thành công 

update GIAIDAU set CLBVoDich='MUN' where MAGD='EPL2223';
    
set @TenCLBA='Real Madrid', @TenCLBB='Barcelona', @NamBD='2021';
use qlclb;
call PROC_HSDD(@TenCLBA, @TenCLBB, @NamBD);

call SP_TonggiatriHD ('Arsenal', @total);
SELECT @total as Tong_Gia_Tri_Hop_Dong;

-- Kiểm tra
select * from GIAIDAU;

-- Khôi phục dữ liệu   
delete from GIAIDAU where MaGD='EPL2223'




