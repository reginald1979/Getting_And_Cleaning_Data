# include dplyr library
library(dplyr)

# if data directory doesn't exist, create it
if(!file.exists("data")) {
  dir.create("data")
}

# download and extract files
if(!file.exists("UCI HAR Dataset")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile="./data/dataset.zip")
  unzip('./data/dataset.zip', exdir = "./data")
}

# read in feature names
features <- read.table('./data/UCI HAR Dataset/features.txt', col.names = c("id", "feature"))

# get only the required column names
features_subset <- features$feature[grepl("mean|std", features$feature)]

# read in activity labels
activity_labels <- read.table('./data/UCI HAR Dataset/activity_labels.txt', col.names = c("id", "Activity"))

# read in feature data and get only required variables, also apply column names
x_test <- read.table('./data/UCI HAR Dataset/test/X_test.txt', col.names = features$feature)
x_train <- read.table('./data/UCI HAR Dataset/train/X_train.txt', col.names = features$feature)
x_data <- rbind(x_test, x_train)
x_data <- select(x_data, features_subset)

# read in subject data and give descriptive column name
subject_test <- read.table('./data/UCI HAR Dataset/test/subject_test.txt', col.names = "subject")
subject_train <- read.table('./data/UCI HAR Dataset/train/subject_train.txt', col.names = "subject")
subject_data <- rbind(subject_test, subject_train)


# read in activity data and give descriptive column name
y_test <- read.table('./data/UCI HAR Dataset/test/y_test.txt', col.names = "activity")
y_train <- read.table('./data/UCI HAR Dataset/train/y_train.txt', col.names = "activity")
y_data <- rbind(y_test, y_train)
y_data$activity <- activity_labels$Activity[match(y_data$activity, activity_labels$id)]


# merge all data and create final data set
tidy_data <- cbind(x_data, y_data, subject_data)

# create second tidy data with average for each variable for activity and subject 
tidy_data_avg <- tidy_data %>%
                  group_by(activity, subject) %>%
                  summarize_all(mean)

  