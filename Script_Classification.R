rm(list=ls(all=TRUE))

# Charger les données
Data<-read.table("fromage.txt",header=TRUE) 
Data<-read.table("clipboard", header = TRUE, sep = "\t", dec = ",")
names(Data)
head(Data)
Fromage<-Data$Fromages
DataCAH <- Data[,-1]

# Renommer les lignes
rownames(DataCAH) <- Data[,1]

# Standardiser les données
data_scaled <- scale(DataCAH)
data_scaled

# Calculer la matrice des distances
distance_matrix <- dist(data_scaled, method = "euclidean")
distance_matrix

# Appliquer le regroupement hiérarchique agglomératif
hc <- hclust(distance_matrix, method = "ward.D2")

### Courbe d'inertie
inertie <- sort(hc$height, decreasing = TRUE)
plot(inertie, type = "s", xlab = "Nombre de classes")

library(factoextra)
##### Dendogramme
fviz_dend(hc, 
          cex = 0.5, # Taille des étiquettes
          k = 4, # Nombre de clusters
          rect = TRUE, # Ajouter des rectangles autour des clusters
          rect_fill = TRUE, # Colorer les rectangles
          rect_border = "jco", # Couleurs des bordures des rectangles
          main = "Dendrogramme avec Ward Linkage et distance euclidienne",
          xlab = "Fromages",
          ylab = "Distance")


# Couper l'arbre en clusters
k <- 5
clusters <- cutree(hc, k=k)
clusters 

# Ajouter les clusters aux données originales
data_clustered <- data.frame(Fromages=Fromage, Cluster=clusters, DataCAH)
library(gtsummary)

# Calculer les statistiques descriptives pour chaque cluster
Res<- data_clustered%>%tbl_summary(include = c(calories,sodium,calcium,lipides,retinol,folates,proteines,cholesterol,magnesium),by = Cluster)
Res
Res<- data_clustered%>%tbl_summary(include =c(calories,sodium,calcium,lipides,retinol,folates,proteines,cholesterol,magnesium),by = Cluster,statistic = list(all_continuous() ~ c("{mean} ({sd})")))
Res

#POur mieux interpreter je ferai du PCA sur la nouvelle base construites
res.pca <- prcomp(data_clustered[, 3:10],  scale = TRUE)

#Pour avoir nos valeurs propres
summary(res.pca)

# Change the color by groups, add ellipses
fviz_pca_biplot(res.pca,label = "all", habillage=data_clustered$Cluster,pointsize = 0.5,labelsize = 3,
                addEllipses=TRUE, ellipse.level=0.95)
