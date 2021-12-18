--РК3 Вариант2, Пронин АС ИУ7-52б
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

--Заполнение
delete from employees;
INSERT INTO employees (fio, birth_date, department) VALUES
('Иванов Иван Иванович', '1990-09-25', 'ИТ'),
('Петров Петр Петрович', '1987-11-12', 'Бухгалтерия'),
('Пронин Арсений Сергеевич', '2000-05-17', 'Киберспорт');

delete from times;
INSERT INTO times (employee_id, date, week_day, tm, tp) VALUES
(1, '2018-12-11', 'Понедельник', '9:00', 1),
(1, '2018-12-11', 'Понедельник', '9:20', 2),
(1, '2018-12-11', 'Понедельник', '9:25', 1),
(1, '2018-12-11', 'Понедельник', '18:00', 2),
(2, '2018-12-11', 'Понедельник', '9:05', 1),
(2, '2018-12-11', 'Понедельник', '17:00', 2),
(3, '2018-12-11', 'Понедельник', '9:00', 1),
(3, '2018-12-11', 'Понедельник', '17:00', 2),
(1, '2018-12-12', 'Вторник', '9:00', 1),
(1, '2018-12-12', 'Вторник', '18:00', 2),
(2, '2018-12-12', 'Вторник', '9:05', 1),
(2, '2018-12-12', 'Вторник', '18:00', 2),
(3, '2018-12-12', 'Вторник', '9:00', 1),
(3, '2018-12-12', 'Вторник', '17:00', 2),
(1, '2018-12-13', 'Среда', '9:00', 1),
(1, '2018-12-13', 'Среда', '18:00', 2),
(2, '2018-12-13', 'Среда', '9:05', 1),
(2, '2018-12-13', 'Среда', '18:00', 2),
(3, '2018-12-13', 'Среда', '9:00', 1),
(3, '2018-12-13', 'Среда', '17:00', 2),
(1, '2018-12-14', 'Четверг', '9:00', 1),
(1, '2018-12-14', 'Четверг', '15:00', 2),
(2, '2018-12-14', 'Четверг', '9:01', 1),
(2, '2018-12-14', 'Четверг', '15:00', 2),
(3, '2018-12-14', 'Четверг', '9:00', 1),
(3, '2018-12-14', 'Четверг', '15:00', 2);

--Функция
--Написать табличную функцию, возвращающую статистику на сколько и кто опоздал в определенную дату.
create OR REPLACE function getLateStats(d date)
returns table 
(
	mins float,
	employees_cnt bigint
)
as $$
begin
    return query(	select extract(minute from late_time) as mins, count(*) as employees_cnt
					from(	select employee_id, (min(tm)-'9:00') as late_time
							from times
							where date = d
							group by employee_id
						) r1
					where r1.late_time > '0:00'
					group by r1.late_time);
end;
$$ LANGUAGE 'plpgsql';

drop function  getLateStats(date);

select * from getLateStats('2018-12-14');

--сам запрос...
select late_time, count(*) employees_cnt
from(	select employee_id, (min(tm)-'9:00') as late_time
		from times
		where date = '2018-12-14'
		group by employee_id
	) r1
where late_time > '0:00'
group by late_time

--Задание 2
--Найти все отделы, в которых нет сотрудников моложе 25 лет
select distinct department
from employees e
where extract(year from age(now(), birth_date)) < 25

--Найти сотрудника, который пришел сегодня на работу раньше всех
--Ответ:
select id, FIO
from employees e join (	select *
						from times t
						where tm = (select min(tm)
									from times t2
									where tp = 1
									and date = CURRENT_DATE)
						and date = CURRENT_DATE) tmins
on e.id = tmins.employee_id

--Для проверки:
select id, FIO
from employees e join (	select *
						from times t
						where tm = (select min(tm)
									from times t2
									where tp = 1
									and date = '2018-12-11')
						and date = '2018-12-11') tmins
on e.id = tmins.employee_id

--Найти сотрудников, опоздавших не менее 5-ти раз
select employee_id
from (	select employee_id, count(*) cnt
		from employees e join
					(select employee_id, min(tm) as mtm
					from times
					group by employee_id, date) t
			on (e.id = t.employee_id)
		where mtm > '9:00'
		group by employee_id) r1
where cnt >= 5

--Для проверки
select employee_id
from (	select employee_id, count(*) cnt
		from employees e join
					(select employee_id, min(tm) as mtm
					from times
					group by employee_id, date) t
			on (e.id = t.employee_id)
		where mtm > '9:00'
		group by employee_id) r1
where cnt >= 5
			