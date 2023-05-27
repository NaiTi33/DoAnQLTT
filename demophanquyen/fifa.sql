
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

insert into TRANDAU values
    ('lfp2122sevi2507', '2022-07-25 18:00', '0-1', 'sevi', 'barc', 'rasp', 'lfp2122'), -- +3
    ('lfp2122barc1508', '2022-08-15 20:45', '2-1', 'barc', 'rebe', 'cano', 'lfp2122'), -- +3
    ('lfp2122reso0509', '2022-09-05 18:00', '1-1', 'reso', 'barc', 'anoe', 'lfp2122'), -- +1
    ('lfp2122barc2609', '2022-09-26 20:45', '0-1', 'barc', 'atma', 'cano', 'lfp2122'); -- +0
set @TenCLB = 'Barcelona', @NamBD=2021;
select FUNC_TONGDIEM(@TenCLB, @NamBD) as 'Điểm';
-- Xóa
delete from TRANDAU
where MaTD in (
    'lfp2122sevi2507',
    'lfp2122barc1508',
    'lfp2122reso0509',
    'lfp2122barc2609'
);

-- Kiểm tra
select * from GIAIDAU;

-- Khôi phục dữ liệu   
delete from GIAIDAU where MaGD='EPL2223'




