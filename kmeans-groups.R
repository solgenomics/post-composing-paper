
setwd("~/Documents/Queries/")
rm(list = ls())
# Use the file generated from the first query
myDF <- read.csv("cassava_accessions_count.csv", header = T, sep = ",")
head(myDF)

#Elbow Method for finding the optimal number of clusters
set.seed(1234)
# Compute and plot wss for k = 2 to k = 6.
k.max <- 6
data <- as.matrix(scale(myDF$total))
wss <- sapply(1:k.max, 
              function(k){kmeans(data, k, nstart=50,iter.max = 15 )$tot.withinss})
wss
plot(1:k.max, wss,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")
#From the plot I choose 3 clusters
cl <- kmeans(myDF$total, 3)
cl$centers #Centroid values