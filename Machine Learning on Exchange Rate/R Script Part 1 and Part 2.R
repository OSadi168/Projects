install.packages("readxl")
install.packages("factoextra")
install.packages("fpc")
library(cluster)
library(NbClust)
library(factoextra)
library(fpc)
library(readxl)
winedataset <- read_xlsx("C:/Users/omsad/OneDrive/Desktop/University of Westminster/Year 2/Machine Learning and Data Mining/CW/Part 1/Whitewine_v6.xlsx")
chosenset <- winedataset[, -ncol(winedataset)]
str(chosenset)
scaledata <- scale(chosenset)
summary(scaledata)
print(scaledata)
Scaledata_df <- as.data.frame(scaledata)
str(Scaledata_df)

remove_outliers_iqr <- function(data) {
  Q1 <- apply(data, 2, quantile, probs = 0.25)
  Q3 <- apply(data, 2, quantile, probs = 0.75)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  outliers <- apply(data, 1, function(x) any(x < lower_bound | x > upper_bound))
  return(data[!outliers, , drop = FALSE])
}

cleaned_data <- remove_outliers_iqr(Scaledata_df)
str(cleaned_data)

# NbClust Method:
nbClusters <- NbClust(cleaned_data, distance = "euclidean", min.nc = 2, max.nc = 15, method = "kmeans", index = "all")
table(nbClusters$Best.n[1,])
barplot(table(nbClusters$Best.n[1,]),    
        xlab="Number of Clusters", 
        ylab="Number of Criteria",
        main="Number of Center Clusters")


# Elbow Method:
fviz_nbclust(cleaned_data, kmeans, method = 'wss')

# Gap Statistics Method: 
fviz_nbclust(cleaned_data, kmeans, method = 'gap_stat')

# Silhouette Method:
fviz_nbclust(cleaned_data, kmeans, method = 'silhouette')

# kmeans clustering
kmeans <- kmeans(cleaned_data,3)
kmeans
fviz_cluster(kmeans, data = cleaned_data )
# cluster mean:
kmeans$centers

# Cluster Vector:
kmeans$cluster

# Calculation of WSS and BSS:
WSS <- kmeans$tot.withinss
BSS <- kmeans$betweenss

TSS <- sum(WSS) + sum(BSS)
BSS_TSS_ratio <- BSS / TSS

# silhouette
sil <- silhouette(kmeans$cluster, dist(cleaned_data))
fviz_silhouette(sil)

#REFRESH WORKSPACE FOR PCA---

# PCA

pca_wine <- prcomp(cleaned_data,center= TRUE, scale. = TRUE)
summary(pca_wine)

eigenvalues <- pca_wine$sdev^2
eigenvectors <- pca_wine$rotation


# cumulative score by using function 'cumsum'
cumulative_score <- cumsum(pca_wine$sdev^2 / sum(pca_wine$sdev^2))
summary(cumulative_score)

num_components <- which.max(cumulative_score > 0.85)
summary(num_components)

#Transformed Data
wine_transform <- as.data.frame(-pca_wine$x[,1:num_components])   
head(wine_transform)

# pca NbClust Method(Takes time to load):
pca_nbClusters <- NbClust(wine_transform, distance = "euclidean", min.nc = 2, max.nc = 10, method = "kmeans", index = "all")
table(pca_nbClusters$Best.n[1,])
barplot(table(pca_nbClusters$Best.n[1,]),    
        xlab="Number of Clusters", 
        ylab="Number of Criteria",
        main="Number of Center Clusters")

## pca Alternative Method:
fviz_nbclust(wine_transform, kmeans, method = 'wss')

# pca Gap Statistics Method: 
fviz_nbclust(wine_transform, kmeans, method = 'gap_stat')

# pca Silhouette Method:
fviz_nbclust(wine_transform, kmeans, method = 'silhouette')

# pca k-means
k= 2
kmeans_pca <- kmeans(wine_transform, centers = k, nstart = 10)
summary(kmeans_pca)

# cluster mean:
kmeans_pca$centers

# Cluster Vector:
kmeans_pca$cluster


# Calculation of WSS and BSS for pca:
WSS_pca <- kmeans_pca$tot.withinss
BSS_pca <- kmeans_pca$betweenss
# BSS/TSS Ratio for pca:
TSS_pca <- sum(WSS_pca) + sum(BSS_pca)
BSS_TSS_ratio_pca <- BSS_pca / TSS_pca


# silhouette fro pca:
sil <- silhouette(kmeans_pca$cluster, dist(wine_transform))
fviz_silhouette(sil)

# Calinski-Harabasz Index for pca:
CalH_index <- calinhara(wine_transform, kmeans_pca$cluster)
