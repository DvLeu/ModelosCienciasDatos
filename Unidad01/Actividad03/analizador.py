import pandas as pd
import matplotlib.pyplot as plt

def cargar_datos(ruta):
    return pd.read_csv(ruta)
#? Implementacion futura : 
# def borrar_datos(ruta):
    # delete(ruta)

def manejo_datos(df):
    print("Primeras filas del DataFrame:")
    print(df.head())
    print("\nInformación del DataFrame:")
    print(df.info())
    print("\nResumen estadístico:")
    print(df.describe())

def manipulacion_datos(df):
    # Ejemplo: Eliminar filas con valores nulos
    df = df.dropna()
    # Ejemplo: Convertir columnas a tipos específicos si es necesario
    # df['columna'] = df['columna'].astype(int)
    print("\nDatos después de la manipulación:")
    print(df.head())
    return df

def exploracion_datos(df):
    # Ejemplo: Mostrar estadísticas descriptivas adicionales
    print("\nFrecuencias de valores categóricos:")
    for columna in df.select_dtypes(include=['object']).columns:
        print(f"\nColumna: {columna}")
        print(df[columna].value_counts())
    print("\nExploración completada.")

def mineria_datos(df):
    # Ejemplo: Calcular correlaciones
    if df.select_dtypes(include=['number']).shape[1] > 1:
        correlaciones = df.corr()
        print("\nMatriz de correlaciones:")
        print(correlaciones)

def main():
    data = cargar_datos("Unidad01/Actividad03/act_tienda.csv")
    df = pd.DataFrame(data)

    print("\n--- Manejo de datos ---")
    manejo_datos(df)

    print("\n--- Manipulación de datos ---")
    df = manipulacion_datos(df)

    print("\n--- Exploración de datos ---")
    exploracion_datos(df)

if __name__ == "__main__":
    main()