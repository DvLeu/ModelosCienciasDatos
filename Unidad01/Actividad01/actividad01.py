import pandas as pd 

data = pd.read_csv("src/dataset.csv")
mean_data = data.groupby("Carrera")["Promedio"].mean().round(2)
age_mean = data["Edad"].mean()

print(f"El data frame es \n {data.head} \n")
print(f"\nLa edad promedio para estudiar es {age_mean} \n")
print(f"El promedio por carrera es  : {mean_data}")