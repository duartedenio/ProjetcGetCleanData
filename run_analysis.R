library(dplyr)
library(data.table)
# Suppose data must be in UCI HAR Dataset folder
fNames<- read.table("UCI HAR Dataset/features.txt")
names(fNames)<-c("Position","formula")
aLabels<- read.table("UCI HAR Dataset/activity_labels.txt")
names(aLabels)<-c("idactivity","activity")
#Training
sTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
aTrainY <- read.table("UCI HAR Dataset/train/y_train.txt")
fTrainX <- read.table("UCI HAR Dataset/train/X_train.txt")
#Test
sTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
aTestY <- read.table("UCI HAR Dataset/test/y_test.txt")
fTestX <- read.table("UCI HAR Dataset/test/X_test.txt")

subdata <- rbind(sTrain, sTest)
actdata <- rbind(aTrainY, aTestY)
featdata <- rbind(fTrainX, fTestX)

names(subdata)<-c("subject")
names(actdata)<-c("idactivity")
names(featdata)<-t(fNames[2])

wideTable<-cbind(subdata,actdata,featdata)

wideTable<-wideTable[!duplicated(names(wideTable))]

cTable<-select(wideTable,matches("idactivity|subject|mean|std",ignore.case=TRUE))

cTable<-merge(cTable,aLabels)


names(cTable)<-gsub("-mean()", "Mean", names(cTable), ignore.case = TRUE)
names(cTable)<-gsub("-std()", "STD", names(cTable), ignore.case = TRUE)
names(cTable)<-gsub("-freq()", "Frequency", names(cTable), ignore.case = TRUE)

names(cTable)<-gsub("^t", "Time", names(cTable))
names(cTable)<-gsub("^f", "Frequency", names(cTable))

names(cTable)<-gsub("Acc", "Accelerometer", names(cTable))
names(cTable)<-gsub("Gyro", "Gyroscope", names(cTable))
names(cTable)<-gsub("BodyBody", "Body", names(cTable))
names(cTable)<-gsub("Mag", "Magnitude", names(cTable))
names(cTable)<-gsub("tBody", "TimeBody", names(cTable))
names(cTable)<-gsub("angle", "Angle", names(cTable))
names(cTable)<-gsub("gravity", "Gravity", names(cTable))


cTable$subject <- as.factor(cTable$subject)
cTable <- data.table(cTable)
finalData <-aggregate(. ~subject + activity, cTable, mean)
finalData <-arrange(finalData,subject,activity)
write.table(finalData, file = "Project.txt", row.names = FALSE)

#Done :)
