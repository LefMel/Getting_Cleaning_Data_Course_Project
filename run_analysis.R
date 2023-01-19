# Getting and Cleaning Data Course Project

getwd()

# Download and unzip Data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "raw_data.zip")
?unzip
unzip("raw_data.zip")
list.files()

# Load data
?read.table
features = read.table(file = "UCI HAR Dataset/features.txt", col.names = c("Feat_ID", "Feature"))
labels = read.table(file = "UCI HAR Dataset/activity_labels.txt", col.names = c("Lab_ID","Label"))
X_test = read.table(file = "UCI HAR Dataset/test/X_test.txt", col.names = features$Feature)
y_test = read.table(file = "UCI HAR Dataset/test/y_test.txt", col.names = "Lab_ID")
subject_test = read.table(file = "UCI HAR Dataset/test/subject_test.txt", col.names = "Subject_ID")
X_train = read.table(file = "UCI HAR Dataset/train/X_train.txt", col.names = features$Feature)
y_train = read.table(file = "UCI HAR Dataset/train/y_train.txt", col.names = "Lab_ID")
subject_train = read.table(file = "UCI HAR Dataset/train/subject_train.txt", col.names = "Subject_ID")

Test_data = cbind(X_test, subject_test, y_test)
Train_data = cbind(X_train, subject_train, y_train)

data = rbind(Train_data, Test_data)

# Extract only the measurements on the mean and standard deviation for each measurement
library(dplyr)
?contains
sum_data = data %>% select(Lab_ID, Subject_ID, contains('mean', ignore.case = TRUE), contains("std", ignore.case = TRUE))
head(sum_data)

# Use descriptive activity names to name the activities in the data set
sum_data$LabelName = labels[sum_data$Lab_ID,2]

# Appropriately label the data set with descriptive variable names
names(sum_data)
# Acc - Accelerometer
# Jerk - Jerk signals
# Gyro - Gyroscope 
# Mag - Magnitude
# t - Time
# f - Frequency 
# ang - Angle
# Gravity
# Body - Body
# mean - Mean
# std - St_Dev

# gsub(pattern, replacement, x = variable, ignore.case = TRUE) # will replace all the patterns 

names(sum_data) = gsub("acc", "Accelerometer", names(sum_data), ignore.case = TRUE)
names(sum_data) = gsub("gyro", "Gyroscope", names(sum_data), ignore.case = TRUE)
names(sum_data) = gsub("mag", "Magnitude", names(sum_data), ignore.case = TRUE)
names(sum_data) = gsub("angle", "Angle", names(sum_data), ignore.case = TRUE)
names(sum_data) = gsub("gravity", "Gravity", names(sum_data), ignore.case = TRUE)
names(sum_data) = gsub("BodyBody", "Body", names(sum_data), ignore.case = FALSE)
names(sum_data) = gsub("^t", "Time", names(sum_data), ignore.case = FALSE)
names(sum_data) = gsub("Freq", "Frequency", names(sum_data), ignore.case = TRUE)
names(sum_data) = gsub("^f", "Frequency", names(sum_data), ignore.case = FALSE)
names(sum_data) = gsub("mean", "Mean", names(sum_data), ignore.case = TRUE)
names(sum_data) = gsub("std", "St_Dev", names(sum_data), ignore.case = TRUE)
names(sum_data)


# Average of each variable for each activity and each subject
?summarise_all
final_data <- sum_data %>% group_by(Subject_ID, LabelName) %>% summarize_all(.funs = mean)
?write.table
write.table(final_data, "final_data.txt", row.names= FALSE)





