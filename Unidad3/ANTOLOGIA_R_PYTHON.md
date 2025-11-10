# Antología de Ejercicios: De R a Python

## Tabla de Contenidos
1. [Introducción](#introducción)
2. [Ejercicio 1: Análisis de Ventas](#ejercicio-1-análisis-de-ventas)
3. [Ejercicio 2: Análisis de Rendimiento de Alumnos](#ejercicio-2-análisis-de-rendimiento-de-alumnos)
4. [Ejercicio 3: Análisis de Clima Diario](#ejercicio-3-análisis-de-clima-diario)
5. [Ejercicio 4: Análisis de Ventas por Sucursal](#ejercicio-4-análisis-de-ventas-por-sucursal)
6. [Ejercicio 5: Análisis de Contaminación por Ciudad](#ejercicio-5-análisis-de-contaminación-por-ciudad)
7. [Comparación R vs Python](#comparación-r-vs-python)
8. [Conclusiones](#conclusiones)

---

## Introducción

Esta antología presenta una colección de ejercicios de análisis de datos implementados tanto en **R** como en **Python**. El objetivo es mostrar las equivalencias entre ambos lenguajes y facilitar la transición de R a Python para análisis de datos.

### Tecnologías Utilizadas

**R:**
- Base R (read.csv, aggregate, boxplot, etc.)
- Gráficos base de R

**Python:**
- pandas (manipulación de datos)
- matplotlib (visualización)
- numpy (operaciones numéricas)

---

## Ejercicio 1: Análisis de Ventas

### Objetivo
Analizar datos de ventas por categoría y ciudad, calculando ingresos totales y generando rankings.

### Archivo de datos
`Ejercicio_ventas.csv` con columnas: `order_id`, `categoria`, `producto`, `ciudad`, `metodo_pago`, `precio_unitario`, `cantidad`, `fecha`

### Implementación en R

```r
# Leer el CSV
ventas <- read.csv("Ejercicio_ventas.csv", stringsAsFactors = FALSE)

# Verificar valores faltantes
na_por_col <- colSums(is.na(ventas))
print(na_por_col)

# Rangos de precio y cantidad
rango_precio <- range(ventas$precio_unitario, na.rm = TRUE)
rango_cantidad <- range(ventas$cantidad, na.rm = TRUE)

# Nueva columna: ingresos
ventas$ingresos <- ventas$precio_unitario * ventas$cantidad

# Ingreso promedio
ingreso_promedio <- mean(ventas$ingresos, na.rm = TRUE)

# Ranking por categoría
ranking_categoria <- aggregate(ingresos ~ categoria, 
                               data = ventas, 
                               FUN = sum)
ranking_categoria <- ranking_categoria[order(-ranking_categoria$ingresos), ]

# Gráfico de barras
barplot(ranking_categoria$ingresos,
        names.arg = ranking_categoria$categoria,
        main = "Ingresos totales por categoría",
        xlab = "Categoría",
        ylab = "Ingresos totales",
        col = "skyblue")
```

### Implementación en Python

```python
import pandas as pd
import matplotlib.pyplot as plt

# Leer el CSV
ventas = pd.read_csv("../../Unidad2/csv/Ejercicio_ventas.csv")

# Verificar valores faltantes
na_por_col = ventas.isna().sum()
print("Valores faltantes por columna:")
print(na_por_col)

# Rangos de precio y cantidad
rango_precio = (ventas['precio_unitario'].min(), ventas['precio_unitario'].max())
rango_cantidad = (ventas['cantidad'].min(), ventas['cantidad'].max())

# Nueva columna: ingresos
ventas['ingresos'] = ventas['precio_unitario'] * ventas['cantidad']

# Ingreso promedio
ingreso_promedio = ventas['ingresos'].mean()
print(f"Ingreso promedio de una venta: {ingreso_promedio}")

# Ranking por categoría
ranking_categoria = (ventas.groupby('categoria')['ingresos']
                     .sum()
                     .reset_index()
                     .rename(columns={'ingresos': 'ingresos_totales'})
                     .sort_values('ingresos_totales', ascending=False))

# Gráfico de barras
plt.figure(figsize=(10, 6))
plt.bar(ranking_categoria['categoria'], 
        ranking_categoria['ingresos_totales'],
        color='skyblue')
plt.xlabel('Categoría')
plt.ylabel('Ingresos totales')
plt.title('Ingresos totales por categoría')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig('ingresos_por_categoria.png')
plt.show()
```

### Resultados Obtenidos

**Valores faltantes:**
- ciudad: 1 valor nulo

**Rangos:**
- Precio unitario: 129.23 a 60397
- Cantidad: 1 a 4

**Ingreso promedio:** 4845.98

**Ranking por categoría:**
1. Hogar: 217,086
2. Juguetes: 140,093
3. Electrónica: 109,267
4. Libros: 51,956
5. Ropa: 48,578

### Diferencias Clave R vs Python
- **Lectura de datos**: `read.csv()` vs `pd.read_csv()`
- **Valores NA**: `is.na()` vs `isna()`
- **Agregación**: `aggregate()` vs `groupby().sum()`
- **Ordenamiento**: `order()` vs `sort_values()`
- **Gráficos**: Base R vs matplotlib

---

## Ejercicio 2: Análisis de Rendimiento de Alumnos

### Objetivo
Analizar el rendimiento académico de estudiantes por carrera y materia, identificando patrones y calculando estadísticas descriptivas.

### Archivo de datos
`rendimiento_alumnos.csv` con columnas: `alumno`, `carrera`, `materia`, `calificacion`

### Implementación en R

```r
# Carga de datos
alumnos <- read.csv("rendimiento_alumnos.csv", stringsAsFactors = FALSE)

# Filtrar alumnos con calificación > 85
alumnos_mas_85 <- alumnos[alumnos$calificacion > 85, ]
print(alumnos_mas_85)

# Promedio por carrera
promedio_por_carrera <- aggregate(calificacion ~ carrera, 
                                  data = alumnos, 
                                  FUN = mean)
promedio_por_carrera <- promedio_por_carrera[order(-promedio_por_carrera$calificacion), ]

# Boxplot por materia
boxplot(calificacion ~ materia, 
        data = alumnos,
        main = "Distribución de calificaciones por materia",
        xlab = "Materia",
        ylab = "Calificación")

# Estadísticos por materia
alumnos_por_materia <- split(alumnos$calificacion, alumnos$materia)
stats <- lapply(alumnos_por_materia, function(x) {
  c(n = length(x),
    min = min(x, na.rm = TRUE),
    q1 = quantile(x, 0.25, na.rm = TRUE),
    media = mean(x, na.rm = TRUE),
    mediana = median(x, na.rm = TRUE),
    q3 = quantile(x, 0.75, na.rm = TRUE),
    max = max(x, na.rm = TRUE),
    sd = sd(x, na.rm = TRUE))
})
```

### Implementación en Python

```python
import pandas as pd
import matplotlib.pyplot as plt

# Carga de datos
alumnos = pd.read_csv("../../Unidad2/R3/rendimiento_alumnos.csv")

# Filtrar alumnos con calificación > 85
alumnos_mas_85 = alumnos[alumnos['calificacion'] > 85]
print("Alumnos con calificación > 85:")
print(alumnos_mas_85)

# Promedio por carrera
promedio_por_carrera = (alumnos.groupby('carrera')['calificacion']
                        .mean()
                        .reset_index()
                        .sort_values('calificacion', ascending=False))

# Boxplot por materia
plt.figure(figsize=(10, 6))
alumnos.boxplot(column='calificacion', by='materia', grid=False)
plt.suptitle('')
plt.title('Distribución de calificaciones por materia')
plt.xlabel('Materia')
plt.ylabel('Calificación')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig('boxplot_calificaciones_materia.png')
plt.show()

# Estadísticos por materia
stats_por_materia = alumnos.groupby('materia')['calificacion'].agg([
    ('n', 'count'),
    ('min', 'min'),
    ('q1', lambda x: x.quantile(0.25)),
    ('media', 'mean'),
    ('mediana', 'median'),
    ('q3', lambda x: x.quantile(0.75)),
    ('max', 'max'),
    ('sd', 'std')
]).reset_index()
```

### Análisis de Resultados

El boxplot permite visualizar:
- **Mediana** de calificaciones por materia
- **Dispersión** de los datos (rango intercuartílico)
- **Valores atípicos** (outliers)
- **Comparación** entre materias

Los estadísticos descriptivos proporcionan información detallada sobre la distribución de calificaciones en cada materia.

### Diferencias Clave R vs Python
- **Filtrado**: `df[condición, ]` vs `df[condición]`
- **Agrupación con múltiples estadísticas**: `split() + lapply()` vs `groupby().agg()`
- **Boxplot**: `boxplot()` base R vs `df.boxplot()` de pandas
- **Cuantiles**: `quantile()` vs `quantile()`

---

## Ejercicio 3: Análisis de Clima Diario

### Objetivo
Analizar temperaturas máximas y mínimas por ciudad, calcular amplitud térmica y identificar días con calor extremo.

### Archivo de datos
`clima_diario.csv` con columnas: `fecha`, `ciudad`, `temp_max`, `temp_min`, `humedad`, `lluvia_mm`

### Implementación en R

```r
# Carga de datos
clima <- read.csv("clima_diario.csv", stringsAsFactors = FALSE)

# Renombrar columnas
names(clima)[names(clima) == "temp_max"] <- "tem_max"
names(clima)[names(clima) == "temp_min"] <- "tem_min"

# Convertir fecha
clima$fecha <- as.Date(clima$fecha)

# Nueva columna: amplitud térmica
clima$amplitud_termica <- clima$tem_max - clima$tem_min

# Temperatura promedio por ciudad
clima$temp_media <- (clima$tem_max + clima$tem_min) / 2
promedio_por_ciudad <- aggregate(cbind(temp_media, tem_max, tem_min) ~ ciudad, 
                                 data = clima, 
                                 FUN = mean)

# Días con temperatura > 35°C
dias_calor_extremo <- clima[clima$tem_max > 35, ]

# Gráfico de barras horizontal
maxima_por_ciudad <- aggregate(tem_max ~ ciudad, 
                               data = clima, 
                               FUN = max)
barplot(maxima_por_ciudad$tem_max,
        names.arg = maxima_por_ciudad$ciudad,
        horiz = TRUE,
        main = "Temperatura máxima observada por ciudad",
        xlab = "Temperatura máxima (°C)")
```

### Implementación en Python

```python
import pandas as pd
import matplotlib.pyplot as plt

# Carga de datos
clima = pd.read_csv("../../Unidad2/R3/clima_diario.csv")

# Renombrar columnas
clima.rename(columns={'temp_max': 'tem_max', 'temp_min': 'tem_min'}, inplace=True)

# Convertir fecha
clima['fecha'] = pd.to_datetime(clima['fecha'])

# Nueva columna: amplitud térmica
clima['amplitud_termica'] = clima['tem_max'] - clima['tem_min']

# Temperatura promedio por ciudad
clima['temp_media'] = (clima['tem_max'] + clima['tem_min']) / 2
promedio_por_ciudad = clima.groupby('ciudad').agg({
    'temp_media': 'mean',
    'tem_max': 'mean',
    'tem_min': 'mean'
}).reset_index()

# Días con temperatura > 35°C
dias_calor_extremo = clima[clima['tem_max'] > 35].copy()

# Gráfico de barras horizontal
maxima_por_ciudad = (clima.groupby('ciudad')['tem_max']
                     .max()
                     .reset_index()
                     .sort_values('tem_max', ascending=True))

plt.figure(figsize=(10, 6))
plt.barh(maxima_por_ciudad['ciudad'], maxima_por_ciudad['tem_max'], color='coral')
plt.xlabel('Temperatura máxima (°C)')
plt.ylabel('Ciudad')
plt.title('Temperatura máxima observada por ciudad')
plt.tight_layout()
plt.savefig('temperatura_maxima_por_ciudad.png')
plt.show()
```

### Insights del Análisis

**Amplitud térmica**: Diferencia entre temperatura máxima y mínima diaria, indicador de:
- Clima continental vs. marítimo
- Estabilidad climática
- Condiciones extremas

**Días con calor extremo (>35°C)**: Importante para:
- Alertas de salud pública
- Planificación de recursos energéticos
- Análisis de cambio climático

### Diferencias Clave R vs Python
- **Renombrar columnas**: `names(df) <- c()` vs `df.rename(columns={})`
- **Fechas**: `as.Date()` vs `pd.to_datetime()`
- **Agregación múltiple**: `aggregate(cbind())` vs `groupby().agg({})`
- **Gráfico horizontal**: `barplot(horiz=TRUE)` vs `plt.barh()`

---

## Ejercicio 4: Análisis de Ventas por Sucursal

### Objetivo
Analizar el desempeño de diferentes sucursales considerando ventas, clientes, devoluciones y métodos de pago.

### Archivo de datos
`ventas_sucursales.csv` con columnas: `sucursal`, `ventas`, `clientes`, `devoluciones`, `metodo_pago`

### Implementación en R

```r
# Carga de datos
ventas <- read.csv("ventas_sucursales.csv", stringsAsFactors = FALSE)

# Limpieza: eliminar NA y rellenar devoluciones
ventas <- ventas[!is.na(ventas$ventas) & !is.na(ventas$clientes), ]
ventas$devoluciones[is.na(ventas$devoluciones)] <- 0

# Ventas netas
ventas$ventas_netas <- ventas$ventas - (ventas$devoluciones * 0.8)

# Total por sucursal
total_ventas_por_sucursal <- aggregate(ventas_netas ~ sucursal, 
                                       data = ventas, 
                                       FUN = sum)

# Ventas por cliente
ventas$ventas_por_cliente <- ventas$ventas_netas / ventas$clientes
promedio_ventas_cliente <- aggregate(ventas_por_cliente ~ sucursal, 
                                     data = ventas, 
                                     FUN = mean)

# Boxplot por método de pago
boxplot(ventas_netas ~ metodo_pago,
        data = ventas,
        main = "Distribución de ventas netas por método de pago",
        xlab = "Método de pago",
        ylab = "Ventas netas")
```

### Implementación en Python

```python
import pandas as pd
import matplotlib.pyplot as plt

# Carga de datos
ventas = pd.read_csv("../../Unidad2/R4/ventas_sucursales.csv")

# Limpieza: eliminar NA y rellenar devoluciones
ventas = ventas.dropna(subset=['ventas', 'clientes'])
ventas['devoluciones'] = ventas['devoluciones'].fillna(0)

# Ventas netas
ventas['ventas_netas'] = ventas['ventas'] - (ventas['devoluciones'] * 0.8)

# Total por sucursal
total_ventas_por_sucursal = (ventas.groupby('sucursal')['ventas_netas']
                             .sum()
                             .reset_index()
                             .sort_values('ventas_netas', ascending=False))

# Ventas por cliente
ventas['ventas_por_cliente'] = ventas['ventas_netas'] / ventas['clientes']
promedio_ventas_cliente = (ventas.groupby('sucursal')['ventas_por_cliente']
                           .mean()
                           .reset_index())

# Boxplot por método de pago
plt.figure(figsize=(10, 6))
ventas.boxplot(column='ventas_netas', by='metodo_pago', grid=False)
plt.suptitle('')
plt.title('Distribución de ventas netas por método de pago')
plt.xlabel('Método de pago')
plt.ylabel('Ventas netas')
plt.tight_layout()
plt.savefig('ventas_por_metodo_pago.png')
plt.show()
```

### Métricas Clave

**Ventas Netas**: `ventas - (devoluciones × 0.8)`
- Considera el impacto de devoluciones
- Factor 0.8 representa costo de procesamiento

**Ventas por Cliente**: `ventas_netas / clientes`
- Indicador de ticket promedio
- Útil para comparar eficiencia entre sucursales

### Diferencias Clave R vs Python
- **Eliminar NA**: `df[!is.na(df$col), ]` vs `df.dropna(subset=['col'])`
- **Rellenar NA**: `df$col[is.na(df$col)] <- valor` vs `df['col'].fillna(valor)`
- **Operaciones vectoriales**: Similar sintaxis en ambos lenguajes

---

## Ejercicio 5: Análisis de Contaminación por Ciudad

### Objetivo
Analizar niveles de contaminación del aire en diferentes ciudades, crear un índice de calidad del aire y estudiar su relación con la temperatura.

### Archivo de datos
`contaminacion_ciudades.csv` con columnas: `ciudad`, `fecha`, `pm10`, `pm2_5`, `no2`, `co`, `temperatura`

### Implementación en R

```r
# Carga de datos
cont <- read.csv("contaminacion_ciudades.csv", stringsAsFactors = FALSE)
cont$fecha <- as.Date(cont$fecha)

# Media y desviación estándar
contaminantes <- c("pm10", "pm2_5", "no2", "co")
for (v in contaminantes) {
  media <- mean(cont[[v]], na.rm = TRUE)
  desv <- sd(cont[[v]], na.rm = TRUE)
  cat(v, "-> Media:", round(media, 2), "| Desv.Est:", round(desv, 2), "\n")
}

# Rellenar NA con media
for (v in contaminantes) {
  if (any(is.na(cont[[v]]))) {
    media <- mean(cont[[v]], na.rm = TRUE)
    cont[[v]][is.na(cont[[v]])] <- media
  }
}

# Índice de calidad del aire
cont$indice_calidad <- (cont$pm10 * 0.3) + 
                       (cont$pm2_5 * 0.4) + 
                       (cont$no2 * 0.2) + 
                       (cont$co * 0.1)

# Clasificar nivel
cont$nivel <- ifelse(cont$indice_calidad <= 50, "Bueno",
                     ifelse(cont$indice_calidad <= 100, "Regular", "Malo"))

# Promedio por ciudad
promedio_ciudad <- aggregate(indice_calidad ~ ciudad, 
                             data = cont, 
                             FUN = mean)

# Correlación temperatura-contaminación
correlacion <- cor(cont$temperatura, cont$indice_calidad, use = "complete.obs")
cat("\nCorrelación temperatura-contaminación:", round(correlacion, 3), "\n")

# Gráfico de líneas (tendencia)
ciudad_ref <- unique(cont$ciudad)[1]
datos_ciudad <- cont[cont$ciudad == ciudad_ref, ]
plot(datos_ciudad$fecha, datos_ciudad$indice_calidad, 
     type = "l", 
     col = "blue",
     main = paste("Tendencia del índice de calidad -", ciudad_ref),
     xlab = "Fecha", 
     ylab = "Índice de calidad")
```

### Implementación en Python

```python
import pandas as pd
import matplotlib.pyplot as plt

# Carga de datos
cont = pd.read_csv("../../Unidad2/R4/contaminacion_ciudades.csv")
cont['fecha'] = pd.to_datetime(cont['fecha'])

# Media y desviación estándar
contaminantes = ["pm10", "pm2_5", "no2", "co"]
print("Media y desviación estándar de contaminantes:")
for v in contaminantes:
    if v in cont.columns:
        media = cont[v].mean()
        desv = cont[v].std()
        print(f"{v} -> Media: {media:.2f} | Desv.Est: {desv:.2f}")

# Rellenar NA con media
for v in contaminantes:
    if v in cont.columns and cont[v].isna().any():
        media = cont[v].mean()
        cont[v] = cont[v].fillna(media)

# Índice de calidad del aire
cont['indice_calidad'] = (cont['pm10'] * 0.3 + 
                          cont['pm2_5'] * 0.4 + 
                          cont['no2'] * 0.2 + 
                          cont['co'] * 0.1)

# Clasificar nivel
cont['nivel'] = pd.cut(cont['indice_calidad'], 
                       bins=[0, 50, 100, float('inf')],
                       labels=['Bueno', 'Regular', 'Malo'])

# Promedio por ciudad
promedio_ciudad = (cont.groupby('ciudad')['indice_calidad']
                   .mean()
                   .reset_index()
                   .sort_values('indice_calidad', ascending=False))

# Correlación temperatura-contaminación
correlacion = cont['temperatura'].corr(cont['indice_calidad'])
print(f"Correlación temperatura-contaminación: {correlacion:.3f}")

# Gráfico de líneas (tendencia)
ciudad_ref = cont['ciudad'].unique()[0]
datos_ciudad = cont[cont['ciudad'] == ciudad_ref]
plt.figure(figsize=(12, 6))
plt.plot(datos_ciudad['fecha'], datos_ciudad['indice_calidad'], color='blue')
plt.title(f"Tendencia del índice de calidad - {ciudad_ref}")
plt.xlabel('Fecha')
plt.ylabel('Índice de calidad')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('tendencia_calidad_aire.png')
plt.show()
```

### Análisis del Índice de Calidad del Aire

**Fórmula del índice:**
$$\text{Índice} = (PM_{10} \times 0.3) + (PM_{2.5} \times 0.4) + (NO_2 \times 0.2) + (CO \times 0.1)$$

**Clasificación:**
- **Bueno**: < 50
- **Regular**: 50-100
- **Malo**: > 100

**Interpretación de la correlación:**
- |r| < 0.3: Relación débil
- 0.3 ≤ |r| < 0.7: Relación moderada
- |r| ≥ 0.7: Relación fuerte

### Diferencias Clave R vs Python
- **Bucles con nombres de columnas**: Similar en ambos lenguajes
- **Condicionales**: `ifelse()` vs `pd.cut()` o numpy.where
- **Correlación**: `cor()` vs `corr()`
- **Gráfico de líneas**: `plot(type="l")` vs `plt.plot()`

---

## Comparación R vs Python

### Tabla de Equivalencias

| Operación | R | Python (pandas) |
|-----------|---|-----------------|
| Leer CSV | `read.csv("file.csv")` | `pd.read_csv("file.csv")` |
| Ver primeras filas | `head(df)` | `df.head()` |
| Dimensiones | `dim(df)` | `df.shape` |
| Nombres de columnas | `names(df)` | `df.columns` |
| Renombrar columnas | `names(df) <- c()` | `df.rename(columns={})` |
| Filtrar filas | `df[df$col > 5, ]` | `df[df['col'] > 5]` |
| Seleccionar columnas | `df[, c("col1", "col2")]` | `df[['col1', 'col2']]` |
| Crear nueva columna | `df$nueva <- valor` | `df['nueva'] = valor` |
| Valores únicos | `unique(df$col)` | `df['col'].unique()` |
| Contar valores | `table(df$col)` | `df['col'].value_counts()` |
| Valores NA | `is.na(df$col)` | `df['col'].isna()` |
| Eliminar NA | `na.omit(df)` | `df.dropna()` |
| Rellenar NA | `df$col[is.na(df$col)] <- 0` | `df['col'].fillna(0)` |
| Agrupar y agregar | `aggregate(y ~ x, data=df, FUN=mean)` | `df.groupby('x')['y'].mean()` |
| Ordenar | `df[order(df$col), ]` | `df.sort_values('col')` |
| Unir dataframes | `merge(df1, df2, by="key")` | `pd.merge(df1, df2, on='key')` |
| Estadísticas | `summary(df)` | `df.describe()` |
| Media | `mean(x, na.rm=TRUE)` | `x.mean()` |
| Mediana | `median(x, na.rm=TRUE)` | `x.median()` |
| Desviación estándar | `sd(x, na.rm=TRUE)` | `x.std()` |
| Correlación | `cor(x, y)` | `x.corr(y)` |
| Fechas | `as.Date()` | `pd.to_datetime()` |
| A numérico | `as.numeric()` | `pd.to_numeric()` |

### Visualizaciones

| Tipo de Gráfico | R (base) | Python (matplotlib) |
|-----------------|----------|---------------------|
| Gráfico de dispersión | `plot(x, y)` | `plt.scatter(x, y)` |
| Gráfico de líneas | `plot(x, y, type="l")` | `plt.plot(x, y)` |
| Gráfico de barras | `barplot(x)` | `plt.bar(x, y)` |
| Barras horizontales | `barplot(x, horiz=TRUE)` | `plt.barh(x, y)` |
| Histograma | `hist(x)` | `plt.hist(x)` |
| Boxplot | `boxplot(x)` | `plt.boxplot(x)` |
| Título | `main="titulo"` | `plt.title("titulo")` |
| Etiqueta X | `xlab="etiqueta"` | `plt.xlabel("etiqueta")` |
| Etiqueta Y | `ylab="etiqueta"` | `plt.ylabel("etiqueta")` |
| Colores | `col="red"` | `color='red'` |
| Guardar gráfico | `png("file.png"); plot(...); dev.off()` | `plt.savefig("file.png")` |

### Ventajas y Desventajas

#### R
**Ventajas:**
- ✅ Diseñado específicamente para estadística
- ✅ Sintaxis más concisa para operaciones estadísticas
- ✅ Excelente para análisis exploratorio rápido
- ✅ Gran cantidad de paquetes especializados (CRAN)
- ✅ RStudio como IDE integrado

**Desventajas:**
- ❌ Menos flexible para programación general
- ❌ Curva de aprendizaje pronunciada para principiantes
- ❌ Menor compatibilidad con otros lenguajes
- ❌ Sintaxis inconsistente entre paquetes

#### Python
**Ventajas:**
- ✅ Lenguaje de propósito general
- ✅ Sintaxis más limpia y consistente
- ✅ Mejor integración con ML/AI (TensorFlow, PyTorch)
- ✅ Gran comunidad y ecosistema
- ✅ Facilita la transición a producción

**Desventajas:**
- ❌ Requiere más librerías para análisis completo
- ❌ Algunas operaciones estadísticas son menos directas
- ❌ Sintaxis más verbosa para ciertas operaciones

---

## Conclusiones

### Aprendizajes Clave

1. **Ambos lenguajes son poderosos** para análisis de datos, cada uno con sus fortalezas.

2. **La transición de R a Python** es factible siguiendo patrones de equivalencia sistemáticos.

3. **pandas es el equivalente de base R** para manipulación de datos, mientras que matplotlib/seaborn son equivalentes a ggplot2 para visualización.

4. **Python ofrece mayor versatilidad** cuando el análisis requiere integración con sistemas de producción o aplicaciones de machine learning.

5. **R sigue siendo superior** para análisis estadísticos especializados y cuando se requiere rapidez en exploración de datos.

### Recomendaciones

**Para principiantes:**
- Comienza con Python si planeas hacer ML/AI
- Comienza con R si tu enfoque es puramente estadístico

**Para profesionales:**
- Aprende ambos lenguajes para maximizar oportunidades
- Usa R para análisis exploratorio y Python para producción
- Considera RStudio para R y Jupyter/VS Code para Python

**Para equipos:**
- Estandariza en un lenguaje según el dominio del proyecto
- Mantén documentación clara de conversiones
- Usa control de versiones (Git) para ambos lenguajes

### Recursos Adicionales

**Librerías Python útiles:**
- `pandas`: Manipulación de datos
- `numpy`: Operaciones numéricas
- `matplotlib`: Visualización básica
- `seaborn`: Visualización estadística
- `scikit-learn`: Machine learning
- `statsmodels`: Modelos estadísticos

**Paquetes R útiles:**
- `dplyr`: Manipulación de datos
- `tidyr`: Limpieza de datos
- `ggplot2`: Visualización
- `caret`: Machine learning
- `shiny`: Aplicaciones web interactivas

### Próximos Pasos

1. Practicar con datasets propios
2. Explorar visualizaciones avanzadas (seaborn, plotly)
3. Aprender SQL para complementar análisis
4. Estudiar machine learning con scikit-learn o caret
5. Crear pipelines automatizados de análisis

---

## Anexos

### Estructura de Archivos del Proyecto

```
ModelosCienciasDatos/
├── Unidad2/
│   ├── csv/
│   │   ├── Ejercicio_ventas.csv
│   │   └── ejercicio.r
│   ├── R3/
│   │   ├── clima_diario.csv
│   │   ├── rendimiento_alumnos.csv
│   │   ├── ejercicio1.r
│   │   └── ejercicio2.r
│   └── R4/
│       ├── contaminacion_ciudades.csv
│       ├── ventas_sucursales.csv
│       ├── ejercicio1.r
│       └── ejercicio2.r
├── Unidad3/
│   ├── Unidad1/
│   │   └── ejercicio1.py
│   ├── Unidad2/
│   │   ├── ejercicio1.py
│   │   └── ejercicio3.py
│   ├── Unidad3/
│   │   ├── ejercicio1.py
│   │   └── ejercicio2.py
│   └── ANTOLOGIA_R_PYTHON.md
```

### Referencias

- [Documentación de pandas](https://pandas.pydata.org/docs/)
- [Documentación de matplotlib](https://matplotlib.org/stable/contents.html)
- [R for Data Science](https://r4ds.had.co.nz/)
- [Python Data Science Handbook](https://jakevdp.github.io/PythonDataScienceHandbook/)

---

**Autor:** Estudiante de Ciencia de Datos  
**Fecha:** Noviembre 2025  
**Versión:** 1.0

---

*Esta antología fue creada con fines educativos como parte del curso de Modelos en Ciencias de Datos.*
