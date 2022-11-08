#Nuriiar Safarov 13.11.2022 Assignment 2. Data set from http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt
#opening relevant libraries, reading data, subsetting dataset to delete missing values in points==0
library(tidyverse)
library(readr)
library(dplyr)
lrn_data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
lrn_data2 <- subset(lrn_data, Points != 0)
#exploring data
View(lrn_data2)
str(lrn_data2)
dim(lrn_data2)
#creating varialbes for column names and selecting those variables and assigning them to new colums of original data as row means
deep_colnames <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
deep_col <- select(lrn_data2, one_of(deep_colnames))
lrn_data2$deep <- rowMeans(deep_col)
surf_colnames <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
surf_col <- select(lrn_data2, one_of(surf_colnames))
lrn_data2$surf <- rowMeans(surf_col)
stra_colnames <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
stra_col <- select(lrn_data2, one_of(stra_colnames))
lrn_data2$stra <- rowMeans(stra_col)

str(lrn_data2)

#select only 7 variables of interest to create lrn_analysis data set, unifying column names, checking did it work
lrn_analysis <- lrn_data2[, c("gender","Age","Attitude", "deep", "stra", "surf", "Points")]
str(lrn_analysis)
colnames(lrn_analysis)[2] <- "age"
colnames(lrn_analysis)[7] <- "points"
colnames(lrn_analysis)[3] <- "attitude"
str(lrn_analysis)

#writing new data set into csv file lrn_analysis.csv and checking have that worked
write_csv(lrn_analysis, "lrn_analysis.csv", append = FALSE, col_names = TRUE)
lrn_csv <- read_csv("lrn_analysis.csv",col_names = TRUE)
head(lrn_csv)
str(lrn_csv)

