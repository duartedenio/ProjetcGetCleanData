# ProjetcGetCleanData
Cleaning and Getting Data Final Project

# Code Book
Here you find how create a tidy data based on the course final project

## Steps

Unzip getdata_projectfiles_UCI HAR Dataset.zip file

Go to R environment

Load required libraries: dplyr and data.table

Load metadata into memory: fNames (features) and aLabels (activities)

fNames<- read.table("UCI HAR Dataset/features.txt")

names(fNames)<-c("Position","formula")

aLabels<- read.table("UCI HAR Dataset/activity_labels.txt")

names(aLabels)<-c("idactivity","activity")

Load data into main memory

###Training
sTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

aTrainY <- read.table("UCI HAR Dataset/train/y_train.txt")

fTrainX <- read.table("UCI HAR Dataset/train/X_train.txt")

###Test
sTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

aTestY <- read.table("UCI HAR Dataset/test/y_test.txt")

fTestX <- read.table("UCI HAR Dataset/test/X_test.txt")

##First part:

Merge the training and the test sets to create one data set.

subdata <- rbind(sTrain, sTest)

actdata <- rbind(aTrainY, aTestY)

featdata <- rbind(fTrainX, fTestX)

Raname columns of the datasets

names(subdata)<-c("subject")

names(actdata)<-c("idactivity")

names(featdata)<-t(fNames[2])

merge all datasets

wideTable<-cbind(subdata,actdata,featdata)

##Second Part

Extracts only the measurements on the mean and standard deviation for each measurement.

As I found duplicate varible names, I ran:

wideTable<-wideTable[!duplicated(names(wideTable))]

Create a new dt with only variables named *mean* or *std* (besides activity and subject)

cTable<-select(wideTable,matches("idactivity|subject|mean|std",ignore.case=TRUE))

##Third Part

Uses descriptive activity names to name the activities in the data set

cTable<-merge(cTable,aLabels)

## Fourth Part
 
Firstly, mean and std become Mean and STD

names(cTable)<-gsub("-mean()", "Mean", names(cTable), ignore.case = TRUE)

names(cTable)<-gsub("-std()", "STD", names(cTable), ignore.case = TRUE)

names(cTable)<-gsub("-freq()", "Frequency", names(cTable), ignore.case = TRUE)

t and f are Time and Frequency, respectively

names(cTable)<-gsub("^t", "Time", names(cTable))
names(cTable)<-gsub("^f", "Frequency", names(cTable))

Same reasoning for the rest

names(cTable)<-gsub("Acc", "Accelerometer", names(cTable))

names(cTable)<-gsub("Gyro", "Gyroscope", names(cTable))

names(cTable)<-gsub("BodyBody", "Body", names(cTable))

names(cTable)<-gsub("Mag", "Magnitude", names(cTable))

names(cTable)<-gsub("tBody", "TimeBody", names(cTable))

names(cTable)<-gsub("angle", "Angle", names(cTable))

names(cTable)<-gsub("gravity", "Gravity", names(cTable))

##Fifth Part

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

cTable$subject <- as.factor(cTable$subject)

cTable <- data.table(cTable)

finalData <-aggregate(. ~subject + activity, cTable, mean)

finalData <-arrange(finalData,subject,activity)

write.table(finalData, file = "Project.txt", row.names = FALSE)

##Done :)
