

#'The aim of study is perform the Principals Components Analysis of Mixed data. 
#'We use one part of data wine, it's a data of packages PCAmix. 
#'For these analyses, we have three possible function in R. 


#' ************* The first way to perfom the PCAmix *******************####
#'For the first way, we use the function PCAmix for the package PCAmixdata ******###

#' Clear the workspace
rm(list=ls(all=TRUE))

#' Packages
library(PCAmixdata)
library(ggplot2)
library(factoextra)
library(base)
help(wine)
View(wine)
#' Import the dataset: We use one part of dataset Wine for package PCAmixdata .
data(wine)
dim(wine)
# Precise the number quantitatives variables and the number of qualitatives variables 
#Here we consider 6 quantitatives variables 
X.quanti <- wine[,c(16, 22, 29, 28, 30, 31)] 
# Here, we use 2 qualitatives variables
X.quali <- wine[,c(1,2)]

#'Perform the analyses  
m1<-PCAmix(X.quanti,X.quali, graph=FALSE)
summary(m1)

#'Answers for The Eigenvalue. This answer allows to identify the Principal Components we will consider 
m1$eig
#Results for quantitatives variables 
m1$quanti
#Results for qualitatives  variables 
m1$levels # for the modalities 
m1$quali  # for the variables 
#Results for individuals 
m1$ind

#' Visualisation the results
#The correlation circle for the quantitatives variables 
plot(m1, axes = c(1, 2), choice = "cor", label = TRUE)
#The graph for modalities of qualitatives variables 
plot(m1, axes = c(1, 2), choice = "levels", label = TRUE)
#The graph of squared loadings for mixtes variables 
plot(m1, axes = c(1, 2), choice = "sqload", label = TRUE)
#The graph of individuals 
plot(m1, axes = c(1, 2), choice = "ind", label = TRUE)


#'***************The second way to perfom the PCAmix *******************#
#'For the second way, we use the function FAMD for the package FactoMineR ******###
#'When we use this function, the analyse is call Factorial Analysis of Mixed Data 

#' Clear the workspace
rm(list=ls(all=TRUE))

#' Packages
library(FactoMineR)
library(ggplot2)
library(factoextra)
library(PCAmixdata)
library(base)

# Import data
data(wine)
bas <- wine[,c(1,2, 16, 22, 29, 28, 30, 31)]
dim(bas)
head(bas[, 1:8],10)
str(bas)

#Basic Statistics of dataset 
summary(bas)

#' Perform the analyse and
#' obtain the results on the each type of variables  and on the individuals 
res.famd <- FAMD(bas, graph = FALSE)
summary (res.famd)

#****Visualiation****# 
# the respective projection of variables and individuals on  the selected principal components
fviz_famd_var(res.famd)  # Graph of variables
fviz_famd_ind(res.famd)  # Graph of individuals
# Graphical Representation for the eigenvalue 
fviz_eig(res.famd) 
# Graphical representation of the contribution of variables on each axis
fviz_contrib(res.famd, choice ="var",axes = 1) 
fviz_contrib(res.famd, choice ="var",axes = 2)
# Graphical representation of the contribution of individuals  on each axis
fviz_contrib(res.famd, choice ="ind",axes = 1) 
fviz_contrib(res.famd, choice ="ind",axes = 2) 



#'***************The third way to perfom the PCAmix *******************#
#'For the third way, we use the function dudi.pca for the package ade4 ******###

#' Clear the workspace
rm(list=ls(all=TRUE))

#' Packages
library(ade4)
library(ggplot2)
library(factoextra)
library(PCAmixdata)
library(base)

# Import data
data(wine)
aut<-wine[,c(1,2, 16, 22, 29, 28, 30, 31)]
dim(aut)
print(summary(aut))

##' Step to transform the mixed data in numerical dataset.
##'  It mandatory if you use the function dudi.pca 

# Function to center and standardize 
CS <- function(x){
  n <- length(x)
  m <- mean(x)
  v <- (n-1)/n*var(x)
  return((x-m)/sqrt(v))
} 
# Application of the function on quantitatives variables 
aut.cont <- data.frame(lapply(subset(aut,select=3:8),CS))
print(aut.cont)

# Application of Complete disjunctive coding on qualitatives variables 
aut.disc <- acm.disjonctif(subset(aut,select=1:2))

# Function for the weighting of indicators.
PF <- function(x){
  m <- mean(x)
  return(x/sqrt(m))
} 
# Apply weighting to the indicators.
aut.disc.pond <- data.frame(lapply(aut.disc,PF))
aut.disc.pond

# Numerical dataset obtain to do  Principal Component Analysis (PCA)
aut.pour.acp <- cbind(aut.cont,aut.disc.pond)
rownames(aut.pour.acp) <- rownames(aut)
print(round(aut.pour.acp,4))

# Perform the analyse using the function dudi.pca
acp.aut <- dudi.pca(aut.pour.acp,center=T,scale=F,scannf=F)

# Eigenvalue
print(round(acp.aut$eig,5))

# Coordinates of  PCA for variables  
print(acp.aut$co)

# Coordinates of PCA for individuals 
acp.aut$li


