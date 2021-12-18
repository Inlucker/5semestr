TASK_2_1 = """
select department
from employees e 
where id in (	select employee_id
				from (	select employee_id, count(date) as lcnt
						from (  select employee_id, date, min(tm) as mtm, (extract(WEEK from date)) as week_number
								from times
								where tp = 1
								group by employee_id, date) r1
						where mtm > '9:00'
						group by(employee_id, week_number)) r2
				where lcnt > 3)
"""

TASK_2_2 = """
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
"""

TASK_2_3 = """
select department, count(*)
from employees e join
			(select employee_id, min(tm) as mtm
			from times
			group by employee_id, date) t
	on (e.id = t.employee_id)
where mtm > '9:00'
group by department
"""