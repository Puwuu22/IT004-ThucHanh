﻿--I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language):

--1. Tạo các quan hệ và khai báo các khóa chính, khóa ngoại của quan hệ.
CREATE TABLE KHACHHANG(
	MAKH CHAR(4) CONSTRAINT KH_MAKH_PK PRIMARY KEY NOT NULL,
	HOTEN VARCHAR(40) CONSTRAINT KH_HOTEN_NN NOT NULL,
	DCHI VARCHAR(50),
	SODT VARCHAR(20) NOT NULL,
	NGSINH SMALLDATETIME CONSTRAINT KH_NGSINH_CHECK CHECK(NGSINH > '01-01-1900'), 
	DOANHSO MONEY CONSTRAINT KH_DOANHSO_DF DEFAULT(10000),
	NGDK SMALLDATETIME
)

CREATE TABLE NHANVIEN(
	MANV CHAR(4) CONSTRAINT NV_MANV_PK PRIMARY KEY NOT NULL,
	HOTEN VARCHAR(40) CONSTRAINT NV_HOTEN_NN NOT NULL,
	SODT VARCHAR(20) NOT NULL,
	NGVL SMALLDATETIME
)

CREATE TABLE SANPHAM(
	MASP CHAR(4) CONSTRAINT SP_MASP_PK PRIMARY KEY NOT NULL,
	TENSP VARCHAR(40) CONSTRAINT SP_TENSP_NN NOT NULL,
	DVT VARCHAR(20),
	NUOCSX VARCHAR(40),
	GIA MONEY
)

CREATE TABLE HOADON(
	SOHD INT CONSTRAINT HD_SOHD_PK PRIMARY KEY,
	NGHD SMALLDATETIME,
	MAKH CHAR(4)CONSTRAINT HD_MAKH_FK FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH),
	MANV CHAR(4)CONSTRAINT HD_MANV_FK FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV),
	TRIGIA MONEY
)

CREATE TABLE CTHD(
	SOHD INT,
	MASP CHAR(4),
	CONSTRAINT CTHD_SOHD_MASP_PK PRIMARY KEY(SOHD, MASP),
	CONSTRAINT CTHD_MASP_FK FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP),
	SL INT
)

--2. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM
ALTER TABLE SANPHAM
ADD GHICHU VARCHAR(20)

--3. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
ALTER TABLE KHACHHANG
ADD LOAIKH TINYINT

--4. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
ALTER TABLE SANPHAM
ALTER COLUMN GHICHU VARCHAR(100)

--5. Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
ALTER TABLE SANPHAM
DROP COLUMN GHICHU

--6. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, …
ALTER TABLE KHACHHANG
ALTER COLUMN LOAIKH VARCHAR(20)

--7. Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
ALTER TABLE SANPHAM
ADD CONSTRAINT SP_KT_CHECK CHECK(DVT IN('cay', 'quyen', 'cai', 'hop', 'chuc'))

--8. Giá bán của sản phẩm từ 500 đồng trở lên.
ALTER TABLE SANPHAM
ADD CONSTRAINT SP_GIA_CHECK CHECK(GIA > 500)

--9. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
ALTER TABLE CTHD
ADD CONSTRAINT CTHD_SL_CHECK CHECK(SL > 1 OR SL = 1)

--10. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.
ALTER TABLE KHACHHANG
ADD CONSTRAINT KH_NGAY_CHECK CHECK(NGDK > NGSINH)

--11. Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK).
CREATE TRIGGER TRG_INS_HD ON HOADON
FOR INSERT
AS
BEGIN
	DECLARE @NGHD SMALLDATETIME, @MAKH CHAR(4), @NGDK SMALLDATETIME
	
	SELECT @NGHD = NGHD, @MAKH = MAKH
	FROM INSERTED

	SELECT @NGDK = NGDK
	FROM KHACHHANG
	WHERE MAKH = @MAKH

	--SO SANH
	IF(@NGHD < @NGDK) 
	BEGIN
		PRINT 'LOI: NGAY HOA DON KHONG HOP LE'
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		PRINT 'THEM MOI MOT HOA DON THANH CONG'
	END
END

--12. Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm.
CREATE TRIGGER TRG_CHECK_NGNV ON HOADON
FOR INSERT, UPDATE
AS 
BEGIN
	DECLARE @NGHD SMALLDATETIME, @NGVL SMALLDATETIME, @MANV CHAR(4)
	
	SELECT @NGHD = NGHD, @MANV = MANV
	FROM INSERTED

	SELECT @NGVL = NGVL
	FROM NHANVIEN
	WHERE @MANV = MANV

	IF(@NGHD < @NGVL)
	BEGIN 
		PRINT 'LOI: NGAY HOA DON KHONG HOP LE'
		ROLLBACK TRANSACTION
	END

	ELSE
	BEGIN
		PRINT 'THEM/CAP NHAT HOA DON THANH CONG'
	END
END
		
--13. Mỗi một hóa đơn phải có ít nhất một chi tiết hóa đơn.
CREATE TRIGGER TRG_CHECK_HD_CTHD ON HOADON
FOR INSERT
AS
BEGIN
	DECLARE @SOHD INT

	SELECT @SOHD = SOHD
	FROM INSERTED

	IF NOT EXISTS (SELECT 1 FROM CTHD WHERE SOHD = @SOHD)
	BEGIN
		PRINT 'LOI: MOI HOA DON PHAI CO IT NHAT MOT CHI TIET HOA DON'
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		PRINT 'HOA DON CO IT NHAT MOT CHI TIET HOA DON'
	END
END
 
--14. Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.
CREATE TRIGGER TRG_UPDATE_TRIGIA ON CTHD
FOR INSERT
AS
BEGIN
	DECLARE @SOHD INT, @MASP CHAR(4), @SOLUONG INT, @TRIGIA MONEY
	--Lấy thông tin của CTHD vừa mới được thêm vào
	SELECT @SOHD = SOHD, @MASP = MASP, @SOLUONG = SL
	FROM INSERTED
	--Tính trị giá của sản phẩm mới được thêm vào HOADON
	SET @TRIGIA = @SOLUONG * (SELECT GIA FROM SANPHAM WHERE MASP = @MASP)
	--Khai báo một cursor duyệt qua tất cả các CTHD đã có sẵn trong HOADON
	DECLARE CUR_CTHD CURSOR
	FOR 
		SELECT MASP, SL
		FROM CTHD
		WHERE SOHD = @SOHD

	OPEN CUR_CTHD
	FETCH NEXT FROM CUR_CTHD INTO @MASP, @SOLUONG

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		--Cộng dồn trị giá của từng sản phẩm vào biến TRIGIA
		SET @TRIGIA = @TRIGIA + @SOLUONG * (SELECT GIA FROM SANPHAM WHERE MASP = @MASP)
		FETCH NEXT FROM CUR_CTHD
		INTO @MASP, @SOLUONG
	END

	CLOSE CUR_CTHD
	DEALLOCATE CUR_CTHD
	--Tiến hành cập nhật lại trị giá hóa đơn
	UPDATE HOADON SET TRIGIA = @TRIGIA WHERE SOHD = @SOHD
END

--15. Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó đã mua.
--(Cập nhật lại DOANHSO khi có một hóa đơn mới được thêm vào)
CREATE TRIGGER TRG_UPDATE_DOANHSO ON HOADON
FOR INSERT
AS 
BEGIN
	DECLARE @MAKH CHAR(4), @SOHD INT, @TRIGIA MONEY, @DOANHSO MONEY

	--Lấy thông tin của HOADON mới được thêm vào
	SELECT @SOHD = SOHD, @TRIGIA =TRIGIA, @MAKH = MAKH
	FROM INSERTED
	
	SET @DOANHSO = 0
	--Khai báo một cursor để duyệt qua tất cả các TRIGIA hóa đơn của KHACHHANG
	DECLARE CUR_HD CURSOR
	FOR
		SELECT TRIGIA
		FROM HOADON
		WHERE MAKH = @MAKH

	OPEN CUR_HD
	FETCH NEXT FROM  CUR_HD
	INTO @TRIGIA

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		--Cộng dồn trị giá của các hóa đơn vào doanh số
		SET @DOANHSO = @DOANHSO + @TRIGIA
		FETCH NEXT FROM CUR_HD
		INTO @TRIGIA
	END

	CLOSE CUR_HD
	DEALLOCATE CUR_HD

	UPDATE KHACHHANG SET DOANHSO = @DOANHSO WHERE MAKH = @MAKH
END

--II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):

--1. Nhập dữ liệu cho các quan hệ trên.
SET DATEFORMAT DMY 

--Nhập dữ liệu cho NHANVIEN
INSERT INTO NHANVIEN(MANV,HOTEN,SODT,NGVL) VALUES ('NV01','NGUYEN NHU NHUT','0927345678','13/04/2006')
INSERT INTO NHANVIEN(MANV,HOTEN,SODT,NGVL) VALUES ('NV02','LE THI PHI YEN','0987567390','21/04/2006')
INSERT INTO NHANVIEN(MANV,HOTEN,SODT,NGVL) VALUES ('NV03','NGUYEN VAN B','0997047382','27/04/2006')
INSERT INTO NHANVIEN(MANV,HOTEN,SODT,NGVL) VALUES ('NV04','NGO THANH TUAN','0913758498','24/06/2006')
INSERT INTO NHANVIEN(MANV,HOTEN,SODT,NGVL) VALUES ('NV05','NGUYEN THI TRUC THANH','0918590387','20/07/2006')

--Nhập dữ liệu cho KHACHHANG
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH01','NGUYEN VAN A','731TRAN HUNG DAO,Q5,THHCM','08823451','22/10/1960','22/07/2006',13060000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH02','TRAN NGOC HAN','23/5NGUYEN TRAI,Q5,TPHCM','0908256478','03/04/1974','30/07/2006',280000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH03','TRAN NGOC LINH','45NGUYEN CANH CHAN,Q1,TPHCM','0938776266','10/06/1980','05/05/2006',3860000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH04','TRAN MINH LONG','50/34LE DAI HANH,Q10,TPHCM','0917325476','09/03/1965','02/10/2006',250000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH05','LE NHAT MINH','34TRUONG DINH,Q3,TPHCM','08246108','10/03/1950','28/10/2006',21000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH06','LE HOAI THUONG','227NGUYEN VAN CU,Q5,TPHCM','08631738','31/12/1981','24/11/2006',915000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH07','NGUYEN VAN TAM','32/3 TRAN BINH TRONG,Q5,TPHCM','0916783565','06/06/1971','01/12/2006',12500)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH08','PHAN THI THANH','45/2 AN DUONG VUONG,Q5,TPHCM','0938435756','10/01/1971','13/12/2006',365000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH09','LE HA VINH','837 LE HONG PHONG,Q5,TPHCM','08654763','03/03/1979','14/01/2007',70000)
INSERT INTO KHACHHANG(MAKH,HOTEN,DCHI,SODT,NGSINH,NGDK,DOANHSO) VALUES ('KH10','HA DUY LAP','34/34B NGUYEN TRAI,Q5,TPHCM','08768904','02/05/1983','16/01/2007',67500)

--Nhập dữ liệu cho SANPHAM
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BC01','BUT CHI','CAY','SINGAPORE',3000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BC02','BUT CHI','CAY','SINGAPORE',5000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BC03','BUT CHI','CAY','VIETNAM',3500)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BC04','BUT CHI','HOP','VIETNAM',30000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BB01','BUT BI','CAY','VIETNAM',5000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BB02','BUT BI','CAY','TRUNGQUOC',7000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('BB03','BUT BI','HOP','THAILAN',100000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV01','TAP 100 TRANG GIAY MONG','QUYEN','TRUNGQUOC',2500)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV02','TAP 200 TRANG GIAY MONG','QUYEN','TRUNGQUOC',4500)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV03','TAP 100 TRANG GIAY TOT','QUYEN','VIETNAM',3000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV04','TAP 200 TRANG GIAY TOT','QUYEN','VIETNAM',5500)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV05','TAP 100 TRANG ','CHUC','VIETNAM',23000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV06','TAP 200 TRANG ','CHUC','VIETNAM',53000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('TV07','TAP 100 TRANG ','CHUC','TRUNGQUOC',34000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST01','SO TAY 500 TRANG','QUYEN','TRUNGQUOC',40000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST02','SO TAY LOAI 1','QUYEN','VIETNAM',55000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST03','SO TAY LOAI 2','QUYEN','VIETNAM',51000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST04','SO TAY','QUYEN','THAILAN',55000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST05','SO TAY MONG','QUYEN','THAILAN',20000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST06','PHAN VIET BANG','HOP','VIETNAM',5000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST07','PHAN KHONG BUI','HOP','VIETNAM',7000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST08','BONG BAMG','CAI','VIETNAM',1000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST09','BUT LONG','CAY','VIETNAM',5000)
INSERT INTO SANPHAM(MASP,TENSP,DVT,NUOCSX,GIA) VALUES ('ST10','BUT LONG','CAY','TRUNGQUOC',7000)

--Nhập dữ liệu cho HOADON
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1001,'27/07/2006','KH01','NV01',320000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1002,'10/08/2006','KH01','NV02',840000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1003,'23/08/2006','KH02','NV01',100000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1004,'01/09/2006','KH02','NV01',180000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1005,'20/10/2006','KH01','NV02',3800000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1006,'16/10/2006','KH01','NV03',2430000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1007,'28/10/2006','KH03','NV03',510000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1008,'28/10/2006','KH01','NV03',440000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1009,'28/10/2006','KH03','NV04',200000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1010,'01/11/2006','KH01','NV01',5200000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1011,'04/11/2006','KH04','NV03',250000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1012,'30/11/2006','KH05','NV03',21000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1013,'12/12/2006','KH06','NV01',5000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1014,'31/12/2006','KH03','NV02',3150000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1015,'01/01/2007','KH06','NV01',910000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1016,'01/01/2007','KH07','NV02',12500)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1017,'02/01/2007','KH08','NV03',35000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1018,'13/01/2007','KH08','NV03',330000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1019,'13/01/2007','KH01','NV03',30000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1020,'14/01/2007','KH09','NV04',70000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1021,'16/01/2007','KH10','NV03',67500)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1022,'16/01/2007',NULL,'NV03',7000)
INSERT INTO HOADON(SOHD,NGHD,MAKH,MANV,TRIGIA) VALUES (1023,'17/01/2007',NULL,'NV01',330000)

--Nhập dữ liệu cho CTHD
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1001,'TV02',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1001,'ST01',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1001,'BC01',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1001,'BC02',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1001,'ST08',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1002,'BC04',20)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1002,'BB01',20)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1002,'BB02',20)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1003,'BB03',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1004,'TV01',20)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1004,'TV02',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1004,'TV03',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1004,'TV04',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1005,'TV05',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1005,'TV06',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1006,'TV07',20)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1006,'ST01',30)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1006,'ST02',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1007,'ST03',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1008,'ST04',8)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1009,'ST05',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1010,'TV07',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1010,'ST07',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1010,'ST08',100)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1010,'ST04',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1010,'TV03',100)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1011,'ST06',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1012,'ST07',3)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1013,'ST08',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1014,'BC02',80)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1014,'BB02',100)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1014,'BC04',60)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1014,'BB01',50)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1015,'BB02',30)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1015,'BB03',7)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1016,'TV01',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1017,'TV02',1)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1017,'TV03',1)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1017,'TV04',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1018,'ST04',6)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1019,'ST05',1)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1019,'ST06',2)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1020,'ST07',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1021,'ST08',5)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1021,'TV01',7)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1021,'TV02',10)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1022,'ST07',1)
INSERT INTO CTHD(SOHD,MASP,SL) VALUES (1023,'ST04',6)

--2. Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. 
SELECT *
INTO SANPHAM1
FROM SANPHAM

--Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.*/
SELECT*
INTO KHACHHANG1
FROM KHACHHANG

--3. Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
UPDATE SANPHAM1
SET GIA = GIA* 1.05
WHERE NUOCSX = 'THAILAN'

--4. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
UPDATE SANPHAM1
SET GIA = GIA *1.05
WHERE NUOCSX = 'TRUNGQUOC' AND GIA <= 10000

/*5. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có doanh số từ 10.000.000 trở lên 
hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1)*/
UPDATE KHACHHANG1
SET LOAIKH = 'Vip'
WHERE (NGDK < '1/1/2007' AND DOANHSO >= 10000000) OR (NGDK > '1/1/2007' AND DOANHSO >= 2000000)

--

--III. Ngôn ngữ truy vấn dữ liệu:

--1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT MASP, TENSP
FROM SANPHAM1
WHERE NUOCSX ='TRUNGQUOC'

--2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
SELECT MASP, TENSP
FROM SANPHAM1
WHERE DVT IN('CAY', 'QUYEN')

--3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
SELECT MASP, TENSP
FROM SANPHAM1
WHERE MASP LIKE 'B%01'

--4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP
FROM SANPHAM1
WHERE NUOCSX = 'TRUNGQUOC' AND GIA BETWEEN 30000 AND 40000

--5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP
FROM SANPHAM1
WHERE (NUOCSX = 'TRUNGQUOC' OR NUOCSX = 'THAILAN') AND GIA BETWEEN 30000 AND 40000

--6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
SELECT SOHD, TRIGIA
FROM HOADON
WHERE NGHD IN('1/1/2007', '2/1/2007')

--7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
SELECT SOHD, TRIGIA
FROM HOADON
WHERE MONTH(NGHD) = 1 AND YEAR(NGHD) = 2007
ORDER BY NGHD ASC, TRIGIA DESC

--8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
SELECT KHACHHANG.MAKH, HOTEN
FROM KHACHHANG, HOADON
WHERE HOADON.MAKH = KHACHHANG.MAKH AND NGHD = '1/1/2007'

--9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
SELECT SOHD, TRIGIA
FROM HOADON HD, NHANVIEN NV
WHERE NV.MANV = HD.MANV 
	AND NV.HOTEN='NGUYEN VAN B'
	AND HD.NGHD = '28/10/2006'

--10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
SELECT SP.MASP, SP.TENSP
FROM HOADON HD, SANPHAM SP, KHACHHANG KH, CTHD
WHERE KH.MAKH = HD.MAKH
	AND CTHD.MASP = SP.MASP
	AND CTHD.SOHD = HD.SOHD
	AND KH.HOTEN = 'NGUYEN VAN A' 
	AND MONTH(HD.NGHD) = '10'
	AND YEAR(HD.NGHD) = '2006'

--11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
SELECT SOHD
FROM CTHD
WHERE MASP IN ('BB01', 'BB02')

--12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT DISTINCT SOHD
FROM CTHD
WHERE MASP IN('BB01', 'BB02')
	AND SL BETWEEN 10 AND 20

--13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB01'
	AND SL BETWEEN 10 AND 20
INTERSECT 
SELECT SOHD
FROM CTHD
WHERE MASP = 'BB02'
	AND SL BETWEEN 10 AND 20

--14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
SELECT DISTINCT SANPHAM.MASP, SANPHAM.TENSP
FROM SANPHAM, HOADON, CTHD
WHERE SANPHAM.MASP = CTHD.MASP
	AND HOADON.SOHD = CTHD.SOHD
	AND (SANPHAM.NUOCSX = 'TRUNGQUOC' OR HOADON.NGHD = '1/1/2007')

SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'TRUNGQUOC'
UNION 
SELECT SANPHAM.MASP, TENSP
FROM SANPHAM, CTHD, HOADON
WHERE SANPHAM.MASP = CTHD.MASP
	AND CTHD.SOHD = HOADON.SOHD
	AND HOADON.NGHD = '1/1/2007'
--15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
SELECT MASP, TENSP
FROM SANPHAM
EXCEPT
SELECT SANPHAM.MASP, SANPHAM.TENSP
FROM SANPHAM, CTHD
WHERE SANPHAM.MASP = CTHD.MASP


SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN (
    SELECT MASP
    FROM CTHD
)


--16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN (
    SELECT CTHD.MASP
    FROM CTHD, HOADON
    WHERE CTHD.SOHD = HOADON.SOHD
        AND YEAR(HOADON.NGHD) = 2006
)

--17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'TRUNGQUOC'
EXCEPT
SELECT SANPHAM.MASP, TENSP
FROM SANPHAM, HOADON,CTHD
WHERE YEAR(HOADON.NGHD) = 2006
	AND SANPHAM.MASP = CTHD.MASP
	AND HOADON.SOHD = CTHD.SOHD
	AND NUOCSX = 'TRUNGQUOC'

SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'TRUNGQUOC'
	AND MASP NOT IN(
		SELECT DISTINCT MASP
		FROM HOADON, CTHD
		WHERE SANPHAM.MASP = CTHD.MASP
			AND CTHD.SOHD = HOADON.SOHD
			AND YEAR(HOADON.NGHD) = '2006'
			AND SANPHAM.NUOCSX = 'TRUNGQUOC'
	)

--20. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(*) AS SOLUONG_KHONGTHANHVIEN
FROM HOADON
WHERE MAKH IS NULL

--21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT DISTINCT COUNT(*) AS SOLUONG_SP_KHACNHAU
FROM HOADON, CTHD
WHERE YEAR(HOADON.NGHD) = '2006'
	AND HOADON.SOHD = CTHD.SOHD

--22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MIN(TRIGIA) AS HOADON_THAPNHAT, MAX(TRIGIA) AS HOADON_CAONHAT
FROM HOADON

--23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) AS TRIGIA_TRUNGBINH
FROM HOADON
WHERE YEAR(NGHD) = '2006'

--24. Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = '2006'

--25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT SOHD
FROM HOADON
WHERE TRIGIA = (
	SELECT MAX(TRIGIA)
	FROM HOADON
	WHERE YEAR(NGHD) = '2006'
	)

--26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT HOTEN
FROM KHACHHANG, HOADON
WHERE KHACHHANG.MAKH = HOADON.MAKH
	AND YEAR(NGHD) = '2006'
	AND TRIGIA = (
		SELECT MAX(TRIGIA)
		FROM HOADON
		WHERE YEAR(NGHD) = '2006'
	)

--27. In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần.
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC

--28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (
	SELECT DISTINCT TOP 3 GIA
	FROM SANPHAM
	ORDER BY GIA DESC
)

--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'THAILAN'
	AND GIA IN (
	SELECT DISTINCT TOP 3 GIA
	FROM SANPHAM
	ORDER BY GIA DESC
)

--30. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX ='TRUNGQUOC'
	AND GIA IN (
	SELECT DISTINCT TOP 3 GIA
	FROM SANPHAM
	WHERE NUOCSX = 'TRUNGQUOC'
	ORDER BY GIA DESC
)

--32. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(*) AS SOLUONG_SP_TRUNGQUOC
FROM SANPHAM
WHERE NUOCSX = 'TRUNGQUOC'

--33. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NUOCSX, COUNT(*) AS SOLUONG_SANPHAM
FROM SANPHAM
GROUP BY NUOCSX

--34. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA) AS GIABAN_CAONHAT, MIN(GIA) AS GIABAN_THAPNHAT, AVG(GIA) AS GIA_TRUNGBINH
FROM SANPHAM
GROUP BY NUOCSX

--35. Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) AS DOANHTHU
FROM HOADON
GROUP BY NGHD

--36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT MASP, SUM(SL) AS TONGSOLUONG
FROM HOADON, CTHD
WHERE HOADON.SOHD = CTHD.SOHD
	AND MONTH(HOADON.NGHD) = '10'
	AND YEAR(HOADON.NGHD) = '2006'
GROUP BY MASP

--37. Tính doanh thu bán hàng của từng tháng trong năm 2006
SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHTHU
FROM HOADON
WHERE YEAR(NGHD) = '2006'
GROUP BY MONTH(NGHD)

--38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT CTHD.SOHD
FROM HOADON, CTHD
WHERE HOADON.SOHD = CTHD.SOHD
GROUP BY CTHD.SOHD
HAVING COUNT(DISTINCT CTHD.MASP) >= 4

--39. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT CTHD.SOHD
FROM HOADON, CTHD, SANPHAM
WHERE HOADON.SOHD = CTHD.SOHD
	AND SANPHAM.MASP = CTHD.MASP
	AND NUOCSX = 'VIETNAM'
GROUP BY CTHD.SOHD
HAVING COUNT(DISTINCT CTHD.MASP) = 3

--40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất. 
SELECT TOP 1 HOADON.MAKH, HOTEN, COUNT(*) AS SOLANMUA
FROM KHACHHANG, HOADON
WHERE KHACHHANG.MAKH = HOADON.MAKH
GROUP BY HOADON.MAKH, HOTEN
ORDER BY SOLANMUA DESC

--41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT TOP 1 MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHSO
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY DOANHSO DESC

--42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT TOP 1 CTHD.MASP, TENSP, SUM(SL) AS TONGSOLUONG
FROM CTHD, HOADON, SANPHAM
WHERE CTHD.MASP = SANPHAM.MASP
	AND HOADON.SOHD = CTHD.SOHD
	AND YEAR(NGHD) = 2006
GROUP BY CTHD.MASP, TENSP
ORDER BY TONGSOLUONG

--43. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT SP.NUOCSX, SP.MASP, SP.TENSP, GIA AS GIACAONHAT
FROM SANPHAM SP, (SELECT NUOCSX, MAX(GIA) AS GIACAONHAT FROM SANPHAM GROUP BY NUOCSX) NUOCSANXUAT
WHERE SP.NUOCSX = NUOCSANXUAT.NUOCSX 
	AND SP.GIA = NUOCSANXUAT.GIACAONHAT

--44. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT SANPHAM.NUOCSX
FROM SANPHAM, (SELECT NUOCSX FROM SANPHAM GROUP BY NUOCSX HAVING COUNT(MASP) >= 3) NUOCSX_TREN3SP
WHERE SANPHAM.NUOCSX = NUOCSX_TREN3SP.NUOCSX
GROUP BY SANPHAM.NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3

--45. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
SELECT TOP 1 HOADON.MAKH, KHACHHANG.HOTEN, COUNT(HOADON.SOHD) AS SOLANMUA
FROM KHACHHANG, HOADON, (SELECT TOP 10 MAKH FROM HOADON GROUP BY MAKH ORDER BY SUM(TRIGIA) DESC) TOPDOANHSO
WHERE KHACHHANG.MAKH = HOADON.MAKH
	AND TOPDOANHSO.MAKH = HOADON.MAKH
GROUP BY HOADON.MAKH, KHACHHANG.HOTEN
ORDER BY COUNT(HOADON.MAKH) DESC

--18. Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
SELECT CTHD.SOHD
FROM HOADON, CTHD, SANPHAM
WHERE HOADON.SOHD = CTHD.SOHD
	AND SANPHAM.MASP = CTHD.MASP
	AND NUOCSX = 'SINGAPORE'
GROUP BY CTHD.SOHD
HAVING COUNT(DISTINCT SANPHAM.MASP) = ( 
		SELECT COUNT(*)
		FROM SANPHAM
		WHERE NUOCSX = 'SINGAPORE'
	)
