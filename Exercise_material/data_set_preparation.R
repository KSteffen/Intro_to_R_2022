library(splitstackshape)
# set seed for random numbers
set.seed(20200110)

# starting data set
iris <- iris

# sample_IDs based on shuffled order
iris["sample_ID"] <- seq(1:150)

# shuffle it up first
iris["rand"] <- sample(1:1000, 150, replace=F) #Select 150 random numbers between 1 and 1000, without replacement
iris <- iris[order(iris$rand),]

# stratified sampling
strat1 <- stratified(iris, "Species", size=50/3, bothSets = TRUE)
s1 <- strat1$SAMP1
iris_remaining <- strat1$SAMP2
strat2 <- stratified(iris_remaining, "Species", size=50/3, bothSets = TRUE)
s2 <- strat2$SAMP1
s3 <- strat2$SAMP2
rm(strat1, strat2)

s1 <- data.frame(s1)
s2 <- data.frame(s2)
s3 <- data.frame(s3)

# adding grouping variable
s1["group"] <- c("s1")
s2["group"] <- c("s2")
s3["group"] <- c("s3")

# reconstitute full data set
full_data <- rbind(s1, s2, s3)
#full_data$rand <- NULL

# checking that the sampling went alright: looks good, group 1 and 2 have 48 samples, group 3 has 54
aggregate(full_data, by=list(full_data$Species, full_data$group), "length")
write.csv(full_data,"~/Documents/Courses/CESKY_KRUMLOV_2020/R/new/Exercise_material/full_data.csv", row.names = FALSE)

# scramble up again 
full_data <- full_data[order(full_data$sample_ID),]
head(full_data)

# prepare identification key
key <- full_data[,c("Species", "sample_ID")]
write.csv(key,"~/Documents/Courses/CESKY_KRUMLOV_2020/R/new/Exercise_material/key.csv", row.names = FALSE)

# prepare subsets
iris_subs1 <- full_data[full_data$group=="s1",]
iris_subs2 <- full_data[full_data$group=="s2",]
iris_subs3 <- full_data[full_data$group=="s3",]

# order
iris_subs1 <- iris_subs1[order(iris_subs1$rand),]
iris_subs2 <- iris_subs2[order(iris_subs2$Species),]
iris_subs3 <- iris_subs3[order(iris_subs3$sample_ID),]

# PLANNING EXERCISE: IMPORTING
# key: nothing, just use read.csv()

# subs1: sep="\t", different order of columns
# subs2: sep=";", dec="," 
# subs3: dec=","
#change 2 and 3

# PLANNING EXERCISE: INSPECTION/MERGING
# subs1: different col names(?)
# subs2: different col names, sample_IDs missing
# subs3: different col names, wrong value(?)


# subset1: tsv
head(iris_subs1)
colnames(iris_subs1)
iris_subs1[, c("Species", "rand", "group")]<- list(NULL)
iris_subs1 <- iris_subs1[,c(5, 1, 2, 3, 4)]
write.csv(iris_subs1,"~/Documents/Courses/CESKY_KRUMLOV_2020/R/new/Exercise_material/field_work_measurements_MC.csv", row.names = FALSE)

# subset2: different column order, different header, missing sample_ID, converted dot to comma
head(iris_subs2)
iris_subs2[, c("Species", "rand", "group")]<- list(NULL)
colnames(iris_subs2) <- c( "sep_len", "sep_wid", "pet_len", "pet_wid", "Sample number")
sample_ID <- c(iris_subs2$`Sample number`)
iris_subs2$`Sample num` <- NULL
#iris_subs2["Sample_ID"] <- sample_ID
write.csv(iris_subs2,"~/Documents/Courses/CESKY_KRUMLOV_2020/R/new/Exercise_material/Iris_sepal_petal_NTR.csv", row.names = FALSE)

sample_ID

# subset3: measured in mm, wrong entry (?), different header -->conversion to cm
head(iris_subs3)
iris_subs3$Sepal.Length <- iris_subs3$Sepal.Length*10
iris_subs3$Sepal.Width <- iris_subs3$Sepal.Width*10
iris_subs3$Petal.Length <- iris_subs3$Petal.Length*10
iris_subs3$Petal.Width <- iris_subs3$Petal.Width*10
iris_subs3[, c("Species", "rand", "group")]<- list(NULL)
colnames(iris_subs3) <- c("sepal_length _mm", "sepal_width_mm", "petal_length_mm", "petal_width_mm", "sample_ID")
iris_subs3 <- iris_subs3[,c(1, 3, 2, 4, 5)]
head(iris_subs3)
write.csv(iris_subs3,"~/Documents/Courses/CESKY_KRUMLOV_2020/R/new/Exercise_material/Iris_measurements_KT.csv", row.names = FALSE)

# goal: reconstitute the full data set
# then : stats & visualisation


