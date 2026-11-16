# Répertoire de travail

# Charger la base de données
cassava <- read.table("Cassava.txt", header = TRUE)

library(readxl)
cassava <- read_excel("wine.xlsx")
View(wine)

# examiner les dimensions (nombre de lignes et nombre de colonnes) de la base
dim(cassava)

# Visualiser les 5 prémières lignes de la base de données
head(cassava, 5)

# Renommer les lignes de la base de données en utilisant les identifiants des juges
# qui se trouvent dans la colonne 1
row.names(cassava) <- cassava[,1]

# Visualiser les 5 prémières lignes de la nouvelle base de données
head(cassava, 5)

# Exclure la 1ère colonne qui contient les identifiants des juges
# (cette colonne n'est pas une variable quantitative)
cassava <- cassava[, -1]
head(cassava, 5)

# Examiner la matrice de diagramme de dispersion
library(GGally)
ggpairs(cassava)

# Réaliser l'ACP
library(FactoMineR)
ResACP <- PCA(cassava, graph = FALSE)
ResACP

# Extraire les Valeurs propres de l'ACP
ResACP$eig

# Extraire le tableau des corrélations des variables avec les Composantes Principales
ResACP$var$cor

# Afficher le graphe de corrélation des variables avec les Composante Principales 1 & 2
# Encore appellée Cercle de corrélations
plot(ResACP, choix = "var", axes = c(1, 2))

# Afficher le graphe de corrélation des variables avec les Composante Principales 1 & 3
plot(ResACP, choix = "var", axes = c(1, 3))

# Afficher le graphe de projection des individus (juges) dans le système d'axes formé par les Composante Principales 1 & 2
plot(ResACP, choix = "ind", axes = c(1, 2))
