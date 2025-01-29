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

# Manejar posibles errores al leer el archivo
tryCatch({
  datos <- read_excel(ruta_archivo)
}, error = function(e) {
  cat("Error al leer el archivo de Excel:", e$message, "\n")
})

# Comandos de busqueda Vicio Refraccion
cons_vicio <- datos %>%
  filter(grepl("lent", `Información adicional`, ignore.case = TRUE) |
         grepl("vici", `Información adicional`, ignore.case = TRUE)) %>%
  distinct(`Nº identificador`, .keep_all = TRUE) %>%
  arrange(`Fecha solicitud`)

# Resultados

cat("Resultados Vicio\n")
if (nrow(cons_vicio) == 0) {
  cat("No se encontraron resultados.\n")
} else {
  for (id in cons_vicio$`Nº identificador`) {
    cat(id, "\n")
  }
}

# Comandos de busqueda LME
md_casos <- datos %>%
  filter(grepl("Medicina", `Tipo prestador`, ignore.case = FALSE))

lme_search <- datos[grepl("licencia", datos$`Información adicional`, ignore.case = TRUE), ] %>% arrange(`Fecha solicitud`)

# Resultados
cat("Resultados LME\n")
if (nrow(lme_search) == 0) {
  cat("No se encontraron resultados para LME\n")
} else {
  for (id in lme_search$`Nº identificador`) {
    cat(id, "\n")
  }
}