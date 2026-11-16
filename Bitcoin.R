# ══════════════════════════════════════════════════════════
#  LISSAGES SUCCESSIFS + PRÉDICTIONS — Bitcoin 2019-2022
# ══════════════════════════════════════════════════════════

library(forecast)   # auto.arima, forecast()
library(zoo)

# ── 1. Construction de la série temporelle ────────────────
bitcoin2019$date <- as.Date(bitcoin2019$date)

x <- ts(bitcoin2019$price,
        start     = c(2019, 1),
        frequency = 91)          # ~91 obs / an (tous les 4 jours)

cat("Série créée :", length(x), "observations\n")
plot(x, main = "Prix Bitcoin brut", col = "gray40",
     xlab = "Année", ylab = "Prix (USD)")


# ══════════════════════════════════════════════════════════
#  PARAMÈTRES GLOBAUX
# ══════════════════════════════════════════════════════════

h      <- 30    # horizon de prédiction (30 points ≈ 120 jours)
alpha  <- 0.2
beta   <- 0.1
gamma  <- 0.3

par(mfrow = c(2, 2))   # 4 graphiques côte à côte


# ══════════════════════════════════════════════════════════
#  1. LISSAGE EXPONENTIEL SIMPLE (SES)
# ══════════════════════════════════════════════════════════

lisse_ses   <- HoltWinters(x, alpha = alpha,
                           beta  = FALSE,
                           gamma = FALSE)

pred_ses    <- predict(lisse_ses, n.ahead = h)

plot(lisse_ses,
     main = paste0("SES  (α = ", alpha, ")"),
     col  = c("gray40", "steelblue"),
     xlab = "Temps", ylab = "Prix")
lines(pred_ses, col = "red", lty = 2, lwd = 2)
legend("topleft",
       legend = c("Observé", "Lissé", "Prédiction"),
       col    = c("gray40", "steelblue", "red"),
       lty    = c(1, 1, 2), bty = "n", cex = 0.8)


# ══════════════════════════════════════════════════════════
#  2. LISSAGE DE HOLT (tendance, sans saisonnalité)
# ══════════════════════════════════════════════════════════

lisse_holt  <- HoltWinters(x, alpha = alpha,
                           beta  = beta,
                           gamma = FALSE)

pred_holt   <- predict(lisse_holt, n.ahead = h)

plot(lisse_holt,
     main = paste0("Holt  (α = ", alpha, ", β = ", beta, ")"),
     col  = c("gray40", "darkorange"),
     xlab = "Temps", ylab = "Prix")
lines(pred_holt, col = "red", lty = 2, lwd = 2)
legend("topleft",
       legend = c("Observé", "Lissé", "Prédiction"),
       col    = c("gray40", "darkorange", "red"),
       lty    = c(1, 1, 2), bty = "n", cex = 0.8)


# ══════════════════════════════════════════════════════════
#  3. HOLT-WINTERS ADDITIF
# ══════════════════════════════════════════════════════════

lisse_add   <- HoltWinters(x, alpha = alpha,
                           beta  = beta,
                           gamma = gamma,
                           seasonal = "additive")

pred_add    <- predict(lisse_add, n.ahead = h)

plot(lisse_add,
     main = paste0("HW Additif  (γ = ", gamma, ")"),
     col  = c("gray40", "darkgreen"),
     xlab = "Temps", ylab = "Prix")
lines(pred_add, col = "red", lty = 2, lwd = 2)
legend("topleft",
       legend = c("Observé", "Lissé", "Prédiction"),
       col    = c("gray40", "darkgreen", "red"),
       lty    = c(1, 1, 2), bty = "n", cex = 0.8)


# ══════════════════════════════════════════════════════════
#  4. HOLT-WINTERS MULTIPLICATIF
# ══════════════════════════════════════════════════════════

lisse_mul   <- HoltWinters(x, alpha = alpha,
                           beta  = beta,
                           gamma = gamma,
                           seasonal = "multiplicative")

pred_mul    <- predict(lisse_mul, n.ahead = h)

plot(lisse_mul,
     main = paste0("HW Multiplicatif  (γ = ", gamma, ")"),
     col  = c("gray40", "purple"),
     xlab = "Temps", ylab = "Prix")
lines(pred_mul, col = "red", lty = 2, lwd = 2)
legend("topleft",
       legend = c("Observé", "Lissé", "Prédiction"),
       col    = c("gray40", "purple", "red"),
       lty    = c(1, 1, 2), bty = "n", cex = 0.8)

par(mfrow = c(1, 1))   # réinitialiser


# ══════════════════════════════════════════════════════════
#  5. AUTO.ARIMA — modèle de référence (comparaison)
# ══════════════════════════════════════════════════════════

modele_auto <- auto.arima(x)
pred_auto   <- forecast(modele_auto, h = h)

plot(pred_auto,
     main = "auto.arima — prédiction avec IC 80% et 95%",
     col  = "gray40",
     xlab = "Temps", ylab = "Prix")


# ══════════════════════════════════════════════════════════
#  6. COMPARAISON DES SSE (qualité d'ajustement)
# ══════════════════════════════════════════════════════════

sse <- data.frame(
  Modèle = c("SES", "Holt", "HW additif", "HW multiplicatif"),
  SSE    = c(lisse_ses$SSE,
             lisse_holt$SSE,
             lisse_add$SSE,
             lisse_mul$SSE)
)

sse$SSE <- round(sse$SSE, 2)
print(sse[order(sse$SSE), ])   # le plus petit SSE = meilleur ajustement


# ══════════════════════════════════════════════════════════
#  7. COMPARAISON GRAPHIQUE SUPERPOSÉE (prédictions futures)
# ══════════════════════════════════════════════════════════

plot(x, xlim = c(start(x)[1], end(x)[1] + 2),
     main = "Comparaison des prédictions",
     col  = "gray40", lwd = 1.5,
     xlab = "Temps", ylab = "Prix (USD)")

lines(pred_ses,  col = "steelblue",  lty = 2, lwd = 1.8)
lines(pred_holt, col = "darkorange", lty = 2, lwd = 1.8)
lines(pred_add,  col = "darkgreen",  lty = 2, lwd = 1.8)
lines(pred_mul,  col = "purple",     lty = 2, lwd = 1.8)
lines(pred_auto$mean, col = "red",   lty = 1, lwd = 2)

legend("topleft",
       legend = c("Observé", "SES", "Holt",
                  "HW additif", "HW multiplicatif", "auto.arima"),
       col    = c("gray40", "steelblue", "darkorange",
                  "darkgreen", "purple", "red"),
       lty    = c(1, 2, 2, 2, 2, 1),
       lwd    = c(1.5, 1.8, 1.8, 1.8, 1.8, 2),
       bty    = "n", cex = 0.8)