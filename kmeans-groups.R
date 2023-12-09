
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


## This part is to find out which trait root is more frequent in post-composed trait
## Use the file from the second query
library(stringr)
myDF2 <- read.csv("traits_frequency_ groupA.csv", header = T, sep = ",")
myDF2$root_trait <- str_extract(myDF2$trait_name, "[^|]+")
trait_freq <- as.data.frame(tapply(myDF2$appearance_count,myDF2$root_trait, sum))
trait_freq <- tibble::rownames_to_column(trait_freq, "traits")
colnames(trait_freq)[2] <- "freq"
trait_freq <- trait_freq[order(-trait_freq$freq),]

# Printing top 10 more frequent root traits
trait_freq[, 10]