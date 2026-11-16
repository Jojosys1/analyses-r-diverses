# ══════════════════════════════════════════════════════════
#  AIRPASSENGERS — LISSAGES SUCCESSIFS + PRÉDICTIONS
# ══════════════════════════════════════════════════════════

library(forecast)

# ── 1. Chargement correct ──────────────────────────────────
data(AirPassengers)          # charge dans l'environnement global
x <- AirPassengers           # AirPassengers est DÉJÀ un objet ts

# Vérifications
class(x)                     # "ts"
frequency(x)                 # 12  (mensuel)
start(x)                     # 1949  1
end(x)                       # 1960 12
summary(x)
plot(x,
     main = "AirPassengers — données brutes",
     col  = "gray40", ylab = "Passagers (milliers)", xlab = "Année")


# ── 2. Décomposition (tendance + saisonnalité + résidu) ──
dec <- decompose(x, type = "multiplicative")  # multiplicatif car variance croissante
plot(dec)


# ══════════════════════════════════════════════════════════
#  PARAMÈTRES GLOBAUX
# ══════════════════════════════════════════════════════════

h     <- 24   # horizon = 24 mois (2 ans)
alpha <- 0.3
beta  <- 0.1
gamma <- 0.4

par(mfrow = c(2, 2))


# ══════════════════════════════════════════════════════════
#  1. LISSAGE EXPONENTIEL SIMPLE (SES)
# ══════════════════════════════════════════════════════════

lisse_ses  <- HoltWinters(x, alpha = alpha,
                          beta  = FALSE,
                          gamma = FALSE)
pred_ses   <- predict(lisse_ses, n.ahead = h)

plot(lisse_ses,
     main = paste0("SES  (α = ", alpha, ")"),
     col  = c("gray40", "steelblue"),
     xlab = "Temps", ylab = "Passagers")
lines(pred_ses, col = "red", lty = 2, lwd = 2)
legend("topleft",
       legend = c("Observé","Lissé","Prédiction"),
       col = c("gray40","steelblue","red"),
       lty = c(1,1,2), bty = "n", cex = 0.8)


# ══════════════════════════════════════════════════════════
#  2. LISSAGE DE HOLT (tendance, sans saisonnalité)
# ══════════════════════════════════════════════════════════

lisse_holt <- HoltWinters(x, alpha = alpha,
                          beta  = beta,
                          gamma = FALSE)
pred_holt  <- predict(lisse_holt, n.ahead = h)

plot(lisse_holt,
     main = paste0("Holt  (α=", alpha, ", β=", beta, ")"),
     col  = c("gray40","darkorange"),
     xlab = "Temps", ylab = "Passagers")
lines(pred_holt, col = "red", lty = 2, lwd = 2)
legend("topleft",
       legend = c("Observé","Lissé","Prédiction"),
       col = c("gray40","darkorange","red"),
       lty = c(1,1,2), bty = "n", cex = 0.8)


# ══════════════════════════════════════════════════════════
#  3. HOLT-WINTERS ADDITIF
# ══════════════════════════════════════════════════════════

lisse_add  <- HoltWinters(x, alpha = alpha,
                          beta  = beta,
                          gamma = gamma,
                          seasonal = "additive")
pred_add   <- predict(lisse_add, n.ahead = h)

plot(lisse_add,
     main = paste0("HW Additif  (γ=", gamma, ")"),
     col  = c("gray40","darkgreen"),
     xlab = "Temps", ylab = "Passagers")
lines(pred_add, col = "red", lty = 2, lwd = 2)
legend("topleft",
       legend = c("Observé","Lissé","Prédiction"),
       col = c("gray40","darkgreen","red"),
       lty = c(1,1,2), bty = "n", cex = 0.8)


# ══════════════════════════════════════════════════════════
#  4. HOLT-WINTERS MULTIPLICATIF  ← recommandé ici !
# ══════════════════════════════════════════════════════════

lisse_mul  <- HoltWinters(x, alpha = alpha,
                          beta  = beta,
                          gamma = gamma,
                          seasonal = "multiplicative")
pred_mul   <- predict(lisse_mul, n.ahead = h)

plot(lisse_mul,
     main = paste0("HW Multiplicatif  (γ=", gamma, ")"),
     col  = c("gray40","purple"),
     xlab = "Temps", ylab = "Passagers")
lines(pred_mul, col = "red", lty = 2, lwd = 2)
legend("topleft",
       legend = c("Observé","Lissé","Prédiction"),
       col = c("gray40","purple","red"),
       lty = c(1,1,2), bty = "n", cex = 0.8)

par(mfrow = c(1,1))


# ══════════════════════════════════════════════════════════
#  5. AUTO.ARIMA — modèle de référence
# ══════════════════════════════════════════════════════════

modele_auto <- auto.arima(x)
summary(modele_auto)         # souvent ARIMA(0,1,1)(0,1,1)[12]
pred_auto   <- forecast(modele_auto, h = h)

plot(pred_auto,
     main = "auto.arima — prédiction avec intervalles de confiance",
     col  = "gray40", xlab = "Temps", ylab = "Passagers")


# ══════════════════════════════════════════════════════════
#  6. COMPARAISON GRAPHIQUE SUPERPOSÉE
# ══════════════════════════════════════════════════════════

plot(x,
     xlim = c(1949, 1963), ylim = c(100, 800),
     main = "Comparaison des prédictions — AirPassengers",
     col  = "gray40", lwd = 1.5,
     xlab = "Année", ylab = "Passagers (milliers)")

lines(pred_ses,       col = "steelblue",  lty = 2, lwd = 1.6)
lines(pred_holt,      col = "darkorange", lty = 2, lwd = 1.6)
lines(pred_add,       col = "darkgreen",  lty = 2, lwd = 1.6)
lines(pred_mul,       col = "purple",     lty = 2, lwd = 1.6)
lines(pred_auto$mean, col = "red",        lty = 1, lwd = 2.0)

legend("topleft",
       legend = c("Observé","SES","Holt",
                  "HW additif","HW multiplicatif","auto.arima"),
       col    = c("gray40","steelblue","darkorange",
                  "darkgreen","purple","red"),
       lty    = c(1,2,2,2,2,1),
       lwd    = c(1.5,1.6,1.6,1.6,1.6,2.0),
       bty    = "n", cex = 0.8)


# ══════════════════════════════════════════════════════════
#  7. TABLEAU DE COMPARAISON DES SSE
# ══════════════════════════════════════════════════════════

sse <- data.frame(
  Modele = c("SES","Holt","HW additif","HW multiplicatif"),
  SSE    = round(c(lisse_ses$SSE, lisse_holt$SSE,
                   lisse_add$SSE, lisse_mul$SSE), 2)
)
print(sse[order(sse$SSE), ])
