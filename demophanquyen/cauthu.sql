use qlclb;

select * from THAMGIATRANDAU;-- thành công
select * from HOPDONG; -- Từ chối

insert into THAMGIATRANDAU values
	('lfp2122cano2410','barc', 'frjo21', 0, 77, -1,'Tiền vệ cánh trái',0); -- Từ chối 

call  SP_DHRaSan ('English Premier League','ARS','CHE','2021-08-22'); -- Thành công 