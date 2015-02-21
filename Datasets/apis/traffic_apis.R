#
# R functions for utilization of traffic APIs
#

library(httr)
library(XML)
# library(jsonlite)

paste0 <- function(...) paste(..., sep = "")
join <- function(v) do.call(function(...) paste(..., sep = ","), as.list(v))

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

#' @description Retrieves traffic incidents from Europa Press
#'  Parameters aren't currently working.
#' @param ccaa Numeric value indicating Autonomy
#' @param carretera Road code
#' @param nivel Severity level, from 1 to 5
#' @param provincia Province code
#' @param tipo Incident type, from 1 to 5
#'
#' @example get_ep_traffic(ccaa = 1, provincia = 7, tipo = 3)
get_ep_traffic <- function(ccaa = "",
                           carretera = "",
                           nivel = "",
                           provincia = "",
                           tipo = "Todas") {

  # Body of a POST request from Europa Press website:
  #
  # Content-Type: application/x-www-form-urlencoded
  # Content-Length: 347
  # __VIEWSTATE=%2FwEPDwUKMjEyNjQ5ODQ4MGRkU2VbKJPokWLsSlLEjOkZUVJoWVM%3D&__VIEWSTATEGENERATOR=C0A6878A&ctl00%24ContenidoCentral%24ddlCCAA=&ctl00%24ContenidoCentral%24txtCarretera=&ctl00%24ContenidoCentral%24ddlNiveles=&ctl00%24ContenidoCentral%24ddlProvincia=&ctl00%24ContenidoCentral%24ddlIncidencias=Todas&ctl00%24ContenidoCentral%24btnBuscar=Buscar


  url <- "http://www.europapress.es/trafico"
  params <- list(
    "__VIEWSTATE" = "%2FwEPDwUKMjEyNjQ5ODQ4MGRkU2VbKJPokWLsSlLEjOkZUVJoWVM%3D",
    "__VIEWSTATEGENERATOR" = "C0A6878A&ctl00%24ContenidoCentral%24ddlCCAA=&ctl00%24ContenidoCentral%24txtCarretera=&ctl00%24ContenidoCentral%24ddlNiveles=&ctl00%24ContenidoCentral%24ddlProvincia=&ctl00%24ContenidoCentral%24ddlIncidencias=Todas&ctl00%24ContenidoCentral%24btnBuscar=Buscar"
  )

  resp <- content(POST(url))
  readHTMLTable(resp)$tblTrafico
}

write.csv(get_ms_traffic(c(36.5802466, -9.0307617, 43.7075935, 2.2192383)), "bing_incidents_spain.csv")
write.csv(get_ms_traffic(c(48.2978125, 1.2744141, 49.4252672, 3.4936523)), "bing_incidents_paris.csv")

write.csv(get_ep_traffic(), "ep_incidents_spain.csv")
