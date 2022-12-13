#Nuriiar Safarov
#Data wrangling ass.6

#importing libraries
library(dplyr)
library(tidyr)

#reading datasets.
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)
rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep ="\t", header = T)
# Look at the (column) names of BPRS
names(BPRS)
head(BPRS)
names(rats)
head(rats)

# Look at the structure of BPRS
str(BPRS)
str(rats)

# Print out summaries of the variables
summary(BPRS)
summary(rats)

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

rats$Group <- factor(rats$Group)
rats$ID <- factor(rats$ID)
head(rats)
# Convert to long form
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks) #order by weeks variable
head(BPRSL)

ratslong <-  pivot_longer(rats, cols = -c(ID, Group),
                       names_to = "times", values_to = "RATS") %>%
  arrange(times) #order by times variable
head(ratslong)

# Extract the week and times number

BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5,5)))
ratslong <-  ratslong %>% mutate(time = as.integer(substr(times, 3,3)))

# Take a glimpse at the data, compare the wide and long formats.
glimpse(BPRSL)
glimpse(BPRS)

glimpse(ratslong)
glimpse(rats)

dim(BPRSL)
dim(BPRS)

dim(ratslong)
dim(rats)

#the long datasets are viewing the time series as extra rows, that enables more analysis. The wide format stores the different points in time in columns that is not so suitable for analysis.

#writing the data
write.table(BPRSL, "BPRSL.txt", row.names = TRUE)
read.table(file.path(".", "data", "BPRSL.txt"))

write.table(ratslong, "ratslong.txt", row.names = TRUE)
read.table(file.path(".", "data", "ratslong.txt"))