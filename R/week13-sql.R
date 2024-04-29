# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(RMariaDB)



# Data Import and Cleaning
conn <- dbConnect(MariaDB(),
                  user = "knepx001",
                  password = key_get("latis-mysql", "knepx001"),
                  host = "mysql-prod5.oit.umn.edu",
                  port = 3306,
                  ssl.ca = "../mysql_hotel_umn_20220728_interm.cer")

dbGetQuery(conn, "SHOW DATABASES;")
result1 <- dbExecute(conn, "USE cla_tntlab;") 
employees_tbl <- dbGetQuery(conn, "SELECT * FROM datascience_employees")
offices_tbl <- dbGetQuery(conn, "SELECT * FROM datascience_offices")
testscores_tbl <- dbGetQuery(conn, "SELECT * FROM datascience_testscores")



q1 <- dbGetQuery(conn, 
                 "SELECT COUNT(*) AS num_managers
                      FROM datascience_employees
                      RIGHT JOIN datascience_testscores
                      ON datascience_employees.employee_id=datascience_testscores.employee_id;")

q1


q2 <- to_see_1 <- dbGetQuery(conn,
                             "SELECT COUNT(DISTINCT datascience_employees.employee_id) AS unique_count
                                 FROM datascience_employees
                                 RIGHT JOIN datascience_testscores
                                 ON datascience_employees.employee_id=datascience_testscores.employee_id;")
q2



q3 <- dbGetQuery(conn, 
                 "SELECT city, COUNT(datascience_employees.employee_id) AS num_managers
                                 FROM datascience_employees
                                 RIGHT JOIN datascience_testscores
                                 ON datascience_employees.employee_id=datascience_testscores.employee_id
                                 WHERE manager_hire = 'N'
                                 GROUP BY city;")
q3


q4 <- dbGetQuery(conn, 
                 "SELECT performance_group, AVG(yrs_employed) AS mean_yrs_employed, STDDEV(yrs_employed) AS stddev_yrs_employed
                                 FROM datascience_employees
                                 RIGHT JOIN datascience_testscores
                                 ON datascience_employees.employee_id=datascience_testscores.employee_id
                                 GROUP BY performance_group;")
q4

q5 <- dbGetQuery(conn, 
                 "SELECT datascience_employees.employee_id, type, test_score
                                  FROM datascience_employees
                                  RIGHT JOIN datascience_testscores
                                  ON datascience_employees.employee_id=datascience_testscores.employee_id 
                                  LEFT JOIN datascience_offices
                                  ON datascience_employees.city=datascience_offices.office
                                  ORDER BY type, test_score DESC;")
q5
