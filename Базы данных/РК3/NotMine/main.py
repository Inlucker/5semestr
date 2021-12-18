from peewee import *

from req_sql import *
from datetime import *

# Подключаемся к нашей БД.
con = PostgresqlDatabase(
	database='rk3',
	user='postgres',
	password='postgres',
	host='localhost',
	port=5432
)


class BaseModel(Model):
	class Meta:
		database = con

class Employee(BaseModel):
	id = IntegerField(column_name='id')
	fio = CharField(column_name='fio')
	birth_date = DateField(column_name='birth_date')
	department = CharField(column_name='department')

	class Meta:
		table_name = 'employees'



class EmployeeVisit(BaseModel):
	#id = IntegerField(column_name='id')
	employee_id = ForeignKeyField(Employee, backref='employee_id')
	empl_date = DateField(column_name='date')
	day_of_week =  CharField(column_name='week_day')
	empl_time = TimeField(column_name='tm')
	time_type = IntegerField(column_name='tp')

	class Meta:
		table_name = 'times'




def print_res(cur):
	rows = cur.fetchall()
	for row in rows:
		print(*row)
	print()

def task_2():
	global con

	cur = con.cursor()

	print("1 запрос\n")
	cur.execute(TASK_2_1)
	print_res(cur)

	print("2 запрос\n")
	cur.execute(TASK_2_2)
	print(*cur.fetchone(), "\n")

	print("3 запрос\n")
	cur.execute(TASK_2_3)
	print_res(cur)

	cur.close()

def print_query_res(query):
	for elem in query.dicts().execute():
		print(elem)
		# print(elem['empl_date'].isocalendar()[1] )

def task_2_orm():
	# 1.
	print("Отделы, в которых сотрудники опаздывают более 2х раз в неделю")
	query = Employee.select(Employee.department).join(EmployeeVisit).where(EmployeeVisit.empl_time > '09:00:00').where(EmployeeVisit.time_type==1).group_by(Employee.department).having(fn.Count(Employee.id) > 2)
	print_query_res(query)
	 
	# 2.
	print("\nНайти средний возраст сотрудников, не находящихся на рабочем месте 8 часов в неделю.")
	print(datetime.now())
	# datetime.datetime.now().year - Employee.birth_date.year
	# Это средний возраст сотрудников.
	query = Employee.select(fn.AVG(datetime.now().year - Employee.birth_date.year))
	print_query_res(query)
	
	# # Это сотрудники, которые находятся на рабочем месте менее 8 часов.
	sql_max = fn.Max(EmployeeVisit.empl_time)
	sql_min = fn.Min(EmployeeVisit.empl_time)
	# query = Employee.select(
	# 		EmployeeVisit.empl_date, EmployeeVisit.employee_id,
	# 		(sql_max - sql_min).alias("cnt")).join(EmployeeVisit).group_by(
	# 		EmployeeVisit.empl_date, EmployeeVisit.employee_id).order_by(EmployeeVisit.employee_id).having(
	# 			sql_max - sql_min > timedelta(hours=8))
	
	# А это недели.
	# res = query.dicts().execute()
	# for elem in res:
	# 	elem['week'] = elem['empl_date'].isocalendar()[1]
	# 	print(elem['empl_date'].isocalendar()[1])

	# query = Employee.select(EmployeeVisit.empl_date).join(EmployeeVisit).group_by(EmployeeVisit.empl_date)
	tmp = Employee.select(
			EmployeeVisit.employee_id).join(EmployeeVisit).group_by(
			EmployeeVisit.empl_date, EmployeeVisit.employee_id).order_by(EmployeeVisit.employee_id).having(
				sql_max - sql_min > timedelta(hours=8))
	query = Employee.select(fn.AVG(datetime.now().year - Employee.birth_date.year))#.where(Employee.id << tmp.employee_id)
	
	print_query_res(tmp)

	# 3.
	print("\nВсе отделы и кол-во сотрудников хоть раз опоздавших за всю историю учета.")
	query = Employee.select(Employee.department, fn.Count(Employee.id.distinct())).join(EmployeeVisit).where(
		EmployeeVisit.empl_time > '09:00').where(EmployeeVisit.time_type==1).group_by(Employee.department)

	print_query_res(query)



def main():
	task_2()
	task_2_orm()

if __name__ == "__main__":
	main()

con.close()