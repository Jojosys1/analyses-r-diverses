#' Packages
library(readxl)

library(FactoMineR)
library(ggplot2)
library(factoextra)
library(PCAmixdata)
library(base)

# Import data

bank <- read_excel("bank.xlsx")
View(bank)

dim(bank)

head(bank,10)
str(bank)

#Basic Statistics of dataset 
summary(bank)

#' Perform the analyse and
#' obtain the results on the each type of variables  and on the individuals 
res.famd <- FAMD(bank, graph = FALSE)
summary (res.famd)

#****Visualiation****# 
# the respective projection of variables and individuals on  the selected principal components
fviz_famd_var(res.famd)  # Graph of variables


#fviz_famd_ind(res.famd)  # Graph of individuals

# Graphical Representation for the eigenvalue 
fviz_eig(res.famd) 
# Graphical representation of the contribution of variables on each axis
fviz_contrib(res.famd, choice ="var",axes = 1) 
fviz_contrib(res.famd, choice ="var",axes = 2)
# Graphical representation of the contribution of individuals  on each axis
fviz_contrib(res.famd, choice ="ind",axes = 1) 
fviz_contrib(res.famd, choice ="ind",axes = 2) 
