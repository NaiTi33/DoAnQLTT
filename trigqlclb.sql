use qlclb;

-- *Trong một CLB chỉ có một đội trưởng
DELIMITER $$
create trigger BFIS_CT_CLB_DT
before insert on CAUTHU for each row
begin
	if exists (select * 
			 from NHANVIEN NV,CAUTHU CT
			 where NV.MaNV=CT.MaNV and DoiTruong=1
			 and NV.CLB=(select CLB 
						from NHANVIEN
						where MaNV=new.MaNV)) 
		and new.DoiTruong=1 
	then
      signal sqlstate '45000'
      set message_text = 'Trong một CLB chỉ có một đội trưởng!';
   end if;
end$$
create trigger BFUD_CT_CLB_DT
before update on CAUTHU for each row
begin
	if exists (select * 
			 from NHANVIEN NV,CAUTHU CT
			 where NV.MaNV=CT.MaNV and DoiTruong=1
			 and NV.CLB=(select CLB 
						from NHANVIEN
						where MaNV=new.MaNV)) 
		and new.DoiTruong=1 
	then
      signal sqlstate '45000'
      set message_text = 'Trong một CLB chỉ có một đội trưởng!';
   end if;
end$$
DELIMITER ;
-- BFIS_CT_CLB_DT
insert into NHANVIEN values ('tin33','Cầu thủ','Tín Nguyễn', '2022-01-06', NULL, 'Thủ Đức, Tp.HCM', '46168989', NULL, 'rema');
insert into CAUTHU values ('tin33',33,1);
delete from NHANVIEN where MaNV='tin33'
-- BFUD_CT_CLB_DT
update CAUTHU set DoiTruong=1 where MaNV='vnju20'

-- *Trong một CLB số áo cầu thủ là duy nhất
DELIMITER $$
create trigger BFIS_CT_CLB_SA
before insert on CAUTHU for each row
begin
	if exists (select *
				from NHANVIEN NV,CAUTHU CT
				where NV.MaNV=CT.MaNV and SoAo=new.SoAo
				and NV.CLB=(select CLB 
							from NHANVIEN
							where MaNV=new.MaNV)) 
	then
      signal sqlstate '45000'
      set message_text = 'Trong một CLB số áo cầu thủ là duy nhất!';
   end if;
end$$
create trigger BFUD_CT_CLB_SA
before update on CAUTHU for each row
begin
	if exists (select *
				from NHANVIEN NV,CAUTHU CT
				where NV.MaNV=CT.MaNV and SoAo=new.SoAo
				and NV.CLB=(select CLB 
							from NHANVIEN
							where MaNV=new.MaNV)) 
	then
      signal sqlstate '45000'
      set message_text = 'Trong một CLB số áo cầu thủ là duy nhất!';
   end if;
end$$
DELIMITER ;
-- BFIS_CT_CLB_SA
insert into NHANVIEN values ('tin33','Cầu thủ','Tín Nguyễn', '2022-01-06', NULL, 'Thủ Đức, Tp.HCM', '46168989', NULL, 'rema');
insert into CAUTHU values ('tin33',20,0);
delete from NHANVIEN where MaNV='tin33'
-- BFUD_CT_CLB_SA
update CAUTHU set SoAo=9 where MaNV='vnju20'

-- *Phút ra sân của cầu thủ trong trận phải trước phút vào sân, phút ghi bàn (nếu có) phải ở trong khoảng thời gian đó
DELIMITER $$
create trigger BFIS_TGTD_PVS_PTS
before insert on THAMGIATRANDAU for each row
begin
	if (new.PhutGhiBan=-1 and new.PhutVaoSan > new.PhutTraSan)
		or (new.PhutGhiBan<>-1 and (new.PhutVaoSan > new.PhutGhiBan or new.PhutGhiBan>new.PhutTraSan))
	then
      signal sqlstate '45000'
      set message_text = 'Phút ra sân của cầu thủ trong trận phải trước phút vào sân, phút ghi bàn (nếu có) phải ở trong khoảng thời gian đó!';
   end if;
end$$
create trigger BFUD_TGTD_PVS_PTS
before update on THAMGIATRANDAU for each row
begin
	if (new.PhutGhiBan=-1 and new.PhutVaoSan > new.PhutTraSan)
		or (new.PhutGhiBan<>-1 and (new.PhutVaoSan > new.PhutGhiBan or new.PhutGhiBan>new.PhutTraSan))
	then
      signal sqlstate '45000'
      set message_text = 'Phút ra sân của cầu thủ trong trận phải trước phút vào sân, phút ghi bàn (nếu có) phải ở trong khoảng thời gian đó!';
   end if;
end$$
DELIMITER ;
-- BFIS_TGTD_PVS_PTS
insert into THAMGIATRANDAU values ('lfp2122cano2410','barc','lime30', 87, 56, -1,'Tiền đạo cắm',0);
-- BFUD_TGTD_PVS_PTS
update THAMGIATRANDAU set PhutVaoSan=76 where MaTD='ckc12122' and MaCLB='rema' and MaNV='vnju20' and PhutGhiBan=59
update THAMGIATRANDAU set PhutGhiBan=48 where MaTD='lfp1718anoe2004' and MaCLB='reso' and MaNV='juan7' and PhutGhiBan=80

-- *Trong một giải đấu danh hiệu 'CLB vô địch' và'CLB á quân' chỉ được trao cho một CLB hay 
-- các danh hiệu 'Cầu thủ xuất sắc nhất’, ‘Cầu thủ ghi nhiều bàn nhất’, 'Thủ môn ít thủng lưới nhất', 
-- 'Cầu thủ trẻ xuất sắc nhất’, ‘HLV xuất sắc nhất' chỉ được trao cho một cá nhân
DELIMITER $$
create trigger BFIS_CTDH
before insert on CTDH for each row
begin
	if exists (select * from CTDH 
			where MaDH=new.MaDH and MaGD=new.MaGD and MaCLB<>new.MaCLB
			and MaDH in (select MaDH from DANHHIEU 
						where TenDH='CLB vô địch' or TenDH='CLB á quân'))
    then
      signal sqlstate '45000'
      set message_text = 'Danh hiệu này trong một giải đấu chỉ được trao cho một CLB!';
	end if;
    if exists (select * from CTDH 
			where MaDH=new.MaDH and MaGD=new.MaGD
            and MaDH in (select MaDH from DANHHIEU 
						where TenDH='Cầu thủ xuất sắc nhất' or TenDH='Cầu thủ ghi nhiều bàn nhất'
							or TenDH='Thủ môn ít thủng lưới nhất' or TenDH='Cầu thủ trẻ xuất sắc nhất' 
							or TenDH='HLV xuất sắc nhất'))
	then
      signal sqlstate '45000'
      set message_text = 'Danh hiệu này trong một giải đấu chỉ được trao cho một cá nhân!';
	end if;
end$$
create trigger BFUD_CTDH
before update on CTDH for each row
begin
	if exists (select * from CTDH 
			where MaDH=new.MaDH and MaGD=new.MaGD and MaCLB<>new.MaCLB
			and MaDH in (select MaDH from DANHHIEU 
						where TenDH='CLB vô địch' or TenDH='CLB á quân'))
    then
      signal sqlstate '45000'
      set message_text = 'Danh hiệu này trong một giải đấu chỉ được trao cho một CLB!';
	end if;
    if exists (select * from CTDH 
			where MaDH=new.MaDH and MaGD=new.MaGD
            and MaDH in (select MaDH from DANHHIEU 
						where TenDH='Cầu thủ xuất sắc nhất' or TenDH='Cầu thủ ghi nhiều bàn nhất'
							or TenDH='Thủ môn ít thủng lưới nhất' or TenDH='Cầu thủ trẻ xuất sắc nhất' 
							or TenDH='HLV xuất sắc nhất'))
	then
      signal sqlstate '45000'
      set message_text = 'Danh hiệu này trong một giải đấu chỉ được trao cho một cá nhân!';
	end if;
end$$
DELIMITER ;
-- BFIS_CTDH
insert into CTDH values ('001','lfp1718','rema','vnju20','2018-05-20');
insert into CTDH values ('005','EPL2122','MUN','cr07','2022-05-22');
-- BFUD_CTDH
update CTDH set MaCLB='barc' where MaDH='001' and MaGD='c12122' and MaCLB='rema' and MaNV='hlvcaan'
