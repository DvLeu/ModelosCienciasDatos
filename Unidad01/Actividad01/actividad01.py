import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
import os

matplotlib.use('Agg')
os.makedirs('Unidad01/Actividad01/plots', exist_ok=True)

def cargar_datos(ruta):
    return pd.read_csv(ruta)

def calcular_estadisticas(data):
    mean_data = data.groupby("Carrera")["Promedio"].mean().round(2)
    age_mean = data["Edad"].mean()
    return mean_data, age_mean

def graficar_promedio_carrera(mean_data, ruta_salida):
    plt.figure(figsize=(8,5))
    mean_data.plot(kind='bar', color='red')
    plt.title('Promedio por Carrera')
    plt.xlabel('Carrera')
    plt.ylabel('Promedio')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(ruta_salida)
    plt.close()

def graficar_histograma_edad(data, ruta_salida):
    plt.figure(figsize=(8,5))
    plt.hist(data["Edad"], bins=10, color='lightgreen', edgecolor='black')
    plt.title('Distribución de Edad de los Estudiantes')
    plt.xlabel('Edad')
    plt.ylabel('Frecuencia')
    plt.tight_layout()
    plt.savefig(ruta_salida)
    plt.close()
    
def graficar_datos(data, ruta_salida):
    plt.figure(figsize=(6,5))
    data.plot(x='Nombre', y='Promedio', kind='bar', color='orange', legend=False)
    plt.title('Tabla de datos')
    plt.xlabel('Nombre')
    plt.ylabel('Promedio')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(ruta_salida)
    plt.close()

def main():
    data = cargar_datos("Unidad01/Actividad01/dataset.csv")
    mean_data, age_mean = calcular_estadisticas(data)

    graficar_datos(data, 'Unidad01/Actividad01/plots/GraficoPromedioEstudiantes.png')
    graficar_promedio_carrera(mean_data, 'Unidad01/Actividad01/plots/GraficoBarrasCarreras.png')
    graficar_histograma_edad(data, 'Unidad01/Actividad01/plots/GraficoEdadEstudiantes.png')
if __name__ == "__main__":
    main()
