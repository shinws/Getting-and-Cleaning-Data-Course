##1.Merges the training and the test sets to create one data set.
##2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive variable names. 
##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


setwd("c:\\work\\Rwork\\SKMOOC")
getwd()

# read train table
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

x_train

# read test table
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read feature table
features <- read.table('./UCI HAR Dataset/features.txt')

# read activity labels table
activity_labels = read.table('./UCI HAR Dataset/activity_labels.txt')

# colunme naming
# related with No. 3, 4
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activity_labels) <- c('activityId','activityType')

# merging all data in one set
# related with No. 1
allinone_train <- cbind(y_train, subject_train, x_train)
allinone_test <- cbind(y_test, subject_test, x_test)
allinone_set <- rbind(allinone_train, allinone_test)

# colume names
# extract columes for mean, standard deviation
# related with No. 2
col_names <- colnames(allinone_set)
mean_std_col <- (grepl("activityId", col_names) | 
             grepl("subjectId", col_names) |
             grepl("mean..", col_names) |
             grepl("std..", col_names) 
     	     )
mean_std_set <- allinone_set[, mean_std_col == TRUE]

# Activity name add by activityId
mean_std_set_with_name <- merge(mean_std_set, activity_labels, by='activityId', all.x = TRUE)

# create second tidy data set
# aggregate by subjectId & activityId
# and order by subjectId & activityId
# related with No. 5
second_tidy_set <- aggregate(. ~subjectId + activityId, mean_std_set_with_name, mean)
second_tidy_set <- second_tidy_set[order(second_tidy_set$subjectId, second_tidy_set$activityId), ]

write.table(second_tidy_set, "second_tidy_set.txt", row.names = FALSE)

