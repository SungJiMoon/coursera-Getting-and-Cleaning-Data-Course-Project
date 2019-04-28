#course project

setwd("F:\\Getting and Cleaning data\\project\\UCI HAR Dataset")


#######################test_set##########################
#subject ids
subjects <- read.table("./test/subject_test.txt") 
colnames(subjects) <- c("subject_id")

#merge with activity names (# Uses descriptive activity names to name the activities in the data set)
activity <- read.table("./test/y_test.txt") 
colnames(activity) <- c("activity")

activity <- dplyr::mutate(activity, activity=ifelse(activity==1, "WALKING",
                                           ifelse(activity==2,"WALKING_UPSTAIRS",
                                                  ifelse(activity==3,"WALKING_DOWNSTAIRS",
                                                            ifelse(activity==4, "SITTING",
                                                                    ifelse(activity==5, "STANDING",
                                                                           ifelse(activity==6, "LAYING",NA)))))))


sub_act <- cbind(subjects, activity)


#set variable names with summary descriptives 
features <- read.table("features.txt")[,2]
features <- levels(features)[as.numeric(features)]

summary <- read.table("./test/X_test.txt") 
colnames(summary) <- features

# Extracts only the measurements on the mean and standard deviation for each measurement.
summary <- summary[,(grepl("mean|std", colnames(summary) ) == T)]


#merge with summury descriptives
test_set <- cbind(sub_act, summary)



#######################train_set##########################
#subject ids
subjects <- read.table("./train/subject_train.txt") 
colnames(subjects) <- c("subject_id")


#merge with activity names (# Uses descriptive activity names to name the activities in the data set)
activity <- read.table("./train/y_train.txt") 
colnames(activity) <- c("activity")


activity <- dplyr::mutate(activity, activity=ifelse(activity==1, "WALKING",
                                                    ifelse(activity==2,"WALKING_UPSTAIRS",
                                                           ifelse(activity==3,"WALKING_DOWNSTAIRS",
                                                                  ifelse(activity==4, "SITTING",
                                                                         ifelse(activity==5, "STANDING",
                                                                                ifelse(activity==6, "LAYING",NA)))))))

sub_act <- cbind(subjects, activity)


#set variable names with summary descriptives 
# Uses descriptive activity names to name the activities in the data set
features <- read.table("features.txt")[,2]
features <- levels(features)[as.numeric(features)]

summary <- read.table("./train/X_train.txt") 
colnames(summary) <- features

# Extracts only the measurements on the mean and standard deviation for each measurement.
summary <- summary[,(grepl("mean|std", colnames(summary) ) == T)]


#merge with summury descriptives
train_set <- cbind(sub_act, summary)


######################################################
# Merges the training and the test sets to create one data set.

merge_set <- rbind(test_set, train_set)

   
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
 
final_data_set <- dplyr::group_by(merge_set,subject_id,activity) %>%
                    dplyr::summarise_all(mean)

colnames(final_data_set)
# Write final table  
write.table(final_data_set,
            "final_data_set",
            row.names=F)


#####making code book####

x <- colnames(final_data_set) %>% as.data.frame() %>%
        dplyr::mutate(New = paste0("Average","_",.))

write.csv(x, "code_book.csv")


