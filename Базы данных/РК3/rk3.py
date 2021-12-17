import psycopg2
from psycopg2 import OperationalError
import csv
import time

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


connection = create_connection("rk3", "postgres", "postgres", "localhost", "5432")

q ="""
    select * from times
    """
rez = execute_read_query(connection, q)
print("task1: \n", rez)

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

q = \
"""
select department, count(*)
from employees e join
        (select employee_id, min(tm) as mtm
        from times
        group by employee_id) t
    on (e.id = t.employee_id)
where mtm > '9:00'
group by department
"""
rez = execute_read_query(connection, q)
print("task3: \n", rez)

connection.close()
print("Exited...")
