drop database rk2;

drop table medicines cascade;
drop table department cascade;
drop table employee cascade;
drop table medicinesemployees cascade;

--��������
create database rk2;

create table if not exists medicines
(
	id int primary key,
	name text,
	instruction text,
	price float
);

create table if not exists department
(
	id int primary key,
	name text,
	phone_number text,
	director_id int
	--foreign key (director_id) references rk2.employee (id)
);

create table if not exists employee
(
	id int primary key,
	department_id int,
	foreign key (department_id) references department (id),
	post text,
	FIO text,
	salary int
);

alter table department ADD constraint director_fkey foreign key (director_id) references employee (id);

create table if not exists medicinesemployees
(
	medicines_id int,
	employee_id int,
	foreign key (medicines_id)  references medicines (id),
	foreign key (employee_id)  references employee (id)
);

delete from medicines;
delete from department;
delete from employee;
delete from medicinesemployees;

--����������
insert into medicines values(1, '����������', '��������� � �������� �����', 1);
insert into medicines values(2, '���������', '������ �������� ����', 2000);
insert into medicines values(3, '��������� 3', '������ �������� ����', 3000);
insert into medicines values(4, '��������� 4', '������ �������� ����', 4000);
insert into medicines values(5, '��������� 5', '������ �������� ����', 5000);
insert into medicines values(6, '��������� 6', '������ �������� ����', 6000);
insert into medicines values(7, '��������� 7', '������ �������� ����', 99000);
insert into medicines values(8, '��������� 8', '������ �������� ����', 88000);
insert into medicines values(9, '��������� 9', '������ �������� ����', 66000);
insert into medicines values(10, '��������� 10', '������ �������� ����', 77000);


insert into department values(1, '����� 1', '88005553530', NULL);
insert into department values(2, '����� 2', '88005553531', NULL);
insert into department values(3, '����� 3', '88005553532', NULL);
insert into department values(4, '����� 4', '88005553533', NULL);
insert into department values(5, '����� 5', '88005553534', NULL);
insert into department values(6, '����� 6', '88005553535', NULL);
insert into department values(7, '����� 7', '88005553536', NULL);
insert into department values(8, '����� 8', '88005553537', NULL);
insert into department values(9, '����� 9', '88005553538', NULL);
insert into department values(10, '����� 10', '88005553539', NULL);

insert into employee values(1, 1, '����������������', '���� �.�.', 3000000);
insert into employee values(2, 2, '�������', '���� �.�.', 20589);
insert into employee values(3, 3, '��������� 3', '���� �.�.', 20589);
insert into employee values(4, 4, '��������� 4', '���� �.�.', 20589);
insert into employee values(5, 5, '��������� 5', '���� �.�.', 20589);
insert into employee values(6, 6, '��������� 6', '���� �.�.', 20589);
insert into employee values(7, 7, '��������� 7', '���� �.�.', 20589);
insert into employee values(8, 8, '��������� 8', '���� �.�.', 20589);
insert into employee values(9, 9, '��������� 9', '���� �.�.', 20589);
insert into employee values(10, 10, '��������� 10', '���� �.�.', 20589);

update department set director_id = 1 where id = 1;
update department set director_id = 2 where id = 2;
update department set director_id = 3 where id = 3;
update department set director_id = 4 where id = 4;
update department set director_id = 5 where id = 5;
update department set director_id = 6 where id = 6;
update department set director_id = 7 where id = 7;
update department set director_id = 8 where id = 8;
update department set director_id = 9 where id = 9;
update department set director_id = 10 where id = 10;


insert into medicinesemployees values(1, 2);
insert into medicinesemployees values(2, 1);
insert into medicinesemployees values(3, 1);
insert into medicinesemployees values(4, 1);
insert into medicinesemployees values(5, 1);
insert into medicinesemployees values(6, 1);
insert into medicinesemployees values(7, 1);
insert into medicinesemployees values(8, 1);
insert into medicinesemployees values(9, 1);
insert into medicinesemployees values(10, 1);

--������� 2
--1) ���������� SELECT, ������������ ������� ��������� CASE
--���������� ���������� �������� �����������
select *, case when post = '����������������' then 'high' else 'low' end as rescue_priority
from employee e 

--2) ����������, ������������ ������� �������
--�������� �������� ���������� � ������������ ��������� � �� �������
select *, max(salary) over (partition by department_id) as max_salary
from employee e 

--3) ���������� SELECT, ��������������� ������ � ������� ����������� GROUP BY � ����������� HAVING
--���������� � ������������, ���-�� ������� ������ 8 (� �� ���-��)
select instruction, count(*) as cnt
from medicines m 
group by m.instruction
having count(*) < 8

--������� 3
--������� �������� ��������� � ����� �������� ����������� - ��� ���� ������ � ��� �������,
--������� ������� �������� �� �������� ��������� ������� � ��������� ���� ������.
create or replace procedure get_indexes(db_name text, t_name text)
as $$
declare 
		cur refcursor;
		tmp pg_indexes%ROWTYPE;
begin 
	open cur for execute format('select * FROM %I.pg_catalog.pg_indexes p WHERE tablename = $1', db_name)
								using t_name;
	loop
		fetch cur into tmp;
		exit when not found;
	RAISE notice 'schemaname = %, tablename = %, indexname = %, tablespace = %, indexdef = %',
					tmp.schemaname, tmp.tablename, tmp.indexname, tmp.tablespace, tmp.indexdef;
	end loop;
	close cur;
end
$$ language plpgsql;

call get_indexes('rk2', 'pg_proc');

drop procedure get_indexes(text, text)

--��� �������
CREATE OR REPLACE PROCEDURE index_info (db_name text, t_name text)
AS $$
DECLARE
    elem RECORD;
BEGIN
    FOR elem in EXECUTE 
        format('select * FROM %I.pg_catalog.pg_indexes p WHERE tablename = $1', db_name) using t_name
    LOOP
        RAISE NOTICE 'elem = %', elem;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL index_info('rk2', 'pg_proc');

--���� (����-������)
SELECT * FROM pg_indexes WHERE tablename = 'pg_proc';

--����2 (format)
create or replace procedure update_table(t_name text)
as $$
begin
	EXECUTE format('update %I set rating = 7787 where nickname = $2', t_name) using 'Players', 'Inlucker';
end
$$ language plpgsql;

call update_table('players');

drop procedure update_table(text);

--��������� ����������� (???????????)
CREATE OR REPLACE FUNCTION prog()
RETURNS TABLE(txt text) LANGUAGE plpgsql AS
$func$
BEGIN
    DROP TABLE IF EXISTS prog;
    CREATE TEMP TABLE prog(txt text);
    COPY prog FROM PROGRAM 'pwd';
    RETURN QUERY (SELECT * FROM prog);
END;
$func$;

SELECT * FROM prog();


--pg_dump rk2 > file
copy (select * from medicines) to program 'touch file';
copy (select * from medicines) to program 'pg_dump rk2 > /var/lib/postgresql/data/file';
copy (select 2) to program 'pg_dump rk2 > /var/lib/postgresql/data/file';

COPY (SELECT 1, 2) TO PROGRAM 'sed -e "s/,/:/" > ~/test.txt' DELIMITER ',';

copy (select * from medicines) to '/file' program 'pg_dump rk2 > file'

COPY (select * from medicines) TO '/file' DELIMITER '|';
COPY medicines (id,name,instruction,price) from '/file' DELIMITER '|';
copy (select row_to_json(d) from department d) to '/department.json';

select * from department;
select row_to_json(d) from department d;

--2�� �������, 3� �������
-- ������� �������� ��������� � ������� ����������, ������� �������
-- ����� � �������� ���� �������� (������ �������� �������� � ���������
-- �������), � ������ ������� �� ����� SQL ����������� ������, ����������
-- ���������� ���������. ��������� �������� ��������� ��������������.

create or replace procedure task_3
(
    str_ text
)
AS $$
DECLARE
    elem record;
BEGIN
    FOR elem IN
        select routine_name, routine_type
        from information_schema.routines
        where routines.routine_definition LIKE CONCAT('%', $1, '%')
    LOOP
        raise notice 'name: %, args: %', elem.routine_name,
                                            elem.routine_type;
end loop;
end;
$$ language plpgsql;

call task_3('routine_name');
