# ------------------------------------------------------------
# Script: Analisis de contaminacion por ciudad (sin paquetes)
# Archivo: /mnt/data/contaminacion_ciudades.csv
# Columnas esperadas:
# ciudad, fecha, pm10, pm2_5, no2, co, temperatura
# ------------------------------------------------------------

# 1) Carga de datos
cont <- read.csv("contaminacion_ciudades.csv", stringsAsFactors = FALSE)

# --- Ajusta nombres si difieren:
# names(cont)
# names(cont) <- c("ciudad", "fecha", "pm10", "pm2_5", "no2", "co", "temperatura")

# Convierte fecha a tipo Date (si aplica)
if(!inherits(cont$fecha, "Date")){
  cont$fecha <- as.Date(cont$fecha)
}

# ------------------------------------------------------------
# EXPLORACIÓN INICIAL
# ------------------------------------------------------------

# Calcular media y desviación estándar por contaminante
contaminantes <- c("pm10", "pm2_5", "no2", "co")

cat("Media y desviación estándar de contaminantes:\n")
for (v in contaminantes) {
  media <- mean(cont[[v]], na.rm = TRUE)
  desv  <- sd(cont[[v]], na.rm = TRUE)
  cat(v, "-> Media:", round(media, 2), "| Desv.Est:", round(desv, 2), "\n")
}

# Revisar valores faltantes y reemplazar con la media correspondiente
for (v in contaminantes) {
  if (any(is.na(cont[[v]]))) {
    media <- mean(cont[[v]], na.rm = TRUE)
    cont[[v]][is.na(cont[[v]])] <- media
  }
}

# ------------------------------------------------------------
# CREACIÓN DE VARIABLES
# ------------------------------------------------------------

# Crear columna indice_calidad
cont$indice_calidad <- (cont$pm10 * 0.3) + (cont$pm2_5 * 0.4) + (cont$no2 * 0.2) + (cont$co * 0.1)

# Clasificar nivel de calidad del aire
# (umbral de ejemplo: <50 Bueno, 50–100 Regular, >100 Malo)
cont$nivel <- ifelse(cont$indice_calidad <= 50, "Bueno",
                     ifelse(cont$indice_calidad <= 100, "Regular", "Malo"))

cat("\nPrimeras filas con índice y nivel:\n")
print(head(cont))

# ------------------------------------------------------------
# ANÁLISIS COMPARATIVO
# ------------------------------------------------------------

# Promedio del índice de calidad por ciudad
promedio_ciudad <- aggregate(indice_calidad ~ ciudad, data = cont, mean)
promedio_ciudad <- promedio_ciudad[order(-promedio_ciudad$indice_calidad), ]
cat("\nPromedio del índice de calidad por ciudad:\n")
print(promedio_ciudad)

# Número de días con nivel “Malo” en cada ciudad
dias_malos <- aggregate(nivel ~ ciudad, data = cont, function(x) sum(x == "Malo"))
names(dias_malos)[2] <- "dias_malos"
cat("\nNúmero de días con nivel 'Malo' por ciudad:\n")
print(dias_malos)

# Relación entre temperatura y contaminación (correlación simple)
correlacion <- cor(cont$temperatura, cont$indice_calidad, use = "complete.obs")
cat("\nCorrelación entre temperatura e índice de contaminación:", round(correlacion, 3), "\n")

if (abs(correlacion) < 0.3) {
  cat("Relación débil o casi nula.\n")
} else if (abs(correlacion) < 0.7) {
  cat("Relación moderada.\n")
} else {
  cat("Relación fuerte.\n")
}

# ------------------------------------------------------------
# VISUALIZACIÓN (base R)
# ------------------------------------------------------------

# 1) Gráfico de líneas: tendencia del índice por fecha
# (Si hay muchas ciudades, se grafica solo una a la vez)
ciudades_unicas <- unique(cont$ciudad)
if (length(ciudades_unicas) == 1) {
  plot(cont$fecha, cont$indice_calidad, type = "l", col = "blue",
       main = paste("Tendencia del índice de calidad del aire -", ciudades_unicas[1]),
       xlab = "Fecha", ylab = "Índice de calidad")
} else {
  # Ejemplo: graficar la primera ciudad
  ciudad_ref <- ciudades_unicas[1]
  datos_ciudad <- cont[cont$ciudad == ciudad_ref, ]
  plot(datos_ciudad$fecha, datos_ciudad$indice_calidad, type = "l", col = "blue",
       main = paste("Tendencia del índice de calidad -", ciudad_ref),
       xlab = "Fecha", ylab = "Índice de calidad")
}

# 2) Gráfico de barras: comparación entre ciudades (promedio del índice)
op <- par(mar = c(5, 8, 4, 2) + 0.1)
barplot(
  promedio_ciudad$indice_calidad,
  names.arg = promedio_ciudad$ciudad,
  horiz = TRUE,
  las = 1,
  col = "orange",
  main = "Comparación del índice de calidad por ciudad",
  xlab = "Índice promedio"
)
par(op)

# ------------------------------------------------------------
# FIN DEL SCRIPT
# ------------------------------------------------------------
