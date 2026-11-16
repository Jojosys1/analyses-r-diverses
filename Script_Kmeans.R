rm(list=ls(all=TRUE))

# Charger les données
Data<-read.table("fromage.txt",header=TRUE) 
names(Data)
head(Data)

# Séparer les données des étiquettes de sites
Fromage <- Data$Fromages
DataK <- Data[,-1]
rownames(DataK) <- Data[,1]

# Normaliser les données
data_scaled <- scale(DataK)

#Déterminer le nombre de groupe à considérer
library(factoextra)
fviz_nbclust(data_scaled, kmeans, method = "wss")

# Appliquer l'algorithme K-means
set.seed(123) 
k <- 4
kmeans_result <- kmeans(data_scaled, centers = k, nstart = 25)
kmeans_result

#Pour obtenir à quel cluster appartient chaque site
kmeans_result$cluster

#Et pour obtenir la valeur de la variabilité intra-cluster :
kmeans_result$tot.withins

# Visualize kmeans clustering
fviz_cluster(kmeans_result, DataK)
fviz_cluster(kmeans_result, DataK,ellipse = T, pointsize = 1,labelsize = 8, ggtheme=theme_bw())

# Ajouter les clusters aux données originales
data_clustered <- data.frame(Fromages=Fromage, Cluster=kmeans_result$cluster, DataK)
data_clustered
library(gtsummary)

# Calculer les statistiques descriptives pour chaque cluster
Res<- data_clustered%>%tbl_summary(include =  c(calories,sodium,calcium,lipides,retinol,folates,proteines,cholesterol,magnesium),by = Cluster,type = all_continuous() ~ "continuous2",statistic = list(all_continuous() ~ c("{mean} ({sd})","{median} ({p25}, {p75})", "{min}, {max}")))
Res

#POur mieux interpreter je ferai du PCA sur la nouvelle base construites
res.pca <- prcomp(data_clustered[, 3:10],  scale = TRUE)

#Pour avoir nos valeurs propres
summary(res.pca)
fviz_pca_var(res.pca)

# Change the color by groups, add ellipses
fviz_pca_biplot(res.pca,label = "all", habillage=data_clustered$Cluster,pointsize = 0.5,labelsize = 3,
                addEllipses=TRUE, ellipse.level=0.95)


