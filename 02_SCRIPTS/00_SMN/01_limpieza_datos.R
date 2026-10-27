# --- R
# Este script limpia y homogeiniza las estaciones del SMN 
# Última actualización: 22 de octubre de 2026
# --- DALM

library(tidyverse)

setwd("~/PhD_Pico")
data <- read.csv("./01_INPUT/00_SMN/dia21020.txt", skip = 19, sep = ";", na.strings = "NA", header = TRUE)
data <- data[c("FECHA", "PRECIP", "TMAX", "TMIN")]
data$FECHA <- as.Date(data$FECHA)
data[c("PRECIP", "TMAX", "TMIN")] <- lapply(data[c("PRECIP", "TMAX", "TMIN")], as.numeric)

write.csv(data, "./03_OUTPUTS/00_SMN/01_extrac_estacs/SMN_BD_precip.csv")

