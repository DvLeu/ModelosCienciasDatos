# Crear un vector de 30 temperaturas aleatorias entre 18 y 35

set.seed(123)  # Semilla para que los valores sean reproducibles

temperaturas <- runif(30, min = 18, max = 35)

print(temperaturas)



# Calcular medidas estadísticas

media <- mean(temperaturas)

mediana <- median(temperaturas)

máximo <- max(temperaturas)

mínimo <- min(temperaturas)



# Mostrar resultados

cat("Media:", media, "\n")

cat("Mediana:", mediana, "\n")

cat("Máximo:", máximo, "\n")

cat("Mínimo:", mínimo, "\n")



# Calcular temperatura promedio del mes

promedio_mes <- mean(temperaturas)

cat("Temperatura promedio del mes:", promedio_mes, "\n")



# Contar días con temperaturas arriba de 30 y menores a 20

días_mayor_30 <- sum(temperaturas > 30)

días_menor_20 <- sum(temperaturas < 20)



cat("Días con temperatura > 30°C:", días_mayor_30, "\n")

cat("Días con temperatura < 20°C:", días_menor_20, "\n")



# --- Gráficos ---

# 1. Gráfico de líneas

plot(

  temperaturas,

  type = "o",

  col = "blue",

  xlab = "Día",

  ylab = "Temperatura (°C)",

  main = "Temperaturas diarias (Gráfico de líneas)"

)
barplot(

  temperaturas,

  col = "orange",

  xlab = "Día",

  ylab = "Temperatura (°C)",

  main = "Temperaturas diarias (Gráfico de barras)"

)

 
