# DALM + Gemini
# PhD Pico - 2026
# Este script calula promedios mensuales de los datos diarios del SMN

setwd("~/PhD_Pico")

library(dplyr)
library(lubridate)
library(readr)

#datos <- read.csv("./.old_phd/z_input/ClimaDiario_limpios/21020.csv", na = "NULO")
archivos_csv <- list.files("./.old_phd/z_input/ClimaDiario_limpios/", pattern = "\\.csv$", full.names = TRUE)


for (archivo in archivos_csv) {
  
  nombre_limpio <- basename(archivo)
  cat("Procesando:", nombre_limpio, "\n")
  
  datos <- read_csv(archivo, na = "NULO", show_col_types = FALSE)
  
  if ("FECHA" %in% colnames(datos)) {
    
    promedios_mensuales <- datos %>%
      mutate(
        Anio = year(FECHA), 
        Mes = month(FECHA),
        Dia = day(FECHA)
      ) %>%

      group_by(Anio, Mes) %>%
      filter(min(Dia) == 1) %>%

      summarise(
        # devolvemos NA en vez de una suma acumulada incompleta y errónea.
        PRECIP_acum = if(sum(!is.na(PRECIP)) >= 28) round(sum(PRECIP, na.rm = TRUE), 4) else NA_real_,
        TMAX_prom   = round(mean(TMAX, na.rm = TRUE), 4),
        TMIN_prom   = round(mean(TMIN, na.rm = TRUE), 4),
        .groups = "drop"
      )
    
    nombre_salida <- paste0("./03_OUTPUTS/SMN_mensuales/SMN_month_", nombre_limpio)
    
    write_csv(promedios_mensuales, nombre_salida)
    
  } else {
    cat("Saltado (no tiene columna FECHA):", nombre_limpio, "\n")
  }
}

