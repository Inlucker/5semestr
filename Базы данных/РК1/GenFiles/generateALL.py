from faker import Faker
from random import randint
from random import choice


color = ["red", "green", "blue", "yellow", "white", "black"]

def generateCars(records_number):
    faker = Faker()
    f = open('Cars.csv', 'w')
    for i in range(records_number):
        line = "{0}|{1}|{2}|{3}\n".format(faker.word(),
                                          choice(color),
                                          2021,
                                          faker.date_this_year())     
        f.write(line)
    f.close()
    print("Finished generating Cars")

def generateDrivers(records_number):
    faker = Faker()
    f = open('Drivers.csv', 'w')
    for i in range(records_number):
        line = "{0}|{1}|{2}\n".format(faker.word(),
                                      faker.name(),
                                      faker.msisdn())     
        f.write(line)
    f.close()
    print("Finished generating Drivers")

def generateDriversCars(records_number):
    faker = Faker()
    f = open('DriversCars.csv', 'w')
    for i in range(records_number):
        driver_id = randint(1, records_number)
        car_id = randint(1, records_number)
        line = "{0}|{1}\n".format(driver_id,
                                  car_id)        
        f.write(line)
    f.close()
    print("Finished generating DriversCars")

def generateFines(records_number):
    faker = Faker()
    f = open('Fines.csv', 'w')
    for i in range(records_number):
        driver_id = randint(1, records_number)
        amount = float(randint(100000,1000000)/100)
        line = "{0}|{1}|{2}|{3}\n".format(driver_id,
                                          faker.word(),
                                          amount,
                                          faker.date_this_year())     
        f.write(line)
    f.close()
    print("Finished generating Fines")

RECORDS_N = 1000

generateDrivers(RECORDS_N)
generateCars(RECORDS_N)
generateDriversCars(RECORDS_N)
generateFines(RECORDS_N)
