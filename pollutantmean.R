setwd("C:/Users/andrew.domenico/OneDrive - Accenture/Documents/Training and Onboarding/Coursera/R Programming/")
library(dplyr)
library(data.table)
pollutantmean <- function(directory, pollutant, id=1:332) {
  #directory is a character vector of length 1 indicating the location of the csv files
  
  #pollutant is a character vector of length 1 indicating the name of the pollutant
  #for which we will calculate the mean; either 'sulfate' or 'nitrate'
  
  #id is an integer vector indicating the monitor id values to be used
  
  #We want to return the mean of the pollutant across all monitors list in the id vector
  #Ignoring NA values.  NOTE: Do not round the results
  
  file_names <- paste0(directory, '/', formatC(id, width=3, flag="0"), ".csv") #make a list of file names width 3 and append .csv
  
  data_table <- lapply(file_names, data.table::fread) %>% #create a data table with all files
    rbindlist()
  
  data_table %>% summarise_at(c(pollutant), mean, na.rm=TRUE) #compute the means of the pollutant
  

}