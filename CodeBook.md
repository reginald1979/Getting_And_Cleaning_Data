---
title: "Getting And Cleaning Data"
author: "Reginald Bryant"
date: "7/24/2019"
output: html_document
---

## Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A R script called run_analysis.R is created and does the following:

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## include necessary libraries

```{r}
library(dplyr)
```

## download and unzip data

```{r}
if(!file.exists("data")) {
  dir.create("data")
}

if(!file.exists("UCI HAR Dataset")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile="./data/dataset.zip")
  unzip('./data/dataset.zip', exdir = "./data")
}
```

## read in feature names

```{r}
features <- read.table('./data/UCI HAR Dataset/features.txt', col.names = c("id", "feature"))
```


## get only required columns (mean, std)
```{r}
features_subset <- features$feature[grepl("mean|std", features$feature)]
str(features_subset)
```

## read in activity labels

```{r}
activity_labels <- read.table('./data/UCI HAR Dataset/activity_labels.txt', col.names = c("id", "Activity"))
```

## read in feature data and get only required variables, also apply column names
```{r}
x_test <- read.table('./data/UCI HAR Dataset/test/X_test.txt', col.names = features$feature)
x_train <- read.table('./data/UCI HAR Dataset/train/X_train.txt', col.names = features$feature)
x_data <- rbind(x_test, x_train)
x_data <- select(x_data, features_subset)
```
```{r}
str(x_data)
```

## read in subject data and give descriptive column name
```{r}
subject_test <- read.table('./data/UCI HAR Dataset/test/subject_test.txt', col.names = "subject")
subject_train <- read.table('./data/UCI HAR Dataset/train/subject_train.txt', col.names = "subject")
subject_data <- rbind(subject_test, subject_train)
```

## read in activity data and give descriptive column name
```{r}
y_test <- read.table('./data/UCI HAR Dataset/test/y_test.txt', col.names = "activity")
y_train <- read.table('./data/UCI HAR Dataset/train/y_train.txt', col.names = "activity")
y_data <- rbind(y_test, y_train)
```

## merge all data and create final data set
```{r}
y_data$activity <- activity_labels$Activity[match(y_data$activity, activity_labels$id)]
tidy_data <- cbind(x_data, y_data, subject_data)
```

```{r}
str(tidy_data)
```

## create second tidy data with average for each variable for activity and subject 
```{r}
tidy_data_avg <- tidy_data %>%
                  group_by(activity, subject) %>%
                  summarize_all(mean)
```

```{r}
str(tidy_data_avg)
```