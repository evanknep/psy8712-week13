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

# write_csv(employees_tbl, "../data/employees_tbl.csv")
# write_csv(offices_tbl, "../data/offices_tbl.csv")
# write_csv(testscores_tbl, "../data/testscores_tbl.csv")

week13_tbl <- right_join(employees_tbl, testscores_tbl, by = "employee_id") %>% #right join on testscores to remove employees without a test score
  left_join(offices_tbl, by = join_by(city == office)) #left join to only take values from offices that match values in our newly combined employees and testscores data

# write_csv(week13_tbl, "../out/week13.csv")

# Analysis


week13_tbl %>% #in this case since each row represents an employee we can just get the total number of rows. I think you could also just pull the first dimension from the tbl shape, but I could see that being bad practice
  summarise(n())

week13_tbl$employee_id %>% #getting the total number of unique employee_ids. In this case that number is the same as the number of rows
  n_distinct()

week13_tbl %>%
  filter(manager_hire == "N") %>% #removing employees hired as managers
  group_by(city) %>% #grouping and counting by city
  count()

week13_tbl %>%
  group_by(performance_group) %>% #similar approach to above. Split by performance group column, then instead of getting total counts we are returning mean and sd of the yrs_employed column
  summarise(mean = mean(yrs_employed),
            sd = sd(yrs_employed)) 
week13_tbl %>%
  select(employee_id, type, test_score) %>% #selecting necessary columns
  arrange(type, desc(test_score)) #arrange to first sort by alphabetical on type column, then descending values of test_score



    