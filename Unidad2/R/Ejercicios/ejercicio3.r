set.seed(123)
lanzamientos <- sample(1:6, 50, replace = TRUE)

print("Resultados de los 50 lanzamientos:")
print(lanzamientos)

conteo <- table(lanzamientos)
print("Cantidad de veces que salió cada cara:")
print(conteo)

frecuencia <- prop.table(conteo)
print("Frecuencia de cada cara:")
print(frecuencia)

resultado <- data.frame(
  Cara = as.numeric(names(conteo)),
  Veces = as.numeric(conteo),
  Frecuencia = round(as.numeric(frecuencia), 2)
)

print("=== RESULTADOS FINALES ===")
print(resultado)

 