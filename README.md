# Analyses R diverses

Recueil de travaux d'analyse de données réalisés en **R / R Markdown**, couvrant
plusieurs méthodes statistiques. Projet RStudio : `analyses-r-diverses.Rproj`.

## Analyse multivariée

| Script | Méthode |
|---|---|
| `Script_ACP.R` | Analyse en Composantes Principales |
| `Script_AFC.R` | Analyse Factorielle des Correspondances |
| `Script_AMC.R` | Analyse des Correspondances Multiples |
| `Script_AFMD.R` | Analyse Factorielle de Données Mixtes |
| `Script_Classification.R` | Classification |
| `Script_Kmeans.R` | K-moyennes |

## Séries temporelles

| Fichier | Contenu |
|---|---|
| `Serie temporelle.Rmd` | Analyse de séries temporelles |
| `TP_series_temporelles.Rmd` | TP séries temporelles |
| `Lissages.R` | Techniques de lissage |
| `VEC and VER.Rmd` | Modèles VAR / VECM |
| `Bitcoin.R` / `Bitcoin.Rmd` | Application aux cours du Bitcoin |

## Régression & modélisation

| Fichier | Contenu |
|---|---|
| `Régression logistique.Rmd` | Régression logistique |
| `TP_regression_logistique_multinomiale*.Rmd` | RLM (versions de travail) |
| `Mod_stat.Rmd` / `Modélisatiion statistique.Rmd` | Modélisation statistique |
| `examen_simulation.Rmd`, `exammm.Rmd`, `Projet.Rmd`, `rls.Rmd`, `12.R` | Exercices et examens |

## Données

`wine.xlsx`, `adult_clean.xlsx`, `bank.xlsx`, `housetasks.xlsx`, `Base_AFC.txt`, `Cassava.txt`.

## Prérequis

- **R** (≥ 4.2) et **RStudio**.
- Packages usuels : `FactoMineR`, `readxl`, `ggplot2`, `dplyr`, `forecast`, `vars`, `nnet`.

```r
install.packages(c("FactoMineR","readxl","ggplot2","dplyr","forecast","vars","nnet"))
```

## Utilisation

Ouvrir `analyses-r-diverses.Rproj` dans RStudio, puis exécuter un script ou
**Knit** un `.Rmd`.
