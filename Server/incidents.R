#
# R functions for utilization of traffic APIs
#

library(httr)
library(XML)
# library(jsonlite)

paste0 <- function(...) paste(..., sep = "")
join <- function(v) do.call(function(...) paste(..., sep = ","), as.list(v))
naifnull <- function(e) ifelse(is.null(e), NA, e)
nospace <- function(str) gsub("^\\s*|\\s*$", "", str)

http_get <- function(url) content(GET(url))

#' @description Retrieves traffic incidents from Bing Maps
#' @param mapArea A rectangular area specified as a bounding box.
#'  The size of the area can be a maximum of 500 km x 500 km.
#'  Format: c(southLatitude, westLongitude, northLatitude, eastLongitude)
#' @param severity One or more of the following integer values:
#'  1 (LowImpact), 2 (Minor), 3 (Moderate), 4 (Serious)
#' @param type One or more of the following integer values:
#'  1: Accident, 2: Congestion, 3: DisabledVehicle, 4: MassTransit,
#'  5: Miscellaneous, 6: OtherNews, 7: PlannedEvent, 8: RoadHazard,
#'  9: Construction, 10: Alert, 11: Weather
#'
#' @example incidents <- get_ms_traffic(mapArea = c(45.219,-122.325,47.610,-122.107))

get_ms_traffic <- function(mapArea = c(36,-4,39,-2),
                           severity = c(1,2,3,4),
                           type = c(1,2,3,4,5,6,7,8,9,10,11)) {
  # Obtención de una clave de Bing Maps:
  #   Acceder a Bing Maps Portal <https://www.bingmapsportal.com>
  #   Iniciar sesión/Crear cuenta (asociada a una de Microsoft)
  #   Crear una clave Trial (expira en 90 días) o Basic

  # Establecer clave en la variable de entorno MS_KEY con:
  #   Sys.setenv(MS_KEY = "AAAABBBBCCCC")
  key <- Sys.getenv("MS_KEY")
  url <- paste0("http://dev.virtualearth.net/REST/v1/Traffic/Incidents/",
                join(mapArea),
                "/?s=", join(severity),
                "&t=", join(type),
                "&key=", key)
  resp <- http_get(url)

  if (!is.null(resp$resourceSets) && resp$resourceSets[[1]]$estimatedTotal > 0) {
    sets <- resp$resourceSets[[1]]$resources
    dataset <- sapply(sets, function(s) {
      row <- c(s$incidentId,
               s$point$type, s$point$coordinates[[1]], s$point$coordinates[[2]],
               s$description,
               s$start, s$end, s$lastModified,
               s$roadClosed, s$severity)
      names(row) <- c("id",
                      "point_type", "lat", "long",
                      "description",
                      "start", "end", "last_modified",
                      "road_closed", "severity")
      row
    })

    as.data.frame(t(dataset))
  } else
    data.frame()
}

#' @description Retrieves traffic incidents from Dirección General de Tráfico
#'
#' @example get_dgt_traffic()
get_dgt_traffic <- function(fecha) {
  
  url <- "http://www.dgt.es/incidencias.xml"
  
  if (!missing(fecha)) url <- paste0(url, "?fecha=", fecha)
  
  resp_xml <- content(GET(url))
  inc_list <- xmlChildren(xmlChildren(resp_xml)[[2]])
  
  inc_list <- lapply(inc_list, function(i) {
    i <- xmlToList(i)
    c(tipo = naifnull(i$tipo),
      causa =         naifnull(nospace(i$causa)),
      nivel =         naifnull(nospace(i$nivel)),
      autonomia =     naifnull(nospace(i$autonomia)),
      provincia =     naifnull(nospace(i$provincia)),
      poblacion =     naifnull(nospace(i$poblacion)),
      carretera =     naifnull(nospace(i$carretera)),
      pk_inicial =    naifnull(as.numeric(i$pk_inicial)),
      pk_final =      naifnull(as.numeric(i$pk_final)),
      sentido =       naifnull(nospace(i$sentido)),
      hacia =         naifnull(nospace(i$hacia)),
      fechahora_ini = naifnull(i$fechahora_ini))
  })
  inc_df <- matrix(unlist(inc_list),
                   nrow = length(inc_list),
                   byrow = T)
  inc_df <- data.frame(inc_df)
  names(inc_df) <- c("Tipo",
                     "Causa",
                     "Nivel",
                     "Autonomia",
                     "Provincia",
                     "Poblacion",
                     "Carretera",
                     "PKinicial",
                     "PKfinal",
                     "Sentido",
                     "Hacia",
                     "Inicio")
  inc_df
}