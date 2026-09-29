#DALM
# PhD Pico - 2026
# Este script es para explorar las estaciones del área de estudio para generar la comparación con los datos del SMN

library(ggplot2)
library(dplyr)
library(readr)
library(lubridate)

setwd("~/PhD_Pico")

# era5_21020 <- read.csv2("./03_OUTPUTS/ERA5_interpolados/t2m/ERA5_extracted_50-25_21020_t2m.csv")
# era5_21020 <- data.frame(era5_21020[c("date","lon","lat","value")])
# era5_21020$date <- as.Date(era5_21020$date)
# era5_21020$lon <- as.numeric(era5_21020$lon)
# era5_21020$lat <- as.numeric(era5_21020$lat)
# era5_21020$value <- as.numeric(era5_21020$value)

# smn_21020 <- read.csv("./03_OUTPUTS/SMN_mensuales/SMN_month_21020.csv", na = "NA")
# smn_21020$date<- as.Date(smn_21020$date)
# smn_21020$TMAX_prom <- as.numeric(smn_21020$TMAX_prom)


# plot(era5_21020$date,era5_21020$value)

archivos_csv <- list.files("./03_OUTPUTS/")








#ERA5
df1 <- era5_21020 %>%
  mutate(date = as.Date(date)) %>%        # Asegurar formato de fecha
  select(date, t2m = value) %>%          # Renombrar 'value' a 'tmed'
  mutate(fuente = "ERA5") # Crear etiqueta de origen

#SMN
df2 <- smn_21020 %>%
  mutate(date = as.Date(date)) %>%        # Asegurar formato de fecha
  mutate(t2m = (TMAX_prom + TMIN_prom) / 2) %>% # Calcular Temperatura Media
  select(date, t2m) %>%                  # Seleccionar columnas comunes
  mutate(fuente = "SMN")   # Crear etiqueta de origen

datos_combinados <- bind_rows(df1, df2)
ggplot(datos_combinados, aes(x = date, y = t2m, color = fuente)) + # 1. Mapea la columna aquí
  geom_line(alpha = 0.8, size = 0.7) +
  scale_x_date(date_breaks = "5 years", date_labels = "%Y") + 
  
  # 2. Define aquí los colores exactos para cada serie
  scale_color_manual(values = c("ERA5" = "red", 
                                "SMN" = "blue")) +
  
  labs(title = "Serie de tiempo de datos para la estación 21020",
       x = "Año",
       y = "Temperatura Media (°C)",
       color = "Fuente de Datos") +
  theme_gray() +
  theme(legend.position = "top")+
  ggsave(
    "./03_OUTPUTS/ERA5_21020.png", 
    plot = last_plot(), 
    width = 11,           # Ancho
    height = 8.5,           # Alto
    units = "in",         # Unidades: "in" (pulgadas), "cm", o "mm"
    dpi = 300             # Resolución para alta calidad
)



#test1
# #ggplot(data = era5_21020, aes(date,value))+
    # geom_point()+
    # geom_line()+
    # geom_abline()+
    # theme_linedraw()



