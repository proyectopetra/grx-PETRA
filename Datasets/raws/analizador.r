datos = read.csv("tiempos_algoritmoTrazas.csv", sep = ",",comment.char = "#")

plot(datos[c("VENTANA","DURACION")])
plot(x=datos$VENTANA,y=datos$DURACION)
plot(datos$VENTANA ~ datos$DURACION)

datos.lm = lm(DURACION ~ VENTANA, data=datos)

minutos_estimar = 60*24
estimacion = coefficients(datos.lm)[1] + coefficients(datos.lm)[2]*minutos_estimar
paste(estimacion / 60,"horas")
