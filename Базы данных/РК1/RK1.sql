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
--Найти все пары вида <дата_нарушения, ФИО водителя>
select F.FineDate, D.FIO
from rk1.Fines F join rk1.Drivers D on F.DriverID = D.DriverID

--Найти все автомабили, водители которых не получили ни одного штрафа
select *
from rk1.cars C
where CarID in (select carid
				from rk1.DriversCars DC
				where not exists (select *
								  from rk1.Fines F
								  where DC.DriverID = F.DriverID))
								  
--Найти год (FineDate?), в котором было выписано наибольшее количество штрафов
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