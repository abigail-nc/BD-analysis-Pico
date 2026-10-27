# --- R
# Script para hacer resumen de NA, etc en datos de precip, tmax, tmin del SMN
# DALM
# Última edición: 26 de octubre de 2026


library(readr)
library(tidyr)
library(dplyr)

setwd("~/PhD_Pico/")
inpath <- ("./03_OUTPUTS/00_SMN/")

precip <- read.csv(paste0(inpath, "00_SMN_BD_precip.csv"))
precip$FECHA <- as.Date(precip$FECHA)

tmax <- read.csv(paste0(inpath, "00_SMN_BD_TMAX.csv"))
tmax$FECHA <- as.Date(precip$FECHA)

tmin <- read.csv(paste0(inpath, "00_SMN_BD_TMIN.csv"))
tmin$FECHA <- as.Date(precip$FECHA)

#--- PRECIP

summ_precip <- precip %>%
  pivot_longer(
    cols = starts_with("X"), 
    names_to = "Estacion", 
    values_to = "Valor"
  ) %>%
  group_by(Estacion) %>%
  summarise(
    Fecha_Mas_Antigua  = min(FECHA[!is.na(Valor)], na.rm = TRUE),
    Fecha_Mas_Reciente = max(FECHA[!is.na(Valor)], na.rm = TRUE),
    Valor_Maximo       = max(Valor, na.rm = TRUE),
    Valor_Minimo       = min(Valor, na.rm = TRUE),
    cant_registros     = n(),
    Cantidad_NA        = round(sum(is.na(Valor)), 2),
    registros_noNA     = round(n() - Cantidad_NA, 2),
    porcent_NA         = round((Cantidad_NA / n()) * 100, 2), 
    porcent_noNA       = round((registros_noNA/n())*100, 2)
  ) %>%
  ungroup()

View(summ_precip)
write.csv2(summ_precip, paste0(inpath, "02_errores/metricas_precip_SMN.csv"))


# --- TMAX
summ_tmax <- tmax %>%
  pivot_longer(
    cols = starts_with("X"), 
    names_to = "Estacion", 
    values_to = "Valor"
  ) %>%
  group_by(Estacion) %>%
  summarise(
    Fecha_Mas_Antigua  = min(FECHA[!is.na(Valor)], na.rm = TRUE),
    Fecha_Mas_Reciente = max(FECHA[!is.na(Valor)], na.rm = TRUE),
    Valor_Maximo       = max(Valor, na.rm = TRUE),
    Valor_Minimo       = min(Valor, na.rm = TRUE),
    cant_registros     = n(),
    Cantidad_NA        = round(sum(is.na(Valor)), 2),
    registros_noNA     = round(n() - Cantidad_NA, 2),
    porcent_NA         = round((Cantidad_NA / n()) * 100, 2), 
    porcent_noNA       = round((registros_noNA/n())*100, 2)
  ) %>%
  ungroup()

View(summ_tmax)
write.csv2(summ_tmax, paste0(inpath, "02_errores/metricas_tmax_SMN.csv"))


# --- TMIN
summ_tmin <- tmin %>%
  pivot_longer(
    cols = starts_with("X"), 
    names_to = "Estacion", 
    values_to = "Valor"
  ) %>%
  group_by(Estacion) %>%
  summarise(
    Fecha_Mas_Antigua  = min(FECHA[!is.na(Valor)], na.rm = TRUE),
    Fecha_Mas_Reciente = max(FECHA[!is.na(Valor)], na.rm = TRUE),
    Valor_Maximo       = max(Valor, na.rm = TRUE),
    Valor_Minimo       = min(Valor, na.rm = TRUE),
    cant_registros     = n(),
    Cantidad_NA        = round(sum(is.na(Valor)), 2),
    registros_noNA     = round(n() - Cantidad_NA, 2),
    porcent_NA         = round((Cantidad_NA / n()) * 100, 2), 
    porcent_noNA       = round((registros_noNA/n())*100, 2)
  ) %>%
  ungroup()

View(summ_tmin)
write.csv2(summ_tmin, paste0(inpath, "02_errores/metricas_tmin_SMN.csv"))


