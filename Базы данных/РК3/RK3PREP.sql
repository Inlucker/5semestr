drop table times cascade;
drop table employees cascade;

--Задание 1
--Создание
create database rk3;

create table if not exists employees
(
	id serial primary key,
	FIO text,
	birth_date date,
	department text
);

create table if not exists times
(
	employee_id int,
	foreign key (employee_id) references employees (id),
	date date,
	week_day text,
	tm time,
	tp int
);

--МОЁ
INSERT INTO employees (fio, birth_date, department) VALUES
('Иванов Иван Иванович', '1990-09-25', 'ИТ'),
('Петров Петр Петрович', '1987-11-12', 'Бухгалтерия'),
('Пронин Арсений Сергеевич', '2000-05-17', 'Киберспорт');

INSERT INTO times (employee_id, date, week_day, tm, tp) VALUES
(1, '2018-12-14', 'Понедельник', '9:00', 1),
(1, '2018-12-14', 'Понедельник', '9:20', 2),
(1, '2018-12-14', 'Понедельник', '9:25', 1),
(1, '2018-12-14', 'Понедельник', '18:00', 2),
(2, '2018-12-14', 'Понедельник', '9:05', 1),
(2, '2018-12-14', 'Понедельник', '17:00', 2),
(3, '2018-12-14', 'Понедельник', '9:00', 1),
(3, '2018-12-14', 'Понедельник', '17:00', 2),
(1, '2018-12-15', 'Вторник', '9:00', 1),
(1, '2018-12-15', 'Вторник', '18:00', 2),
(2, '2018-12-15', 'Вторник', '9:05', 1),
(2, '2018-12-15', 'Вторник', '18:00', 2),
(3, '2018-12-15', 'Вторник', '9:00', 1),
(3, '2018-12-15', 'Вторник', '17:00', 2),
(1, '2018-12-16', 'Среда', '9:00', 1),
(1, '2018-12-16', 'Среда', '18:00', 2),
(2, '2018-12-16', 'Среда', '9:05', 1),
(2, '2018-12-16', 'Среда', '18:00', 2),
(3, '2018-12-16', 'Среда', '9:00', 1),
(3, '2018-12-16', 'Среда', '17:00', 2),
(1, '2018-12-17', 'Четверг', '9:00', 1),
(1, '2018-12-17', 'Четверг', '15:00', 2),
(2, '2018-12-17', 'Четверг', '9:01', 1),
(2, '2018-12-17', 'Четверг', '15:00', 2),
(3, '2018-12-17', 'Четверг', '9:00', 1),
(3, '2018-12-17', 'Четверг', '15:00', 2);

--НЕ МОЁ
insert into employees
values 
(1, 'Иванов Петр Иванович', '1987-12-11', 'Бухгалтерия'),
(2, 'Рядовов Петр Иванович', '1987-12-11', 'ИТ'),
(3, 'Петров Петр Иванович', '1987-12-11', 'Бухгалтерия2'),
(4, 'Иван Петр Иванович', '1987-12-11', 'Бухгалтерия2');

insert into times 
values 
(1, '2018-12-15', 'Суббота', '09:00', 1),
	(1, '2018-12-15', 'Суббота', '09:20', 2),
	(1, '2018-12-15', 'Суббота', '09:25', 1),
	(2, '2018-12-15', 'Суббота', '09:05', 1),
	(1, '2018-12-16', 'Суббота', '09:00', 1),
	(1, '2018-12-16', 'Суббота', '09:20', 2),
	(1, '2018-12-16', 'Суббота', '09:25', 1),
	(2, '2018-12-16', 'Суббота', '09:05', 1),
	(3, '2018-12-16', 'Суббота', '08:00', 1),
	(1, '2018-12-17', 'Суббота', '09:00', 1),
	(1, '2018-12-17', 'Суббота', '09:20', 2),
	(1, '2018-12-17', 'Суббота', '09:25', 1),
	(2, '2018-12-17', 'Суббота', '09:05', 1),
	(3, '2018-12-17', 'Суббота', '08:00', 1),
	(1, '2018-12-18', 'Суббота', '09:00', 1),
	(1, '2018-12-18', 'Суббота', '09:20', 2),
	(1, '2018-12-18', 'Суббота', '09:25', 1),
	(2, '2018-12-18', 'Суббота', '09:05', 1),
	(3, '2018-12-18', 'Суббота', '08:00', 1),
	(1, '2018-12-19', 'Суббота', '09:00', 1),
	(1, '2018-12-19', 'Суббота', '09:20', 2),
	(1, '2018-12-19', 'Суббота', '09:25', 1),
	(2, '2018-12-19', 'Суббота', '09:05', 1),
	(3, '2018-12-19', 'Суббота', '08:00', 1),
	(1, '2018-12-20', 'Суббота', '09:25', 1),
	(2, '2018-12-20', 'Суббота', '09:05', 1),
	(3, '2018-12-20', 'Суббота', '08:00', 1),
	(1, '2018-12-21', 'Суббота', '09:25', 1),
	(2, '2018-12-21', 'Суббота', '09:05', 1),
	(3, '2018-12-21', 'Суббота', '08:00', 1);

--Функция
create OR REPLACE function getLateEmps(d date)
returns int
as $$
begin
    return (select count(*) from employees e join
   				(select employee_id, min(tm) as mtm
   				from times
   				where date = d
   				group by employee_id) t
   			on (e.id = t.employee_id)
   			where mtm > '9:00');
end;
$$ LANGUAGE 'plpgsql';

drop function  getLateEmps(date);

select getLateEmps('2018-12-14');

select getLateEmps('2018-12-18');

select *
from employees e join
		(select employee_id, min(tm) as mtm
		from times
		where date = '2018-12-14'
		group by employee_id) t
	on (e.id = t.employee_id)
where mtm > '9:00'


--Задание 2
-- Найти отделы, в которых хоть один сотрудник опаздывает больше 3-х раз в неделю.
--МОЁ??
select *
from employees e join
		(select employee_id, min(tm) as mtm
		from times
		where date = '2018-12-14'
		group by employee_id) t
	on (e.id = t.employee_id)
where mtm > '9:00' and 
	
--НЕ МОЁ (Андрея)
select distinct department
from employees
where id in (
	select distinct employee_id
	from (
		select employee_id, count(date) over(partition by week_num, employee_id) cnt
		from (
			select distinct employee_id, date, templ.ant / 7 week_num
			from (
				select
					employee_id,
					date,
					min(tm) over(partition by date, employee_id) as min_time,
					tp,
					(date - (select min(date)
							  from times)) ant
				from times) templ
			where tp = 1 and min_time > '9:00') namee) nam
	where cnt > 3);

-- Найти средний возраст сотрудников, не находящихся на рабочем месте 8 часов в день.
-- employee_id и их время работы за день (у которых < 8 рабочих часов)
select * from
	(select t1.employee_id, (s2-s1) as summa
	from
		(select employee_id, sum(tm) as s1
		from times
		where tp = 1 and date = '2018-12-14'
		group by employee_id) t1
			join
		(select employee_id, sum(tm) as s2
		from times
		where tp = 2 and date = '2018-12-14'
		group by employee_id) t2
		on t1.employee_id = t2.employee_id) es
where extract(hour from summa) < 8

--средний возраст сотрудников 
select avg(extract(YEAR from age(now(), birth_date)))
from employees
	
--Теперь всё задание...
select avg(extract(YEAR from age(now(), birth_date)))
from employees e join
	(select t1.employee_id, (s2-s1) as summa
	from
		(select employee_id, sum(tm) as s1
		from times
		where tp = 1 and date = '2018-12-14'
		group by employee_id) t1
			join
		(select employee_id, sum(tm) as s2
		from times
		where tp = 2 and date = '2018-12-14'
		group by employee_id) t2
		on t1.employee_id = t2.employee_id) es
on e.id = es.employee_id
where extract(hour from summa) < 8
	

-- Вывести все отделы и количество сотрудников хоть раз опоздавших за всю историю учета.
select department, count(*)
from employees e join
			(select employee_id, min(tm) as mtm
			from times
			group by employee_id, date) t
	on (e.id = t.employee_id)
where mtm > '9:00'
group by department

select *
from employees e join
			(select employee_id, date, min(tm) as mtm
			from times
			group by employee_id, date) t
	on (e.id = t.employee_id)

--ОКНО
select department, min(id) over(partition by department)
from employees

select department, min(id)
from employees
group by department 