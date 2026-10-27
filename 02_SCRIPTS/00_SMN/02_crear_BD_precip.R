# --- R
# Este script crea un solo CSV con todos los registros del SMN para precip
# última edición: 22 de octubre de 2022
# DALM

setwd("~/PhD_Pico")
library(tidyverse)
path <- "./03_OUTPUTS/00_SMN/01_extrac_estacs"

archivos <- list.files(path = path, pattern = "\\.csv$", full.names = TRUE)

#FECHAS
todas_las_fechas <- c() 

for (archivo in archivos) {
  temp_fechas <- read_csv(archivo, col_select = FECHA, show_col_types = FALSE)
  todas_las_fechas <- c(todas_las_fechas, temp_fechas$FECHA)
}

todas_las_fechas <- as.Date(todas_las_fechas)
fecha_inicio <- min(todas_las_fechas, na.rm = TRUE)
fecha_fin    <- max(todas_las_fechas, na.rm = TRUE)

fechas_base <- data.frame(
  FECHA = seq(fecha_inicio, fecha_fin, by = "day")
)

for (archivo in archivos) {
  
  nombre_estacion <- tools::file_path_sans_ext(basename(archivo))
  
  datos_estacion <- read_csv(archivo, na = c("NULO", "Nulo", ""), show_col_types = FALSE)
  
  datos_filtrados <- datos_estacion %>%
    mutate(FECHA = as.Date(FECHA)) %>%
    select(FECHA, !!nombre_estacion := PRECIP)
  
  fechas_base <- left_join(fechas_base, datos_filtrados, by = "FECHA")
}

outpath <-"./03_OUTPUTS/00_SMN/"
write_csv(fechas_base, file.path(outpath, "00_SMN_BD_precip.csv"))
