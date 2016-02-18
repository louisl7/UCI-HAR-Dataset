#I already downloaded and unzipped the files manually
setwd("~/datascienceclass/CleaningData/CDFinalproject/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

#Reading the data from text files into tables using read.table
activityTest  <- read.table("./test/y_test.txt", header = FALSE)
activityTrain <- read.table("./train/y_train.txt", header = FALSE)
subjectTrain <- read.table("./train/subject_train.txt", header = FALSE)
subjectTest  <- read.table("./test/subject_test.txt", header = FALSE)
featuresTest  <- read.table("./test/X_test.txt", header = FALSE)
featuresTrain <- read.table("./train/X_train.txt", header = FALSE)
featuresNames <- read.table("features.txt",head=FALSE)

#Combining the train and test tables using rbind
subjectCombined <- rbind(subjectTrain, subjectTest)
activityCombined   <- rbind(activityTrain, activityTest)
featuresCombined<- rbind(featuresTrain, featuresTest)

#Labeling subject  activity and features
names(subjectCombined)<-c("subject")
names(activityCombined)<- c("activity")
names(featuresCombined)<- featuresNames$V2

#Combining the overall data for subject activity together and then
#combining those with the features data
subjectActivity <- cbind(subjectCombined, activityCombined)
completeData <- cbind(featuresCombined, subjectActivity)

#Extract only the measurement on mean & standard deviation from the data set
subfeaturesNames <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
selectedNames <- c(as.character(subfeaturesNames), "subject", "activity" )
completeData<-subset(completeData,select=selectedNames)

#Appropriately labeling the data set with descriptive variable names.
activityLabels <- read.table("activity_labels.txt",header = FALSE)
names(completeData)<-gsub("^t", "time", names(completeData))
names(completeData)<-gsub("^f", "frequency", names(completeData))
names(completeData)<-gsub("Acc", "Accelerometer", names(completeData))
names(completeData)<-gsub("Mag", "Magnitude", names(completeData))
names(completeData)<-gsub("BodyBody", "Body", names(completeData))

#creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.

library(plyr);
tidyData<-aggregate(. ~subject + activity, completeData, mean)
tidyData<-Data2[order(Data2$subject,Data2$activity),]
write.table(tidyData, file = "tidyData.txt",row.name=FALSE)

#Convert the Rmd files into html
rmarkdown::render("CodeBook.Rmd")
rmarkdown::render("Readme.Rmd")
