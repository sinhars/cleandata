run_analysis <- function(directory = getwd()) {
    
    merged_data <- data.frame()
    
    if(dir.exists(paths = directory) == TRUE) {
        
        activities <- data.frame()
        features <- data.frame()
        train_data <- data.frame()
        test_data <- data.frame()
        
        # Read feature names from file
        
        features_file <- paste0(directory, "/features.txt")
        if(file.exists(features_file)) {
            features <- read.table(file = features_file, sep = "", header = FALSE)
        }
        
        # Read the activity class and corresponding names from file
        
        activities_file <- paste0(directory, "/activity_labels.txt")
        if(file.exists(activities_file)) {
            activities <- read.table(file = activities_file, sep = "", header = FALSE)
        }
        
        train_file <- paste0(directory, "/train/X_train.txt")
        train_y <- paste0(directory, "/train/y_train.txt")
        train_subject <- paste0(directory, "/train/subject_train.txt")
        
        if(file.exists(train_file) & file.exists(train_subject)) {
            
            # Read train, activity and subject data from files
            
            train_data <- read.table(file = train_file, sep = "", header = FALSE)
            y_data <- read.table(file = train_y, sep = "", header = FALSE)
            subject_data <- read.table(file = train_subject, sep = "", header = FALSE)
            
            # Rename columns with the appropriate feature names
            
            if("V2" %in% colnames(features)) {
                names(train_data) <- features$V2
            }
            
            # Bind train data with activity class data and rename activity column
            
            train_data <- cbind(y_data, train_data)
            if("V1" %in% colnames(train_data)) {
                names(train_data)[names(train_data) == "V1"] <- "Activity"
            }
            
            # Bind train data with subject data and rename subject column
            
            train_data <- cbind(subject_data, train_data)
            if("V1" %in% colnames(train_data)) {
                names(train_data)[names(train_data) == "V1"] <- "Subject"
            }
        }
        
        test_file <- paste0(directory, "/test/X_test.txt")
        test_y <- paste0(directory, "/test/y_test.txt")
        test_subject <- paste0(directory, "/test/subject_test.txt")
        
        if(file.exists(test_file) & file.exists(test_subject)) {
            
            # Read test, activity and subject data from files
            
            test_data <- read.table(file = test_file, sep = "", header = FALSE)
            y_data <- read.table(file = test_y, sep = "", header = FALSE)
            subject_data <- read.table(file = test_subject, sep = "", header = FALSE)
            
            # Rename columns with the appropriate feature names
            
            if("V2" %in% colnames(features)) {
                names(test_data) <- features$V2
            }
            
            # Bind test data with activity class data and rename activity column
            
            test_data <- cbind(y_data, test_data)
            if("V1" %in% colnames(test_data)) {
                names(test_data)[names(test_data) == "V1"] <- "Activity"
            }
            
            # Bind test data with subject data and rename subject column
            
            test_data <- cbind(subject_data, test_data)
            if("V1" %in% colnames(test_data)) {
                names(test_data)[names(test_data) == "V1"] <- "Subject"
            }
        }
        
        # Merge train and test data frames into single set
        
        merged_data <- rbind(train_data, test_data)
        
        # Keep only Subject, Activity, mean and std columns in the final data frame
        
        group_col <- c("Subject", "Activity")
        mean_cols <- grep("mean()", names(merged_data), value = TRUE, fixed = TRUE)
        std_cols <- grep("std()", names(merged_data), value = TRUE, fixed = TRUE)
        merged_data <- merged_data[, c(group_col, mean_cols, std_cols)]
        
        # Merge activity names from activities data frame and replace IDs with descriptive text
        
        merged_data <- merge.data.frame(merged_data, activities, by.x = "Activity", by.y = "V1")
        merged_data$Activity <- merged_data$V2
        merged_data <- merged_data[, !(names(merged_data) %in% "V2")]
    }
    
    merged_data
}
