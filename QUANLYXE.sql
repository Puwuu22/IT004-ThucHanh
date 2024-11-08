﻿--1. Tạo các ràng buộc khóa chính, khóa ngoại tương ứng
CREATE TABLE NHANVIEN(
	MANV CHAR(5) CONSTRAINT NV_MANV_PK PRIMARY KEY NOT NULL,
	HOTEN VARCHAR(20),
	NGAYVL SMALLDATETIME,
	HSLUONG NUMERIC(4,2),
	MAPHONG CHAR(5)
)

CREATE TABLE PHONGBAN(
	MAPHONG CHAR(5) CONSTRAINT PB_MAPHG_PK PRIMARY KEY NOT NULL,
	TENPHONG VARCHAR(25),
	TRUONGPHONG CHAR(5)
)

CREATE TABLE XE(
	MAXE CHAR(5) CONSTRAINT XE_MAXE_PK PRIMARY KEY NOT NULL,
	LOAIXE VARCHAR(20),
	SOCHONGOI INT,
	NAMSX INT
)

CREATE TABLE PHANCONG(
	MAPC CHAR(5) CONSTRAINT PC_MAPC_PK PRIMARY KEY NOT NULL,
	MANV CHAR(5),
	MAXE CHAR(5),
	NGAYDI SMALLDATETIME,
	NGAYDEN SMALLDATETIME,
	NOIDEN VARCHAR(25)
)

--Tạo khóa ngoại
ALTER TABLE PHONGBAN
ADD CONSTRAINT PB_TRGPHG_FK FOREIGN KEY(TRUONGPHONG) REFERENCES NHANVIEN(MANV)

ALTER TABLE NHANVIEN
ADD CONSTRAINT NV_MAPHG_FK FOREIGN KEY(MAPHONG) REFERENCES PHONGBAN(MAPHONG)

ALTER TABLE PHANCONG
ADD CONSTRAINT PC_MANV_FK FOREIGN KEY(MANV) REFERENCES NHANVIEN(MANV)

ALTER TABLE PHANCONG
ADD CONSTRAINT PC_MAXE_FK FOREIGN KEY(MAXE) REFERENCES XE(MAXE)

--Nhập dữ liệu cho các quan hệ trên
SET DATEFORMAT DMY

--Nhập dữ liệu cho bảng NHANVIEN
INSERT INTO NHANVIEN (MANV, HOTEN, NGAYVL, HSLUONG, MAPHONG) VALUES (
INSERT INTO NHANVIEN (MANV, HOTEN, NGAYVL, HSLUONG, MAPHONG)
INSERT INTO NHANVIEN (MANV, HOTEN, NGAYVL, HSLUONG, MAPHONG)
INSERT INTO NHANVIEN (MANV, HOTEN, NGAYVL, HSLUONG, MAPHONG)
INSERT INTO NHANVIEN (MANV, HOTEN, NGAYVL, HSLUONG, MAPHONG)

--Nhập dữ liệu cho bảng PHONGBAN
--Nhập dữ liệu cho bảng XE
--Nhập dữ liệu cho bảng PHANCONG

-- Insert data into NHANVIEN
INSERT INTO NHANVIEN (MANV, HOTEN, NGAYVL, HSLUONG, MAPHONG) 
VALUES ('NV01', 'Nguyen Van A', '01-01-2020', 1.0, 'PB01'),
       ('NV02', 'Tran Thi B', '15-02-2020', 1.2, 'PB02'),
       ('NV03', 'Le Van C', '20-03-2020', 1.1, 'PB01'),
       ('NV04', 'Pham Thi D', '25-04-2020', 1.3, 'PB02'),
       ('NV05', 'Hoang Van E', '30-05-2020', 1.2, 'PB01');

-- Insert data into PHONGBAN
INSERT INTO PHONGBAN (MAPHONG, TENPHONG, TRUONGPHONG)
VALUES ('PB01', 'Phong Ke Toan', 'NV01'),
       ('PB02', 'Phong Kinh Doanh', 'NV02');

-- Insert data into XE
INSERT INTO XE (MAXE, LOAIXE, SOCHONGOI, NAMSX)
VALUES ('XE01', 'Toyota', 4, 2018),
       ('XE02', 'Honda', 5, 2019),
       ('XE03', 'Ford', 7, 2020),
       ('XE04', 'Hyundai', 5, 2021),
       ('XE05', 'Kia', 4, 2022);

-- Insert data into PHANCONG
INSERT INTO PHANCONG (MAPC, MANV, MAXE, NGAYDI, NGAYDEN, NOIDEN)
VALUES ('PC01', 'NV01', 'XE01', '01-06-2020', '05-06-2020', 'Da Nang'),
       ('PC02', 'NV02', 'XE02', '10-06-2020', '15-06-2020', 'Ha Noi'),
       ('PC03', 'NV03', 'XE03', '20-06-2020', '25-06-2020', 'Can Tho'),
       ('PC04', 'NV04', 'XE04', '01-07-2020', '05-07-2020', 'Da Lat'),
       ('PC05', 'NV05', 'XE05', '10-07-2020', '15-07-2020', 'Vung Tau');
