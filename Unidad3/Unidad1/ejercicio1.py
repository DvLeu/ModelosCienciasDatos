"""Ejercicio 01 de R a PY - Análisis de Ventas"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# ============================================
# ANALISIS DE VENTAS - RESPUESTAS DIRECTAS
# ============================================

# Leer el CSV
ventas = pd.read_csv("../../Unidad2/csv/Ejercicio_ventas.csv")


na_por_col = ventas.isna().sum()
print("Valores faltantes por columna:")
print(na_por_col)
print()
rango_precio = (ventas['precio_unitario'].min(), ventas['precio_unitario'].max())
rango_cantidad = (ventas['cantidad'].min(), ventas['cantidad'].max())

print(f"Rango de precio_unitario: {rango_precio[0]} a {rango_precio[1]}")
print(f"Rango de cantidad: {rango_cantidad[0]} a {rango_cantidad[1]}")
print()
ventas['ingresos'] = ventas['precio_unitario'] * ventas['cantidad']

print("Primeras filas con la columna 'ingresos':")
print(ventas.head())
print()

print("Estadísticas básicas de ingresos:")
print(ventas['ingresos'].describe())
print()

# ==============================
# 5) Ingreso promedio de una venta
# ==============================
ingreso_promedio = ventas['ingresos'].mean()
print(f"Ingreso promedio de una venta: {ingreso_promedio}")
print()

# ==============================
# 6) Filtrar ventas de una ciudad o categoría específica
# ==============================
# Ejemplo: Ciudad = "Monterrey"
ventas_mty = ventas[ventas['ciudad'] == 'Monterrey']

# Ejemplo: Categoría = "Electrónica"
ventas_elec = ventas[ventas['categoria'] == 'Electrónica']

print("Ventas en Monterrey:")
print(ventas_mty.head())
print()
print("Ventas de Electrónica:")
print(ventas_elec.head())
print()

# ==============================
# 7) ¿Qué ciudad o categoría tiene ventas más altas?
# ==============================
# Por categoría
ranking_categoria = (ventas.groupby('categoria')['ingresos']
                     .sum()
                     .reset_index()
                     .rename(columns={'ingresos': 'ingresos_totales'})
                     .sort_values('ingresos_totales', ascending=False))

print("Ranking por categoría:")
print(ranking_categoria)
print()

# Por ciudad
ranking_ciudad = (ventas.groupby('ciudad')['ingresos']
                  .sum()
                  .reset_index()
                  .rename(columns={'ingresos': 'ingresos_totales'})
                  .sort_values('ingresos_totales', ascending=False))

print("Ranking por ciudad:")
print(ranking_ciudad)
print()

# ==============================
# 8) Gráfico de barras con los ingresos por categoría
# ==============================
plt.figure(figsize=(10, 6))
plt.bar(ranking_categoria['categoria'], 
        ranking_categoria['ingresos_totales'],
        color=plt.cm.Set3(range(len(ranking_categoria))))
plt.xlabel('Categoría')
plt.ylabel('Ingresos totales')
plt.title('Ingresos totales por categoría')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig('Unidad3/Unidad1/ingresos_por_categoria.png')
plt.show()

print("Gráfico guardado como 'ingresos_por_categoria.png'")
print(ventas['ingresos'].describe())
print()


ingreso_promedio = ventas['ingresos'].mean()
print(f"Ingreso promedio de una venta: {ingreso_promedio}")
print()


ventas_mty = ventas[ventas['ciudad'] == 'Monterrey']
ventas_elec = ventas[ventas['categoria'] == 'Electrónica']

print("Ventas en Monterrey:")
print(ventas_mty.head())
print()
print("Ventas de Electrónica:")
print(ventas_elec.head())
print()
ranking_categoria = (ventas.groupby('categoria')['ingresos']
                     .sum()
                     .reset_index()
                     .rename(columns={'ingresos': 'ingresos_totales'})
                     .sort_values('ingresos_totales', ascending=False))

print("Ranking por categoría:")
print(ranking_categoria)
print()


ranking_ciudad = (ventas.groupby('ciudad')['ingresos']
                  .sum()
                  .reset_index()
                  .rename(columns={'ingresos': 'ingresos_totales'})
                  .sort_values('ingresos_totales', ascending=False))

print("Ranking por ciudad:")
print(ranking_ciudad)
print()

plt.figure(figsize=(10, 6))
plt.bar(ranking_categoria['categoria'], 
        ranking_categoria['ingresos_totales'],
        color=plt.cm.Set3(range(len(ranking_categoria))))
plt.xlabel('Categoría')
plt.ylabel('Ingresos totales')
plt.title('Ingresos totales por categoría')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig('ingresos_por_categoria.png')
plt.show()

print("Gráfico guardado como 'ingresos_por_categoria.png'")