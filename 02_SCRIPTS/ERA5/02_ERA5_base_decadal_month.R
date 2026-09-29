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
tpnc <- "./01_INPUT/01_ERA5/ERA5_0.25x0.25_month22_prcp.nc"
dtp <- "tp"
nctp <- nc_open(tpnc)
dlt2p <- ncatt_get(nctp, dtp, "long_name")
tpunits <- ncatt_get(nctp, dtp, "units")

t2nc <- "./01_INPUT/01_ERA5/ERA5_0.25x0.25_month22_temp.nc"
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

# --- CONSTRUIR MALLA y plotear

# --- CONSTRUIR MALLA BASE CON TODOS LOS MESES (FASE BUCLE)
meses_nombres <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", 
                   "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")

lista_meses <- list()

for (i in 1:12) {
  # Creamos la malla base para el mes actual
  grid_mes <- expand.grid(lon = lon, lat = lat)
  
  # Extraemos y convertimos las variables directamente usando la dimensión 'i'
  grid_mes$t2 <- as.vector(t2_array[,,i]) - 273.15  # a °C
  grid_mes$tp <- as.vector(tp_array[,,i]) * 1000    # a mm
  
  # Guardamos el mes como un factor para asegurar el orden cronológico correcto
  grid_mes$Mes <- factor(meses_nombres[i], levels = meses_nombres)
  
  lista_meses[[i]] <- grid_mes
}

# Unimos los data.frames de todos los meses en uno solo
grid_completo <- bind_rows(lista_meses)

# --- CERRAR CONEXIONES netCDF (Buenas prácticas)
nc_close(nctp)
nc_close(nct2)


# --- GENERAR EL GRÁFICO EN PANEL (Temperatura)
p_panel <- ggplot(grid_completo, aes(x = lon, y = lat, fill = t2)) +
  # interpolate = TRUE elimina los cuadrotes visuales suavizando los píxeles
  geom_raster(interpolate = FALSE) +  
  geom_sf(data = pico, fill = NA, color = "black", linewidth = 0.6, inherit.aes = FALSE) +
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
  # Divide el plano en una cuadrícula de 4 filas x 3 columnas
  facet_wrap(~ Mes, ncol = 3) + 
  theme(
    strip.text = element_text(face = "bold", size = 11), # Formato del título del mes
    panel.spacing = unit(0.4, "lines"),                 # Espacio entre cada mapa
    plot.title = element_text(face = "bold", hjust = 0.5)
  ) +
  labs(
    title = "Promedio mensual de temperatura para 1950 - 2025",
    x = "Longitud",
    y = "Latitud",
    fill = "Temp (°C)"
  )

# --- GUARDAR PANEL COMPLETO
ggsave(
  filename = "./03_OUTPUTS/ERA5_t2_decad22_MonthPanel.png",
  plot = p_panel,
  width = 24,                             # cm (ajustado para albergar 3 columnas)
  height = 30,                            # cm (ajustado para albergar 4 filas)
  units = "cm",                           
  dpi = 300                               
)































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
  filename = "./03OUTPUTS/ERA5_t2m_AveMonth_abr.png",
  width = 15,                             # cm
  height = 15,                            # cm
  units = "cm",                           # unidades
  dpi = 300                               # Res end dpi
)




