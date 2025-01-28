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

#Comandos de busqueda Vicio Refraccion
lentes_search <- datos[grepl("lent", datos$`Información adicional`, ignore.case = TRUE), ]
ametropia_search <- datos[grepl("vici", datos$`Información adicional`, ignore.case = TRUE), ]
cons_vicio <- bind_rows(lentes_search, ametropia_search)
cons_vicio_limpio <- cons_vicio %>% distinct(`Nº identificador`, .keep_all = TRUE) %>% arrange(`Nº identificador`)
cat("Resultados Vicio\n")
for (id in cons_vicio_limpio$`Nº identificador`) {
  cat(id, "\n")
}

#Comandos de busqueda LME
md_casos <- datos[grepl("Medicina", datos$`Tipo prestador`, ignore.case = FALSE), ]
lme_search <- datos[grepl("licencia", datos$`Información adicional`, ignore.case = TRUE), ]
cat("Resultados LME\n")
for (id in lme_search$`Nº identificador`) {
  cat(id, "\n")
}