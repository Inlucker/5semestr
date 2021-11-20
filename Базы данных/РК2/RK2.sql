--��� ������������
drop table region cascade;
drop table vacationer cascade;
drop table sanatoriumsvacationers cascade;
drop table sanatorium cascade;

--������� 1
--��������
create database rk2;

create table if not exists region
(
	id int primary key,
	name text,
	description text
);

create table if not exists sanatorium
(
	id int primary key,
	region_id int,
	foreign key (region_id) references region (id),
	name text,
	foundation_year int,
	description text
);

create table if not exists vacationer
(
	id int primary key,
	FIO text,
	birth_year int,
	address text,
	email text
);

create table if not exists sanatoriumsvacationers
(
	sanatorium_id int,
	vacationer_id int,
	foreign key (sanatorium_id) references sanatorium (id),
	foreign key (vacationer_id) references vacationer (id)
);

--����������
delete from sanatoriumsvacationers cascade;
delete from sanatorium cascade;
delete from region cascade;
delete from vacationer cascade;


insert into region values(1, '������ 1', '�������� 1');
insert into region values(2, '������ 2', '�������� 2');
insert into region values(3, '������ 3', '�������� 3');
insert into region values(4, '������ 4', '�������� 4');
insert into region values(5, '������ 5', '�������� 5');
insert into region values(6, '������ 6', '�������� 6');
insert into region values(7, '������ 7', '�������� 7');
insert into region values(8, '������ 8', '�������� 8');
insert into region values(9, '������ 9', '�������� 9');
insert into region values(10, '������ 10', '�������� 10');

insert into sanatorium values(1, 1, '��������� 1', 2001, '�������� 10');
insert into sanatorium values(2, 2, '��������� 2', 2002, '�������� 10');
insert into sanatorium values(3, 3, '��������� 3', 2003, '�������� 10');
insert into sanatorium values(4, 4, '��������� 4', 2004, '�������� 10');
insert into sanatorium values(5, 5, '��������� 5', 2005, '�������� 10');
insert into sanatorium values(6, 6, '��������� 6', 2006, '�������� 6');
insert into sanatorium values(7, 7, '��������� 7', 2007, '�������� 7');
insert into sanatorium values(8, 8, '��������� 8', 2008, '�������� 8');
insert into sanatorium values(9, 9, '��������� 9', 2009, '�������� 9');
insert into sanatorium values(10, 10, '��������� 10', 2010, '�������� 10');

insert into vacationer values(1, '���� �.�.', 1981, '�. ������, ���������� �������, �. 1', 'IvanAA@mail.ru');
insert into vacationer values(2, '���� �.�.', 1982, '�. ������, ���������� �������, �. 2', 'IvanBB@mail.ru');
insert into vacationer values(3, '���� �.�.', 1983, '�. ������, ���������� �������, �. 3', 'IvanVV@mail.ru');
insert into vacationer values(4, '���� �.�.', 1984, '�. ������, ���������� �������, �. 4', 'IvanGG@mail.ru');
insert into vacationer values(5, '���� �.�.', 1985, '�. ������, ���������� �������, �. 5', 'IvanDD@mail.ru');
insert into vacationer values(6, '���� �.�.', 1986, '�. ������, ���������� �������, �. 6', 'IvanJJ@mail.ru');
insert into vacationer values(7, '���� �.�.', 1987, '�. ������, ���������� �������, �. 7', 'IvanZZ@mail.ru');
insert into vacationer values(8, '���� �.�.', 1988, '�. ������, ���������� �������, �. 8', 'IvanII@mail.ru');
insert into vacationer values(9, '���� �.�.', 1989, '�. ������, ���������� �������, �. 9', 'IvanKK@mail.ru');
insert into vacationer values(10, '���� �.�.', 1990, '�. ������, ���������� �������, �. 10', 'IvanLL@mail.ru');

insert into sanatoriumsvacationers values(1, 1);
insert into sanatoriumsvacationers values(2, 2);
insert into sanatoriumsvacationers values(3, 3);
insert into sanatoriumsvacationers values(4, 4);
insert into sanatoriumsvacationers values(5, 5);
insert into sanatoriumsvacationers values(6, 6);
insert into sanatoriumsvacationers values(7, 7);
insert into sanatoriumsvacationers values(8, 8);
insert into sanatoriumsvacationers values(9, 9);
insert into sanatoriumsvacationers values(10, 10);

--������� 2
--1)Select, ������������ ��������� ��������� CASE
--�������� id, ���, ��� ��������, � �������������� '������' ��� '�������' ���� ����������
select id, FIO, birth_year, case when birth_year > 1985 then 'Old' else 'Young' end as age
from vacationer v;

--2)���������� UPDATE �� ��������� ����������� � ����������� set
--������ ��� ��������� ��������� 10, �� ��� �������� ����� �.�.
update sanatorium
set foundation_year = (select birth_year
						from vacationer
						where FIO = '���� �.�.')
where name = '��������� 10';

--3) ���������� SELECT, ��������������� ������ � ������� ����������� GROUP BY � ����������� HAVING
--�������� �������� ����������, ������� ����������� ������ 1 ���
select description, count(*) as cnt
from sanatorium
group by description
having count(*) > 1

--������� 3
--�������� ���� view ��� �������� ���������
create view v_vacationer as
select * from vacationer;

select * from v_vacationer;

create or replace procedure delete_views(v_number inout int)
as $$
declare 
	r RECORD;
begin 
	v_number = 0;
	for r in 
	SELECT table_schema, table_name FROM INFORMATION_SCHEMA.tables WHERE table_type='VIEW' AND table_schema=ANY(current_schemas(false)) ORDER BY table_name
	loop
		raise notice '% %', r.table_schema, r.table_name;
		--EXECUTE format('drop view %I.%I cascade;', r.table_schema, r.table_name);
		EXECUTE 'drop view ' || r.table_schema || '.' || r.table_name || ' cascade;';
		v_number = v_number + 1;
	end loop;
end
$$ language plpgsql;

call delete_views(0);

drop procedure delete_views(int);
--��������� ����-������
--��� view (����� ������� ���� �� ����� �������, ����� �������� ��� view)
SELECT table_schema, table_name FROM INFORMATION_SCHEMA.tables WHERE table_type='VIEW';

--������ ��� view
SELECT table_schema, table_name FROM INFORMATION_SCHEMA.tables WHERE table_type='VIEW' AND table_schema=ANY(current_schemas(false)) ORDER BY table_name;