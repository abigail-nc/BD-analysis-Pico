## DALM
# Primero, instalar los paquetes
# -- Para que funcione ncdf4 hay que instalar antes libnetcdf-dev
# -- (en este caso en el ambiente del directorio que estamos usando)

setwd("~/PhD_Pico")
#install.packages(c("ncdf4", "CFtime", "lattice", "RColorBrewer", "ggplot2", "maps")) #solo ejecutar una vez
library(ncdf4)
library(lattice)
library(RColorBrewer)
library(CFtime)
library(ggplot2)
library(maps)
library(sf)
library(tibble) #lo necesita sf para desplegar los poligonos
library(dplyr)

#--- ABRIR NETCDF
ncpath <- "./ERA5_0.25x0.25_monthly_temp.nc"
dname<-"t2m"
ncin <- nc_open(ncpath)
# print(ncin) #parecido al cdo -sinfo

#--- CARGAR DATOS DEL SHAPE DE LOS POLIGONOS
ANP <- read_sf("./old_phd/z_input/anp2021gw.shp")
pico <- ANP %>% filter(NOMBRE == "Pico de Orizaba")
#pico <- ANP[ANP$NOMBRE == "Pico de Orizaba", ] #lo mismo que arriba pero con la base de R



#--- OBTENER COORDENADAS + TIEMPO
lon <- ncvar_get(ncin, "longitude")
nlon <- dim(lon) #tamaño de la serie (pasos de lon)
lat <- ncvar_get(ncin, "latitude")
nlat <- dim(lat) #tamaño de la serie (pasos de lat)
time <- ncvar_get(ncin,"valid_time")
tunits <- ncatt_get(ncin,"valid_time","units")
ntime <- dim(time)

# --- OBTENER LOS DATOS DE TEMPERATURA
t2m_array <- ncvar_get(ncin, dname)
dlname <- ncatt_get(ncin, dname, "long_name")
dunits <- ncatt_get(ncin, dname, "units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
dim(t2m_array)

#-- obtener los atributos globales:
# get global attributes
title <- ncatt_get(ncin,0,"title")
institution <- ncatt_get(ncin,0,"institution")
datasource <- ncatt_get(ncin,0,"source")
references <- ncatt_get(ncin,0,"references")
history <- ncatt_get(ncin,0,"history")
Conventions <- ncatt_get(ncin,0,"Conventions")

#---- OBTENER UNA REBANADA DE LA MALLA
t2m_ene <- t2m_array[,,1]
t2m_feb <- t2m_array[,,2]
t2m_mzo <- t2m_array[,,3]
t2m_abr <- t2m_array[,,4]
t2m_may <- t2m_array[,,5]
t2m_jun <- t2m_array[,,6]
t2m_jul <- t2m_array[,,7]
t2m_ago <- t2m_array[,,8]
t2m_sep <- t2m_array[,,9]
t2m_oct <- t2m_array[,,10]
t2m_nov <- t2m_array[,,11]
t2m_dic <- t2m_array[,,12]

grid <- expand.grid(lon = lon, lat = lat)
grid$t2m <- as.vector(t2m_abr)-273.15

ggplot(grid, aes(x = lon, y = lat, fill = t2m)) +
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



#-------------------------- PANEL DE IMÁGENES

# 1. Crear una lista o data frame largo con los 12 meses
meses_nombres <- c("Ene", "Feb", "Mzo", "Abr", "May", "Jun", 
                   "Jul", "Ago", "Sep", "Oct", "Nov", "Dic")

grid_list <- lapply(1:12, function(i) {
  df <- expand.grid(lon = lon, lat = lat)
  df$t2m <- as.vector(t2m_array[,,i]) - 273.15
  df$mes <- meses_nombres[i]
  return(df)
})

grid_total <- bind_rows(grid_list)

# Asegurar el orden correcto de los meses en el panel
grid_total$mes <- factor(grid_total$mes, levels = meses_nombres)

# 2. Graficar con facet_wrap
ggplot(grid_total, aes(x = lon, y = lat, fill = t2m)) +
  geom_raster(interpolate = FALSE) +  
  geom_sf(data = pico, fill = NA, color = "black", linewidth = 0.5, inherit.aes = FALSE) +
  facet_wrap(~ mes, ncol = 4, nrow = 3) +
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
    title = "Promedio mensual de temperatura (1950 - 2025)",
    x = "Longitud",
    y = "Latitud",
    fill = "Temp (°C)"
  )

# 3. Guardar con mayor tamaño para que se distingan los 12 mapas
ggsave(
  filename = "./OUTPUTS/ERA5_t2m_AveMonth_12panel.png",
  width = 24,                             # cm (ampliado para 4 columnas)
  height = 18,                            # cm (ampliado para 3 filas)
  units = "cm",                           
  dpi = 300                               
)

