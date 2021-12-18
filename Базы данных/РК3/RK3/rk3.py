import psycopg2
from psycopg2 import OperationalError
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
    except OperationalError as e:
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

# 1 запрос
q = \
"""
select distinct department
from employees e
where extract(year from age(now(), birth_date)) < 25
"""
rez = execute_read_query(connection, q)
print("task1: \n", rez)

# 2 запрос
q = \
"""
select id, FIO
from employees e join (	select *
						from times t
						where tm = (select min(tm)
									from times t2
									where tp = 1
									and date = CURRENT_DATE)
						and date = CURRENT_DATE) tmins
on e.id = tmins.employee_id
"""
rez = execute_read_query(connection, q)
print("task2: \n", rez)

# 3 запрос
q = \
"""
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
"""
rez = execute_read_query(connection, q)
print("task3: \n", rez)

# LINQ
employees = Enumerable(get_Employees())
#print('employees:')
#for i in employees:
#    print(i)

times = Enumerable(get_Times())
#print('times:')
# for i in times:
#   print(i)

#QUERY1 Найти все отделы, в которых нет сотрудников моложе 25 лет
rez1 = employees.where(lambda x: (datetime.date.today().year - x['birth_date'].year) < 25)
rez1 = rez1.distinct(lambda x: x['department'])
rez1 = rez1.select(lambda x: x['department'])
for i in rez1:
    print(i)

#QUERY2 Найти сотрудника, который пришел сегодня на работу раньше всех
test_date = datetime.date(2018, 12, 11) # = datetime.date.today() #именно сегодня
#mtm = times.where(lambda x: x['tp'] == 1 and x['date'] == datetime.date.today()).min(lambda x: x['tm']) #именно сегодня
mtm = times.where(lambda x: x['tp'] == 1 and x['date'] == test_date).min(lambda x: x['tm']) # для проверки
tmp = times.where(lambda x: x['tm'] == mtm and x['date'] == test_date) #именно сегодня == datetime.date.today() вместо times[0]['date']
rez2 = employees.select(lambda x: {'id': x['id'], 'FIO': x['FIO']})
rez2 = rez2.join(tmp, lambda s1: s1['id'], lambda s2: s2['employee_id'], lambda result: result[0] | result[1])
rez2 = rez2.select(lambda x: {'id': x['id'], 'FIO': x['FIO']})
print("LINQ task2:")
print("mtm = ", mtm)
for i in rez2:
    print(i)

#QUERY3 Найти сотрудников, опоздавших не менее 5-ти раз
rez3 = times.group_by(['employee_id', 'date'], lambda x: [x['employee_id'], str(x['date'])])

rez3 = rez3.select(lambda x: {  'employee_id': x.select(lambda y: y['employee_id'])[0],
                                'mtm': x.min(lambda y: y['tm'])})
tmp = employees
rez3 = tmp.join(rez3, lambda s1: s1['id'], lambda s2: s2['employee_id'], lambda result: result[0] | result[1])
rez3 = rez3.where(lambda x: x['mtm'] > datetime.time(9))
rez3 = rez3.group_by(['employee_id'], lambda x: x['employee_id'])
rez3 = rez3.select(lambda x: {  'employee_id': x.select(lambda y: y['employee_id'])[0],
                                'cnt': x.count()})
rez3 = rez3.where(lambda x: x['cnt'] >= 4) #для проверки >= 4, а так надо >=5

print("LINQ task3:")
for i in rez3:
    print(i)

connection.close()
print("Exited...")
