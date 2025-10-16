nombres <- c("Ana","Luis","Carlos","María","Sofía",
             "Jorge","Valeria","Diego","Lucía","Mateo")
edades <- c(18,19,20,18,21,20,19,22,18,20)

cal1 <- c(85, 67, 90, 72, 65, 78, 94, 58, 70, 88)
cal2 <- c(80, 71, 88, 69, 60, 82, 91, 62, 73, 85)
cal3 <- c(78, 69, 95, 75, 68, 74, 89, 55, 72, 90)

df <- data.frame(
  nombre = nombres,
  edad = edades,
  cal1 = cal1,
  cal2 = cal2,
  cal3 = cal3,
  stringsAsFactors = FALSE
)

df$promedio <- rowMeans(df[, c("cal1", "cal2", "cal3")])
df$promedio <- round(df$promedio, 2)

df$status <- ifelse(df$promedio >= 70, "aprobado", "reprobado")

print("=== DATA FRAME FINAL ===")
print(df)
