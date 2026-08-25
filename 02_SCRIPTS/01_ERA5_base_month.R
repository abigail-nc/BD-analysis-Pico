## DALM
# Script para desplegar climatología mensual 1950 - 2025
# DATOS DE ENTRADA: ERA5 monthly procesados en CDO
# PhD Pico

setwd("~/PhD_Pico")

library(ncdf4)
library(lattice)
library(RColorBrewer)
library(CFtime)
library(ggplot2)
library(maps)
library(sf)
library(tibble) #lo necesita sf para desplegar los poligonos
library(dplyr)

# --- CARGAR DATOS DEL SHP (poligono del área de estudio)
ANP <- read_sf("./.old_phd/z_input/anp2021gw.shp")
pico <- ANP[ANP$NOMBRE == "Pico de Orizaba", ]

# --- DEFINIR RUTA Y ABRIR netCDF
tpnc <- "./01_INPUT/01_ERA5/ERA5_0.25x0.25_monthly_precip.nc"
dtp <- "tp"
nctp <- nc_open(tpnc)
dlt2p <- ncatt_get(nctp, dtp, "long_name")
tpunits <- ncatt_get(nctp, dtp, "units")

t2nc <- "./01_INPUT/01_ERA5/ERA5_0.25x0.25_monthly_temp.nc"
dt2 <- "t2m"
nct2 <- nc_open(t2nc)
dlt2 <- ncatt_get(nct2, dt2, "long_name")
t2units <- ncatt_get(nct2, dt2, "units")



# --- OBTENER COORDENADAS + TIEMPO + INFORMACION (aplica para ambas variables)
lon <- ncvar_get(nctp, "longitude")
nlon <- dim(lon) #tamaño de la serie (pasos de lon)
lat <- ncvar_get(nctp, "latitude")
nlat <- dim(lat) #tamaño de la serie (pasos de lat)
time <- ncvar_get(nctp,"valid_time")
tunits <- ncatt_get(nctp,"valid_time","units")
ntime <- dim(time)


# --- CONSTRUIR ARREGLO DE TEMPERATURA Y PRECIPITACION
t2_array <- ncvar_get(nct2, dt2)
tp_array <- ncvar_get(nctp, dtp)

# --- CONSTRUIR MALLA BASE
grid <- expand.grid(lon = lon, lat = lat)



# --- EXTRAER DATOS DE precip por tiempo

#t2
t2_1 <- t2_array[,,1]
t2_2 <- t2_array[,,2]
t2_3 <- t2_array[,,3]
t2_4 <- t2_array[,,4]
t2_2 <- t2_array[,,2]
t2_3 <- t2_array[,,3]
t2_4 <- t2_array[,,4]
t2_5 <- t2_array[,,5]
t2_6 <- t2_array[,,6]
t2_7 <- t2_array[,,7]
t2_8 <- t2_array[,,8]
t2_9 <- t2_array[,,9]
t2_10 <- t2_array[,,10]
t2_11 <- t2_array[,,11]
t2_12 <- t2_array[,,12]

#tp
tp_1 <- tp_array[,,1]
tp_2 <- tp_array[,,2]
tp_3 <- tp_array[,,3]
tp_4 <- tp_array[,,4]
tp_5 <- tp_array[,,5]
tp_6 <- tp_array[,,6]
tp_7 <- tp_array[,,7]
tp_8 <- tp_array[,,8]
tp_9 <- tp_array[,,9]
tp_10 <- tp_array[,,10]
tp_11 <- tp_array[,,11]
tp_12 <- tp_array[,,12]


# --- CONSTRUIR MALLA DE DATOS PARA TEMPERATURA Y PRECIPITACION
grid$t2 <- as.vector(t2_4)-273.15 #a °C
grid$tp <- as.vector(tp_4)*1000 #a mm


# plotear

#nombre para el titulo de la foto
mes <- c("enero", "febrero", "marzo", "abril", "mayo", "junio", 
        "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre")


#Temp
for (i in 1:12) {
  
  # 1. Construir la malla para el mes 'i' usando get o indexación directa del array
  # Si tienes los arrays listos, puedes extraer la capa directamente:
  grid$t2 <- as.vector(t2_array[,,i]) - 273.15  # a °C
  grid$tp <- as.vector(tp_array[,,i]) * 1000   # a mm
  
  # 2. Crear el gráfico
  p <- ggplot(grid, aes(x = lon, y = lat, fill = t2)) +
    geom_raster(interpolate = FALSE) +  
    geom_sf(data = pico, fill = NA, color = "black", linewidth = 0.8, inherit.aes = FALSE) +
    scale_fill_gradientn(
      colors = rev(brewer.pal(10, "Spectral")),
      breaks = \(x) pretty(x, n = 5),
      limits = c(5, 25),
      na.value = "transparent"          
    ) +
    coord_sf(
      xlim = c(-97.76, -96.76), 
      ylim = c(18.53, 19.53), 
      expand = FALSE
    ) +                  
    theme_minimal() +                   
    labs(
      title = paste("Promedio mensual de temperatura para", meses_nombres[i], "1950 - 2025"),
      x = "Longitud",
      y = "Latitud",
      fill = "Temp"
    )
  
  # 3. Guardar la imagen dinámicamente usando sprintf o paste0
  nombre_archivo <- sprintf("./03_OUTPUTS/ERA5_t2m_AveMonth_%02d.png", i)
  
  ggsave(
    filename = nombre_archivo,
    plot = p,
    width = 15,     # cm
    height = 15,    # cm
    units = "cm",   # unidades
    dpi = 300       # Res
  )
}

#PRECIP

for (i in 1:12) {
  
  # 1. Construir la malla para el mes 'i' usando get o indexación directa del array
  # Si tienes los arrays listos, puedes extraer la capa directamente:
  grid$t2 <- as.vector(t2_array[,,i]) - 273.15  # a °C
  grid$tp <- as.vector(tp_array[,,i]) * 1000   # a mm
  
  # 2. Crear el gráfico
  p <- ggplot(grid, aes(x = lon, y = lat, fill = tp)) +
    geom_raster(interpolate = FALSE) +  
    geom_sf(data = pico, fill = NA, color = "black", linewidth = 0.8, inherit.aes = FALSE) +
    scale_fill_gradientn(
      colors = rev(brewer.pal(10, "Spectral")),
      breaks = \(x) pretty(x, n = 3),
      limits = c(0, 15),
      na.value = "transparent"          
    ) +
    coord_sf(
      xlim = c(-97.76, -96.76), 
      ylim = c(18.53, 19.53), 
      expand = FALSE
    ) +                  
    theme_minimal() +                   
    labs(
      title = paste("Promedio mensual de temperatura para", meses_nombres[i], "1950 - 2025"),
      x = "Longitud",
      y = "Latitud",
      fill = "Temp"
    )
  
  # 3. Guardar la imagen dinámicamente usando sprintf o paste0
  nombre_archivo <- sprintf("./03_OUTPUTS/ERA5_tp_AveMonth_%02d.png", i)
  
  ggsave(
    filename = nombre_archivo,
    plot = p,
    width = 15,     # cm
    height = 15,    # cm
    units = "cm",   # unidades
    dpi = 300       # Res
  )
}

























#codigo base prueba teste
ggplot(grid, aes(x = lon, y = lat, fill = t2)) +
  geom_raster(interpolate = FALSE) +  # Se recomienda poner el raster de fondo
  geom_sf(data = pico, fill = NA, color = "black", linewidth = 0.8, inherit.aes = FALSE) +
  scale_fill_gradientn(
    colors = rev(brewer.pal(10, "Spectral")),
    breaks = \(x) pretty(x, n = 5),
    limits = c(5,25),
    na.value = "transparent"          
  ) +
  # Reemplazamos coord_quickmap por coord_sf con tus límites calculados
  coord_sf(
    xlim = c(-97.76, -96.76), 
    ylim = c(18.53, 19.53), 
    expand = FALSE
  ) +                  
  theme_minimal() +                   
  labs(
    title = "Promedio mensual de temperatura para abril de 1950 - 2025",
    x = "Longitud",
    y = "Latitud",
    fill = "Temp"
  )

ggsave(
  filename = "./OUTPUTS/ERA5_t2m_AveMonth_abr.png",
  width = 15,                             # cm
  height = 15,                            # cm
  units = "cm",                           # unidades
  dpi = 300                               # Res end dpi
)