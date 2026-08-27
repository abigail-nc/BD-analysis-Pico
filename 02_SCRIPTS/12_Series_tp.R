# DALM
# PhD Pico - 2026
# este script hace un análisis exploratorio y comparativa de cada base de datos (SMN) y (ERA5)

library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)

setwd("~/PhD_Pico")

dir_era5 <- "./03_OUTPUTS/ERA5_interpolados/tp/"
dir_smn  <- "./03_OUTPUTS/SMN_mensuales/"

estac_ids <- c( "21020", "21023", "21025", "21026", "21027", "21031", "21033", "21038", "21039", "21040", "21052", "21053", "21056", "21060", "21067", "21072", 
                "21073", "21077", "21079", "21080", "21081", "21082", "21093", "21095", "21100", "21105", "21117", "21119", "21145", "21154", "21157", "21158",
                "21159", "21161", "21170", "21171", "21173", "21182", "21184", "21200", "21221", "21226", "21244", "29007", "30004", "30010", "30015", "30017",
                "30026", "30030", "30032", "30036", "30042", "30052", "30053", "30061", "30066", "30072", "30075", "30085", "30087", "30100", "30115", "30119",
                "30120", "30140", "30151", "30155", "30156", "30164", "30175", "30177", "30178", "30179", "30181", "30186", "30187", "30195", "30198", "30200",
                "30206", "30209", "30210", "30212", "30227", "30228", "30238", "30241", "30259", "30274", "30296", "30299", "30311", "30316", "30330", "30336",
                "30342", "30366", "30387", "30391", "30395", "30452", "30453", "30486", "30487")


for (id in estac_ids) {
  path_era5 <- read.csv2(paste0(dir_era5, "ERA5_extracted_50-25_", id, "_tp.csv"))
  path_era5[c("date")] <- as.Date(path_era5$date)
  path_era5[c("value")] <- as.numeric(path_era5$value)*30.4375
  
  path_smn <- read_csv(paste0(dir_smn, "SMN_month_", id, ".csv"))
  path_smn$date <- as.Date(paste(path_smn$Anio, path_smn$Mes, "01", sep = "-"))
  path_smn$Tmed <- as.numeric(path_smn$PRECIP_acum)

  path_era5_t2 <- as.data.frame(path_era5[c("date", "value")])
  path_smn_t2 <- as.data.frame(path_smn[c("date","Tmed")])
  
  era5_smn <- merge(path_era5_t2, path_smn_t2, by = "date", all=TRUE) #base
  colnames(era5_smn) <- c("Fecha", "ERA5", "SMN")

  ggplot(data = era5_smn, aes(x=Fecha)) +
    geom_line(aes(y = ERA5, color="ERA5")) +
    geom_line(aes(y = SMN, color="SMN")) +
    scale_x_date(date_breaks = "5 years", date_labels = "%Y") + 
    scale_color_manual(values=c("ERA5"="orange","SMN"="brown"))+
    labs( x = "Fecha",
          y="Temperatura media mensual",
          color="Fuente de datos",
          title = paste("Series de tiempo de precipitación acumulada mensual para la estación", id),
          subtitle = "Fuente de datos: ERA5 y SMN")+
    theme_gray()+
    theme(legend.position = "top",
              plot.title = element_text(face = "bold", size = 14))
              
  ggsave(paste("./03_OUTPUTS/Imagenes/tp/Serie_ERA5vsSMN_",id,"_tp.png"),
    plot = last_plot(), 
    width = 11, height = 8.5,
    units = "in", dpi = 300)
}
