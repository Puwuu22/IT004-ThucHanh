﻿			--I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language)--
--1. Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại.
--Tạo bảng KHOA
CREATE TABLE KHOA(
	MAKHOA VARCHAR(4) CONSTRAINT KHOA_MAKHOA_PK PRIMARY KEY,
	TENKHOA VARCHAR(40) CONSTRAINT KHOA_MAKHOA_NN NOT NULL,
	NGTLAP SMALLDATETIME,
	TRGKHOA CHAR(4)
)
--Tạo bảng MONHOC
CREATE TABLE MONHOC(
	MAMH VARCHAR(10)  CONSTRAINT MH_MAMH_PK PRIMARY KEY,
	TENMH VARCHAR(40) CONSTRAINT MH_TENMH_NN NOT NULL,
	TCLT TINYINT,
	TCTH TINYINT,
	MAKHOA VARCHAR(4) 
)
--Tạo bảng DIEUKIEN
CREATE TABLE DIEUKIEN(
	MAMH VARCHAR(10),
	MAMH_TRUOC VARCHAR(10),
	CONSTRAINT DK_MAMH_MAMHTRUOC_PK PRIMARY KEY(MAMH, MAMH_TRUOC)
)
--Tạo bảng GIAOVIEN
CREATE TABLE GIAOVIEN(
	MAGV CHAR(4) CONSTRAINT GV_MAGV_PK PRIMARY KEY,
	HOTEN VARCHAR(40) CONSTRAINT GV_HOTEN_NN NOT NULL,
	HOCVI VARCHAR(10),
	HOCHAM VARCHAR(10),
	GIOITINH VARCHAR(3),
	NGSINH SMALLDATETIME,
	NGVL SMALLDATETIME,
	HESO NUMERIC(4,2),
	MUCLUONG MONEY, 
	MAKHOA VARCHAR(4),
)

--Tạo bảng LOP
CREATE TABLE LOP(
	MALOP CHAR(3) CONSTRAINT LOP_MALOP_PK PRIMARY KEY,
	TENLOP VARCHAR(40) CONSTRAINT LOP_TENLOP_NN NOT NULL,
	TRGLOP CHAR(5),
	SISO TINYINT,
	MAGVCN CHAR(4) 
)
--Tạo bảng HOCVIEN
CREATE TABLE HOCVIEN(
	MAHV CHAR(5) CONSTRAINT HV_MAHV_PK PRIMARY KEY,
	HO VARCHAR(40) CONSTRAINT HV_HO_NN NOT NULL,
	TEN VARCHAR(40) CONSTRAINT HV_TEN_NN NOT NULL,
	NGSINH SMALLDATETIME,
	GIOITINH VARCHAR(3),
	NOISINH VARCHAR(40),
	MALOP CHAR(3) 
)
--Tạo bảng GIANGDAY
CREATE TABLE GIANGDAY(
	MALOP CHAR(3),
	MAMH VARCHAR (10),
	MAGV CHAR(4),
	HOCKY TINYINT,
	NAM SMALLINT,
	TUNGAY SMALLDATETIME,
	DENNGAY SMALLDATETIME,
	CONSTRAINT GD_MALOP_MAMH_PK PRIMARY KEY(MALOP,MAMH)
)
--Tạo bảng KETQUATHI
CREATE TABLE KETQUATHI(
	MAHV CHAR(5), 
	MAMH VARCHAR(10),
	LANTHI TINYINT,
	NGTHI SMALLDATETIME,
	DIEM NUMERIC(4,2),
	KQUA VARCHAR(10),
	CONSTRAINT KQ_MAHV_MAMH_LANTHI_PK PRIMARY KEY(MAHV, MAMH, LANTHI)
)

--Định dạng ngày 
SET DATEFORMAT DMY 

--Nhập dữ liệu cho KHOA
INSERT INTO KHOA VALUES ('KHMT','Khoa Hoc May Tinh','07/06/2005',NULL)
INSERT INTO KHOA VALUES ('HTTT','He Thong Thong Tin','07/06/2005',NULL)
INSERT INTO KHOA VALUES ('CNPM','Cong Nghe Phan Mem','07/06/2005',NULL)
INSERT INTO KHOA VALUES ('MTT','Mang Va Truyen Thong','20/10/2005',NULL)
INSERT INTO KHOA VALUES ('KTMT','Ky Thuat May Tinh','20/12/2005',NULL) 

--Nhập dữ liệu cho GIAOVIEN
INSERT INTO GIAOVIEN VALUES ('GV01','Ho Thanh Son','PTS','GS','Nam','02/05/1950','11/01/2004','5.00',2250000,'KHMT')
INSERT INTO GIAOVIEN VALUES ('GV02','Tran Tam Thanh','TS','PGS','Nam','17/02/1965','20/04/2004','4.50',2025000,'HTTT')
INSERT INTO GIAOVIEN VALUES ('GV03','Do Nghiem Phung','TS','GS','Nu','01/08/1950','23/09/2004','4.00',1800000,'CNPM')
INSERT INTO GIAOVIEN VALUES ('GV04','Tran Nam Som','TS','PGS','Nam','22/02/1961','12/01/2005','4.50',2025000,'KTMT')
INSERT INTO GIAOVIEN VALUES ('GV05','Mai Thanh Danh','ThS','GV','Nam','12/03/1958','12/01/2005','3.00',1350000,'HTTT')
INSERT INTO GIAOVIEN VALUES ('GV06','Tran Doan Hung','TS','GV','Nam','11/03/1953','12/01/2005','4.50',2025000,'KHMT')
INSERT INTO GIAOVIEN VALUES ('GV07','Nguyen Minh Tien','ThS','GV','Nam','23/11/1971','01/03/2005','4.00',1800000,'KHMT')
INSERT INTO GIAOVIEN VALUES ('GV08','Le Thi Tran','KS','NULL','Nu','26/03/1974','01/03/2005','1.69',760500,'KHMT')
INSERT INTO GIAOVIEN VALUES ('GV09','Nguyen To Lan','ThS','GV','Nu','31/12/1966','01/03/2005','4.00',1800000,'HTTT')
INSERT INTO GIAOVIEN VALUES ('GV10','Le Tran Anh Loan','KS','NULL','Nu','17/07/1972','01/03/2005','1.86',837000,'CNPM')
INSERT INTO GIAOVIEN VALUES ('GV11','Ho Thanh Tung','CN','GV','Nam','12/01/1980','15/05/2005','2.67',1201500,'MTT')
INSERT INTO GIAOVIEN VALUES ('GV12','Tran Van Anh','CN','NULL','Nu','29/03/1981','15/05/2005','1.69',760500,'CNPM')
INSERT INTO GIAOVIEN VALUES ('GV13','Nguyen Linh Dan','CN','NULL','Nu','23/05/1980','15/05/2005','1.69',760500,'KTMT')
INSERT INTO GIAOVIEN VALUES ('GV14','Truong Minh Chau','ThS','GV','Nu','30/11/1976','15/05/2005','3.00',1350000,'MTT')
INSERT INTO GIAOVIEN VALUES ('GV15','Le Ha Thanh','ThS','GV','Nam','04/05/1978','15/05/2005','3.00',1350000,'KHMT')

--Cập nhật dữ liệu trưởng khoa các khoa
UPDATE KHOA
SET TRGKHOA='GV01'
WHERE MAKHOA='KHMT'

UPDATE KHOA
SET TRGKHOA='GV02'
WHERE MAKHOA='HTTT'

UPDATE KHOA
SET TRGKHOA='GV04'
WHERE MAKHOA='CNPM'

UPDATE KHOA
SET TRGKHOA='GV03'
WHERE MAKHOA='MTT'

UPDATE KHOA
SET TRGKHOA=NULL
WHERE MAKHOA='KTMT'

--Nhập dữ liệu cho LOP
INSERT INTO LOP VALUES ('K11','Lop 1 Khoa 1','K1108','11','GV07')
INSERT INTO LOP VALUES ('K12','Lop 2 Khoa 1','K1205','12','GV09')
INSERT INTO LOP VALUES ('K13','Lop 3 Khoa 1','K1305','12','GV14')

--Nhập dữ liệu cho MONHOC
INSERT INTO MONHOC VALUES ('THDC','Tin Hoc Dai Cuong','4','1','KHMT')
INSERT INTO MONHOC VALUES ('CTRR','Cau TRuc Roi Rac','5','0','KHMT')
INSERT INTO MONHOC VALUES ('CSDL','Co So Du Lieu','3','1','HTTT')
INSERT INTO MONHOC VALUES ('CTDLGT','Cau Truc Du Lieu Va Giai Thuat','3','1','KHMT')
INSERT INTO MONHOC VALUES ('PTTKTT','Phan Tich Thuet Ke Thuat Toan','3','0','KHMT')
INSERT INTO MONHOC VALUES ('DHMT','Do Hoa May Tinh','3','1','KHMT')
INSERT INTO MONHOC VALUES ('KTMT','Kien Truc May Tinh','3','0','KTMT')
INSERT INTO MONHOC VALUES ('TKCSDL','Thiet Ke Co So Du Lieu','3','1','HTTT')
INSERT INTO MONHOC VALUES ('PTTKHTTT','Phan Tich Thiet Ke He Thong Thong Tin','4','1','HTTT')
INSERT INTO MONHOC VALUES ('HDH','He Dieu Hanh','4','0','KHMT')
INSERT INTO MONHOC VALUES ('NMCNPM','Nhap Mon Cong Nghe Phan Mem','3','0','CNPM')
iNSERT INTO MONHOC VALUES ('LTCFW','Lap Trinh C For Win','3','1','CNPM')
INSERT INTO MONHOC VALUES ('LTHDT','Lap Trinh Huong Doi Tuong','3','1','CNPM')

--Nhập dữ liệu cho DIEUKIEN
INSERT INTO DIEUKIEN VALUES ('CSDL','CTRR')
INSERT INTO DIEUKIEN VALUES ('CSDL','CTDLGT')
INSERT INTO DIEUKIEN VALUES ('CTDLGT','THDC')
INSERT INTO DIEUKIEN VALUES ('PTTKTT','CTDLGT')
INSERT INTO DIEUKIEN VALUES ('PTTKTT','THDC')
INSERT INTO DIEUKIEN VALUES ('DHMT','THDC')
INSERT INTO DIEUKIEN VALUES ('LTHDT','THDC')
INSERT INTO DIEUKIEN VALUES ('PTTKHTTT','CSDL')

--Nhập dữ liệu cho HOCVIEN
INSERT INTO HOCVIEN VALUES ('K1101','Nguyen Van','A','27/01/1986','Nam','TPHCM','K11')
INSERT INTO HOCVIEN VALUES ('K1102','Tran Ngoc','Han','14/03/1986','Nu','Kien Giang','K11')
INSERT INTO HOCVIEN VALUES ('K1103','Ha Duy','Lap','18/04/1986','Nam','Nghe An','K11')
INSERT INTO HOCVIEN VALUES ('K1104','Tran NGoc ','Linh','30/03/1986','Nu','Tay Ninh','K11')
INSERT INTO HOCVIEN VALUES ('K1105','Tran Minh','Long','27/02/1986','Nam','TPHCM','K11')
INSERT INTO HOCVIEN VALUES ('K1106','Le Nhat ','Minh','24/01/1986','Nam','TPHCM','K11')
INSERT INTO HOCVIEN VALUES ('K1107','Nguyen Nhu','Nhut','27/01/1986','Nam','Ha Noi','K11')
INSERT INTO HOCVIEN VALUES ('K1108','Nguyen Manh','Tam','27/02/1986','Nam','Kien Giang','K11')
INSERT INTO HOCVIEN VALUES ('K1109','Phan Thi Thanh','Tam','27/01/1986','Nu','Vinh Long','K11')
INSERT INTO HOCVIEN VALUES ('K1110','Le Hoai','Thuong','05/02/1986','Nu','Can Tho','K11')
INSERT INTO HOCVIEN VALUES ('K1111','Le Ha','Vinh','25/12/1986','Nam','Vinh Long','K11')
INSERT INTO HOCVIEN VALUES ('K1201','NGuyen Van ','B','11/02/1986','Nam','TPHCM','K12')
INSERT INTO HOCVIEN VALUES ('K1202','Nguyen Thi Kim','Duyen','18/01/1986','Nu','TPHCM','K12')
INSERT INTO HOCVIEN VALUES ('K1203','Tran Thi Kim','Duyen','17/09/1986','Nu','TPHCM','K12')
INSERT INTO HOCVIEN VALUES ('K1204','Truong My','Hanh','19/05/1986','Nu','Dong Nai','K12')
INSERT INTO HOCVIEN VALUES ('K1205','Nguyen Thanh','Nam','17/04/1986','Nam','TPHCM','K12')
INSERT INTO HOCVIEN VALUES ('K1206','NGuyen Thi Truc ','Thanh','04/03/1986','Nu','Kien Giang','K12')
INSERT INTO HOCVIEN VALUES ('K1207','Tran Thi Bich ','Thuy','08/02/1986','Nu','Nghe An','K12')
INSERT INTO HOCVIEN VALUES ('K1208','Huynh Thi Kim','Trieu','08/04/1986','Nu','Tay Ninh','K12')
INSERT INTO HOCVIEN VALUES ('K1209','Pham Thanh','Trieu','23/02/1986','Nam','TPHCM','K12')
INSERT INTO HOCVIEN VALUES ('K1210','Ngo Thanh','Tuan','14/02/1986','Nam','TPHCM','K12')
INSERT INTO HOCVIEN VALUES ('K1211','Do Thi','Xuan','09/03/1986','Nu','Ha Noi','K12')
INSERT INTO HOCVIEN VALUES ('K1212','Le Thi Phi','Yen','12/03/1986','Nu','TPHCM','K12')
INSERT INTO HOCVIEN VALUES ('K1301','NGuyen Thi Kim','Cuc','09/06/1986','Nu','Kien Giang','K13')
INSERT INTO HOCVIEN VALUES ('K1302','Truong Thi My','Hien','18/03/1986','Nu','Nghe An','K13')
INSERT INTO HOCVIEN VALUES ('K1303','Le Duc','Hien','21/03/1986','Nam','Tay Ninh','K13')
INSERT INTO HOCVIEN VALUES ('K1304','Le Quang','Hien','18/04/1986','Nam','TPHCM','K13')
INSERT INTO HOCVIEN VALUES ('K1305','Le Thi ','Huong','27/03/1986','Nu','TPHCM','K13')
INSERT INTO HOCVIEN VALUES ('K1306','Nguyen Thai','Huu','30/03/1986','Nam','Ha Noi','K13')
INSERT INTO HOCVIEN VALUES ('K1307','Tran Minh','Man','28/05/1986','Nam','TPHCM','K13')
INSERT INTO HOCVIEN VALUES ('K1308','Huynh Hieu','Nghia','08/04/1986','Nam','Kien Giang','K13')
INSERT INTO HOCVIEN VALUES ('K1309','Nguyen Trung ','Nghia','18/01/1987','Nam','Nghe An','K13')
INSERT INTO HOCVIEN VALUES ('K1310','Tran Thi Hong','Tham','22/04/1986','Nu','Tay Ninh','K13')
INSERT INTO HOCVIEN VALUES ('K1311','Tran Minh','Thuc','04/04/1986','Nam','TPHCM','K13')
INSERT INTO HOCVIEN VALUES ('K1312','Nguyen Thi Kim','Yen','07/09/1986','Nu','TPHCM','K13')

--Nhập dữ liệu cho GIANGDAY
INSERT INTO GIANGDAY VALUES ('K11','THDC','GV07','1','2006','02/01/2006','12/05/2006')
INSERT INTO GIANGDAY VALUES ('K12','THDC','GV06','1','2006','02/01/2006','12/05/2006')
INSERT INTO GIANGDAY VALUES ('K13','THDC','GV15','1','2006','02/01/2006','12/05/2006')
INSERT INTO GIANGDAY VALUES ('K11','CTRR','GV02','1','2006','09/01/2006','17/05/2006')
INSERT INTO GIANGDAY VALUES ('K12','CTRR','GV02','1','2006','09/01/2006','17/05/2006')
INSERT INTO GIANGDAY VALUES ('K13','CTRR','GV08','1','2006','09/01/2006','17/05/2006')
INSERT INTO GIANGDAY VALUES ('K11','CSDL','GV05','2','2006','01/06/2006','15/07/2006')
INSERT INTO GIANGDAY VALUES ('K12','CSDL','GV09','2','2006','01/06/2006','15/07/2006')
INSERT INTO GIANGDAY VALUES ('K13','CTDLGT','GV15','2','2006','01/06/2006','15/07/2006')
INSERT INTO GIANGDAY VALUES ('K13','CSDL','GV05','3','2006','01/08/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K13','DHMT','GV07','3','2006','01/08/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K11','CTDLGT','GV15','3','2006','01/08/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K12','CTDLGT','GV15','3','2006','01/08/2007','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K11','HDH','GV04','1','2007','02/01/2007','18/02/2007')
INSERT INTO GIANGDAY VALUES ('K12','HDH','GV04','1','2007','02/01/2007','20/03/2007')
INSERT INTO GIANGDAY VALUES ('K11','DHMT','GV07','1','2007','18/02/2007','20/03/2007')

--Nhập dữ liệu cho KETQUATHI
INSERT INTO KETQUATHI VALUES ('K1305','CTRR','1','13/05/2006','10.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1101','CSDL','1','20/07/2006','10.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1101','CTDLGT','1','28/12/2006','9.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1101','THDC','1','20/05/2006','9.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1101','CTRR','1','13/05/2006','9.50','Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CSDL','1','20/07/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CSDL','2','27/07/2006','4.25','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CSDL','3','10/08/2006','4.50','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTDLGT','1','28/12/2006','4.50','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTDLGT','2','05/01/2007','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTDLGT','3','15/01/2007','6.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1102','THDC','1','20/05/2006','5.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTRR','1','13/05/2006','7.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CSDL','1','20/07/2006','3.50','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CSDL','2','27/07/2006','8.25','Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CTDLGT','1','28/12/2006','7.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1103','THDC','1','20/05/2006','8.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CTRR','1','13/05/2006','6.25','Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CSDL','1','20/07/2006','3.75','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTDLGT','1','28/12/2006','4.00','KHong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','THDC','1','20/05/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTRR','1','13/05/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTRR','2','20/05/2006','3.50','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTRR','3','30/06/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1201','CSDL','1','20/07/2006','6.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1201','CTDLGT','1','28/12/2006','5.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1201','THDC','1','20/05/2006','8.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1201','CTRR','1','13/05/2006','9.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CSDL','1','20/07/2006','8.00','dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTDLGT','1','28/12/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTDLGT','2','05/01/2007','5.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1202','THDC','1','20/05/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','THDC','2','27/05/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTRR','1','13/05/2006','3.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTRR','2','20/05/2006','4.00','Khong dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTRR','3','30/06/2006','6.25','Dat')
INSERT INTO KETQUATHI VALUES ('K1203','CSDL','1','20/07/2006','9.25','Dat')
INSERT INTO KETQUATHI VALUES ('K1203','CTDLGT','1','28/12/2006','9.50','Dat')
INSERT INTO KETQUATHI VALUES ('K1203','THDC','1','20/05/2006','10','Dat')
INSERT INTO KETQUATHI VALUES ('K1203','CTRR','1','13/05/2006','10','Dat')
INSERT INTO KETQUATHI VALUES ('K1204','CSDL','1','20/07/2006','8.50','Dat')
INSERT INTO KETQUATHI VALUES ('K1204','CTDLGT','1','28/12/2006','6.25','dat')
INSERT INTO KETQUATHI VALUES ('K1204','THDC','1','20/05/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1204','CTRR','1','13/05/2006','6.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1301','CSDL','1','20/12/2006','4.25','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1301','CTDLGT','1','25/07/2006','8.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1301','THDC','1','20/05/2006','7.75','Dat')
INSERT INTO KETQUATHI VALUES ('K1301','CTRR','1','13/05/2006','8.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1302','CSDL','1','20/12/2006','6.75','Dat')
INSERT INTO KETQUATHI VALUES ('K1302','CTDLGT','1','13/05/2006','5.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1302','THDC','1','20/05/2006','8.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1302','CTRR','1','13/05/2006','8.50','Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CSDL','1','20/12/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTDLGT','1','25/07/2006','4.50','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTDLGT','2','07/08/2006','4.00','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTDLGT','3','15/08/2006','4.25','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','THDC','1','20/05/2006','4.50','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTRR','1','13/05/2006','3.25','Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTRR','2','20/05/2006','5.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1304','CSDL','1','20/12/2006','7.75','Dat')
INSERT INTO KETQUATHI VALUES ('K1304','CTDLGT','1','25/07/2006','9.75','Dat')
INSERT INTO KETQUATHI VALUES ('K1304','THDC','1','20/05/2006','5.50','Dat')
INSERT INTO KETQUATHI VALUES ('K1304','CTRR','1','13/05/2006','5.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1305','CSDL','1','20/12/2006','9.25','Dat')
INSERT INTO KETQUATHI VALUES ('K1305','CTDLGT','1','25/07/2006','10.00','Dat')
INSERT INTO KETQUATHI VALUES ('K1305','THDC','1','20/05/2006','8.00','Dat')

--Tạo khóa ngoại
ALTER TABLE KHOA
ADD CONSTRAINT KHOA_TRGKHOA_FK FOREIGN KEY (TRGKHOA) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE KHOA
ADD CONSTRAINT MH_MAKHOA_FK FOREIGN KEY (MAKHOA) REFERENCES KHOA (MAKHOA)

ALTER TABLE DIEUKIEN
ADD CONSTRAINT DK_MAMH_FK FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)

ALTER TABLE DIEUKIEN
ADD CONSTRAINT DK_MAMH_TRUOC_FK FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)

ALTER TABLE GIAOVIEN
ADD CONSTRAINT GV_MAKHOA_FK FOREIGN KEY(MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE LOP
ADD CONSTRAINT LOP_TRGLOP_FK FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV)

ALTER TABLE LOP
ADD CONSTRAINT LOP_MAGVCN_FK FOREIGN KEY(MAGVCN) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE HOCVIEN
ADD CONSTRAINT HV_MALOP_FK FOREIGN KEY(MALOP) REFERENCES LOP(MALOP) 

ALTER TABLE GIANGDAY
ADD CONSTRAINT GD_MAGV_FK FOREIGN KEY(MAGV) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE GIANGDAY
ADD CONSTRAINT GD_MAMH_FK FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)

ALTER TABLE GIANGDAY
ADD CONSTRAINT GD_MALOP_FK FOREIGN KEY(MALOP) REFERENCES LOP(MALOP)

ALTER TABLE KETQUATHI
ADD CONSTRAINT KQ_MAHV_FK FOREIGN KEY(MAHV) REFERENCES HOCVIEN(MAHV)

ALTER TABLE KETQUATHI
ADD CONSTRAINT KQ_MAMH_FK FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)


-- Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
ALTER TABLE HOCVIEN
ADD GHICHU VARCHAR(100),
	DIEMTB NUMERIC(4,2),
	XEPLOAI VARCHAR(20)

--2. Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học viên trong lớp. VD: “K1101”
ALTER TABLE HOCVIEN
ADD CONSTRAINT HV_KT_CHECK CHECK (MAHV LIKE MALOP +'[0-9][0-9]')


--3. Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT GV_GT_CHECK CHECK(GIOITINH IN ('Nam', 'Nu'))

ALTER TABLE HOCVIEN
ADD CONSTRAINT HV_GT_CHECK CHECK(GIOITINH IN('Nam', 'Nu'))

--4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI 
ADD CONSTRAINT KQ_DIEM_CHECK CHECK
(
	DIEM >=0 AND DIEM <=10
	AND DIEM LIKE '%.[0-9][0-9]'
)

--5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI
ADD CONSTRAINT KQ_KQUA_CHECK CHECK
(
	(KQUA = 'Dat' AND DIEM BETWEEN 5 AND 10)
	OR (KQUA = 'Khong dat' AND DIEM < 5)
)

--6. Học viên thi một môn tối đa 3 lần.
ALTER TABLE KETQUATHI 
ADD CONSTRAINT KQ_LANTHI_CHECK CHECK(LANTHI <= 3)

--7. Học kỳ chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY
ADD CONSTRAINT GD_HOCKY_CHECK CHECK(HOCKY BETWEEN 1 AND 3)

--8. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT GV_HOCVI_CHECK CHECK(HOCVI IN('CN', 'KS', 'Ths', 'TS', 'PTS'))

--9. Lớp trưởng của một lớp phải là học viên của lớp đó.
ALTER TABLE LOP
ADD CONSTRAINT LOP_TRLOP_CHECK CHECK (TRGLOP LIKE MALOP + '[0-9][0-9]')

--10. Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”.
ALTER TABLE KHOA
ADD CONSTRAINT KHOA_TRGKHOA_CHECK CHECK
( TRGKHOA IN 
	(
	SELECT GV.MAGV
	FROM GIAOVIEN GV, KHOA
	WHERE GV.MAKHOA= KHOA.MAKHOA 
		AND GV.HOCVI IN ('TS', 'PTS')
	)
)

--11. Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN 
ADD CONSTRAINT HV_TUOI_CHECK CHECK(YEAR(GETDATE()) - YEAR(NGSINH) >= 18)

--12. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY 
ADD CONSTRAINT GD_NGAYGD_CHECK CHECK(TUNGAY < DENNGAY)

--13. Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT GV_TUOI_CHECK CHECK(YEAR(NGVL) - YEAR(NGSINH) >= 22)

--14. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3
ALTER TABLE MONHOC 
ADD CONSTRAINT CHECK_TC_CHECK CHECK (ABS(TCLT - TCTH) <= 3)

--15. Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này.
CREATE TRIGGER TRG_CHECK_THI ON KETQUATHI
FOR INSERT
AS
BEGIN
    DECLARE @MAHV CHAR(5), @MAMH VARCHAR(10), @NGTHI SMALLDATETIME, @DENNGAY SMALLDATETIME, @MALOP  CHAR(3)

    SELECT @MAHV = MAHV, @MAMH = MAMH, @NGTHI = NGTHI
    FROM INSERTED

    SELECT @DENNGAY = DENNGAY
    FROM GIANGDAY
    WHERE MALOP = @MALOP

    IF (@NGTHI < @DENNGAY)
		BEGIN
			PRINT 'LOI: KHONG DUOC PHEP THI'
			ROLLBACK TRANSACTION
		END
	ELSE 
		BEGIN
			PRINT 'CO THE THI'
		END
END

--16. Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn.
CREATE TRIGGER TRG_MONHOCHK_GD ON GIANGDAY
FOR INSERT
AS
BEGIN
    DECLARE @MALOP CHAR(3), @HOCKY TINYINT, @NAM SMALLINT, @SOLUONGMON INT

    SELECT @MALOP = MALOP, @HOCKY = HOCKY, @NAM = NAM
    FROM INSERTED

    SELECT @SOLUONGMON = COUNT(*) 
						 FROM GIANGDAY
						 WHERE MALOP = @MALOP 
							AND HOCKY = @HOCKY 
							AND NAM = @NAM

    IF (@SOLUONGMON > 3)
		BEGIN
			PRINT 'LOI: MOI HOC KY CUA NAM, CHI DUOC DANG KY TOI DA 3 MON'
			ROLLBACK TRANSACTION
		END
	ELSE
		BEGIN
			PRINT 'THEM MON THANH CONG'
		END
END

--17. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó.
CREATE TRIGGER TRG_CHECK_SISO ON HOCVIEN
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MALOP CHAR(3), @SOLUONGHV INT, @SISO INT

    SELECT @MALOP = MALOP
    FROM INSERTED

    SELECT @SOLUONGHV = COUNT(*) FROM HOCVIEN WHERE MALOP = @MALOP

    SELECT @SISO = SISO
	FROM LOP
    WHERE MALOP = @MALOP

    IF (@SOLUONGHV = @SISO)
		BEGIN
			PRINT 'SI SO LOP BANG SO LUONG HOC VIEN CUA LOP'
		END
	ELSE 
		BEGIN
			PRINT 'LOI: SI SO LOP KHONG BANG SO LUONG HOC VIEN CUA LOP'
			ROLLBACK TRANSACTION
		END
END

------------------------------------------------------------------------------------
			--II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language)--
--1. Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN
SET HESO = 0.2 + HESO
WHERE MAGV IN (SELECT TRGKHOA FROM KHOA)

--2. Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
UPDATE HOCVIEN
SET DIEMTB = (
	SELECT AVG(DIEM)
	FROM KETQUATHI
	WHERE LANTHI = (SELECT MAX(LANTHI)
					FROM KETQUATHI KQ
					WHERE MAHV = KETQUATHI.MAHV
					GROUP BY MAHV)
	GROUP BY MAHV
	HAVING MAHV = HOCVIEN.MAHV
)

--3. Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm.
UPDATE HOCVIEN
SET GHICHU = 'Cam thi'
WHERE MAHV IN(
	SELECT MAHV
	FROM KETQUATHI
	WHERE LANTHI = '3'
		AND DIEM < '5'
)

--4. Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
--Nếu DIEMTB >= 9 thì XEPLOAI =”XS”
--Nếu 8 <= DIEMTB < 9 thì XEPLOAI = “G”
--Nếu 6.5 <= DIEMTB < 8 thì XEPLOAI = “K”
--Nếu 5 <= DIEMTB < 6.5 thì XEPLOAI = “TB”
--Nếu DIEMTB < 5 thì XEPLOAI = ”Y 
UPDATE HOCVIEN
SET XEPLOAI = (
	CASE 
		WHEN DIEMTB >= 9 THEN 'XS'
		WHEN DIEMTB >= 8 AND DIEMTB < 9 THEN 'G'
		WHEN DIEMTB >= 6.5 AND DIEMTB < 8 THEN 'K'
		WHEN DIEMTB >= 5 AND DIEMTB < 6.5 THEN 'TB'
		WHEN DIEMTB < 5 THEN 'Y'
	END
)
-------------------------------------------------------------------------------------

			--III. Ngôn ngữ truy vấn dữ liệu--
--1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN, HV.NGSINH, HV.MALOP
FROM HOCVIEN HV, LOP
WHERE LOP.TRGLOP = HV.MAHV

--2. In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN, KQ.LANTHI, KQ.DIEM
FROM KETQUATHI KQ, HOCVIEN HV
WHERE KQ.MAHV = HV.MAHV
	AND KQ.MAMH = 'CTRR'
	AND HV.MALOP = 'K12'
ORDER BY HOTEN

--3. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN, KQ.MAMH
FROM HOCVIEN HV, KETQUATHI KQ
WHERE KQ.MAHV = HV.MAHV
	AND KQ.LANTHI = '1'
	AND KQUA = 'Dat'

--4. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN
FROM HOCVIEN HV, KETQUATHI KQ
WHERE KQ.MAHV = HV.MAHV	
	AND HV.MALOP = 'K11'
	AND KQ.MAMH = 'CTRR'
	AND KQ.LANTHI = '1'
	AND KQ.KQUA = 'Khong Dat'

--5. * Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT DISTINCT HV.MAHV, HO + ' ' + TEN AS HOTEN
FROM HOCVIEN HV, KETQUATHI KQ
WHERE KQ.MAHV = HV.MAHV	
	AND KQ.MAMH = 'CTRR'
	AND KQ.KQUA = 'Khong Dat'

--6. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
SELECT MH.TENMH
FROM MONHOC MH, GIAOVIEN GV, GIANGDAY GD
WHERE MH.MAMH = GD.MAMH
	AND GD.MAGV = GV.MAGV
	AND GV.HOTEN = 'Tran Tam Thanh'
	AND GD.HOCKY = '1'
	AND GD.NAM = '2006'
GROUP BY MH.TENMH

--7. Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT MH.MAMH, MH.TENMH
FROM MONHOC MH, GIANGDAY GD, LOP 
WHERE MH.MAMH = GD.MAMH
	AND GD.MALOP = LOP.MALOP
	AND GD.MAGV = LOP.MAGVCN
	AND LOP.MALOP = 'K11'
	AND GD.HOCKY = '1'
	AND GD.NAM = '2006'

--8. Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
SELECT HV.HO, HV.TEN
FROM HOCVIEN HV, GIAOVIEN GV, GIANGDAY GD, MONHOC MH, LOP
WHERE GV.HOTEN = 'Nguyen To Lan'
	AND MH.TENMH = 'Co So Du Lieu'
	AND GV.MAGV = GD.MAGV
	AND GD.MAMH = MH.MAMH
	AND GD.MALOP = LOP.MALOP
	AND LOP.TRGLOP = HV.MAHV

--9. In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
SELECT MONHOCTRUOC.MAMH, MONHOCTRUOC.TENMH
FROM MONHOC MH, MONHOC AS MONHOCTRUOC, DIEUKIEN DK
WHERE MH.TENMH = 'Co So Du Lieu'
	AND MH.MAMH = DK.MAMH
	AND MONHOCTRUOC.MAMH = DK.MAMH_TRUOC

--10. Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào
SELECT MH.MAMH, MH.TENMH
FROM MONHOC MH, MONHOC AS MONHOCTRUOC, DIEUKIEN DK
WHERE MH.MAMH = DK.MAMH
	AND MONHOCTRUOC.MAMH = DK.MAMH_TRUOC
	AND MONHOCTRUOC.TENMH = 'Cau Truc Roi Rac'

--11. Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
SELECT HOTEN 
FROM GIAOVIEN, GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV
	AND GIANGDAY.MAMH = 'CTRR'
	AND GIANGDAY.HOCKY = '1'
	AND GIANGDAY.NAM = '2006'
	AND GIANGDAY.MALOP = 'K11'
INTERSECT 
SELECT HOTEN 
FROM GIAOVIEN, GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV
	AND GIANGDAY.MAMH = 'CTRR'
	AND GIANGDAY.HOCKY = '1'
	AND GIANGDAY.NAM = '2006'
	AND GIANGDAY.MALOP = 'K12'

--12. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN
FROM KETQUATHI KQ, HOCVIEN HV
WHERE HV.MAHV = KQ.MAHV
	AND KQ.MAMH = 'CSDL'
	AND KQ.LANTHI = '1'
	AND KQ.KQUA = 'Khong Dat'
	AND NOT EXISTS(
		SELECT*
		FROM KETQUATHI KQ2
		WHERE KQ2.MAMH = 'CSDL'
			AND KQ2.MAHV = HV.MAHV
			AND KQ2.LANTHI > 1
	)

--13. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN(
	SELECT MAGV
	FROM GIANGDAY
	)

--14. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT GIAOVIEN.MAGV, GIAOVIEN.HOTEN
FROM GIAOVIEN
WHERE GIAOVIEN.MAGV NOT IN (
    SELECT DISTINCT GIANGDAY.MAGV
    FROM GIANGDAY, MONHOC
    WHERE MONHOC.MAKHOA = GIAOVIEN.MAKHOA
	 AND GIANGDAY.MAMH = MONHOC.MAMH
)

--15. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT HO + ' ' + TEN AS HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND HOCVIEN.MALOP = 'K11'
	AND KETQUATHI.LANTHI >= 3 
	AND KETQUATHI.KQUA = 'Khong Dat'
UNION
SELECT HO + ' ' + TEN AS HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND HOCVIEN.MALOP = 'K11'
	AND KETQUATHI.LANTHI = 2
	AND MAMH = 'CTRR'
	AND DIEM = 5


--16. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
SELECT HOTEN
FROM GIAOVIEN, GIANGDAY
WHERE GIAOVIEN.MAGV = GIANGDAY.MAGV
	AND MAMH = 'CTRR'
GROUP BY GIAOVIEN.MAGV, GIANGDAY.HOCKY
HAVING COUNT (GIANGDAY.MALOP) >= 2

--17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT HOCVIEN.*, DIEM AS 'DIEMTHICSDL'
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND KETQUATHI.MAMH = 'CSDL'
	AND LANTHI = (
		SELECT MAX(LANTHI)
		FROM KETQUATHI
		WHERE MAMH = 'CSDL'
			AND KETQUATHI.MAHV = HOCVIEN.MAHV
			GROUP BY MAHV
	)

--18. Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT HOCVIEN.*, DIEM AS 'DIEMTHICSDL'
FROM HOCVIEN, KETQUATHI, MONHOC
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND MONHOC.MAMH = KETQUATHI.MAMH
	AND MONHOC.TENMH = 'Co So Du Lieu'
	AND DIEM = (
		SELECT MAX(DIEM)
		FROM KETQUATHI, MONHOC
		WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
			AND MONHOC.MAMH = KETQUATHI.MAMH
			AND MONHOC.TENMH = 'Co So Du Lieu'
			GROUP BY MAHV
	)
	
--19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT MAKHOA, TENKHOA
FROM KHOA
WHERE NGTLAP = (
	SELECT MIN(NGTLAP)
	FROM KHOA
	)
--20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT COUNT(*)
FROM GIAOVIEN
WHERE HOCHAM IN ('GS', 'PGS')

--21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT MAKHOA, HOCVI, COUNT(*) AS SOLUONG
FROM GIAOVIEN
GROUP BY MAKHOA, HOCVI

--22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT MONHOC.MAMH, KQUA, COUNT(*) AS SOLUONG
FROM MONHOC, KETQUATHI
WHERE KETQUATHI.MAMH = MONHOC.MAMH
GROUP BY MONHOC.MAMH, KETQUATHI.KQUA

--23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT DISTINCT GIAOVIEN.MAGV, HOTEN
FROM GIAOVIEN, LOP, GIANGDAY
WHERE GIAOVIEN.MAGV = LOP.MAGVCN
	AND GIAOVIEN.MAGV = GIANGDAY.MAGV
	AND LOP.MALOP = GIANGDAY.MALOP

--24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất
SELECT HO + ' ' + TEN
FROM LOP, HOCVIEN
WHERE LOP.TRGLOP = HOCVIEN.MAHV
	AND SISO = (
		SELECT MAX(SISO)
		FROM LOP
	)

--25. * Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
SELECT HO + ' ' + TEN AS HOTEN
FROM KETQUATHI, LOP, HOCVIEN
WHERE HOCVIEN.MAHV = LOP.TRGLOP
	AND HOCVIEN.MAHV = KETQUATHI.MAHV
	AND KETQUATHI.MAHV IN (
			SELECT MAHV
			FROM KETQUATHI
			WHERE KQUA = 'Khong Dat'
			GROUP BY MAHV
			HAVING COUNT(DISTINCT MAMH) >= 3
			)

--26. Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT TOP 1 WITH TIES KETQUATHI.MAHV, HO + ' ' + TEN AS HOTEN, COUNT(DISTINCT MAMH) AS SOMON
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND KETQUATHI.DIEM >= 9
GROUP BY KETQUATHI.MAHV, HO + ' ' + TEN
ORDER BY SOMON DESC

--27. Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT HOCVIEN.MALOP, HOCVIEN.MAHV, HO + ' ' + TEN AS HOTEN, COUNT(DISTINCT MAMH) SOMON
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND KETQUATHI.DIEM >= 9
GROUP BY HOCVIEN.MALOP, HOCVIEN.MAHV, HO + ' ' + TEN
HAVING COUNT(DISTINCT MAMH) = (
			SELECT MAX(SOMON)
			FROM (
				SELECT HOCVIEN.MALOP, COUNT(DISTINCT MAMH) AS SOMON
				FROM HOCVIEN, KETQUATHI
				WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
					AND KETQUATHI.DIEM >= 9 
				GROUP BY HOCVIEN.MALOP ) MAX_SOMON
			WHERE MAX_SOMON.MALOP = HOCVIEN.MALOP
		)

--28. Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT HOCKY, NAM, MAGV,  COUNT(DISTINCT MAMH) AS SOMON, COUNT(DISTINCT MALOP) AS SOLOP
FROM GIANGDAY
GROUP BY NAM, HOCKY, MAGV

--29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT TOP 1 WITH TIES HOCKY, NAM, GIANGDAY.MAGV, HOTEN
FROM GIANGDAY, GIAOVIEN
WHERE GIANGDAY.MAGV = GIAOVIEN.MAGV
GROUP BY HOCKY, NAM, GIANGDAY.MAGV, HOTEN 
ORDER BY COUNT(GIANGDAY.MAGV) DESC

--30. Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
SELECT TOP 1 WITH TIES MONHOC.MAMH, TENMH, COUNT(MAHV) AS SOSINHVIEN_KHONGDAT
FROM MONHOC, KETQUATHI
WHERE MONHOC.MAMH = KETQUATHI.MAMH
	AND LANTHI = '1' 
	AND KQUA = 'Khong Dat'
GROUP BY MONHOC.MAMH, TENMH
ORDER BY SOSINHVIEN_KHONGDAT DESC

--31. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
SELECT DISTINCT HOCVIEN.MAHV, HO + ' ' + TEN AS HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND NOT EXISTS (
		SELECT *
		FROM KETQUATHI
		WHERE KQUA = 'Khong Dat'
			AND LANTHI = '1'
			AND MAHV = HOCVIEN.MAHV
	)

--32. * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
SELECT DISTINCT HOCVIEN.MAHV, HO + ' ' + TEN AS HOTEN
FROM HOCVIEN, KETQUATHI
WHERE HOCVIEN.MAHV = KETQUATHI.MAHV
	AND NOT EXISTS (
		SELECT *
		FROM KETQUATHI
		WHERE KQUA = 'Khong Dat'
		AND LANTHI = (
			SELECT MAX(LANTHI)
			FROM KETQUATHI
			WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
			GROUP BY MAHV
			)
		AND HOCVIEN.MAHV = KETQUATHI.MAHV
		)

--33. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1).
SELECT KETQUATHI.MAHV, HO + ' ' + TEN AS HOTEN
FROM KETQUATHI, HOCVIEN, MONHOC
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
	AND MONHOC.MAMH = KETQUATHI.MAMH
	AND KQUA = 'Dat'
	AND LANTHI = 1
GROUP BY KETQUATHI.MAHV, HO + ' ' + TEN
HAVING COUNT(DISTINCT KETQUATHI.MAMH) = (SELECT COUNT(*) FROM MONHOC)
								
--34. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi sau cùng).
SELECT DISTINCT HOCVIEN.MAHV, HO + ' ' + TEN AS HOTEN
FROM KETQUATHI, HOCVIEN, MONHOC
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
	AND MONHOC.MAMH = KETQUATHI.MAMH
	AND NOT EXISTS (
		SELECT *
		FROM KETQUATHI
		WHERE KQUA = 'Khong Dat'
			AND LANTHI = (
				SELECT MAX(LANTHI)
				FROM KETQUATHI
				WHERE MAHV = KETQUATHI.MAHV
				GROUP BY MAHV
				)
		AND MAHV = KETQUATHI.MAHV
		)
GROUP BY HOCVIEN.MAHV, HO + ' ' + TEN
HAVING COUNT(DISTINCT KETQUATHI.MAMH) = (SELECT COUNT(*) FROM MONHOC)

--35. ** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng)
SELECT KETQUATHI.MAHV, HO + ' ' + TEN AS HOTEN, KETQUATHI.MAMH, KETQUATHI.DIEM
FROM KETQUATHI, HOCVIEN, (SELECT MAHV, MAMH, MAX(DIEM) AS MAXDIEM FROM KETQUATHI GROUP BY MAMH) MAXDIEM_MON
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
	AND MAXDIEM_MON.MAMH = KETQUATHI.MAMH
	AND KETQUATHI.DIEM = MAXDIEM_MON.MAXDIEM






