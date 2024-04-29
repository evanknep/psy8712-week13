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

write_csv(employees_tbl, "../data/employees_tbl.csv")
write_csv(offices_tbl, "../data/offices_tbl.csv")
write_csv(testscores_tbl, "../data/testscores_tbl.csv")

week13_tbl <- right_join(employees_tbl, testscores_tbl, by = "employee_id") %>% #right join on testscores to remove employees without a test score
  left_join(offices_tbl, by = join_by(city == office))


