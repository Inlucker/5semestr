--CREATION
create schema rk1

drop table rk1.Cars cascade;
drop table rk1.Drivers cascade;
drop table rk1.DriversCars cascade;
drop table rk1.Fines cascade;

create table if not exists rk1.Cars
(
	CarID serial primary key,
	Model text,
	Color text,
	Year int,
	RegistrationDate date
);

create table if not exists rk1.Drivers
(
	DriverID serial primary key,
	DriveLicense text,
	FIO text,
	Phone text
);

create table if not exists rk1.DriversCars
(
	DriverID int,
	CarID int,
	FOREIGN KEY (DriverID) REFERENCES rk1.Drivers (DriverID),
	FOREIGN KEY (CarID) REFERENCES rk1.Cars (CarID)
);


create table if not exists rk1.Fines
(
	FineID serial primary key,
	DriverID int,
	FineType text,
	Amount float,
	FineDate date,
	FOREIGN KEY (DriverID) REFERENCES rk1.Drivers (DriverID)
);

--COPY
copy rk1.Cars(Model, Color, Year, RegistrationDate) from '/Cars.csv' delimiter '|' csv;
copy rk1.Drivers(DriveLicense, FIO, Phone) from '/Drivers.csv' delimiter '|' csv;
copy rk1.DriversCars(DriverID, CarID) from '/DriversCars.csv' delimiter '|' csv;
copy rk1.Fines(DriverID, FineType, Amount, FineDate) from '/Fines.csv' delimiter '|' csv;

delete from rk1.Fines;
delete from rk1.DriversCars;
delete from rk1.Cars;
delete from rk1.Drivers;

--SELECTS
--Билет 6
--1)Найти все пары вида <дата_нарушения, ФИО водителя>
select F.FineDate, D.FIO
from rk1.Fines F join rk1.Drivers D on F.DriverID = D.DriverID

--2)Найти все автомабили, водители которых не получили ни одного штрафа
select *
from rk1.cars C
where CarID in (select carid
				from rk1.DriversCars DC
				where not exists (select *
								  from rk1.Fines F
								  where DC.DriverID = F.DriverID))

--Илья
select distinct CarID 
from rk1.DriversCars DC
where not exists (select *
				  from rk1.Fines F
				  where DC.DriverID = F.DriverID)
				  
select DriverID
from rk1.fines
group by DriverID
--3)Найти год (FineDate?), в котором было выписано наибольшее количество штрафов
--Моё вариант 1
with datesCnts (FineDate, cnt) as
(
	select FineDate, count(FineID) as cnt
	from rk1.Fines
	group by FineDate
)
select FineDate
from datesCnts
where cnt = (select max(cnt)
			 from datesCnts)

--Чужой вариант
with groupF (FineDate, cnt) as
(
    select FineDate, count(*) as cnt
	from rk1.Fines F
	group by FineDate
)
select FineDate
from groupF
where cnt = (select max(cnt)
             from groupF)
             
--Билет 1      
--1)Найти все пары вида <ФИО водителя, модель автомобиля>
select DDC.FIO, C.Model
from (rk1.Drivers D join rk1.DriversCars DC on D.DriverID = DC.DriverID) as DDC join rk1.Cars C on DDC.CarId = C.CarID

--2)Найти все штрафы водителей, автомобили которых были зарегестрированы в 2020 году
select *
from rk1.Fines F
where F.DriverID in (select DriverID
					 from rk1.DriversCars DC join rk1.Cars C on DC.CarID = C.CarID
					 where C.Year = 2021)


--3)Вычислить общую сумму штрафов водителей в 2019 году
select sum(amount)
from rk1.Fines
where (select Extract(YEAR from FineDate)) = '2021'

--Билет 8
--1) Найти все тройки вида 

--2) Найти водителей, владеющих хотя бы одной машиной красного цвета
select *
from rk1.Drivers D
where DriverID in (select DC.DriverID
				   from rk1.DriversCars DC
				   where CarID in (select CarID
								   from rk1.Cars C))
								   
select DC.DriverID
from rk1.DriversCars DC join rk1.Drivers D on D.DriverID=DC.DriverID

--3) Найти машины, которыми владеют более 2ух водителей
--Мой вариант
with DriversCount (CarID, cnt) as
(
	select CarID, count(DriverID) as cnt
	from rk1.DriversCars DC
	group by CarID
)
select CarID
from DriversCount
where cnt > 2

--Чужой вариант
select CarID
from rk1.DriversCars DC
group by CarID
having count(*) >2