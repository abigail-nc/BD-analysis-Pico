# R ---
# Este script hace mapa de las estaciones dentro del área de estudio para el proyecto de doctorado
# Última actualización: 05 de octubre de 2026
# DALM

setwd("~/PhD_Pico")

library(terra)
library(sf)
library(ggplot2)

dom50 <- st_read("./01_INPUT/area_estudio/Dom_50km.kml")

anp_pico <- st_read("./01_INPUT/area_estudio/anp2021gw.shp")
anp_pico <- st_transform(anp_pico, st_crs(dom50))
anp_pico <- subset(anp_pico, grepl("Pico de Orizaba", NOMBRE, ignore.case = TRUE))

estacs50 <- c("./01_INPUT/area_estudio/Estaciones.kml")
estacs_susp <- st_transform(st_read("./01_INPUT/area_estudio/50km_estaciones_suspendidas.shp"), st_crs(dom50))
estacs_oper <- st_transform(st_read("./01_INPUT/area_estudio/50km_estaciones_operativas.shp"), st_crs(dom50))
#plot(st_geometry(estacs_susp))



ggplot()+
geom_sf(data = dom50, fill = "gray80", color = "black", alpha=0.5)+
geom_sf(data = estacs_oper, shape = 17, size= 2, color = "#04a204") +
geom_sf(data = estacs_susp, shape = 15, size = 2, color = "darkred") + 
geom_sf(data = anp_pico, color = "gray50")+
labs(
    title = "Parque Nacional Pico de Orizaba",
    subtitle = "Área de estudio (Buffer 50km)",
    x = "Longitud", 
    y = "Latitud",
    color = "Estado de la estación"
  ) +
  theme_gray()

ggsave("./03_OUTPUTS/area_estudio_50.png",get_last_plot(), dpi = 300)
