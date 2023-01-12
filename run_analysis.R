
library(tidyverse)
library(dplyr)

## Step 0 load the datas
# importing datasets
X_test <- read.table("./test/X_test.txt",header=F)
Y_train <- read.table("./train/X_train.txt",header=F)

# importing activity codes for each line in both datasets
y_test <- read.table("./test/y_test.txt",header=F)
y_train <- read.table("./train/y_train.txt",header=F)

# importing activity codes + labels
activity_labels <- read.table("activity_labels.txt",header = F)
#defining column names for the activity_labels df
colnames(activity_labels) <- c("activity_code",'activity_label')

# importing subject identifier for each row of both datasets
subject_test <- read.table("./test/subject_test.txt",header = F)
subject_train <- read.table("./train/subject_train.txt", header = F)

# importing variable names (features)
features <- read.table("features.txt")
#defining column names for the features df
colnames(features) <- c("feature_code","feature_label")

### Step 1
## merging records, activity codes and subject identifier from the three sources
# for the test sample
X_df <- cbind(X_test,y_test,subject_test)
# for the train sample
Y_df <- cbind(Y_train,y_train,subject_train)

## merging both data frames to make one unique with test sample records and train sample records
df <- rbind(X_df, Y_df)

### Step 4
# assigning correct variable names in both data frames
var_names <- c(features[,2],"activity_code","subject_identifier")
colnames(df) <- var_names

### Step 2 
# extracting only the measurements on the mean and standard deviation for each record of the dataset
df_light <- df %>% select(matches("mean()|std()|activity_code|subject_identifier"))

### Step 3
# associating activity labels with activity codes in the df obtained at previous step
# we could have recoded the variable instead of linking it but it doesn't really matter to our point of view
df_light <- df_light %>% left_join(activity_labels, by = c("activity_code"="activity_code"))
# replacing activity label aside activity code for avoiding confusion with subject identifier
df_light <- relocate(df_light,activity_label,.after=activity_code)
# confirm there is no NA in our dataset
sum(is.na(df_light))
# export df_light
save(df_light,file="df_light.Rda")

### Step 5 
# thanks dflight from step 3, we summarised datas by subject and activity with their means
df_summary <- df_light %>% group_by(subject_identifier,activity_code,activity_label) %>% summarize(across(everything(),mean))
# export df_sumamry
save(df_summary,file="df_summary.Rda")
                                       
### final for assignment
write.table(df_summary,file ="df_summary.txt",row.names = FALSE)
                                                            