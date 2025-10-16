set.seed(789)

dias   <- 1:15
ventas <- sample(2500:8000, size = length(dias), replace = TRUE)

prom_ventas <- mean(ventas)


dia_max <- dias[which.max(ventas)]
dia_min <- dias[which.min(ventas)]

dias_superan_7000 <- dias[ventas > 7000]

cat("=== Ventas diarias (15 días) ===\n")
print(data.frame(Dia = dias, Venta = ventas))
cat(sprintf("Promedio de ventas: %.2f\n", prom_ventas))
cat(sprintf("Día con venta máxima: Día %d (%.0f)\n", dia_max, ventas[dia_max]))
cat(sprintf("Día con venta mínima: Día %d (%.0f)\n", dia_min, ventas[dia_min]))
cat("Días con ventas > 7000: "); print(dias_superan_7000)


plot(
  dias, ventas,
  type = "o",
  xlab = "Día",
  ylab = "Ventas",
  main = "Ventas diarias (línea)",
  ylim = c(min(ventas) * 0.95, max(ventas) * 1.05),
  col = "darkorange",        
  pch = 16,                  
  lwd = 2                   
)
abline(h = 7000, lty = 2, col = "red")
