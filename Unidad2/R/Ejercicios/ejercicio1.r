numeros <- c(5, 12, 8, 20, 15, 9, 3, 14, 6, 18, 7, 11, 4, 10, 13, 16, 2, 19, 1, 17)

promedio <- mean(numeros)
cantidad <- length(numeros)
suma_total <- sum(numeros)
valor_minimo <- min(numeros)
valor_maximo <- max(numeros)

cat("Vector:", numeros, "\n")
cat("Promedio:", promedio, "\n")
cat("Cantidad de elementos:", cantidad, "\n")
cat("Suma total:", suma_total, "\n")
cat("Valor mínimo:", valor_minimo, "\n")
cat("Valor máximo:", valor_maximo, "\n")
