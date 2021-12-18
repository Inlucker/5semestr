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

--�Ψ
INSERT INTO employees (fio, birth_date, department) VALUES
('������ ���� ��������', '1990-09-25', '��'),
('������ ���� ��������', '1987-11-12', '�����������'),
('������ ������� ���������', '2000-05-17', '����������');

INSERT INTO times (employee_id, date, week_day, tm, tp) VALUES
(1, '2018-12-14', '�����������', '9:00', 1),
(1, '2018-12-14', '�����������', '9:20', 2),
(1, '2018-12-14', '�����������', '9:25', 1),
(1, '2018-12-14', '�����������', '18:00', 2),
(2, '2018-12-14', '�����������', '9:05', 1),
(2, '2018-12-14', '�����������', '17:00', 2),
(3, '2018-12-14', '�����������', '9:00', 1),
(3, '2018-12-14', '�����������', '17:00', 2),
(1, '2018-12-15', '�������', '9:00', 1),
(1, '2018-12-15', '�������', '18:00', 2),
(2, '2018-12-15', '�������', '9:05', 1),
(2, '2018-12-15', '�������', '18:00', 2),
(3, '2018-12-15', '�������', '9:00', 1),
(3, '2018-12-15', '�������', '17:00', 2),
(1, '2018-12-16', '�����', '9:00', 1),
(1, '2018-12-16', '�����', '18:00', 2),
(2, '2018-12-16', '�����', '9:05', 1),
(2, '2018-12-16', '�����', '18:00', 2),
(3, '2018-12-16', '�����', '9:00', 1),
(3, '2018-12-16', '�����', '17:00', 2),
(1, '2018-12-17', '�������', '9:00', 1),
(1, '2018-12-17', '�������', '15:00', 2),
(2, '2018-12-17', '�������', '9:01', 1),
(2, '2018-12-17', '�������', '15:00', 2),
(3, '2018-12-17', '�������', '9:00', 1),
(3, '2018-12-17', '�������', '15:00', 2);

--�� �Ψ
insert into employees
values 
(1, '������ ���� ��������', '1987-12-11', '�����������'),
(2, '������� ���� ��������', '1987-12-11', '��'),
(3, '������ ���� ��������', '1987-12-11', '�����������2'),
(4, '���� ���� ��������', '1987-12-11', '�����������2');

insert into times 
values 
(1, '2018-12-15', '�������', '09:00', 1),
	(1, '2018-12-15', '�������', '09:20', 2),
	(1, '2018-12-15', '�������', '09:25', 1),
	(2, '2018-12-15', '�������', '09:05', 1),
	(1, '2018-12-16', '�������', '09:00', 1),
	(1, '2018-12-16', '�������', '09:20', 2),
	(1, '2018-12-16', '�������', '09:25', 1),
	(2, '2018-12-16', '�������', '09:05', 1),
	(3, '2018-12-16', '�������', '08:00', 1),
	(1, '2018-12-17', '�������', '09:00', 1),
	(1, '2018-12-17', '�������', '09:20', 2),
	(1, '2018-12-17', '�������', '09:25', 1),
	(2, '2018-12-17', '�������', '09:05', 1),
	(3, '2018-12-17', '�������', '08:00', 1),
	(1, '2018-12-18', '�������', '09:00', 1),
	(1, '2018-12-18', '�������', '09:20', 2),
	(1, '2018-12-18', '�������', '09:25', 1),
	(2, '2018-12-18', '�������', '09:05', 1),
	(3, '2018-12-18', '�������', '08:00', 1),
	(1, '2018-12-19', '�������', '09:00', 1),
	(1, '2018-12-19', '�������', '09:20', 2),
	(1, '2018-12-19', '�������', '09:25', 1),
	(2, '2018-12-19', '�������', '09:05', 1),
	(3, '2018-12-19', '�������', '08:00', 1),
	(1, '2018-12-20', '�������', '09:25', 1),
	(2, '2018-12-20', '�������', '09:05', 1),
	(3, '2018-12-20', '�������', '08:00', 1),
	(1, '2018-12-21', '�������', '09:25', 1),
	(2, '2018-12-21', '�������', '09:05', 1),
	(3, '2018-12-21', '�������', '08:00', 1);

--�������
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


--������� 2
-- ����� ������, � ������� ���� ���� ��������� ���������� ������ 3-� ��� � ������.
--�Ψ??
select *
from employees e join
		(select employee_id, min(tm) as mtm
		from times
		where date = '2018-12-14'
		group by employee_id) t
	on (e.id = t.employee_id)
where mtm > '9:00' and 
	
--�� �Ψ (������)
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

--����
select department, min(id) over(partition by department)
from employees

select department, min(id)
from employees
group by department 