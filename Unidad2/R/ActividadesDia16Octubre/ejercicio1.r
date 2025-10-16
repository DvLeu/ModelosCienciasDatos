set.seed(123)  
califs <- round(runif(30, min = 0, max = 100))
media_califs   <- mean(califs)
mediana_califs <- median(califs)

aprobados   <- sum(califs >= 70)
reprobados  <- sum(califs < 70)

cat("=== Calificaciones (30 estudiantes) ===\n")
cat("Calificaciones:\n"); print(califs)
cat(sprintf("Media:   %.2f\n", media_califs))
cat(sprintf("Mediana: %.2f\n", mediana_califs))
cat(sprintf("Aprobados (>=70): %d\n", aprobados))
cat(sprintf("Reprobados (<70): %d\n", reprobados))

barplot(
  califs,
  names.arg = paste0("E", 1:length(califs)),
  las = 2,
  main = "Calificaciones por estudiante",
  xlab = "Estudiante",
  ylab = "Calificación",
  ylim = c(0, 100),
  col = ifelse(califs >= 70, "skyblue", "tomato") 
)
abline(h = 70, lty = 2)

