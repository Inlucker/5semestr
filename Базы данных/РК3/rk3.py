import psycopg2
from psycopg2 import OperationalError
import csv
import time
from py_linq import *
import datetime

def create_connection(db_name, db_user, db_password, db_host, db_port):
    connection = None
    try:
        connection = psycopg2.connect(
            database=db_name,
            user=db_user,
            password=db_password,
            host=db_host,
            port=db_port,
        )
        print("Connection to PostgreSQL DB successful")
    except OperationalError as e:
        print(f"The error '{e}' occurred")
    return connection

def execute_query(connection, query):
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        connection.commit()
        print("Query executed successfully")
    except OperationalError as e:
        print(f"The error '{e}' occurred")

def execute_read_query(connection, query):
    cursor = connection.cursor()
    result = None
    try:
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    except Error as e:
        print(f"The error '{e}' occurred")

class Employee:
    id = int()
    FIO = str()
    birth_date = datetime.date.today()
    department = str()

    def __init__(self, param):
        self.id = param[0]
        self.FIO = param[1]
        self.birth_date = param[2]
        self.department = param[3]

    #def __str__(self):
    #    return f"{self.id} {self.fio} {self.birthdate} {self.department}"

    def get(self):
        return {'id': self.id, 'FIO': self.FIO, 'birth_date': self.birth_date,
                'department': self.department}

def get_Employees():
    q = \
        """
        select *
        from employees;
        """
    rez = execute_read_query(connection, q)
    employess = list()
    for elem in rez:
        employess.append(Employee(elem).get())

    return employess

class Time:
    employee_id = int()
    date = datetime.date.today()
    week_day = str()
    tm = datetime.time()
    tp = int()

    def __init__(self, params):
        self.employee_id = params[0]
        self.date = params[1]
        self.week_day = params[2]
        self.tm = params[3]
        self.tp = params[4]

    #def __str__(self):
    #    return f"{self.id} {self.cur_date} {self.day} {self.time} {self.type}"

    def get(self):
        return {'employee_id': self.employee_id, 'date': self.date, 'week_day': self.week_day,
                'tm': self.tm, 'tp': self.tp}

def get_Times():
    q = \
        """
        select *
        from times;
        """
    rez = execute_read_query(connection, q)
    times = list()
    for elem in rez:
        times.append(Time(elem).get())

    return times

connection = create_connection("rk3", "postgres", "postgres", "localhost", "5432")

#1 запрос
q = \
"""
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
"""
rez = execute_read_query(connection, q)
print("task1: \n", rez)

#2 запрос
q = \
"""
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
rez = execute_read_query(connection, q)
print("task2: \n", rez)

#3 запрос
q = \
"""
select department, count(*)
from employees e join
		(select employee_id, date, min(tm) as mtm
		from times
		group by employee_id, date) t
	on (e.id = t.employee_id)
where mtm > '9:00'
group by department
"""
rez = execute_read_query(connection, q)
print("task3: \n", rez)

#LINQ
employees = Enumerable(get_Employees())
print('employees:')
for i in employees:
   print(i)

times = Enumerable(get_Times())
print('times:')
for i in times:
   print(i)
#print(times)


#rez = employees.select(lambda x: x.id).group_by(key_names=['asd'], key=lambda x: x)
# [{'enumerable': '[1]', 'key': "{'id': 1}"}, {'enumerable': '[2]', 'key': "{'id': 2}"}, {'enumerable': '[3]', 'key': "{'id': 3}"}]

#rez = employees.group_by(key_names=['id'], key=lambda x: x)

#rez = employees.select(lambda x: {x.department, employees.where(lambda y: y.department == x.department).min(lambda y: y.id)}).distinct(lambda y: y.department)
#rez = times.group_by(key_names=['employee_id'], key=lambda x: x.employee_id)#.select(lambda x: x.key)
#print("LINQ task1:")
#print(rez)
#for i in rez:
#   print(i)

connection.close()
print("Exited...")

