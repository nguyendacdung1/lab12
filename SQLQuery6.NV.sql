create database city_Group
go
use city_Group
go
create table NV
(
     IDNv int primary key,
	 NameNv nvarchar(100),
	 Tel char(13),
	 Email varchar(30),
)
go
create table Project
(
      IDProject int primary key,
	  ProjectName nvarchar(50),
	  StartDate datetime,
	  EndDate datetime,
	  Period int,
	  Cost money 
)
go
create table Groups
(
      IDGroup int primary key,
	  GroupName nvarchar(100),
	  LeaderID int foreign key references NV(IDNv),
	  IDProject int foreign key references Project(IDProject)
)
go
create table GroupDetail
( 
       IDGroup int foreign key references Groups(IDGroup),
	   IDNv int foreign key references NV(IDNv),
	   Status char(20)
)
go
insert into NV values(1,N'Nguyễn Đắc Dũng', '0585009531', 'nguyendungmk9@gmail.com'),
                     (2,N'Đỗ Thu Trang', '0964120026', 'trangsuns3006@gmail.com'),
					 (3,N'Nguyễn Đức Mạnh','0213894203','mah0110@gmail.com'),
					 (4,N'Lê Hải Thịnh','0524623563','thinhtrang0210@gmail.com'),
					 (5,N'Lê Hải Tú','0524623564','tutrang0210@gmail.com'),
					 (6,N'Đức Hiểu','0354623562','hieuhien0304@gmail.com')
go
insert into Project values(001, N'CHơi','2022-01-13','2022-03-24',0,'100000'),
                          (002,N'Thực Hành','2022-01-13','2022-03-24',0,'110000'),
						  (003,N'Home','2022-01-13','2022-03-24',0,'1000000000'),
                          (004, N'Game','2022-01-13','2022-03-24',0,'10000')
go
insert into Groups values(3006,N'Home',1,003),
                         (01,N'LOL',4,004),
						 (02,N'Học',6,002),
						 (03,N'come',2,001)
go
insert into GroupDetail values(3006,1,'Đang làm'),
                              (3006,2,'Đang làm'),
							  (01,4,'Đã làm'),
							  (01,1,'Đã làm'),
							  (01,6,'Đã làm'),
							  (02,3,'Sắp làm'),
							  (02,5,'Sắp làm'),
							  (03,2,'Sắp làm'),
							  (03,1,'Sắp làm'),
							  (03,4,'Sắp làm'),
							  (03,6,'Sắp làm')
go
select*from Groups
select*from Project
select*from NV
select*from GroupDetail
--Hiển thị thông tin của tất cả nhân viên
select*from NV
--Liệt kê danh sách nhân viên đang làm dự án “HOME”
select NameNv from NV
where IDNv in (
               select IDnv from GroupDetail
			   where IDGroup=3006)
go
--Thống kê số lượng nhân viên đang làm việc tại mỗi nhóm
select COUNT(*) from GroupDetail
--Liệt kê thông tin cá nhân của các trưởng nhóm
select*from NV
where IDNv in(select LeaderID from Groups)
go
--Liệt kê thông tin về nhóm và nhân viên đang làm các dự án có ngày bắt đầu làm trước ngày 2022-01-14
select*from Project
where StartDate < '2022-01-14'
--Liệt kê tất cả thông tin về nhân viên, nhóm làm việc, dự án của những dự án đã hoàn thành
select*from GroupDetail
where Status='Đã làm'
--dự án sắp thực hiện
select*from GroupDetail
where Status='Sắp làm'
--Giảm Giá Đi 5
create procedure ProCost
as
  update Project
  set Cost=Cost-5
go
exec ProCost
select Cost from Project

--Tạo chỉ mục duy nhất tên là IX_Group trên 2 trường GroupID và EmployeeID của bảng GroupDetail
create unique index IX_Group  on GroupDetail(IDGroup,IDNv);
--Tạo chỉ mục tên là IX_Project trên trường ProjectName của bảng Project gồm các trường StartDate và EndDate
create index IX_Project on Project(ProjectName,StartDate,EndDate)
go
--Tạo các khung nhìn để
--Liệt kê thông tin về nhân viên, nhóm làm việc có dự án đang thực hiện
create view View_NhanVien1 AS
select NV.IDNv,NV.NameNv,NV.Tel,NV.Email, GroupDetail.Status from NV
join GroupDetail
on NV.IDNv=GroupDetail.IDNv
where Status='Đã làm'
select*from View_NhanVien1
--Tạo khung nhìn chứa các dữ liệu sau: tên Nhân viên, tên Nhóm, tên Dự án và trạng thái làm việc của Nhân viên.
create view Nhan_vien1 AS
select NV.NameNv,Project.ProjectName,Groups.GroupName,GroupDetail.Status
from Groups
join GroupDetail
on Groups.IDGroup=GroupDetail.IDGroup
join Project
on Groups.IDProject=Project.IDProject
join NV
on GroupDetail.IDNv=NV.IDNv
select*from Nhan_vien1



      
