use qlclb;
-- Function tính tổng điểm có được trong giải đấu La Liga để xếp hạng
DELIMITER $$
create function FUNC_TONGDIEM(TenCLB varchar(30), NamBD int)
returns int
DETERMINISTIC
begin
	declare CLB varchar(10);
    declare GDAU varchar(10);
    declare TONG int;
    select MaCLB into CLB from CLB where TenCLB=TenCLB;
    select MaGD into GDAU from GIAIDAU where TenGD='La Liga' and year(NgBD)=NamBD;
    set TONG=0;
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
set @TenCLB = 'barca', @NamBD=2017;
select FUNC_TONGDIEM(@TenCLB, @NamBD);
-- Xóa
drop function FUNC_TONGDIEM;
