# Effacer l'environnement
rm(list=ls(all=T))


#Load the packages

library(FactoMineR)
library(factoextra)

# Charger les données
data <- read.table("clipboard", header = T, dec = ",", sep = "\t")
attach(data)
View(data)


#'In the R code below, the MCA is performed only on the active
#'individuals/variables :
res.mca <- MCA(data, graph = FALSE)
print(res.mca)


#'Eigenvalues / Variances
#'The proportion of variances retained by the different dimensions (axes) 
#'can be extracted using the function get_eigenvalue() [factoextra package] 
#'as follow:
eig.val <- get_eigenvalue(res.mca)
head(eig.val)
eig.val

#'To visualize the percentages of inertia explained by each
#'MCA dimensions, use the function fviz_eig() or fviz_screeplot() 
fviz_screeplot(res.mca, addlabels = TRUE, ylim = c(0, 45))

#'Biplot
#'The function fviz_mca_biplot() [factoextra package] is used to draw 
#'the biplot of individuals and variable categories:
fviz_mca_biplot(res.mca, 
                repel = TRUE, # Avoid text overlapping (slow if many point)
                ggtheme = theme_minimal())

#'Graph of variables
#'Results: The function get_mca_var() [in factoextra] is used 
#'to extract the results for variable categories. 
#'This function returns a list containing the coordinates, 
#'the cos2 and the contribution of variable categories:

var <- get_mca_var(res.mca)
var
summary(res.mca)
#'The different components can be accessed as follow:
# Coordinates
var$coord
# Cos2: quality on the factore map
var$cos2
# Contributions to the principal components
var$contrib


#'Correlation between variables and principal dimensions
#'To visualize the correlation between variables 
#'and MCA principal dimensions, type this:
fviz_mca_var(res.mca, choice = "mca.cor", 
             repel = TRUE, # Avoid text overlapping (slow)
             ggtheme = theme_minimal())

#'Coordinates of variable categories
#'The R code below displays the coordinates of each variable 
#'categories in each dimension (1, 2 and 3):
head(round(var$coord, 2), 4)

#'Use the function fviz_mca_var() [in factoextra] 
#'to visualize only variable categories:
fviz_mca_var(res.mca, 
             repel = TRUE, # Avoid text overlapping (slow)
             ggtheme = theme_minimal())


#'It’s possible to change the color and the shape of the variable points using the arguments col.var and shape.var as follow:
fviz_mca_var(res.mca, col.var="black", shape.var = 15,
             repel = TRUE)


#'Quality of representation of variable categories
#'The quality of the representation is called the squared cosine (cos2), 
#'which measures the degree of association between variable categories 
#'and a particular axis. The cos2 of variable categories can 
#'be extracted as follow:
head(var$cos2)

#'If a variable category is well represented by two dimensions, 
#'the sum of the cos2 is closed to one. For some of the row items, 
#'more than 2 dimensions are required to perfectly represent the data.
#'It’s possible to color variable categories by their cos2 values 
#'using the argument col.var = “cos2”. This produces a gradient colors, 
#'which can be customized using the argument gradient.cols. 
#'For instance, gradient.cols = c("white", "blue", "red") means that:
#'variable categories with low cos2 values will be colored in “white”
#'variable categories with mid cos2 values will be colored in “blue”
#'variable categories with high cos2 values will be colored in “red”
# Color by cos2 values: quality on the factor map
fviz_mca_var(res.mca, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE, # Avoid text overlapping
             ggtheme = theme_minimal())


#'Note that, it’s also possible to change the transparency of the variable 
#'categories according to their cos2 values using 
#'the option alpha.var = "cos2". For example, type this:

# Change the transparency by cos2 values
fviz_mca_var(res.mca, alpha.var="cos2",
             repel = TRUE,
             ggtheme = theme_minimal())

#'You can visualize the cos2 of row categories on all the dimensions 
#'using the corrplot package:

library("corrplot")
corrplot(var$cos2, is.corr=FALSE)
#'It’s also possible to create a bar plot of variable cos2 
#'using the function fviz_cos2()[in factoextra]:

# Cos2 of variable categories on Dim.1 and Dim.2
fviz_cos2(res.mca, choice = "var", axes = 1:2)




