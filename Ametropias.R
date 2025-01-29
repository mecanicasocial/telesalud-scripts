# Instalar y cargar el paquete necesario
if (!require("readxl")) {
  install.packages("readxl")
}
if (!require("conflicted")) {
  devtools::install_github("r-lib/conflicted")
}
conflicts_prefer(dplyr::filter)
conflicts_prefer(dplyr::lag)
if (!require("tidyverse")) {
  install.packages("tidyverse")
}
library(readxl)
library(conflicted)
library(tidyverse)
# Definir la ruta del archivo
ruta_archivo <- file.path(Sys.getenv("USERPROFILE"), "Downloads", "TodasLasSolicitudesPendientes.xlsx")
datos <- read_excel(ruta_archivo)

#Comandos de busqueda
lentes_search <- datos[grepl("lent", datos$`Información adicional`, ignore.case = TRUE), ]
ametropia_search <- datos[grepl("vici", datos$`Información adicional`, ignore.case = TRUE), ]

# Consolidar y limpiar duplicados
cons_vicio <- bind_rows(lentes_search, ametropia_search)
cons_vicio_limpio <- cons_vicio %>% distinct(`Nº identificador`, .keep_all = TRUE) %>% arrange(`Fecha solicitud`)
# Resultados
cat("Resultados Vicio\n")
if (nrow(cons_vicio_limpio) == 0) {
  cat("No se encontraron resultados.\n")
} else {
  for (id in cons_vicio_limpio$`Nº identificador`) {
    cat(id, "\n")
  }
}