## 
## 0) Obtaining the raw data
## -- create directory to store the raw datafile locally
setwd("D:/Coursera/Getting and Cleaning data/GetDataCourseProject")

## create data dir 
data_dir = ".data"
if(!file.exists(data_dir)) {
   dir.create(data_dir)
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
## enable https-download on windows
setInternet2(TRUE)

## mode = wb  downloading in binary mode
zipfile = "./data/Dataset.zip"
download.file(fileUrl, destfile = zipfile , mode="wb")

unzip_dir = "./data/unzipped"
if(!file.exists(unzip_dir)) {
   dir.create(unzip_dir)
}

unzip_check = "./data/unzipped/UCI HAR Dataset"
if( file.exists(unzip_dir) && !file.exists(unzip_check) ){
   unzip( zipfile, exdir=unzip_dir)
}

## Determine the original variable_names 
features_df = read.table("./data/unzipped/UCI HAR Dataset/features.txt", 
                          stringsAsFactors = FALSE,
                          col.names = c("colNum", "varName"))

## Determine mean() and std() variables
features_df$isMeanVariable <- grepl("mean()", features_df$varName, fixed=TRUE)
features_df$isStdVariable <- grepl("std()", features_df$varName, fixed=TRUE)

## Ensure that only mean() and std() variables are extracted 
features_df$rclass <- rep("NULL", length(features_df$colNum))
features_df$rclass[ features_df$isMeanVariable | features_df$isStdVariable ] <- "numeric"

## 1) Training and the test sets are merged to create one data set
##
## --generate training_set (7352 obs)
training_subject_df = read.table("./data/unzipped/UCI HAR Dataset/train/subject_train.txt", 
                                 col.names = "SubjectId")
training_activity_df = read.table("./data/unzipped/UCI HAR Dataset/train/y_train.txt", 
                                  col.names ="ActivityClass")
training_data_df = read.table("./data/unzipped/UCI HAR Dataset/train/X_train.txt", 
                              col.names = features_df$varName, 
                              colClasses=features_df$rclass)
training_set = cbind(training_subject_df, training_activity_df, training_data_df)
training_set$originalSet <- rep("training",length(training_set$SubjectId))
##
## --generate test_set (2947 obs)
test_subject_df = read.table("./data/unzipped/UCI HAR Dataset/test/subject_test.txt", 
                             col.names = "SubjectId")
test_activity_df = read.table("./data/unzipped/UCI HAR Dataset/test/y_test.txt", 
                              col.names ="ActivityClass")
test_data_df = read.table("./data/unzipped/UCI HAR Dataset/test/X_test.txt", , 
                              col.names = features_df$varName, 
                              colClasses=features_df$rclass)
test_set = cbind(test_subject_df, test_activity_df, test_data_df)
test_set$originalSet <- rep("test",length(test_set$SubjectId))
##
## -- merging the sets (10299 obs)
## -- Using the original variable names as with descriptive variable names
## -- in addition to the 3 new variables : originalSet, SubjectId, ActivityClass
full_set = rbind(training_set, test_set)

full_set$originalSet   <- as.factor(full_set$originalSet)
full_set$SubjectId     <- as.factor(full_set$SubjectId)

## Add descriptive activity names to name the activities in the data sets
activity_df <- read.table( "./data/unzipped/UCI HAR Dataset/activity_labels.txt")
activityLabels = tolower(levels(activity_df$V2))
full_set$ActivityClass = factor(full_set$ActivityClass, labels=activityLabels)

## Creation of a second, independent tidy data set with the average of each variable for activity and each subject
library(plyr)
result = ddply(full_set, .(ActivityClass, SubjectId), numcolwise(mean))
write.table(result,file="./tidy_data.txt",row.name=FALSE)
