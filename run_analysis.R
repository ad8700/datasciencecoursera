#libraries
library(tidyverse)
library(reshape2)
#create data directory if not exists
if(!dir.exists("./data")) {
  dir.create("./data")
} else {
  print("Data directory already exists")
}
#Download data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest <- "./data/HARDataset.zip"
download.file(fileUrl, dest)
#unzip data
unzip(dest, exdir="./data")
#create data tables
xTestData <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
yTestData <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
xTrainData <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
yTrainData <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", 
                           col.names = c("Subject"))
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", 
                            col.names=c("Subject"))
features_list <- read.table("./data/UCI HAR Dataset/features.txt", 
                            col.names = c("index", "feature_labels"))
#Merge the training and the test sets to create one data set.
subject_all <- rbind(subject_train, subject_test)
features_data <- rbind(xTestData, xTrainData)
feature_labels <- features_list$feature_labels
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
features_subset <- grepl('mean\\(\\)|std\\(\\)', feature_labels)
feature_list <- as.character(feature_labels[features_subset])
colnames(features_data) <- feature_labels
features_data <- features_data[,features_subset]
#From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject.
activities_all <- rbind(yTestData, yTrainData)
colnames(activities_all)<-"activityLabel"
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt",
                              sep=" ",
                              col.names=c("activityLabel","Activity"))
activities_all <- plyr::join(activities_all, activity_labels, by="activityLabel", 
                             type="left")
activities_all$activityLabel <- NULL
all_df <- cbind(features_data, activities_all, subject_all)
tdf <- melt(all_df, id=c("Subject", "Activity"), measure.vars=feature_list)
tdf <- dcast(tdf, Activity + Subject ~ variable, mean)
tdf <- tdf[order(tdf$Subject, tdf$Activity),]
rownames(tdf) <- 1:nrow(tdf)
write.table(tdf, file="./data/tidy_data.txt")







