library(dplyr)

# Load in the names of the fields in the x datasets and create a vector
# containing just the colnames
cols <- read.table("UCI HAR Dataset/features.txt")
col_names <- cols[[2]]

# A vector of the columns that we want to keep from the x data sets
cols_to_keep <- c(1, 2, 3, 4, 5, 6,
                  41, 42, 43, 44, 45, 46,
                  81, 82, 83, 84, 85, 86,
                  121, 122, 123, 124, 125, 126,
                  161, 162, 163, 164, 165, 166,
                  201, 202, 214, 215, 227, 228,
                  240, 241, 253, 254, 
                  266, 267, 268, 269, 270, 271,
                  345, 346, 347, 348, 349, 350,
                  424, 425, 426, 427, 428, 429,
                  503, 504, 516, 517, 529, 530,
                  542, 543)

# Load the training data files into variables
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Set the colnames for the x_train data
colnames(x_train) <- col_names

# and then select only the ones that we want
x_train <- x_train[cols_to_keep]

# Give sensible names for the y and subj data as well
y_train <- rename(y_train, Activity.Label = V1)
subj_train <- rename(subj_train, Subject.Id = V1)

# And combine into a single data.frame
combined_train <- cbind(subj_train, y_train, x_train)

# Load the test data files into variables
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Set the colnames for the x_train data
colnames(x_test) <- col_names

# and then select only the ones that we want
x_test <- x_test[cols_to_keep]

# Set some column headings
y_test <- rename(y_test, Activity.Label = V1)
subj_test <- rename(subj_test, Subject.Id = V1)

# And combine into a single data.frame
combined_test <- cbind(subj_test, y_test, x_test)

# Now combine the 2 data sets into a single set
combined <- rbind(combined_test, combined_train)

# create a new column with a text description of the activity type
combined <- mutate(combined, Activity.Label = factor(Activity.Label,
            labels=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
                     "SITTING", "STANDING", "LAYING")))

#
# Tidy up the column names
#
# Convert the data type - t = Time, f = Freq
names(combined) <- gsub("^t", "Time", names(combined))
names(combined) <- gsub("^f", "Freq", names(combined))
# Remove brackets
names(combined) <- gsub("\\(\\)", "", names(combined))
# Remove hyphens, and capitalise the trailing m or s from mean or std
names(combined) <- gsub("-m", "M", names(combined))
names(combined) <- gsub("-s", "S", names(combined))
names(combined) <- gsub("-(X|Y|Z)", "\\1", names(combined))
# Finally, separate words by a full stop
names(combined) <- gsub("([a-z])([A-Z])", "\\1.\\2", names(combined))

# Now summarise the data
summ <- group_by(combined, Subject.Id, Activity.Label)
table_of_data <- summ %>% summarise_each(funs(mean))
write.table(table_of_data, file="assignment_table.tab")
