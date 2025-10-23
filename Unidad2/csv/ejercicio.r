# ============================================
# ANALISIS DE VENTAS - RESPUESTAS DIRECTAS
# ============================================

# 1. Cargar librerías
library(dplyr)
library(ggplot2)
library(readr)

# 2. Leer el CSV
ventas <- read_csv("Ejercicio_ventas.csv")

# ==============================
# 1) Columnas con valores faltantes
# ==============================
na_por_col <- colSums(is.na(ventas))
na_por_col

# ==============================
# 2) Valores mínimos y máximos de precio_unitario y cantidad
# ==============================
rango_precio <- range(ventas$precio_unitario, na.rm = TRUE)
rango_cantidad <- range(ventas$cantidad, na.rm = TRUE)

cat("Rango de precio_unitario:", rango_precio[1], "a", rango_precio[2], "\n")
cat("Rango de cantidad:", rango_cantidad[1], "a", rango_cantidad[2], "\n")

# ==============================
# 3) Nueva columna “ingresos” = precio × cantidad
# ==============================
ventas <- ventas %>%
  mutate(ingresos = precio_unitario * cantidad)

head(ventas)

# ==============================
# 4) Estadísticas básicas
# ==============================
summary(ventas$ingresos)

# ==============================
# 5) Ingreso promedio de una venta
# ==============================
ingreso_promedio <- mean(ventas$ingresos, na.rm = TRUE)
cat("Ingreso promedio de una venta:", ingreso_promedio, "\n")

# ==============================
# 6) Filtrar ventas de una ciudad o categoría específica
# ==============================
# Ejemplo: Ciudad = "Monterrey"
ventas_mty <- ventas %>% filter(ciudad == "Monterrey")

# Ejemplo: Categoría = "Electrónica"
ventas_elec <- ventas %>% filter(categoria == "Electrónica")

# Puedes imprimir para revisar:
head(ventas_mty)
head(ventas_elec)

# ==============================
# 7) ¿Qué ciudad o categoría tiene ventas más altas?
# ==============================
# Por categoría
ranking_categoria <- ventas %>%
  group_by(categoria) %>%
  summarise(ingresos_totales = sum(ingresos, na.rm = TRUE)) %>%
  arrange(desc(ingresos_totales))

cat("Ranking por categoría:\n")
print(ranking_categoria)

# Por ciudad
ranking_ciudad <- ventas %>%
  group_by(ciudad) %>%
  summarise(ingresos_totales = sum(ingresos, na.rm = TRUE)) %>%
  arrange(desc(ingresos_totales))

cat("\nRanking por ciudad:\n")
print(ranking_ciudad)

# ==============================
# 8) Gráfico de barras con los ingresos por categoría
# ==============================
ggplot(ranking_categoria, aes(x = reorder(categoria, -ingresos_totales),
                              y = ingresos_totales,
                              fill = categoria)) +
  geom_col() +
  labs(title = "Ingresos totales por categoría",
       x = "Categoría",
       y = "Ingresos totales") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none")
