use qlclb;
-- Procedure tìm CLB hơn về hiệu số đối đầu giữa 2 CLB trong giải La Liga để xếp hạng trong trường hợp bằng điểm
DELIMITER $$
create procedure PROC_HSDD(
	in TenCLBA varchar(30),
    in TenCLBB varchar(30),
    in TenGDAU varchar(30),
    in NamBD int)
begin
	declare CLBA varchar(10);
    declare CLBB varchar(10);
    declare GDAU varchar(10);
    declare TS1 varchar(3);
    declare TS2 varchar(3);
    declare mess varchar(50);
	select MaCLB into CLBA from CLB where TenCLB=TenCLBA;
    select MaCLB into CLBB from CLB where TenCLB=TenCLBB;
    select MaGD into GDAU from GIAIDAU where TenGD=TenGDAU and year(NgBD)=NamBD;
    select TySo into TS1 from TRANDAU where CLB_A=CLBA and CLB_B=CLBB and MaGD=GDAU;
    select TySo into TS2 from TRANDAU where CLB_A=CLBB and CLB_B=CLBA and MaGD=GDAU;
    if left(TS1, 1) + right(TS2, 1)>right(TS1, 1) + left(TS2, 1) then
		set mess=concat('CLB ', TenCLBA, ' hơn về hiệu số đối đầu');
		signal sqlstate '45000' set message_text = mess;
    elseif left(TS1, 1) + right(TS2, 1)<right(TS1, 1) + left(TS2, 1) then
		set mess=concat('CLB ', TenCLBB, ' hơn về hiệu số đối đầu');
		signal sqlstate '45000' set message_text = mess;
    else 
		if right(TS2, 1)>right(TS1, 1) then
			set mess=concat('CLB ', TenCLBA, ' hơn về hiệu số đối đầu');
			signal sqlstate '45000' set message_text = mess;
        elseif right(TS2, 1)<right(TS1, 1) then
			set mess=concat('CLB ', TenCLBB, ' hơn về hiệu số đối đầu');
			signal sqlstate '45000' set message_text = mess;
		else
			signal sqlstate '45000' set message_text = 'Cần phải xét các chỉ số fairplay hay trận đấu phụ để xác định được CLB';
        end if;
    end if;
end$$
DELIMITER ;
-- Kiểm tra
set @TenCLBA='Real Madrid', @TenCLBB='Barcelona', @TenGDAU='La Liga', @NamBD='2021';
call PROC_HSDD(@TenCLBA, @TenCLBB, @TenGDAU, @NamBD);
-- Xóa
drop procedure PROC_HSDD;
