drop table times cascade;
drop table employees cascade;

--������� 1
--��������
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

INSERT INTO employees (fio, birth_date, department) VALUES
('������ ���� ��������', '1990-09-25', '��'),
('������ ���� ��������', '1987-11-12', '�����������');

INSERT INTO times (employee_id, date, week_day, tm, tp) VALUES
(1, '2018-12-14', '�������', '9:00', 1),
(1, '2018-12-14', '�������', '9:20', 2),
(1, '2018-12-14', '�������', '9:25', 1),
(2, '2018-12-14', '�������', '9:05', 1),
(1, '2018-12-14', '�������', '18:00', 2),
(2, '2018-12-14', '�������', '17:00', 2);

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

select *
from employees e join
		(select employee_id, min(tm) as mtm
		from times
		where date = '2018-12-14'
		group by employee_id) t
	on (e.id = t.employee_id)
where mtm > '9:00'


--������� 2
-- ����� ������, � ������� ���� ���� ��������� ���������� ������ 3-� ��� � ������.

select *
from employees e join
		(select employee_id, min(tm) as mtm
		from times
		where date = '2018-12-14'
		group by employee_id) t
	on (e.id = t.employee_id)
where mtm > '9:00' and 
	  

-- ����� ������� ������� �����������, �� ����������� �� ������� ����� 8 ����� � ����.

-- employee_id � �� ����� ������ �� ���� (� ������� < 8 ������� �����)
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

--������� ������� ����������� 
select avg(extract(YEAR from age(now(), birth_date)))
from employees
	
--������ �� �������...
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
	

-- ������� ��� ������ � ���������� ����������� ���� ��� ���������� �� ��� ������� �����.
select department, count(*)
from employees e join
		(select employee_id, min(tm) as mtm
		from times
		group by employee_id) t
	on (e.id = t.employee_id)
where mtm > '9:00'
group by department