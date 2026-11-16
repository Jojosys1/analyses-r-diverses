rm(list=ls(all=TRUE))

#Préciser le repertoire de travail
Data<-read.table("Base_AFC.txt",header=TRUE) 
names(Data)
head(Data)

#Afficher les différentes modalités de chaque variable
unique(Data$Region)
unique(Data$Produit)

# Table de Contingence
DataAFC <- table(Data$Region, Data$Produit) 
DataAFC
dim(DataAFC)

# Charger le package requis
library(FactoMineR)

#  Exécuter l'analyse factorielle des correspondances 
CAResults1 <- CA(DataAFC,graph = FALSE)
#Afficher les résultats de l'analyse des correspondances.
summary(CAResults1)

# Visualiser le résultat sur une graphe
plot.CA(CAResults1, axes = c(1,2))

# Modifier les noms des colonnes
rownames(CAResults1$col$coord) <- c("Café", "Maïs","Manioc","Mil", "Riz","Tabac")

# Visualiser le résultat sur une graphe avec les nouveaux noms
plot.CA(CAResults1, axes = c(1, 2))
