# Author: Nuriiar Safarov
# Date: 29.11.2022
# Description: Data wrandling create_human.R

library(dplyr)
library(tidyverse)

# Reading the Human development and Gender inequality data
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")


# Exploring the data with structure, dimensions, summaries.

str(hd)
summary(hd)

str(gii)
summary(gii)
# Look at the meta files and rename the variables with (shorter) descriptive names.
colnames(hd) <- c('HDI.Rank', 'Country', 'HDI', 'Life.Exp', 'Edu.Exp', 'Edu.Mean', 'GNI', 'GNI-HDI.Rank')
colnames(gii) <- c('GII.Rank', 'Country', 'GII', 'Mat.Mor', 'Ado.Birth', 'Parli.F', 'Edu2.F', 'Edu2.M', 'Labo.F', 'Labo.M')


# Mutate the “Gender inequality” data and create two new variables. The first one is the ratio of Female and Male populations with secondary education in each country. (i.e. edu2F / edu2M). The second new variable should be the ratio of labor force participation of females and males in each country (i.e. labF / labM). 
gii <- mutate(gii, Edu2.FM = gii$Edu2.F / gii$Edu2.M, Labo.FM = gii$Labo.F / gii$Labo.M)

# Joining together the two datasets using the variable Country as the identifier. Keep only the countries in both data sets (Hint: inner join). The joined data should have 195 observations and 19 variables. Call the new joined data "human" and save it in your data folder.
human <- inner_join(hd, gii, by = 'Country')
str(human)

write_csv(human, 'human.csv')

# Please note human.csv has been overwritten by the code for assignment 5 below
# The dimension of human.csv will match the description of Assignment 5, instead of this assignment





# Author: Jue Hou
# Date: 2022-11-18
# Description: Assignment 5

# Load the ‘human’ data into R. Explore the structure and the dimensions of the data and describe the dataset briefly, assuming the reader has no previous knowledge of it (this is now close to the reality, since you have named the variables yourself). (0-1 point)
human <- read_csv('human.csv')
# This dataset originates from the United Nations Development Programme. It is assembled from two datasets: “Human development” and “Gender inequality”. It contains 195 observations and 19 variables. Observations are listed according to the human development index rank, which is also the first column. More detailed metadata can be found at: https://github.com/KimmoVehkalahti/Helsinki-Open-Data-Science/blob/master/datasets/human_meta.txt. Except for the Country column is in string format, the rest of the variables are numbers.

# Mutate the data: transform the Gross National Income (GNI) variable to numeric (using string manipulation). Note that the mutation of 'human' was NOT done in the Exercise Set. (1 point)
human$GNI <- gsub(",", "", human$GNI) %>% as.numeric

# Exclude unneeded variables: keep only the columns matching the following variable names (described in the meta file above):  "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F" (1 point)
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(keep))

# Remove all rows with missing values (1 point).
human <- filter(human, complete.cases(human))

# Remove the observations which relate to regions instead of countries. (1 point)
last <- nrow(human) - 7
human <- human[1:last, ]

# Define the row names of the data by the country names and remove the country name column from the data. The data should now have 155 observations and 8 variables. Save the human data in your data folder including the row names. You can overwrite your old ‘human’ data. (1 point)
country <- human$Country
human <- select(human, -Country)
rownames(human) <- country
write.csv(human, 'human.csv')