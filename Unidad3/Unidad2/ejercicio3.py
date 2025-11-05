"""
Script 2: Análisis de clima diario (conversión de R a Python)
Archivo: clima_diario.csv
Columnas esperadas: ciudad, fecha, tem_max, tem_min
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

clima = pd.read_csv("Unidad3/Unidad2/contaminacion_ciudades.csv")


print("Columnas disponibles en el CSV:")
print(clima.columns.tolist())
print()

print("Primeras filas del dataset:")
print(clima.head())
print()

print("Información del DataFrame:")
print(clima.info())
print()

print("Estadísticas descriptivas:")
print(clima.describe())
print()

if 'ciudad' in clima.columns:
    # Agrupar por ciudad
    resumen_ciudad = clima.groupby('ciudad').mean(numeric_only=True)
    print("Promedio de variables por ciudad:")
    print(resumen_ciudad)
    print()
    
    # Gráfico de barras para la primera columna numérica
    primera_col_numerica = clima.select_dtypes(include=[np.number]).columns[0]
    promedio = clima.groupby('ciudad')[primera_col_numerica].mean().sort_values(ascending=False)
    
    plt.figure(figsize=(10, 6))
    plt.bar(promedio.index, promedio.values, color='steelblue')
    plt.xlabel('Ciudad')
    plt.ylabel(f'{primera_col_numerica}')
    plt.title(f'Promedio de {primera_col_numerica} por ciudad')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig('contaminacion_por_ciudad.png')
    plt.show()