set.seed(456) 
n_pacientes <- 40
mu_bp  <- 120   
sd_bp  <- 15    
bp <- rnorm(n_pacientes, mean = mu_bp, sd = sd_bp)
promedio_bp <- mean(bp)
mayor_media <- sum(bp > promedio_bp)
menor_media <- sum(bp < promedio_bp)
igual_media <- sum(abs(bp - promedio_bp) < .Machine$double.eps^0.5)  

en_rango <- sum(bp >= 110 & bp <= 130)

cat("=== Presión arterial (40 pacientes) ===\n")
cat(sprintf("Media poblacional asumida: %.2f\n", mu_bp))
cat(sprintf("Promedio muestral:         %.2f\n", promedio_bp))
cat(sprintf("Pacientes > media:         %d\n", mayor_media))
cat(sprintf("Pacientes < media:         %d\n", menor_media))
cat(sprintf("Pacientes == media:        %d\n", igual_media))
cat(sprintf("En rango [110,130]:        %d\n", en_rango))

hist(
  bp,
  breaks = 10,
  main = "Distribución de presión arterial (mmHg)",
  xlab  = "Presión (mmHg)",
  col = "lightgreen",       
  border = "darkgreen"      
)
abline(v = promedio_bp, lwd = 2, lty = 2, col = "blue")
abline(v = c(110, 130), lty = 3, col = "red")
