# ------------------------------------------------------------
# Script 2: Análisis de clima diario (sin paquetes)
# Archivo: /mnt/data/clima_diario.csv
# Columnas esperadas: ciudad, fecha, tem_max, tem_min
# ------------------------------------------------------------

# 1) Carga de datos
clima <- read.csv("clima_diario.csv", stringsAsFactors = FALSE)

# --- Ajusta nombres para que coincidan con el script:
names(clima)[names(clima) == "temp_max"] <- "tem_max"
names(clima)[names(clima) == "temp_min"] <- "tem_min"

# Si 'fecha' viene como texto y quieres Date:
clima$fecha <- as.Date(clima$fecha)  # adapta el formato si es necesario: as.Date(clima$fecha, "%Y-%m-%d")

# Asegura numéricos en temperaturas (por si el CSV trae texto):
clima$tem_max <- as.numeric(clima$tem_max)
clima$tem_min <- as.numeric(clima$tem_min)

# 2) Nueva columna: amplitud térmica (tem_max - tem_min)
clima$amplitud_termica <- clima$tem_max - clima$tem_min
cat("Primeras filas con amplitud térmica:\n")
print(head(clima, 10))

# 3) Temperatura promedio de cada ciudad (media de (tem_max+tem_min)/2)
clima$temp_media <- (clima$tem_max + clima$tem_min) / 2
promedio_por_ciudad <- aggregate(temp_media ~ ciudad, data = clima,
                                 FUN = function(x) mean(x, na.rm = TRUE))
# También puedes incluir promedios de max y min:
tem_max_prom <- aggregate(tem_max ~ ciudad, data = clima, FUN = function(x) mean(x, na.rm = TRUE))
tem_min_prom <- aggregate(tem_min ~ ciudad, data = clima, FUN = function(x) mean(x, na.rm = TRUE))

# Unir columnas por ciudad (base R):
promedio_por_ciudad <- merge(promedio_por_ciudad, tem_max_prom, by = "ciudad", all.x = TRUE)
promedio_por_ciudad <- merge(promedio_por_ciudad, tem_min_prom, by = "ciudad", all.x = TRUE)

# Renombrar columnas para claridad
names(promedio_por_ciudad) <- c("ciudad", "temp_media_prom", "tem_max_prom", "tem_min_prom")

# Ordenar por temperatura media descendente
promedio_por_ciudad <- promedio_por_ciudad[order(-promedio_por_ciudad$temp_media_prom), ]

cat("\nTemperatura promedio por ciudad:\n")
print(promedio_por_ciudad)

# 4) Días con temperatura máxima > 35 °C
dias_calor_extremo <- clima[!is.na(clima$tem_max) & clima$tem_max > 35, ]
dias_calor_extremo <- dias_calor_extremo[order(dias_calor_extremo$ciudad, dias_calor_extremo$fecha), ]
cat("\nDías con temperatura máxima > 35 °C:\n")
print(dias_calor_extremo)

# 5) Gráfico de barras: temperatura máxima (máximo absoluto observado) por ciudad
maxima_por_ciudad <- aggregate(tem_max ~ ciudad, data = clima,
                               FUN = function(x) max(x, na.rm = TRUE))
# Ordenar para gráfico más legible
maxima_por_ciudad <- maxima_por_ciudad[order(maxima_por_ciudad$tem_max, decreasing = TRUE), ]

# Barplot horizontal
op <- par(mar = c(5, 10, 4, 2) + 0.1)  # margen amplio para etiquetas
barplot(height = maxima_por_ciudad$tem_max,
        names.arg = maxima_por_ciudad$ciudad,
        horiz = TRUE,
        las = 1,
        main = "Temperatura máxima observada por ciudad",
        xlab = "Temperatura máxima (°C)")
par(op)

# --- Si prefieres barras del promedio de las máximas por ciudad (en vez del máximo absoluto):
# maxima_prom <- aggregate(tem_max ~ ciudad, data = clima, FUN = function(x) mean(x, na.rm = TRUE))
# maxima_prom <- maxima_prom[order(maxima_prom$tem_max, decreasing = TRUE), ]
# op <- par(mar = c(5, 10, 4, 2) + 0.1)
# barplot(height = maxima_prom$tem_max,
#         names.arg = maxima_prom$ciudad,
#         horiz = TRUE,
#         las = 1,
#         main = "Temperatura máxima promedio por ciudad",
#         xlab = "Temperatura (°C)")
# par(op)
