--��3 �������2, ������ �� ��7-52�
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

--����������
delete from employees;
INSERT INTO employees (fio, birth_date, department) VALUES
('������ ���� ��������', '1990-09-25', '��'),
('������ ���� ��������', '1987-11-12', '�����������'),
('������ ������� ���������', '2000-05-17', '����������');

delete from times;
INSERT INTO times (employee_id, date, week_day, tm, tp) VALUES
(1, '2018-12-11', '�����������', '9:00', 1),
(1, '2018-12-11', '�����������', '9:20', 2),
(1, '2018-12-11', '�����������', '9:25', 1),
(1, '2018-12-11', '�����������', '18:00', 2),
(2, '2018-12-11', '�����������', '9:05', 1),
(2, '2018-12-11', '�����������', '17:00', 2),
(3, '2018-12-11', '�����������', '9:00', 1),
(3, '2018-12-11', '�����������', '17:00', 2),
(1, '2018-12-12', '�������', '9:00', 1),
(1, '2018-12-12', '�������', '18:00', 2),
(2, '2018-12-12', '�������', '9:05', 1),
(2, '2018-12-12', '�������', '18:00', 2),
(3, '2018-12-12', '�������', '9:00', 1),
(3, '2018-12-12', '�������', '17:00', 2),
(1, '2018-12-13', '�����', '9:00', 1),
(1, '2018-12-13', '�����', '18:00', 2),
(2, '2018-12-13', '�����', '9:05', 1),
(2, '2018-12-13', '�����', '18:00', 2),
(3, '2018-12-13', '�����', '9:00', 1),
(3, '2018-12-13', '�����', '17:00', 2),
(1, '2018-12-14', '�������', '9:00', 1),
(1, '2018-12-14', '�������', '15:00', 2),
(2, '2018-12-14', '�������', '9:01', 1),
(2, '2018-12-14', '�������', '15:00', 2),
(3, '2018-12-14', '�������', '9:00', 1),
(3, '2018-12-14', '�������', '15:00', 2);

--�������
--�������� ��������� �������, ������������ ���������� �� ������� � ��� ������� � ������������ ����.
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

--��� ������...
select late_time, count(*) employees_cnt
from(	select employee_id, (min(tm)-'9:00') as late_time
		from times
		where date = '2018-12-14'
		group by employee_id
	) r1
where late_time > '0:00'
group by late_time

--������� 2
--����� ��� ������, � ������� ��� ����������� ������ 25 ���
select distinct department
from employees e
where extract(year from age(now(), birth_date)) < 25

--����� ����������, ������� ������ ������� �� ������ ������ ����
--�����:
select id, FIO
from employees e join (	select *
						from times t
						where tm = (select min(tm)
									from times t2
									where tp = 1
									and date = CURRENT_DATE)
						and date = CURRENT_DATE) tmins
on e.id = tmins.employee_id

--��� ��������:
select id, FIO
from employees e join (	select *
						from times t
						where tm = (select min(tm)
									from times t2
									where tp = 1
									and date = '2018-12-11')
						and date = '2018-12-11') tmins
on e.id = tmins.employee_id

--����� �����������, ���������� �� ����� 5-�� ���
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

--��� ��������
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
			