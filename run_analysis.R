# Importing the library
library(dplyr)

#downloading and unzipping the archive
# filename <- "Coursera_DS3_Final.zip"
# fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(fileURL, filename, method="auto")
# unzip(filename)

# Creting variables
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","formulas"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity_id", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$formulas)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity_id")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$formulas)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity_id")

# Joining tables with x data (10299x561):
x_total <- rbind(x_train, x_test)

# Joining tables with y data (10299x1):
y_total <- rbind(y_train, y_test)

# Joining tables with subject data (10299x1):
subject <- rbind(subject_train, subject_test)

# Columnwise joining of all the previously created data (10299x563):
merged_data <- cbind(subject, y_total, x_total)

# Selecting "subject", "activity_id" and other columns containing "mean" or "std":
mean_std_data <- select(merged_data, subject, activity_id, contains("mean"), contains("std"))

# Replacing ids with word description of activities:
mean_std_data$activity_id <- activities[mean_std_data$activity_id, 2]

# Replacing some of the acronyms by a more descriptive word:
names(mean_std_data)[2] = "activity"

# Replacing "Acc" by "Accelerometer" in the column names
names(mean_std_data)<-gsub("Acc", "Accelerometer", names(mean_std_data))

# Replacing "Gyro" by "Gyroscope" in the column names
names(mean_std_data)<-gsub("Gyro", "Gyroscope", names(mean_std_data))

# Replacing "Mag" by "Magnitude" in the column names
names(mean_std_data)<-gsub("Mag", "Magnitude", names(mean_std_data))

# Replacing "t" by "Time" in the column names
names(mean_std_data)<-gsub("^t", "Time", names(mean_std_data))

# Replacing "f" by "Frequency" in the column names
names(mean_std_data)<-gsub("^f", "Frequency", names(mean_std_data))

# Grouping data to be used for averaging:
grouped_data <- group_by(mean_std_data, subject, activity)

# Taking the average for avery variable and every subject:
data <- summarise_all(grouped_data, funs(mean))

# Creating the final .txt file:
write.table(data, "data.txt", row.name=FALSE)