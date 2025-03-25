# Usar el servidor CRAN de Chile
options(repos = c(CRAN = "https://cran.dcc.uchile.cl"))

# Instalar y cargar paquetes necesarios
required_packages <- c("conflicted", "tidyverse", "rmarkdown", "dplyr", "quarto")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

# Instalar paquetes en el orden correcto
if (length(new_packages)) {
  install.packages("conflicted")
  install.packages("dplyr")
  install.packages("rmarkdown")
  install.packages("quarto")
  install.packages("tidyverse")
}

lapply(required_packages, library, character.only = TRUE)

# Instalar el paquete 'torch' desde GitHub
if (!requireNamespace("remotes", quietly = TRUE)) install.packages("remotes")
remotes::install_github("mlverse/torch")