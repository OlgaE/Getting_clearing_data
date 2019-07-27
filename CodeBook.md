---
title: "Code Book"
author: "me"
date: "27 07 2019"
output: html_document
---

## The steps the original data was modified:

1. The training and test sets were merged to create one data set (using rbind and cbind)
2. The measurements on the mean and standard deviation were extracted for each measurement (using select() function).
3. Descriptive activity names were added to the data set
4. Data sets were named with descriptive variable names
5. Independent tidy data set with the average of each variable for each activity and each subject was created.

## About the data:
1) *x_train*, *y_train*, *x_test*, *y_test*, *subject_train* and *subject_test* contain the data from the downloaded archive.

2) *x_total* is obtained by binding the x_train with x_test (rbind(x_train, x_test))
3) *y_total* is obtained by binding the y_train with y_test (rbind(y_train, y_test))
4) *subject* is obtained by binding the subject_train and subject_test (rbind(subject_train, subject_test))
5) *merged_data* is obtained by binding subject, y_total, x_total (cbind(subject, y_total, x_total))
6) *mean_std_data* is obtained by selecting columns containing *mean* or *std* (select(merged_data, subject, activity_id, contains("mean"), contains("std")))
7) *grouped_data* data grouped by *subject* and *activity* (group_by(mean_std_data, subject, activity))
8) *data* is obtained by averaging all variables for each subject (summarise_all(grouped_data, funs(mean)))