"""
Script 1: Análisis de alumnos (conversión de R a Python)
Archivo: rendimiento_alumnos.csv
Columnas esperadas: alumno, carrera, materia, calificacion
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

alumnos = pd.read_csv("Unidad3/Unidad2/rendimiento_alumnos.csv")
alumnos_mas_85 = alumnos[alumnos['calificacion'] > 85]
print("Alumnos con calificación > 85:")
print(alumnos_mas_85)
print()
promedio_por_carrera = (alumnos.groupby('carrera')['calificacion']
                        .mean()
                        .reset_index()
                        .sort_values('calificacion', ascending=False))
print("Promedio de calificación por carrera:")
print(promedio_por_carrera)
print()

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
print("Boxplot guardado como 'boxplot_calificaciones_materia.png'\n")
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

stats_por_materia = stats_por_materia.sort_values('media', ascending=False)

print("Estadísticos por materia:")
print(stats_por_materia)
print()

x = alumnos['calificacion'].dropna()
stats_globales = pd.DataFrame({
    'n': [len(x)],
    'min': [x.min()],
    'q1': [x.quantile(0.25)],
    'media': [x.mean()],
    'mediana': [x.median()],
    'q3': [x.quantile(0.75)],
    'max': [x.max()],
    'sd': [x.std()]
})

print("Estadísticos globales:")
print(stats_globales)