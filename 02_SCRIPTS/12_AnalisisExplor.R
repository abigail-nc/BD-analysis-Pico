# DALM
# PhD Pico - 2026
# este script hace un análisis exploratorio y comparativa de cada base de datos (SMN) y (ERA5)

library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)

setwd("~/PhD_Pico")


era5_21020 <- read.csv2("./03_OUTPUTS/ERA5_interpolados/t2m/ERA5_extracted_50-25_21020_t2m.csv")
era5_21020[c("date")] <- as.Date(era5_21020$date)
era5_21020[c("value")] <- as.numeric(era5_21020$value)
smn_21020 <- read.csv("./03_OUTPUTS/SMN_mensuales/SMN_month_21020.csv")
smn_21020$date <- as.Date(paste(smn_21020$Anio, smn_21020$Mes, "01", sep = "-"))
smn_21020$Tmed <- as.numeric((smn_21020$TMAX_prom+smn_21020$TMIN_prom)/2)

era5_21020_t2 <- as.data.frame(era5_21020[c("date", "value")])
smn_21020_t2 <- as.data.frame(smn_21020[c("date","Tmed")])
fechas <- era5_21020$date

era5_smn_21020 <- merge(era5_21020_t2, smn_21020_t2, by = "date", all=TRUE) #base
colnames(era5_smn_21020) <- c("Fecha", "ERA5", "SMN")
#df_unido <- full_join(era5_21020_t2d", al, smn_21020_t2, by = "date") %>% arrange(date) # Asegura el orden cronológico


ggplot(data = era5_smn_21020, aes(x=Fecha)) +
  geom_line(aes(y = ERA5, color="ERA5")) +
  geom_line(aes(y = SMN, color="SMN")) +
  scale_x_date(date_breaks = "5 years", date_labels = "%Y") + 
  scale_color_manual(values=c("ERA5"="orange","SMN"="brown"))+
  labs( x = "Fecha",
        y="Temperatura media mensual",
        color="Fuente de datos",
        title = "Series de tiempo de temperatura media mensual",
        subtitle = "Fuente de datos: ERA5 y SMN")+
  theme_gray()+
  theme(legend.position = "top",
            plot.title = element_text(face = "bold", size = 14))+
  ggsave(
    "./03_OUTPUTS/Serie_ERA5vsSMN_21020.png", 
    plot = last_plot(), 
    width = 11,           # Ancho
    height = 8.5,           # Alto
    units = "in",         # Unidades: "in" (pulgadas), "cm", o "mm"
    dpi = 300             # Resolución para alta calidad
)
