# ------------------------------------------------------------
# Script: Analisis de ventas por sucursal (sin paquetes)
# Archivo: /mnt/data/ventas_sucursales.csv
# Columnas esperadas:
# sucursal, ventas, clientes, devoluciones, metodo_pago
# ------------------------------------------------------------

# 1) Carga de datos
ventas <- read.csv("ventas_sucursales.csv", stringsAsFactors = FALSE)

# --- Si los nombres difieren, ajusta aquí:
# names(ventas)
# names(ventas) <- c("sucursal", "ventas", "clientes", "devoluciones", "metodo_pago")

# ------------------------------------------------------------
# LIMPIEZA BÁSICA
# ------------------------------------------------------------

# Verificar valores nulos en ventas o clientes
cat("Valores nulos en 'ventas':", sum(is.na(ventas$ventas)), "\n")
cat("Valores nulos en 'clientes':", sum(is.na(ventas$clientes)), "\n")

# Opción: eliminar filas con NA en ventas o clientes
ventas <- ventas[!is.na(ventas$ventas) & !is.na(ventas$clientes), ]

# También puedes reemplazar valores faltantes en devoluciones con 0
ventas$devoluciones[is.na(ventas$devoluciones)] <- 0

# Crear nueva columna: ventas_netas = ventas - (devoluciones * 0.8)
ventas$ventas_netas <- ventas$ventas - (ventas$devoluciones * 0.8)

cat("\nPrimeras filas tras limpieza:\n")
print(head(ventas))

# ------------------------------------------------------------
# ANÁLISIS GENERAL
# ------------------------------------------------------------

# Total de ventas por sucursal
total_ventas_por_sucursal <- aggregate(ventas_netas ~ sucursal, data = ventas, sum)
total_ventas_por_sucursal <- total_ventas_por_sucursal[order(-total_ventas_por_sucursal$ventas_netas), ]

cat("\nTotal de ventas netas por sucursal:\n")
print(total_ventas_por_sucursal)

# Promedio de ventas por cliente por sucursal
ventas$ventas_por_cliente <- ventas$ventas_netas / ventas$clientes
promedio_ventas_cliente <- aggregate(ventas_por_cliente ~ sucursal, data = ventas, mean)

# Sucursal con mayor promedio
sucursal_top <- promedio_ventas_cliente$sucursal[which.max(promedio_ventas_cliente$ventas_por_cliente)]

cat("\nSucursal con mayor promedio de ventas por cliente:", sucursal_top, "\n")
print(promedio_ventas_cliente)

# ------------------------------------------------------------
# VISUALIZACIÓN (solo gráficos base)
# ------------------------------------------------------------

# 1) Gráfico de barras — ingresos totales por sucursal
op <- par(mar = c(5, 8, 4, 2) + 0.1)
barplot(
  height = total_ventas_por_sucursal$ventas_netas,
  names.arg = total_ventas_por_sucursal$sucursal,
  horiz = TRUE,
  las = 1,
  col = "skyblue",
  main = "Ingresos totales por sucursal",
  xlab = "Ventas netas"
)
par(op)

# 2) Boxplot — distribución de ventas por método de pago
ventas$metodo_pago <- as.factor(ventas$metodo_pago)

boxplot(
  ventas_netas ~ metodo_pago,
  data = ventas,
  main = "Distribución de ventas netas por método de pago",
  xlab = "Método de pago",
  ylab = "Ventas netas",
  col = "lightgreen"
)
