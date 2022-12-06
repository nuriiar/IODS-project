# Author: Nuriiar Safarov
# Date: 05.12.2022
# Description: Data wrandling create_human.R

library(dplyr)
library(tidyverse)

# Reading the Human development index and Gender inequality data. Original source is https://hdr.undp.org/data-center/human-development-index#/indicies/HDI

hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")


# Exploring the data with structure, dimensions, summaries.

str(hd)
dim(hd)
summary(hd)
colnames(hd)

str(gii)
dim(gii)
summary(gii)
colnames(gii)
# Look at the meta files and rename the variables with (shorter) descriptive names.
colnames(hd) <- c('HDI.Rank', 'Country', 'HDI', 'Life.Exp', 'Edu.Exp', 'Edu.Mean', 'GNI', 'GNI-HDI.Rank')
colnames(gii) <- c('GII.Rank', 'Country', 'GII', 'Mat.Mor', 'Ado.Birth', 'Parli.F', 'Edu2.F', 'Edu2.M', 'Labo.F', 'Labo.M')


# Mutate the “Gender inequality” data and create two new variables. The first one is the ratio of Female and Male populations with secondary education in each country. (i.e. edu2F / edu2M). The second new variable should be the ratio of labor force participation of females and males in each country (i.e. labF / labM). 
gii <- mutate(gii, Edu2.FM = gii$Edu2.F / gii$Edu2.M, Labo.FM = gii$Labo.F / gii$Labo.M)

# Joining together the two datasets using the variable Country as the identifier. Keep only the countries in both data sets (Hint: inner join). The joined data should have 195 observations and 19 variables. Call the new joined data "human" and save it in your data folder.
human <- inner_join(hd, gii, by = 'Country')
str(human)

write_csv(human, 'human.csv')
human <- read_csv('human.csv')
head(human)


#assignment 5, overwrting the human file for analysis

#reading the data into human1 object and seeing its structure. More on data in the beginning of the .R file
human1 <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human1.txt", header = T, sep = ",")
str(human1)
colnames(human1)

#mutating the GNI variable to numeric
head(human1)
class(human1$GNI)
human1$GNI <- gsub(",", ".", human1$GNI) %>% as.numeric

#checking did it work
class(human1$GNI)
head(human1)

# Exclude unneeded variables: keep only the columns matching the following variable names (described in the meta file above):  "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F" (1 point)

keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human1 <- select(human1, one_of(keep))

# Remove all rows with missing values
comp <- complete.cases(human1)
human1 <- filter(human1, complete.cases(human1))

#Removing regiouns and leaving only countries
tail(human1)
last <- nrow(human1) - 7
human1 <- human1[1:last, ]
rownames(human1) <- human1$Country
head(human1)
#deleting country variable
human1 <- select(human1, -Country)

write.csv(human1, 'human.csv')
