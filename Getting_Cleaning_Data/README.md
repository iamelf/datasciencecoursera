script.r consist of the following functions:



#### mergeDataSets()
* This is a main function to merge the measurements data for "test" and "train"
* The merged data is writting to file "measurements.csv"
* return the merged data set that meets assignment creteria #1, #2, #3, #4
* mergeDataSets call the following functions:

  ###### locateCol() 
  * This is a subfunctin that 
    1. locates the row # of mean and standard deviation data. ((assignment creteria #2)
    2. generate descriptive variable names (assignment creteria #4)


  ###### getActivities(x)
  * This is a subfunction that translate activity type (numeric) to descriptive activity names
  * Assignment creteria #3: Uses descriptive activity names to name the activities in the data set
  
  
  ###### getMeasurements(dataType)
  * This is a subfunction that 
    1. reads data from file
    2. calls subfunctions to transform data 
    3. generate data set that meet assignment creteria #2, #3, #4

#### mergeSignals()
* This is the main function to merge the "Inertial Signals" data for "test" and "train"
* The merged data is written into files under directory "Inertial Signals"

#### createSummary (t)
* This is the main function to generate summary: average of each variable for each activity and each subject
* The summary data is writting to "summary.csv"
* return a data set that meets assignment creteria #1, #2, #3, #4, #5

#### main()
* Set environment: working directory, clean data directory and download data files.
* Call main data processing function: mergeDataSets(), mergeSignals(), and createSummary(t).
