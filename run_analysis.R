#Getting and Cleaning Data Course Project
#Zhehan Tang 2016-6-26

#general requirement: 
##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement.
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names.
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


##read data frames
###feature and activity: set working directory 
setwd("~/Box Sync/2016 Spring/Data Science/Data cleaning/final project/UCI HAR Dataset")
###List of the feature 
features<-read.table("features.txt")
features[,2]<-as.character(features[,2])
###List of activities 
activity<-read.table("activity_labels.txt")
activity[,2]<-as.character(activity[,2])


###training set 
training_set<-read.table("train/X_train.txt")
###training labels 
training_labels<-read.table("train/Y_train.txt")
###subject train file 
training_subject<-read.table("train/subject_train.txt")


###test set 
test_set<-read.table("test/X_test.txt")
###test labels 
test_labels<-read.table("test/Y_test.txt")
###subject test file 
test_subject<-read.table("test/subject_test.txt")

## 1. Merge the training and the test sets to create one data set.
###training data 
training<-cbind(training_set,training_subject, training_labels)
###test data
test<-cbind(test_set,test_subject, test_labels)
###merge training and test together
training_test<-rbind(training, test)
####set names for the entire data set 
colnames(training_test)<-c(features[,2],"subject","activity") 


##2. Extracts only the measurements on the mean and standard deviation for each measurement.
###extract the mean and standard deviation 
training_test_mean_std<-training_test[,(grep("mean|std",names(training_test)))]
###add the final two columns 
training_test_mean_std<-cbind(training_test_mean_std,training_test$subject,training_test$activity)
###change the name of the final two columns 
names(training_test_mean_std)[c(80,81)]<-c("subject","activity")


##3. Uses descriptive activity names to name the activities in the data set
training_test_mean_std<-merge(training_test_mean_std, activity ,by.x="activity",by.y = "V1")[,-1]
names(training_test_mean_std)[81]<-"activity"


##4. Appropriately labels the data set with descriptive variable names.
#(1)change t to time
names(training_test_mean_std)<-gsub("^t","time",names(training_test_mean_std))
#(2)change f to frequency
names(training_test_mean_std)<-gsub("^f","frequency",names(training_test_mean_std))
#(3)change Acc to acceleration
names(training_test_mean_std)<-gsub("Acc","Acceleration",names(training_test_mean_std))
#(4)change Mag to Magnitude
names(training_test_mean_std)<-gsub("Mag","Magnitude",names(training_test_mean_std))
#(5)change -mean to Mean
names(training_test_mean_std)<-gsub("-mean","Mean",names(training_test_mean_std))
#(6)change -std to Standard Deviation
names(training_test_mean_std)<-gsub("-std","StdDev",names(training_test_mean_std))
#(7)remove ()
names(training_test_mean_std)<-gsub("\\()","",names(training_test_mean_std))


##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
###use group_by function in dplyr package
tidydata<-training_test_mean_std %>%
    group_by(subject, activity) %>%
    summarise_each(funs(mean)) #use summarise_each, because there're two groups
###write the table out
write.table(tidydata, file = "/Users/apple/Box Sync/2016 Spring/Data Science/Data cleaning/final project/tidydata", row.names = FALSE)


