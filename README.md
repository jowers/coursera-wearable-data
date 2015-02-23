## Getting and Cleaning Data - Coursework

As described in the project description:

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### Project contents
This project contains a script `run_analysis.R` that takes the data provided above and tidies the data. There is also a codebook (codebook.md) that describes the data contained within the resulting tidy data set.

### Running the script
Before running the script, you should ensure that you have downloaded the dataset (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and unzipped it. This will provide you with a directory within your current working directory called `UCI HAR Dataset`. You should then set the location of your current working directory in R using the `setwd()` function.

Once this has been done, you can run `run_analysis.R`. This will output a file called `assignment_table.tab` which contains a table of tidy data, grouped by subject and activity. The remaining columns of the output dataset consist of the mean of the measurements from the study for each of the pairs of subject and activity.


### What is the script doing?
`run_analysis.R` does a reasonable about of manipulation of the downloaded data in order to both tidy the data, and remove observations that are not of interest for this exercise.

#### Setup the column headings and required columns
The first thing that the script does is to use the `features.txt` file to get the column names for subsequent imports. It loads in `features.txt` and creates a vector out of the second column.

I also create a vector of column numbers to use from the data sets provided. This list was created manually by reviewing the fields in the dataset and identifying those which represent a mean or standard deviation measurement. I've interpreted the data such that only the measurements that are explicitly described as "mean" or "std" are included. More specifically, I've not included the "angle" measurements  or the MeanFreq measurements - described as "Weighted average of the frequency components to obtain a mean frequency" in the source data.


#### Load in the test and training data sets
The next stage is to load in the 2 data sets. To achieve this, I load the `x_train.txt`, `y_train.txt` and `subj_info.txt` files (and the equivalent test files) into data tables so that I can start manipulating them. To allow easier identification of the data, I apply the column headings prepared earlier to the `x_*`, and assign the names Subject.Id and Activity.Label to the `subj_*` and `y_*` data sets accordingly.

Then I subset the `x_*` data tables to only include the columns identified in the previous step.

Next I need to combine the 2 sets of data. To do this I use cbind to combine the x, y and subj datasets for each of the test and training sets, and I then use rbind to join the two datasets together into a single data table.

#### Apply text labels to the activities
I'm using `mutate` to apply the labels, WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING and LAYING in place of the integers used to represent them in the original data.

#### Clean up the Column Names
The column names in the original data set are somewhat clunky, and some also contain brackets which may cause issues with further R data analysis. The tidied headings will consist of capitalised words, separated by full stops. As an example of the transform that I am going to apply, consider the following two column headings in the original dataset:

tBodyAcc-mean()-Y
fBodyAcc-mean()-Y

In my tidied dataset, these column headings become:

Time.Body.Acc.Mean.Y
Freq.Body.Acc.Mean.Y

It is also worth noting that the magnitude column names for the Frequency measurements contained a duplicate "Body" (e.g. Freq.Body.Body.Gyro.Mag.Mean). I also remove the duplicate Body.

#### Summarising the data
The final step is to summarise the data and save it to a file. To do this, I'm using the dply package and performing a group by on the combined data set. I can them summarise the data by taking the mean of each measurement, grouped by subject and activity.

### Explanation of Tidy Data

From 2.3 in Hadley Wickham's Paper on Tidy Data from the Journal of Statistical Software, MMMMMM YYYY, Volume VV, Issue II, tidy data is described as data where:

1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

It is also noted in this paper that this is the same as Codd's 3rd normal form, but with the constraints framed in statistical language

I've not made any attempt to combine data measurements, which means that the output data I've produced meets point one of the description. For point 2, the observations asked for in the exercise are the means of each recording, grouped by subject and activity. My data set contains one row for each of the combinations of subject and activity, which meets this description. The third point is a wider point regarding the data set, and I believe is met by the orginal study, and hence by my dataset.

