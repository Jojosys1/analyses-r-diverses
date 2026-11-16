# Pistes d'amélioration — Analyses R diverses

## C'est quoi
Recueil de travaux R variés : ACP/AFC/ACM/AFDM, classification et k-means,
séries temporelles (lissage, VAR/VEC), régression logistique, survie (Cox).

## État actuel
- Un projet RStudio (`bASE DE DONN2ES.Rproj`) avec scripts `Script_*.R` et `*.Rmd`.
- Données : `wine.xlsx`, `adult_clean.xlsx`, `bank.xlsx`, `housetasks.xlsx`, `*.txt`.
- Beaucoup de sujets différents dans un même dossier (fourre-tout).

## Pistes (courtes)
- Éclater en sous-dossiers thématiques : `acp-afc-acm/`, `series-temporelles/`, `classification/`, `survie/`.
- Renommer le dossier/`.Rproj` (`bASE DE DONN2ES` → `analyses-r-diverses`).
- Ajouter un `README.md` : liste des scripts et à quoi sert chacun.
- Nettoyer les sorties générées (`Rplot*.png`, `.RData`, `.Rhistory`) via `.gitignore`.
- Déplacer `TP_regression_logistique_multinomiale*.Rmd` vers le projet RLM dédié.

## Mini-prompt
> Classe ce fourre-tout R en sous-dossiers thématiques, renomme le projet,
> ajoute un README qui liste chaque script, et ajoute un `.gitignore` R.
