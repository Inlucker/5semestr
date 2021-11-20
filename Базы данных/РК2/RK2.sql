--Для пересоздания
drop table region cascade;
drop table vacationer cascade;
drop table sanatoriumsvacationers cascade;
drop table sanatorium cascade;

--Задание 1
--Создание
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

--Заполнение
delete from sanatoriumsvacationers cascade;
delete from sanatorium cascade;
delete from region cascade;
delete from vacationer cascade;


insert into region values(1, 'Регион 1', 'Описание 1');
insert into region values(2, 'Регион 2', 'Описание 2');
insert into region values(3, 'Регион 3', 'Описание 3');
insert into region values(4, 'Регион 4', 'Описание 4');
insert into region values(5, 'Регион 5', 'Описание 5');
insert into region values(6, 'Регион 6', 'Описание 6');
insert into region values(7, 'Регион 7', 'Описание 7');
insert into region values(8, 'Регион 8', 'Описание 8');
insert into region values(9, 'Регион 9', 'Описание 9');
insert into region values(10, 'Регион 10', 'Описание 10');

insert into sanatorium values(1, 1, 'Санаторий 1', 2001, 'Описание 10');
insert into sanatorium values(2, 2, 'Санаторий 2', 2002, 'Описание 10');
insert into sanatorium values(3, 3, 'Санаторий 3', 2003, 'Описание 10');
insert into sanatorium values(4, 4, 'Санаторий 4', 2004, 'Описание 10');
insert into sanatorium values(5, 5, 'Санаторий 5', 2005, 'Описание 10');
insert into sanatorium values(6, 6, 'Санаторий 6', 2006, 'Описание 6');
insert into sanatorium values(7, 7, 'Санаторий 7', 2007, 'Описание 7');
insert into sanatorium values(8, 8, 'Санаторий 8', 2008, 'Описание 8');
insert into sanatorium values(9, 9, 'Санаторий 9', 2009, 'Описание 9');
insert into sanatorium values(10, 10, 'Санаторий 10', 2010, 'Описание 10');

insert into vacationer values(1, 'Иван А.А.', 1981, 'г. Москва, Мячковский бульвар, д. 1', 'IvanAA@mail.ru');
insert into vacationer values(2, 'Иван Б.Б.', 1982, 'г. Москва, Мячковский бульвар, д. 2', 'IvanBB@mail.ru');
insert into vacationer values(3, 'Иван В.В.', 1983, 'г. Москва, Мячковский бульвар, д. 3', 'IvanVV@mail.ru');
insert into vacationer values(4, 'Иван Г.Г.', 1984, 'г. Москва, Мячковский бульвар, д. 4', 'IvanGG@mail.ru');
insert into vacationer values(5, 'Иван Д.Д.', 1985, 'г. Москва, Мячковский бульвар, д. 5', 'IvanDD@mail.ru');
insert into vacationer values(6, 'Иван Ж.Ж.', 1986, 'г. Москва, Мячковский бульвар, д. 6', 'IvanJJ@mail.ru');
insert into vacationer values(7, 'Иван З.З.', 1987, 'г. Москва, Мячковский бульвар, д. 7', 'IvanZZ@mail.ru');
insert into vacationer values(8, 'Иван И.И.', 1988, 'г. Москва, Мячковский бульвар, д. 8', 'IvanII@mail.ru');
insert into vacationer values(9, 'Иван К.К.', 1989, 'г. Москва, Мячковский бульвар, д. 9', 'IvanKK@mail.ru');
insert into vacationer values(10, 'Иван Л.Л.', 1990, 'г. Москва, Мячковский бульвар, д. 10', 'IvanLL@mail.ru');

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

--Задание 2
--1)Select, использующий поисковое выражение CASE
--Получаем id, ФИО, год рождения, и классифицируем 'старый' или 'молодой' всех отдыхающих
select id, FIO, birth_year, case when birth_year > 1985 then 'Old' else 'Young' end as age
from vacationer v;

--2)Инструкция UPDATE со скалярным подзапросом в предолжении set
--Меняем год основания Санатория 10, на год рождения Ивана Л.Л.
update sanatorium
set foundation_year = (select birth_year
						from vacationer
						where FIO = 'Иван Л.Л.')
where name = 'Санаторий 10';

--3) Инструкция SELECT, консолидирующую данные с помощью предложения GROUP BY и предложения HAVING
--Выбираем описания санаториев, которые повторяются хотябы 1 раз
select description, count(*) as cnt
from sanatorium
group by description
having count(*) > 1

--Задание 3
--Создание моей view для проверки процедуры
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
--Получение мета-данных
--Все view (Можно сделать цикл по этому запросу, тогда удалятся ВСЕ view)
SELECT table_schema, table_name FROM INFORMATION_SCHEMA.tables WHERE table_type='VIEW';

--Только мои view
SELECT table_schema, table_name FROM INFORMATION_SCHEMA.tables WHERE table_type='VIEW' AND table_schema=ANY(current_schemas(false)) ORDER BY table_name;