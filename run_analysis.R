library(readr)
library(tidyr)
library(stringr)
library(dplyr)

# setwd("~/Dropbox/My Slide Rule/Foundations of Data Science/Data Wrangling Project")

path <- file.path("UCI HAR Dataset")
files <- list.files(path, recursive=TRUE)
files

# You should create one R script called run_analysis.R that does the following:

# -----------------------------------------------------------------------------
# 1. Merges the training and the test sets to create one data set.

# Train
xtrain <- read_table("./UCI HAR Dataset/train/X_train.txt", col_names = FALSE)
xsubject_train <- read_table("./UCI HAR Dataset/train/subject_train.txt" , col_names = FALSE) %>% rename(SUBJECT=X1)
ytrain <- read_table("./UCI HAR Dataset/train/y_train.txt" , col_names = FALSE) %>% rename(ACTIVITY=X1)

# Test
xtest <- read_table("./UCI HAR Dataset/test/X_test.txt", col_names = FALSE)
xsubject_test <- read_table("./UCI HAR Dataset/test/subject_test.txt" , col_names = FALSE) %>% rename(SUBJECT=X1)
ytest <- read_table("./UCI HAR Dataset/test/y_test.txt" , col_names = FALSE) %>% rename(ACTIVITY=X1)

# Features
features <- read.table("./UCI HAR Dataset/features.txt")

# Bind datasets
df <- bind_rows(xtrain, xtest)
names(df) <- features$V2

# -----------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
extract <- df[, grepl("mean|std",colnames(df))]

# -----------------------------------------------------------------------------
# 3. Uses descriptive activity names to name the activities in the data set
activity <- read.table("./UCI HAR Dataset/activity_labels.txt") %>% rename(ACTIVITY=V1, ACTIVITY_NAME=V2)
activity_names <- bind_rows(ytrain, ytest) %>% left_join(activity)

# -----------------------------------------------------------------------------
# 4. Appropriately labels the data set with descriptive variable names.
extract_activity_names <- bind_cols(activity_names, extract)

# -----------------------------------------------------------------------------
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
subject <- bind_rows(xsubject_train, xsubject_test)
bd <- bind_cols(subject, extract_activity_names)

tidy <- bd %>% select(-ACTIVITY) %>% group_by(SUBJECT, ACTIVITY_NAME) %>% summarise_each(funs(mean))
