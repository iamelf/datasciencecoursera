book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 

### Clean Data
* **summary.csv**: summary for the average of each variable for each activity and each subject.
* **measurements.csv**: mean & standard deviation measurements of combined train & test data.

These 2 clean data files meet all the requirements specified in the assignment description.
  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement.
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names.


### Data transformation process
1. grep the lines with "mean|std": the first column is the column number of the data wanted; the second column is transformed into descriptive variable name by using gsub & grep
2. read data from test/subject_test.txt, test/X_test.txt, test/Y_test.txt, and combine all data using cbind:
  * subject_test.txt  --> column "subject"
  * Y_test.txt --> activity type
    * load data from activity_labels.txt, and translate the activity labels to descriptive activity names
    * change the column name to "activity"
  * X_test.txt  --> measurements
    1. read feature description from featrues.txt
    2. grep the lines with "mean|std": the first column is the column numbers of the data wanted; the second column is transformed into descriptive variable name by using gsub & grep
    3. filter the data from X_test.txt with the column numbers generated in step 2.
    4. change the column names to corresponding descriptive variable names generated in step 2.

3. Apply step 2 to train data.
4. Combining data for train and test, and combined data written to "measurements.txt"
5. Generate summary for the average of each variable for each activity and each subject, by using function summarize_each. Summary data written to "summary.txt"
6. Simply combine the Inertial Signals data files for train and test, and combined data written under foldr "Inertial Signals"


