"""
Script: Análisis de ventas por sucursal (conversión de R a Python)
Archivo: ventas_sucursales.csv
Columnas esperadas: sucursal, ventas, clientes, devoluciones, metodo_pago
"""

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# 1) Carga de datos
ventas = pd.read_csv("../../Unidad2/R4/ventas_sucursales.csv")

# --- Si los nombres difieren, ajusta aquí:
# ventas.columns = ["sucursal", "ventas", "clientes", "devoluciones", "metodo_pago"]

# ------------------------------------------------------------
# LIMPIEZA BÁSICA
# ------------------------------------------------------------

# Verificar valores nulos en ventas o clientes
print("Valores nulos en 'ventas':", ventas['ventas'].isna().sum())
print("Valores nulos en 'clientes':", ventas['clientes'].isna().sum())
print()

# Opción: eliminar filas con NA en ventas o clientes
ventas = ventas.dropna(subset=['ventas', 'clientes'])

# También puedes reemplazar valores faltantes en devoluciones con 0
ventas['devoluciones'] = ventas['devoluciones'].fillna(0)

# Crear nueva columna: ventas_netas = ventas - (devoluciones * 0.8)
ventas['ventas_netas'] = ventas['ventas'] - (ventas['devoluciones'] * 0.8)

print("Primeras filas tras limpieza:")
print(ventas.head())
print()

# ------------------------------------------------------------
# ANÁLISIS GENERAL
# ------------------------------------------------------------

# Total de ventas por sucursal
total_ventas_por_sucursal = (ventas.groupby('sucursal')['ventas_netas']
                             .sum()
                             .reset_index()
                             .sort_values('ventas_netas', ascending=False))

print("Total de ventas netas por sucursal:")
print(total_ventas_por_sucursal)
print()

# Promedio de ventas por cliente por sucursal
ventas['ventas_por_cliente'] = ventas['ventas_netas'] / ventas['clientes']
promedio_ventas_cliente = (ventas.groupby('sucursal')['ventas_por_cliente']
                           .mean()
                           .reset_index())

# Sucursal con mayor promedio
sucursal_top = promedio_ventas_cliente.loc[promedio_ventas_cliente['ventas_por_cliente'].idxmax(), 'sucursal']

print("Sucursal con mayor promedio de ventas por cliente:", sucursal_top)
print(promedio_ventas_cliente)
print()

# ------------------------------------------------------------
# VISUALIZACIÓN
# ------------------------------------------------------------

# 1) Gráfico de barras — ingresos totales por sucursal
plt.figure(figsize=(10, 6))
plt.barh(total_ventas_por_sucursal['sucursal'], 
         total_ventas_por_sucursal['ventas_netas'],
         color='skyblue')
plt.xlabel('Ventas netas')
plt.ylabel('Sucursal')
plt.title('Ingresos totales por sucursal')
plt.tight_layout()
plt.savefig('Unidad3/Unidad3/ingresos_por_sucursal.png')
plt.show()
print("Gráfico guardado como 'ingresos_por_sucursal.png'\n")

# 2) Boxplot — distribución de ventas por método de pago
plt.figure(figsize=(10, 6))
ventas.boxplot(column='ventas_netas', by='metodo_pago', grid=False)
plt.suptitle('')  # Eliminar el título automático
plt.title('Distribución de ventas netas por método de pago')
plt.xlabel('Método de pago')
plt.ylabel('Ventas netas')
plt.tight_layout()
plt.savefig('Unidad3/Unidad3/ventas_por_metodo_pago.png')
plt.show()
print("Gráfico guardado como 'ventas_por_metodo_pago.png'")
