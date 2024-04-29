# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(dplyr)
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
