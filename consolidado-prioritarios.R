required_packages <- c("readxl", "conflicted", "tidyverse", "rmarkdown", "dplyr", "quarto")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(readxl)
library(conflicted)
library(tidyverse)
library(rmarkdown)
library(dplyr)
library(quarto)

conflicts_prefer(dplyr::filter)
conflicts_prefer(dplyr::lag)

# Definir la ruta del archivo
ruta_descargas <- if (Sys.info()["sysname"] == "Windows") {
  file.path(Sys.getenv("USERPROFILE"), "Downloads")
} else {
  file.path(Sys.getenv("HOME"), "Downloads")
}
# Validar que el archivo exista
archivos <- list.files(ruta_descargas, pattern = "TodasLasSolicitudesPendientes.*\\.xlsx$", full.names = TRUE)
if (length(archivos) == 0) {
  cat("No se encontraron archivos.\n")
  return()
}
ruta_archivo <- archivos[which.max(file.info(archivos)$mtime)]

# Manejar posibles errores al leer el archivo
tryCatch({
  datos <- read_excel(ruta_archivo)
}, error = function(e) {
  cat("Error al leer el archivo de Excel:", e$message, "\n")
})

# Función para realizar la búsqueda y mostrar resultados
buscar_y_mostrar_resultados <- function(datos, patron, mensaje) {
  resultados <- datos[grepl(patron, datos$`Información adicional`, ignore.case = TRUE), ] %>% arrange(`Fecha solicitud`)
  cat(mensaje, "\n")
  if (nrow(resultados) == 0) {
    cat("No se encontraron resultados.\n")
  } else {
    for (id in resultados$`Nº identificador`) {
      cat(id, "\n")
    }
  }
}

# Comandos de búsqueda y resultados
buscar_y_mostrar_resultados(datos, "lent|vici", "Resultados Vicio")
buscar_y_mostrar_resultados(datos, "licencia", "Resultados LME")
buscar_y_mostrar_resultados(datos, "\\bGES\\b", "Resultados GES")
buscar_y_mostrar_resultados(datos, "fieb|resp|COVID|influe|conges", "Respiratorios")
buscar_y_mostrar_resultados(datos, "diar|vomi|naus", "Gastrointestinal")