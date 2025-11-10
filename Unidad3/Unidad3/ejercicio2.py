"""
Script: Análisis de contaminación por ciudad (conversión de R a Python)
Archivo: contaminacion_ciudades.csv
Columnas esperadas: ciudad, fecha, pm10, pm2_5, no2, co, temperatura
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# 1) Carga de datos
cont = pd.read_csv("../../Unidad2/R4/contaminacion_ciudades.csv")

# --- Ajusta nombres si difieren:
# cont.columns = ["ciudad", "fecha", "pm10", "pm2_5", "no2", "co", "temperatura"]

# Convierte fecha a tipo Date (si aplica)
cont['fecha'] = pd.to_datetime(cont['fecha'])

# ------------------------------------------------------------
# EXPLORACIÓN INICIAL
# ------------------------------------------------------------

# Calcular media y desviación estándar por contaminante
contaminantes = ["pm10", "pm2_5", "no2", "co"]

print("Media y desviación estándar de contaminantes:")
for v in contaminantes:
    if v in cont.columns:
        media = cont[v].mean()
        desv = cont[v].std()
        print(f"{v} -> Media: {media:.2f} | Desv.Est: {desv:.2f}")
print()

# Revisar valores faltantes y reemplazar con la media correspondiente
for v in contaminantes:
    if v in cont.columns and cont[v].isna().any():
        media = cont[v].mean()
        cont[v] = cont[v].fillna(media)

# ------------------------------------------------------------
# CREACIÓN DE VARIABLES
# ------------------------------------------------------------

# Crear columna indice_calidad
cont['indice_calidad'] = (cont['pm10'] * 0.3 + 
                          cont['pm2_5'] * 0.4 + 
                          cont['no2'] * 0.2 + 
                          cont['co'] * 0.1)

# Clasificar nivel de calidad del aire
# (umbral de ejemplo: <50 Bueno, 50–100 Regular, >100 Malo)
cont['nivel'] = pd.cut(cont['indice_calidad'], 
                       bins=[0, 50, 100, float('inf')],
                       labels=['Bueno', 'Regular', 'Malo'])

print("Primeras filas con índice y nivel:")
print(cont.head())
print()

# ------------------------------------------------------------
# ANÁLISIS COMPARATIVO
# ------------------------------------------------------------

# Promedio del índice de calidad por ciudad
promedio_ciudad = (cont.groupby('ciudad')['indice_calidad']
                   .mean()
                   .reset_index()
                   .sort_values('indice_calidad', ascending=False))
print("Promedio del índice de calidad por ciudad:")
print(promedio_ciudad)
print()

# Número de días con nivel "Malo" en cada ciudad
dias_malos = (cont[cont['nivel'] == 'Malo']
              .groupby('ciudad')
              .size()
              .reset_index(name='dias_malos'))
print("Número de días con nivel 'Malo' por ciudad:")
print(dias_malos)
print()

# Relación entre temperatura y contaminación (correlación simple)
correlacion = cont['temperatura'].corr(cont['indice_calidad'])
print(f"Correlación entre temperatura e índice de contaminación: {correlacion:.3f}")

if abs(correlacion) < 0.3:
    print("Relación débil o casi nula.\n")
elif abs(correlacion) < 0.7:
    print("Relación moderada.\n")
else:
    print("Relación fuerte.\n")

# ------------------------------------------------------------
# VISUALIZACIÓN
# ------------------------------------------------------------

# 1) Gráfico de líneas: tendencia del índice por fecha
ciudades_unicas = cont['ciudad'].unique()
if len(ciudades_unicas) == 1:
    plt.figure(figsize=(12, 6))
    plt.plot(cont['fecha'], cont['indice_calidad'], color='blue')
    plt.title(f"Tendencia del índice de calidad del aire - {ciudades_unicas[0]}")
    plt.xlabel('Fecha')
    plt.ylabel('Índice de calidad')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig('Unidad3/Unidad3/tendencia_calidad_aire.png')
    plt.show()
else:
    # Ejemplo: graficar la primera ciudad
    ciudad_ref = ciudades_unicas[0]
    datos_ciudad = cont[cont['ciudad'] == ciudad_ref]
    plt.figure(figsize=(12, 6))
    plt.plot(datos_ciudad['fecha'], datos_ciudad['indice_calidad'], color='blue')
    plt.title(f"Tendencia del índice de calidad - {ciudad_ref}")
    plt.xlabel('Fecha')
    plt.ylabel('Índice de calidad')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig('Unidad3/Unidad3/tendencia_calidad_aire.png')
    plt.show()

print("Gráfico de tendencia guardado como 'tendencia_calidad_aire.png'\n")

# 2) Gráfico de barras: comparación entre ciudades (promedio del índice)
plt.figure(figsize=(10, 6))
plt.barh(promedio_ciudad['ciudad'], promedio_ciudad['indice_calidad'], color='orange')
plt.xlabel('Índice promedio')
plt.ylabel('Ciudad')
plt.title('Comparación del índice de calidad por ciudad')
plt.tight_layout()
plt.savefig('Unidad3/Unidad3/comparacion_indice_por_ciudad.png')
plt.show()
print("Gráfico de comparación guardado como 'comparacion_indice_por_ciudad.png'")

# ------------------------------------------------------------
# FIN DEL SCRIPT
# ------------------------------------------------------------
