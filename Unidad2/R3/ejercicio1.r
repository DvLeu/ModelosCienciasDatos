# ------------------------------------------------------------
# Script 1: Análisis de alumnos (sin paquetes)
# Archivo: /mnt/data/rendimiento_alumnos.csv
# Columnas esperadas: alumno, carrera, materia, calificacion
# ------------------------------------------------------------

# 1) Carga de datos
alumnos <- read.csv("rendimiento_alumnos.csv", stringsAsFactors = FALSE)

# --- Si los nombres difieren, renómbralos aquí:
# names(alumnos) <- c("alumno","carrera","materia","calificacion")

# 2) Muestra solo los alumnos con calificación > 85
alumnos_mas_85 <- alumnos[!is.na(alumnos$calificacion) & alumnos$calificacion > 85, ]
cat("Alumnos con calificación > 85:\n")
print(alumnos_mas_85)

# 3) Promedio de calificación por carrera
promedio_por_carrera <- aggregate(calificacion ~ carrera, data = alumnos,
                                  FUN = function(x) mean(x, na.rm = TRUE))
promedio_por_carrera <- promedio_por_carrera[order(-promedio_por_carrera$calificacion), ]
cat("\nPromedio de calificación por carrera:\n")
print(promedio_por_carrera)

# 4) Boxplot de calificaciones por materia
# Si tu columna "materia" está como texto, conviene factorizar para el orden en el plot:
alumnos$materia <- as.factor(alumnos$materia)
boxplot(calificacion ~ materia, data = alumnos,
        main = "Distribución de calificaciones por materia",
        xlab = "Materia", ylab = "Calificación")

# 5) Cálculos estadísticos por materia y globales
split_calif <- split(alumnos$calificacion, alumnos$materia)

stats_list <- lapply(split_calif, function(x) {
  x <- x[!is.na(x)]
  c(
    n       = length(x),
    min     = if (length(x)) min(x) else NA,
    q1      = if (length(x)) as.numeric(quantile(x, 0.25)) else NA,
    media   = if (length(x)) mean(x) else NA,
    mediana = if (length(x)) median(x) else NA,
    q3      = if (length(x)) as.numeric(quantile(x, 0.75)) else NA,
    max     = if (length(x)) max(x) else NA,
    sd      = if (length(x)) sd(x) else NA
  )
})

stats_por_materia <- do.call(rbind, stats_list)
stats_por_materia <- data.frame(materia = rownames(stats_por_materia),
                                stats_por_materia, row.names = NULL)
# Orden opcional por media desc
stats_por_materia <- stats_por_materia[order(-stats_por_materia$media), ]

cat("\nEstadísticos por materia:\n")
print(stats_por_materia)

# Estadísticos globales
x <- alumnos$calificacion
x <- x[!is.na(x)]
stats_globales <- data.frame(
  n       = length(x),
  min     = if (length(x)) min(x) else NA,
  q1      = if (length(x)) as.numeric(quantile(x, 0.25)) else NA,
  media   = if (length(x)) mean(x) else NA,
  mediana = if (length(x)) median(x) else NA,
  q3      = if (length(x)) as.numeric(quantile(x, 0.75)) else NA,
  max     = if (length(x)) max(x) else NA,
  sd      = if (length(x)) sd(x) else NA
)

cat("\nEstadísticos globales:\n")
print(stats_globales)
