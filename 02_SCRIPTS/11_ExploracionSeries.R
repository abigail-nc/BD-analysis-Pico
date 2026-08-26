#DALM
# PhD Pico - 2026
# Este script es para explorar las estaciones del área de estudio para generar la comparación con los datos del SMN

library(ggplot2)
library(dplyr)

setwd("~/PhD_Pico")


era5_21020 <- read.csv2("./03_OUTPUTS/ERA5_interpolados/ERA5_extracted_50-25_21020.csv")
smn_21020 <- read.csv("./.old_phd/z_input/ClimaDiario_limpios/21020.csv", sep = ,)


plot(era5_21020$value)
plot(smn_21020$TMAX)


