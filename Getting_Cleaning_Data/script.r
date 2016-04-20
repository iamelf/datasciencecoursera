library(dplyr)

#########
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#########

#  This is a subfunctin that 
#  1. locates the row # of mean and standard deviation data. ((assignment creteria #2)
#  2. generate descriptive variable names (assignment creteria #4)
locateCol <- function() {
  # Read all features
  message("Locate measurements for mean and standard deviation.")
  fPath <- "features.txt"
  fList <- read.csv(fPath, header = FALSE, sep = " ", col.names = c("colId", "desc"))
  # find the row # for the features with "mean()" and "std()"
  t <- fList[grep("mean|std()", fList$desc),]
  message("Create descriptable variable names.")
  t$desc <- gsub("()", "", t$desc, fixed=TRUE)
  t$desc <- gsub("-", ".", t$desc, fixed=TRUE)
  t$desc <- tolower(t$desc)
  return (t)
  
}

# This is a subfunction that translate activity type (numeric) to descriptive activity names
# Assignment creteria #3: Uses descriptive activity names to name the activities in the data set
getActivities <- function(x) {
  message("Translate activity type to descriptive activity names.")
  actFile <- "activity_labels.txt"
  actList <- read.csv(actFile, header = FALSE, sep="")
  names(actList) <- c("ActivityType", "ActivityName")
  actNames <- as.character()
  for (i in x) {
    t <- as.character(actList$ActivityName[match(i, actList$ActivityType)])
    actNames <- append(actNames, t)
  }
  actNames
}

# This is a subfunction that 
# 1. reads data from file
# 2. calls subfunctions to transform data 
# 3. generate data set that meet assignment creteria #2, #3, #4
getMeasurements <- function(dataType) {
  if (dataType != "train" && dataType != "test") {
    stop("Wrong data set: ", dataType)
  }
  
  subjectFile <- file.path(dataType, paste0("subject_", dataType, ".txt"));
  activityFile <- file.path(dataType, paste0("Y_", dataType, ".txt"));
  dataFile <- file.path(dataType, paste0("X_", dataType, ".txt"));
  
  loc <- locateCol()
  message("Reading and arranging ", dataType, " data...")
  sub <- read.csv(subjectFile, head=FALSE)[[1]]
  act <- read.csv(activityFile, head=FALSE)[[1]]
  obs <- read.csv(dataFile, sep= "", header=FALSE)
  obs <- obs[, loc$colId];
  names(obs) <- loc$desc;
  
  obs$activity <- getActivities(act);
  
  obs$subject <- sub;
  
  #rearragne the column order, so the subject & activity are the first 2 columns
  n <- ncol(obs)
  t <- c(n-1, n, 1:(n-2))
  obs <- obs[,t]
  
  return (obs)
}

# This is a main function to merge the measurements data for "test" and "train"
# the output meets assignment creteria #1, #2, #3, #4
# The merged data is writting to file "measurements.csv"
mergeDataSets <- function() {
  
  # merge test and train measurements for mean & std
  testData <- getMeasurements("test")
  trainData <- getMeasurements("train")
  
  message("Combining data for train and test...")
  combined <- rbind(trainData, testData)
  
  
  # dump into file
  destFile <- file.path(getwd(), "cleanData");
  
  if (!dir.exists(destFile)) {
    dir.create(destFile)
  }
  destFile <- file.path(destFile, "measurements.csv");
  
  message("Combined data for test and train written to: ", destFile)
  
  write.csv(combined, file=destFile, row.names = FALSE)
  return(combined)
}


# This is the main function to merge the "Inertial Signals" data for "test" and "train"
# The merged data is written into files under directory "Inertial Signals"
mergeSignals <- function() {
  message("Merging Inertial Signals for test and train...")
  signalDataPath <- file.path(cleanDataPath, "Inertial Signals");
  if (!dir.exists(signalDataPath)) {
    dir.create(signalDataPath)
  }
  testPath <- file.path("test", "Inertial Signals")
  trainPath <- file.path("train", "Inertial Signals")
  fnames <- dir(testPath);
  for (testFile in fnames) {
    trainFile <- sub("test", "train", testFile)
    testData <- read.csv(file.path(testPath,testFile), sep="", header=FALSE)
    trainData <- read.csv(file.path(trainPath, trainFile), sep = "", header=FALSE)
    
    combined <- rbind(trainData, testData)
    
    cleanFile <- sub(".txt", ".csv", sub("_test", "", testFile))
    
    write.csv(combined, file=file.path(signalDataPath, cleanFile), row.names = FALSE)
  }
  message("Merged Inertial Signals data written to: ", signalDataPath)
}


# This is the main function to generate summary: average of each variable for each activity and each subject
# the output meet assignment creteria #5
# The summary data is writting to "summary.csv"
createSummary <- function (t) {
  message("Creating summary for the average of each variable for each activity and each subject...")
  s <- t %>% group_by(subject, activity) %>% summarize_each(funs(mean))
  summaryFile <- file.path(cleanDataPath, "summary.csv")
  message("Summary data written to: ", summaryFile)
  write.csv(s, file=summaryFile, row.names = FALSE)
  return (s)
}




main <- function() {
  
  wd <- "/Users/yuazhuan/R"
  setwd(wd)
  wd <- getwd()
  
  # Download data
  message("Download and unzip data file.")
  destFile <- "UCI HAR Dataset"
  if (!dir.exists(destFile)) {
    tmp <- "wearable.zip"
    dlink <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(dlink, tmp, "curl")
    unzip(tmp)
  }
  
  # Set up working directory
  wd <- file.path(wd, destFile)
  message("Set working directory to: ", wd)
  setwd(wd)
  
  
  # Set up directory for clean data output
  
  cleanDataPath <- file.path(getwd(), "cleanData");
  if (!dir.exists(cleanDataPath)) {
    dir.create(cleanDataPath)
  }
  message("Set up directory for clean data: ", cleanDataPath)
  
  t <- mergeDataSets()
  createSummary (t)
  mergeSignals()
}

main()



