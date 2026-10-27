# --- R
# Script para crear mapa de calor de disponibiliad de datos del SMN para cada estación y cada día
# DALM
# Última modificación: 26 de octibre de 2026

setwd("~/PhD_Pico")
inpath <- ("./03_OUTPUTS/00_SMN/")
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)


precip <- read.csv(paste0(inpath, "00_SMN_BD_precip.csv"))
precip$FECHA <- as.Date(precip$FECHA)


tmax <- read.csv(paste0(inpath, "00_SMN_BD_TMAX.csv"))
tmax$FECHA <- as.Date(precip$FECHA)

tmin <- read.csv(paste0(inpath, "00_SMN_BD_TMIN.csv"))
tmin$FECHA <- as.Date(precip$FECHA)


#armado de precipitacion
precip_long <- precip %>%
  pivot_longer(
    cols = -FECHA, 
    names_to = "Estacion", 
    values_to = "Valor"
  ) %>%
  mutate(
    Estado = ifelse(is.na(Valor), "Faltante", "Disponible")
  )


ggplot(precip_long, aes(x = FECHA, y = Estacion, fill = Estado)) +
  geom_tile() +
  scale_fill_manual(
    values = c("Disponible" = "#39586d", "Faltante" = "#d2d7db")
  ) +
  labs(
    title = "Disponibilidad de datos de Precipitación (SMN)",
    x = "Fecha",
    y = "Estación",
    fill = "Estado"
  ) +
  theme_gray() +
  theme(
    axis.text.y = element_text(size = 8), 
    panel.grid = element_blank()   
  )

  ggsave(paste0(inpath, "1_MapaCalor_dispo_SMN_precip.png"), get_last_plot(), width = 8, height = 11, units = "in", dpi = 300)


#armado de tmax
tmax_long <- tmax %>%
  pivot_longer(
    cols = -FECHA, 
    names_to = "Estacion", 
    values_to = "Valor"
  ) %>%
  mutate(
    Estado = ifelse(is.na(Valor), "Faltante", "Disponible")
  )


ggplot(tmax_long, aes(x = FECHA, y = Estacion, fill = Estado)) +
  geom_tile() +
  scale_fill_manual(
    values = c("Disponible" = "#702d19", "Faltante" = "#d2d7db")
  ) +
  labs(
    title = "Disponibilidad de datos de Temp. Máxima (SMN)",
    x = "Fecha",
    y = "Estación",
    fill = "Estado"
  ) +
  theme_gray() +
  theme(
    axis.text.y = element_text(size = 8), 
    panel.grid = element_blank()   
  )

  ggsave(paste0(inpath, "1_MapaCalor_dispo_SMN_tmax.png"), get_last_plot(), width = 8, height = 11, units = "in", dpi = 300)


#armado de tmin
tmin_long <- tmin %>%
  pivot_longer(
    cols = -FECHA, 
    names_to = "Estacion", 
    values_to = "Valor"
  ) %>%
  mutate(
    Estado = ifelse(is.na(Valor), "Faltante", "Disponible")
  )


ggplot(tmin_long, aes(x = FECHA, y = Estacion, fill = Estado)) +
  geom_tile() +
  scale_fill_manual(
    values = c("Disponible" = "#0078c9", "Faltante" = "#d2d7db")
  ) +
  labs(
    title = "Disponibilidad de datos de Precipitación (SMN)",
    x = "Fecha",
    y = "Estación",
    fill = "Estado"
  ) +
  theme_gray() +
  theme(
    axis.text.y = element_text(size = 8), 
    panel.grid = element_blank()   
  )

  ggsave(paste0(inpath, "1_MapaCalor_dispo_SMN_tmin.png"), get_last_plot(), width = 8, height = 11, units = "in", dpi = 300)
