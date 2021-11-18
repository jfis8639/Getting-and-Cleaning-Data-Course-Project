# GCD Course Project

#### You should create one R script called run_analysis.R that does the following. 

###### Task 1: Merges the training and the test sets to create one data set.

###### Task 2: Extracts only the measurements on the mean and standard deviation for each measurement. 

###### Task 3: Uses descriptive activity names to name the activities in the data set

###### Task 4: Appropriately labels the data set with descriptive variable names. 

###### Task 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Task 1: Merge data

### Task 1a: Download data

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "smart.zip")

unzip("smart.zip")

### Task 1b: Set data filepath

dir <- "~/Documents/Coursera_JHU/Getting-and-Cleaning-Data-Course-Project/"
root_path <- "~/Documents/Coursera_JHU/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset/"
test_path <- "~/Documents/Coursera_JHU/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset/test/"
train_path <- "~/Documents/Coursera_JHU/Getting-and-Cleaning-Data-Course-Project/UCI HAR Dataset/train/"

### Task 1c: Import reference lists

library(dplyr)
activity_labels <- read.delim(paste0(root_path, "activity_labels.txt"), sep = "", header = F)
names(activity_labels) <- c("activityid", "activity")

features <- read.delim(paste0(root_path, "features.txt"), sep = "", header = F)
names(features) <- c("featureid", "feature")

### Task 1d: Import test data

subject_test <- read.delim(paste0(test_path,"subject_test.txt"), header = F)
head(subject_test, 5)
names(subject_test) <- c("subjectid")


x_test <- read.delim(paste0(test_path,"X_test.txt"), sep = "", header = F)
names(x_test) <- tolower(features[,c("feature")])
y_test <- read.delim(paste0(test_path,"y_test.txt"), sep = "", header = F)
names(y_test) <- c("activityid")


### Task 1e: Import training data

subject_train <- read.delim(paste0(train_path,"subject_train.txt"), header = F)
head(subject_train,5)
names(subject_train) <- c("subjectid")


x_train <- read.delim(paste0(train_path,"X_train.txt"), sep = "", header = F)
names(x_train) <- tolower(features[,c("feature")])
y_train <- read.delim(paste0(train_path,"y_train.txt"), sep = "", header = F)
names(y_train) <- c("activityid")


## Task 1f: Join data

test_d <- cbind(subject_test, x_test, y_test)
train_d <- cbind(subject_train, x_train, y_train)
data <- rbind(test_d, train_d)

#### End Task 1


## Task 2: Subset data

names(data)
d <- data %>%
        select(subjectid, activityid, grep("*-mean\\(|*-std", names(data))) 
names(d)

#### End Task 2


## Task 3: Update activity names

d <- d %>% merge(activity_labels, by = "activityid") %>%
            select(subjectid, activityid, activity, 3:ncol(d))

#### End Task 3

## Task 4: Check names (already created at import).

names(d)

## Task 5: Tidy and summarised data

tidy_d <- d %>% group_by(subjectid, activity) %>%
                    summarise_at(vars(-activityid), 
                              ~ mean(.x, na.rm = T)) 

names(tidy_d)[3:ncol(tidy_d)] <- paste0("mymean_",names(tidy_d)[3:ncol(tidy_d)])

write.csv(tidy_d, paste0(root_path, "tidy_averages.csv"))

#### End Task 5