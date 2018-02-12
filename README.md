# cleandata

run_analysis.R is a script that defines the run_analysis function

run_analysis function takes in 1 argument - directory

If the directory exists, then the function reads the feature names, activity names and the train and test data into data frames.

It merges the train and test data into one data frame and also joins the activity and subject inputs.

It keeps only the mean and std variables and removes all other columns from the merged data frame.

Finally, it also computes a new data frame with the aggregate (mean) of all variables grouped by Subject and Activity.
