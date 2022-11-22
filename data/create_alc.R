#Nuriiar Safarov 18.11.2022 '
# data wrangling excercise for aclohol consuption data from https://archive.ics.uci.edu/ml/datasets/Student+Performance
#Read both student-mat.csv and student-por.csv into R (from the data folder) and explore the structure and dimensions of the data. (1 point)

#Join the two data sets using all other variables than "failures", "paid", "absences", "G1", "G2", "G3" as (student) identifiers.
#Keep only the students present in both data sets. Explore the structure and dimensions of the joined data. (1 point)

#Get rid of the duplicate records in the joined data set. Either a) copy the solution from the exercise "3.3 The if-else structure" 
#to combine the 'duplicated' answers in the joined data, or b) write your own solution to achieve this task. (1 point)

#Take the average of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data. 
#Then use 'alc_use' to create a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise). (1 point)

#Glimpse at the joined and modified data to make sure everything is in order. The joined data should now have 370 observations. 

#Save the joined and modified data set to the ‘data’ folder, using for example write_csv() function (readr package, part of tidyverse). (1 point)

#install.packages("tidyverse")
#install.packages("boot")
#install.packages("readr")
#install.packages("dplyr")
library(tidyverse)
library(readr)
library(dplyr)
library(boot)

#setting the working directory to my data folder
setwd("C:/LocalData/safarov/PhD/ODS/IODS-project_my/data")

#reading two datasets and saving them in object math and por and checking their structure and dimensions
math <- read_delim("student-mat.csv", delim = ";", col_names = TRUE)
por <- read_delim("student-por.csv", delim = ";", col_names = TRUE)
dim(math)
dim(por)
str(por)
str(math)
head(por)

##Joining the two data sets using all other variables than "failures", "paid", "absences", "G1", "G2", "G3" as (student) identifiers and keeping only the students present in both data sets. Explore the structure and dimensions of the joined data
#Geting rid of the duplicate records in the joined data set with if-else structure to combine the 'duplicated' answers in the joined data

free_cols <- c("failures","paid","absences","G1","G2","G3")
join_cols <- setdiff(colnames(por), free_cols)
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))
alc <- select(math_por, all_of(join_cols))
for(col_name in free_cols) {
  two_cols <- select(math_por, starts_with(col_name))
  first_col <- select(two_cols, 1)[[1]]
  if(is.numeric(first_col)) {
    alc[col_name] <- round(rowMeans(two_cols))
  } else {
    alc[col_name] <- first_col
  }
}

# Take the average of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data. 
# Creating a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

#Glimpse at the joined and modified data
glimpse(alc)

#Save the joined and modified data set to the ‘data’ folder as csv file

write_csv(alc, "alcohol.csv", append = FALSE, col_names = TRUE)
