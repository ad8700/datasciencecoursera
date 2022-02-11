#Write a function that reads a directory full of files and reports the number 
#of completely observed cases in each data file. 
#The function should return a data frame where the first column is the name 
#of the file and the second column is the number of complete cases. 

#Set the working directory for where the data files are located
setwd("C:/Users/andrew.domenico/OneDrive - Accenture/Documents/Training and Onboarding/Coursera/R Programming")

library(dplyr)
library(data.table)

complete <- function(directory, id=1:332) {
  file_names <- paste0(directory, '/', formatC(id, width=3, flag="0"), ".csv")
  data_table <- lapply(file_names, data.table::fread) %>% 
    rbindlist()
  data_table %>%
    filter(complete.cases(data_table)) %>%
    group_by(ID) %>%
    summarise(cases=n())
}