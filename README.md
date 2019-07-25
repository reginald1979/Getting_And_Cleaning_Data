# Getting And Cleaning Data Course Project

This repository contains the following files:

# 1) run_analysis.R
This script...
- downloads the raw data files from the provided url
- merges the test and training features data
- merges the test and training activity data
- merges the test and training subject data
- merges all of the data into a single data frame
- gives the columns meaningful names
- takes only the mean and standard deviation measurement columns
- replaces the activity id value with the activity description
- creates a separate tidy data frame with the average of each variable for each activity and each subject

# 2) CodeBook.rmd
This is the raw markdown file that describes all of the steps that run_analysis.R performs on the raw data.

# 3) CodeBook.html
This is the html output of the knit command that was executed on CodeBook.rmd. 
It contains the neatly formatted html of all of the activities contained in CodeBook.rmd.
