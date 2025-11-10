"""
Script 2: Análisis de clima diario (conversión de R a Python)
Archivo: clima_diario.csv
Columnas esperadas: ciudad, fecha, tem_max, tem_min
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# 1) Carga de datos
clima = pd.read_csv("../../Unidad2/R3/clima_diario.csv")

# --- Ajusta nombres para que coincidan con el script:
clima.rename(columns={'temp_max': 'tem_max', 'temp_min': 'tem_min'}, inplace=True)

# Si 'fecha' viene como texto y quieres Date:
clima['fecha'] = pd.to_datetime(clima['fecha'])

# Asegura numéricos en temperaturas (por si el CSV trae texto):
clima['tem_max'] = pd.to_numeric(clima['tem_max'], errors='coerce')
clima['tem_min'] = pd.to_numeric(clima['tem_min'], errors='coerce')

# 2) Nueva columna: amplitud térmica (tem_max - tem_min)
clima['amplitud_termica'] = clima['tem_max'] - clima['tem_min']
print("Primeras filas con amplitud térmica:")
print(clima.head(10))
print()

# 3) Temperatura promedio de cada ciudad (media de (tem_max+tem_min)/2)
clima['temp_media'] = (clima['tem_max'] + clima['tem_min']) / 2

promedio_por_ciudad = clima.groupby('ciudad').agg({
    'temp_media': 'mean',
    'tem_max': 'mean',
    'tem_min': 'mean'
}).reset_index()

# Renombrar columnas para claridad
promedio_por_ciudad.columns = ['ciudad', 'temp_media_prom', 'tem_max_prom', 'tem_min_prom']

# Ordenar por temperatura media descendente
promedio_por_ciudad = promedio_por_ciudad.sort_values('temp_media_prom', ascending=False)

print("Temperatura promedio por ciudad:")
print(promedio_por_ciudad)
print()

# 4) Días con temperatura máxima > 35 °C
dias_calor_extremo = clima[clima['tem_max'] > 35].copy()
dias_calor_extremo = dias_calor_extremo.sort_values(['ciudad', 'fecha'])
print("Días con temperatura máxima > 35 °C:")
print(dias_calor_extremo)
print()

# 5) Gráfico de barras: temperatura máxima (máximo absoluto observado) por ciudad
maxima_por_ciudad = (clima.groupby('ciudad')['tem_max']
                     .max()
                     .reset_index()
                     .sort_values('tem_max', ascending=True))

# Barplot horizontal
plt.figure(figsize=(10, 6))
plt.barh(maxima_por_ciudad['ciudad'], maxima_por_ciudad['tem_max'], color='coral')
plt.xlabel('Temperatura máxima (°C)')
plt.ylabel('Ciudad')
plt.title('Temperatura máxima observada por ciudad')
plt.tight_layout()
plt.savefig('Unidad3/Unidad2/temperatura_maxima_por_ciudad.png')
plt.show()
print("Gráfico guardado como 'temperatura_maxima_por_ciudad.png'\n")

# --- Alternativa: barras del promedio de las máximas por ciudad
maxima_prom = (clima.groupby('ciudad')['tem_max']
               .mean()
               .reset_index()
               .sort_values('tem_max', ascending=True))

plt.figure(figsize=(10, 6))
plt.barh(maxima_prom['ciudad'], maxima_prom['tem_max'], color='skyblue')
plt.xlabel('Temperatura (°C)')
plt.ylabel('Ciudad')
plt.title('Temperatura máxima promedio por ciudad')
plt.tight_layout()
plt.savefig('Unidad3/Unidad2/temperatura_maxima_promedio_por_ciudad.png')
plt.show()
print("Gráfico alternativo guardado como 'temperatura_maxima_promedio_por_ciudad.png'")
