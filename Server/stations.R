stations <- read.csv("../Datasets/dgt/all-without-0-data-years.csv", sep = ";")
noyears <- unique(stations[, c("Tipo", "Estación", "Calzada", "Carriles", "Provincia", "Población", "Carretera", "PK")])

group_by <- function(x, name, func) {
  uniques <- unique(x[, name])
  useful <- uniques
  
  if (length(name) > 1) {
    useful <- as.list(as.data.frame(t(uniques)))
    useful <- lapply(useful, function(i) ifelse(is.factor(i), as.character(i), i))
  }
  
  applied <- sapply(useful, function(i) func(x[x[, name] == i, ]))
  names(applied) <- if (is.atomic(uniques))
    as.character(uniques)
  else
    do.call(paste, uniques)

  applied
}

count_by <- function(x, name) group_by(x, name, function(i) length(i[,1]))

# Estudio de las estaciones según carreteras
stations_by_road <- function() {
  byroad <- count_by(noyears, "Carretera")
  hist(byroad,
       main = "Número de carreteras por número de estaciones")
}

stations_by_roadtype <- function() {
  categorias <- c(Autovia = "A", Autopista = "AP", Nacional = "N", Radial = "R")
  rgxs <- paste("^", categorias, "-", sep = "")
  roadtypecount <- sapply(rgxs, function(r) length(carreteras[grep(r, carreteras)]))
  catcount <- sapply(rgxs, function(r) length(noyears[grep(r, noyears$Carretera), 1]))
  names(catcount) <- names(categorias)
  barplot(catcount, col = rainbow(length(catcount)),
          main = "Estaciones por tipo de carretera")
  barplot(catcount/roadtypecount, col = rainbow(length(catcount)),
          main = "Estaciones relativas por tipo carretera")
}

# Estaciones por provincias
stations_by_province <- function() {
  byprov <- count_by(noyears, "Provincia")
  byprov <- byprov[!is.na(names(byprov))]
  hist(byprov)
  barplot(byprov, col = rainbow(length(byprov)), cex.names = 0.5)
}

# Estaciones por año
stations_by_year <- function() {
  byyear <- aggregate(PK ~ Total, stations, length)
  plot(byyear, type = "l",
       main = "Estaciones por año")
}