#######################Applied Machine Learning Days by EPFL##############################
#########################Crash course in R for machine learning###################
#########################Radmila VELICHKOVICH#####################################
#########################27.1.2019, Lausanne, Switzerland#########################

install.packages("factoextra")
library(factoextra)
#clustering techniques


#  Clustering with k-means 
#getwd tells you where is your current working directory
getwd()
#setwd is used to tell R where to look for the csv file
setwd("C:/Users/Rada/Desktop")

#ABOUT THE DATASET
#SNS (social networking service) data are collected on 30.000 high school students
#in USA using simple random sampling. Web crawler was used for data collection. 

# load Teenager Market Segments dataset 
teens <- read.csv("snsdata.csv")
#Let큦 inspect the dataset
View(teens)
# The number of obs. (30,000)  and 40 variables
dim(teens)
#Let큦 check the data type
str(teens)

# Number of persons according to the gender
table(teens$gender)

# Look at missing values
table(teens$gender, useNA = "ifany")
summary(teens$gender)

#DATA PREPARATION


# View # of missing data for age variable
summary(teens$age)

# Remove the age outliers (could be though differently defined)

teens$age <- ifelse(teens$age >= 13 & teens$age < 20,
                    teens$age, NA)
#notice that with the above function, we did not cut the dataset
#we just replaced the defined outliers as missing values
#Let큦 now check the summary, notice increase in NA큦
summary(teens$age)
#but the dataset is the same
dim(teens)

#WHY DIDN큈 WE JUST DELETE THE MISSING VALUES? 
#What are the advantages and disadvantages of deleting instead of dealing with them?
#Check r packages for dealing with MV: MICE,Amelia, missForest, Hmisc

# Reassign missing gender values to "unknown"
teens$female <- ifelse(teens$gender == "F" &
                         !is.na(teens$gender), 1, 0)
teens$no_gender <- ifelse(is.na(teens$gender), 1, 0)

View(teens$female)
summary(teens$female)
View(teens$no_gender)

# Check our recoding work
table(teens$gender, useNA = "ifany")
# We can clearly identify the female and the male with a third gender
table(teens$female, useNA = "ifany")
table(teens$no_gender, useNA = "ifany")

# Finding the mean age by cohort
mean(teens$age) # doesn't work
mean(teens$age, na.rm = TRUE) 

# Age by cohort
#use aggregate function to calculate average by group 
aggregate(data = teens, age ~ gradyear, mean, na.rm = TRUE)
#note on aggregate: it returns dataframe which is great
#but makes it difficult to merge back in the original data
#an alternative is ave function()
#notice that we opted to substitute with mean

# Calculating the expected age for each person
ave.age <- ave(teens$age, teens$gradyear,
               FUN = function(x) mean(x, na.rm = TRUE))

teens$age <- ifelse(is.na(teens$age), ave.age, teens$age)



# View the summary results to ensure missing values are eliminated
summary(teens$age)

#How smart is it to impute MVs with average? What is the consequence?
#What are the alternatives?

#TRAINING A MODEL ON THE DATA
#let큦 choose the variables regarding the interests
train.interests <- teens[5:40]
#but let큦 standardise these values
#why is that important in this case?
#how it helps interpretation?

#let큦 standardise all variables using lapply function
train.interests.z <- as.data.frame(lapply(train.interests, scale)) 

set.seed(2345)
teen.clusters <- kmeans(train.interests.z, 5)

#EVALUATING THE MODEL PERFORMANCE

# Inspect the results 
# The size of the clusters
teen.clusters$size

# The assignement of each person
teen.clusters$cluster[1:10]

# The cluster centers
teen.clusters$centers
#cluster centers are cluster큦 average values for the defined interest
#What can we tell?
#Can we find unique name for each cluster?


#CAN WE SAY MORE ABOUT THESE CLUSTERS

# Proportion of females by cluster
aggregate(data = teens, female ~ teen.clusters$cluster, mean)

# Mean number of age by cluster
aggregate(data = teens, age ~ teen.clusters$cluster, mean)

# Mean number of friends by cluster
aggregate(data = teens, friends ~ teen.clusters$cluster, mean)

#which cluster has the highest number of friends?

#Feel free to play with number of k. What will happen with homogeneity 
#if k is e.g 3 or 7. How can this be related to under/overfitting the data?

#Reference book: Machine Learning with R by Brett Lantz

#Have in mind that this is just an illustrative example. From a statistical point of view,
#more could have been done. E.g. we could have done overall ANOVA test to check,
#whether there is a significant difference among the clusters.
#Or, even more precise, t-test between two particular cluster. 

#There are statistical measures that help deciding on the number of clusters
#these can be found in NbClust package;
#be careful how you specify arguments, read about computation expenses for using
#these measures

#HIERARCHICAL METHODS

#Load the data
data("USArrests")

#Murder arrests (per 100,000)
#Assault arrests (per 100,000)
#Percent urban population
#Rape arrests (per 100,000)

#View the dataset
View(USArrests)
#how many observations and variables are there?
dim(USArrests)
#let큦 standardize the data
USAArrests<-scale(USArrests)

#defining measure of similarity
res.dis<-dist(USAArrests, method = "euclidian")
?dist
class(res.dis)
res.dis #not clear what is inside the object res.dis, we need better View
View(res.dis) #we cannot use View(),#reports the following error: Error in View : cannot coerce class '"dist"' to a data.frame
#we have to make it as a matrix
res.dis<-as.matrix(res.dis)
 
View(res.dis) #We can now see the distances in a View pane
sum(is.na(res.dis))
#linkage method
res.hc<-hclust(d=res.dis, method = "complete")
fviz_dend(res.hc,cex=0.5)
#Let큦 cut the tree a bit and then visualise
grp<-cutree(res.hc,  k=4)
fviz_cluster(list(data=res.dis,cluster=grp)) #not bad, but there are some overlapping
#let큦 avoid the overlapping
fviz_cluster(list(data=res.dis,cluster=grp),
             palette=c("#2E9FDF","#00AFBB","#E7B800","#FC4E07"),
             elipse.type="convex",
             repel=T,
             show.clust.cent = F, ggtheme = theme_minimal())


#Now you can try to implement k-means algorithm we learned in previous example. 
#Does it make sense to have 4 clusters?
#What can you tell about them? What names would you give them?



