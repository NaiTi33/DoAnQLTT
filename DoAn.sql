create database qlclb;
use qlclb;

create table CLB(
	MaCLB varchar(10) primary key,
    	TenCLB varchar(30) not null,
    	DiaDiem varchar(30),
    	NgayLap datetime,
    	CTy varchar(50),
    	NVDH varchar(10)
);

create table NHANVIEN(
	MaNV varchar(10) primary key,
    	ChucVu varchar(30) not null,
    	Ten varchar(30) not null,
        NgVaoLam date,
	Ngketthuc date,
    	DiaChi varchar(100),
    	SDT varchar(10),
    	NgQL varchar(10),
    	CLB varchar(10),
        foreign key (NgQL) references NHANVIEN(MaNV),
	foreign key (CLB) references CLB(MaCLB)
);

alter table CLB
add foreign key (NVDH) references NHANVIEN(MaNV);

create table CAUTHU(
	MaNV varchar(10) primary key,
    	SoAo int not null,
    	DoiTruong boolean not null,
    	foreign key (MaNV) references NHANVIEN(MaNV)
);

create table HLV(
	MaNV varchar(10) primary key,
    	CapBacCS int not null,
    	KinhNghiem int, -- Số năm
    	foreign key (MaNV) references NHANVIEN(MaNV)
);

create table HOPDONG(
	MaCLB varchar(10),
    	MaNV varchar(10),
    	VaiTro varchar(30),
    	NgBD date not null,
    	NgKT date not null,
    	GiaTri float, -- triệu euro
	primary key (MaCLB, MaNV),
    	foreign key (MaCLB) references CLB(MaCLB),
    	foreign key (MaNV) references NHANVIEN(MaNV)
);

create table SAN(
	MaSan varchar(10) primary key,
    	TenSan varchar(30) not null,
    	DiaChi varchar(30),
        SucChua int,
    	CLBQLy varchar(10),
	foreign key (CLBQLy) references CLB(MaCLB)
);

create table GIAIDAU(
	MaGD varchar(10) primary key,
    	TenGD varchar(30) not null,
    	NgBD date,
	NgKT date,
    	DiaDiem varchar(30)
);

create table TRANDAU(
	MaTD varchar(10),
    	TGThiDau datetime,
    	TySo varchar(3) not null,
    	CLB_A varchar(10),
    	CLB_B varchar(10),
    	MaSan varchar(10),
    	MaGD varchar(10),
        primary key (MaTD, CLB_A, CLB_B),
    	foreign key (CLB_A) references CLB(MaCLB),
    	foreign key (CLB_B) references CLB(MaCLB),
    	foreign key (MaSan) references SAN(MaSan),
    	foreign key (MaGD) references GIAIDAU(MaGD)
);

create table THAMGIATRANDAU(
	MaTD varchar(10),
    	MaCLB varchar(10),
    	MaNV varchar(10),
    	PhutVaoSan int not null,
    	PhutTraSan int not null,
    	PhutGhiBan int,
    	ChucVu varchar(30),
    	MVP boolean,
    	primary key (MaTD, MaCLB, MaNV,PhutGhiBan),
    	foreign key (MaTD) references TRANDAU(MaTD),
    	foreign key (MaCLB) references CLB(MaCLB),
    	foreign key (MaNV) references CAUTHU(MaNV)
);

create table DANHHIEU(
	MaDH varchar(10) primary key,
    	TenDH varchar(30) not null
);

create table CTDH(
	MaDH varchar(10),
    	MaGD varchar(10),
    	MaCLB varchar(10),
    	MaNV varchar(10),
    	NgTraoTang date not null,
    	primary key (MaDH,MaGD,MaCLB,MaNV),
    	foreign key (MaDH) references DANHHIEU(MaDH),
    	foreign key (MaGD) references GIAIDAU(MaGD),
    	foreign key (MaCLB) references CLB(MaCLB),
    	foreign key (MaNV) references CAUTHU(MaNV)
);


insert into GIAIDAU values
	('lfp2017', 'La Liga', '2021-08-14', '2022-05-23', 'Tây Ban Nha'),
	('lfp2021', 'La Liga', '2017-08-19', '2018-05-21', 'Tây Ban Nha'),
	('c12122', 'Champions League', '2021-06-22', '2022-05-29', 'Pháp');
	
insert into CLB values
	('rema', 'Real Madrid', 'Madrid, Tây Ban Nha', '1902-03-06','Real Madrid Club de Fútbol', NULL),
	('barc','Barcelona', 'Barcelona, Tây Ban Nha', '1899-11-29','Futbol Club Barcelona',NULL),
	('atma','Atlético Madrid', 'Madrid, Tây Ban Nha', '1903-04-26','Club Atlético de Madrid', NULL),
	('sevi','Sevilla', 'Sevilla, Tây Ban Nha', '1890-01-25','Sevilla Fútbol Club', NULL),
	('rebe','Real Betis', 'Sevilla, Tây Ban Nha', '1907-09-12','Real Betis Balompié', NULL),
	('atbi','Athletic Bilbao', 'Bilbao, Tây Ban Nha', '1898-09-23','Athletic Club', NULL),
	('reso','Real Sociedad', 'San Sebastián, Tây Ban Nha', '1909-09-07', 'Real Sociedad de Fútbol', NULL),
	('vale','Valencia', 'Valencia, Tây Ban Nha', '1919-03-18','Valencia Club de Fútbol', NULL),
	('MCI','Manchester City', 'Anh', '1894-04-16','City Football Group Limited', NULL),
	('LIV','Liverpool', 'Anh', '1892-06-03','Tập đoàn Thể thao Fenway', NULL),
	('VIL','Villarreal', 'Tây Ban Nha', '1923-03-10',NULL, NULL),
    	('psg','Paris Saint-Germain','Paris, Pháp', '1970-08-12','Paris Saint-Germain Football Club',NULL);

insert into NHANVIEN values
	('ctjola','Chủ tịch','Joan Laporta', '2021-03-17',NULL,'25 Main Street, Barcelona, Tây Ban Nha','12345678',NULL,'barc'),
	('fp991','Chủ tịch','Florentino Perez', '2000-01-01',NULL,'Marid, Tây Ban Nha','13145678',NULL,'rema'),
	('tw991','Chủ tịch','Tom Werner', '2012-12-01',NULL,'Liverpool, Anh','11111678',NULL,'LIV'),
	('kam991','Chủ tịch','Khaldoon Al Mubarak', '2013-01-01',NULL,'Manchester City, Anh','11661666',NULL,'MCI'),
	('fra991','Chủ tịch','Fernando Roig Alfonso', '2000-12-01',NULL,'Tây Ban Nha','11555252',NULL,'VIL'),
	('hlvcaan','HLV','Carlo Ancelotti', '2021-06-01',NULL, '15 Lombardy Lane, Madrid, Tây Ban Nha', '23456789',NULL,'rema'),
	('hlvdisi','HLV','Diego Simeone', '2011-12-23',NULL, '10 Madrid Avenue, Madrid, Tây Ban Nha', '34567890',NULL,'atma'),
	('hlvjk','HLV','Jürgen Klopp', '2015-10-08',NULL,'Liverpool, Anh','14611678',NULL,'LIV'),
	('hlvp','HLV','Pep Guardiola', '2016-01-02',NULL,'Manchester City, Anh','11661556',NULL,'MCI'),
	('hlvqs','HLV','Quique Setién', '2022-10-25',NULL,'Tây Ban Nha','11525252',NULL,'VIL'),
	('kabe9','Cầu thủ','Karim Benzema', '2009-07-01',NULL, '20 Bernabeu Street, Madrid, Tây Ban Nha', '45678901','hlvcaan','rema'),
	('lm10','Cầu thủ','Luka Modrić', '2012-08-27',NULL, ' khu La Moraleja, Madrid, Tây Ban Nha', '85678901','hlvcaan','rema'),
	('tk8','Cầu thủ','Toni Kroos', '2014-07-17',NULL, ' La Finca, Madrid, Tây Ban Nha', '891831','hlvcaan','rema'),
	('ms11','Cầu thủ','Mohamed Salah', '2017-06-23',NULL, ' Royal Albert Dock Liverpool, Anh', '8918121','hlvjk','LIV'),
	('al1','Cầu thủ','Alisson', '2018-07-20',NULL, ' Royal Albert Dock Liverpool, Anh', '8916121','hlvjk','LIV'),
	('gs9','Cầu thủ','Gabriel Jesus', '2016-12-02',NULL,'Manchester City, Anh','11661456','hlvp','MCI'),
	('kdb17','Cầu thủ','Kevin De Bruyne', '2015-08-30',NULL,'Manchester City, Anh','11261456','hlvp','MCI'),
	('gmb7','Cầu thủ','Gerard Moreno Balagueró', '2010-11-02',NULL,'Villareal, Tây Ban Nha','17661456','hlvqs','VIL'),
	('gr13','Cầu thủ','Gerónimo Rulli', '2010-11-02',NULL,'Villareal, Tây Ban Nha','17669456','hlvqs','VIL'),
	('vnju20','Cầu thủ','Vinícius Júnior', '2018-07-12',NULL, '40 Castellana Boulevard, Madrid, Tây Ban Nha', '56789012','hlvcaan','rema'),
	('thco1','Cầu thủ','Thibaut Courtois', '2018-08-09',NULL, '30 Gran Via Street, Madrid, Tây Ban Nha', '67890123','hlvcaan','rema'),
	('lime30','Cầu thủ','Lionel Messi', '2021-08-05',NULL, '73 Saint-Germain, Paris, Pháp', '78901234',NULL, 'psg'),
	('frjo21','Cầu thủ','Frenkie de Jong', '2019-07-01',NULL, '40 Les Corts Road, Barcelona, Tây Ban Nha', '89012345',NULL,'barc'),
	('koke6','Cầu thủ','Koke', '2008-09-01',NULL, '50 Sevilla Street, Madrid, Tây Ban Nha', '90123456','hlvdisi','atma'),
	('jaob13','Cầu thủ','Jan Oblak', '2014-07-16',NULL, '10 Madrid Avenue, Madrid, Tây Ban Nha', '01234567','hlvdisi','atma'),
	('ivra10','Cầu thủ','Ivan Rakitić', '2014-07-01',NULL, '30 Rambla Street, Seville, Tây Ban Nha', '12345678',NULL,'sevi'),
	('juan7','Cầu thủ','Juanmi', '2021-08-31',NULL, '25 Real Street, Seville, Tây Ban Nha', '23456789',NULL,'rebe'),
	('dasi21','Cầu thủ','David Silva', '2020-08-17',NULL, '15 San Sebastian Avenue, San Sebastian, Tây Ban Nha', '34567890',NULL,'reso'),
	('unsi13','Cầu thủ','Unai Simón', '2016-07-01',NULL, '5 Athletic Way, Bilbao, Tây Ban Nha', '45678901',NULL,'atbi'),
	('roma9','Cầu thủ','Roger Martí', '2013-07-01',NULL, '20 Valencia Street, Valencia, Tây Ban Nha', '56789012',NULL,'vale'),
	('edca7','Cầu thủ','Edinson Cavani', '2020-10-05',NULL, '10 Levante Boulevard, Valencia, Tây Ban Nha', '67890123',NULL,'vale');

update CLB set NVDH='ctjola' where MaCLB='barc';

insert into CAUTHU values
	('kabe9', 9, 1),
	('vnju20', 20, 0),
	('thco1', 1, 0),
	('lime30', 30, 0),
	('frjo21', 21, 0),
	('koke6', 6, 1),
	('jaob13', 13, 0),
	('ivra10', 10, 0),
	('juan7', 7, 0),
	('dasi21', 21, 0),
	('unsi13', 13, 0),
	('roma9', 9, 1),
	('edca7', 7, 0);
	
insert into HLV values
	('hlvcaan',1, 30),
	('hlvdisi',1, 10);

insert into SAN values
	('sabe','Santiago Bernabéu', 'Madrid, Tây Ban Nha','81044', 'rema'),
	('cano','Camp Nou', 'Barcelona, Tây Ban Nha','99354','barc'),
	('wame','Wanda Metropolitano', 'Madrid, Tây Ban Nha', '68000','atma'),
	('rasp','Ramón Sánchez Pizjuán', 'Sevilla, Tây Ban Nha', '43700','sevi'),
	('bevi','Benito Villamarin', 'Sevilla, Tây Ban Nha','60720','rebe'),
	('sama','San Mamés', 'Bilbao, Tây Ban Nha','53289','atbi'),
	('anoe','Anoeta', 'San Sebastián, Tây Ban Nha','32000','reso'),
	('EM','El Madrigal', 'Tây Ban Nha','23500','VIL'),
	('AF','Anfield', 'Anh','54000','LIV'),
	('ES','Etihad Stadium', 'Anh','53400','MCI'),
	('SDF','Stade de France', 'Pháp','80000',NULL),
	('mest','Mestalla', 'Valencia, Tây Ban Nha','55000','vale');
	
	
insert into TRANDAU values
	('lfp2122cano2410','2021-10-24 21:00', '1-2','barc','rema','cano','lfp2021'),
    	('lfp2122sabe2103','2022-03-21 22:00', '0-4', 'rema', 'barc', 'sabe','lfp2021'),
    	('fp2122rasp1804','2022-04-18 22:00', '2-3', 'sevi', 'rema', 'rasp','lfp2021'),
    	('lfp1718bevi2201','2018-01-22 18:00', '0-5', 'rebe', 'barc', 'bevi','lfp2017'),
	('ckc12122','2022-05-29 18:00', '0-1', 'LIV', 'rema', 'sdf','c12122'),
	('bkc12122SB0505','2022-05-05 18:00', '3-1', 'rema', 'MCI', 'sabe','c12122'),
	('bkc12122ES2704','2022-04-27 18:00', '4-3', 'MCI', 'rema', 'ES','c12122'),
	('bkc12122AF2804','2022-04-28 18:00', '2-0', 'MCI', 'VIL', 'AF','c12122'),
	('bkc12122EM0405','2022-05-04 18:00', '3-2', 'MCI', 'VIL', 'EM','c12122'),
    	('lfp1718anoe2004','2018-04-20 18:00', '3-0', 'reso', 'atma','anoe','lfp2017');

insert into HOPDONG values
	('barc', 'ctjola', 'Chủ tịch', '2021-03-17','2026-06-30',15),
	('rema', 'hlvcaan', 'HLV', '2021-06-01', '2024-06-30',6),
	('atma', 'hlvdisi', 'HLV', '2011-12-23', '2024-06-30',25),
	('rema', 'kabe9', 'Cầu thủ', '2009-07-01', '2023-06-30', 60),
	('rema', 'vnju20', 'Cầu thủ', '2018-07-12', '2025-06-30', 55),
	('rema', 'thco1', 'Cầu thủ', '2018-08-09', '2026-06-30', 35),
	('psg', 'lime30', 'Cầu thủ', '2021-08-05', '2023-06-30', 35),
	('barc', 'frjo21', 'Cầu thủ', '2019-07-01', '2026-06-30', 75),
	('atma', 'koke6', 'Cầu thủ', '2008-09-01', '2024-06-30', 80),
	('atma', 'jaob13', 'Cầu thủ', '2016-07-01', '2024-06-30', 30),
	('sevi', 'ivra10', 'Cầu thủ', '2014-07-01', '2021-06-30', 10),
	('rebe', 'juan7', 'Cầu thủ', '2021-08-31', '2023-06-30', 20),
	('reso', 'dasi21', 'Cầu thủ', '2020-08-17', '2022-06-30', 12),
	('atbi', 'unsi13', 'Cầu thủ', '2016-07-01', '2024-06-30', 30),
	('vale', 'roma9', 'Cầu thủ', '2013-07-01', '2023-06-30', 20),
	('vale', 'edca7', 'Cầu thủ', '2020-10-05', '2022-06-30', 8);
	
insert into THAMGIATRANDAU values
	('209lfp2017','barc', 'lime30', 0, 93, 64,'Tiền đạo cánh phải',1),
	('209lfp2017','barc', 'lime30', 0, 93, 80,'Tiền đạo cánh phải',1),
	('290lfp2021','barc', 'frjo21', 0, 71, -1,'Tiền vệ trung tâm',0),
	('337lfp2017','reso', 'juan7', 72, 94, 80,'Tiền đạo cắm',1),
	('337lfp2017','reso', 'juan7', 72, 94, 92,'Tiền đạo cắm',1),
	('329fp2021','rema','kabe9', 0, 95,92,'Tiền đạo cắm',1),
	('329fp2021','sevi','ivra10', 0, 97,21,'Tiền vệ trung tâm',0);
	
insert into DANHHIEU values
	('001','CLB vô địch'),
	('002','CLB á quân'),
	('003','Cầu thủ xuất sắc nhất'),
	('004','Cầu thủ ghi nhiều bàn nhất'),
	('005','Thủ môn ít thủng lưới nhất'),
	('006','Cầu thủ trẻ xuất sắc nhất'),
	('007','HLV xuất sắc nhất');
	
insert into CTDH values
	('001','lfp2017','barc','lime30','2018-05-20'),
	('001','lfp2017','barc','frjo21','2018-05-20'),
	('002','lfp2017','atma','koke6','2018-05-20'),
	('002','lfp2017','atma','jaob13','2018-05-20'),
	('003','lfp2017','barc','lime30','2018-11-12'),
	('004','lfp2017','barc','lime30','2018-11-12'),
	('005','lfp2017','atma','jaob13','2018-11-12'),
	('001','lfp2021','rema','kabe9','2022-05-22'),
	('001','lfp2021','rema','vnju20','2022-05-22'),
	('001','lfp2021','rema','thco1','2022-05-22'),
	('002','lfp2021','barc','frjo21','2022-05-22'),
	('003','lfp2021','rema','kabe9','2022-11-21'),
	('004','lfp2021','rema','kabe9','2022-11-21'),
	('001','c12122','rema','bz10','2022-05-29'),
	('003','c12122','rema','bz10','2022-05-29'),
	('007','c12122','rema','ca14','2022-05-29'),
	('001','c12122','rema','ca14','2022-05-29'),
	('001','c12122','rema','lm10','2022-05-29'),
	('001','c12122','rema','tk8','2022-05-29'),
	('002','c12122','LIV','ms11','2022-05-29'),
	('002','c12122','LIV','al1','2022-05-29'),
	('005','lfp2021','atma','jaob13','2018-11-21');
