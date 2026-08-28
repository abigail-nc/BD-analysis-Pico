# DALM
# PhD Pico - 2026
# Este script cálcula errores estadísticos comparando ERA5 con SMN

setwd("~/PhD_Pico")
library(readr)
library(lubridate)
#install.packages("Metrics")
library(Metrics)
library(ggplot2)


#---
era5_21023 <- read.csv2("./03_OUTPUTS/ERA5_interpolados/t2m/ERA5_extracted_50-25_21023_t2m.csv")
era5_21023[c("date")] <- as.Date(era5_21023$date)
era5_21023[c("value")] <- as.numeric(era5_21023$value)

smn_21023 <- read.csv("./03_OUTPUTS/SMN_mensuales/SMN_month_21023.csv")
smn_21023$date <- as.Date(paste(smn_21023$Anio, smn_21023$Mes, "01", sep = "-"))
smn_21023$Tmed <- as.numeric((smn_21023$TMAX_prom+smn_21023$TMIN_prom)/2)

era5_21023_t2 <- as.data.frame(era5_21023[c("date", "value")])
smn_21023_t2 <- as.data.frame(smn_21023[c("date","Tmed")])

era5_smn_21023 <- merge(era5_21023_t2, smn_21023_t2, by = "date", all=TRUE) #base
colnames(era5_smn_21023) <- c("Fecha", "ERA5", "SMN")
datos_utiles <- 100-(sum((is.na(era5_smn_21023$SMN)/nrow(era5_smn_21023))*100))
era5_smn_21023 <- era5_smn_21023[!is.na(era5_smn_21023$SMN) & !is.na(era5_smn_21023$ERA5), ]

#---
#datos que sirven (%)

# 1. RMSE
#rmse_era5_smn <- rmse(era5_smn_21023$SMN,era5_smn_21023$ERA5)
rmse <- sqrt(mean((era5_smn_21023$ERA5 - era5_smn_21023$SMN)^2))
bias <- mean(era5_smn_21023$ERA5 - era5_smn_21023$SMN)    
pbias<- -1*(percent_bias(era5_smn_21023$SMN, era5_smn_21023$ERA5)*100)
pearson <- cor(era5_smn_21023$SMN, era5_smn_21023$ERA5, method = "pearson",use = "complete.obs") # R Base

# 3. Índice de Willmott (d) en R Base
numerador   <- sum((era5_smn_21023$ERA5 - era5_smn_21023$SMN)^2)
denominador <- sum((abs(era5_smn_21023$ERA5 - mean(era5_smn_21023$SMN)) + abs(era5_smn_21023$SMN - mean(era5_smn_21023$SMN)))^2,na.rm=TRUE)
d_val       <- 1 - (numerador / denominador)

# Mostrar resultados resumidos
resultados <- data.frame(
  Metrica = c("RMSE (°C)", "BIAS (°C)", "PBIAS (%)", "Pearson (r)", "Willmott (d)"),
  Valor   = c(rmse, bias, pbias, pearson, d_val)
)
print(resultados)


texto_metricas <- paste0(
  "Métricas de validación:\n",
  "RMSE: ", round(resultados$Valor[resultados$Metrica == "RMSE (°C)"], 2), " °C   |   ",
  "BIAS: ", round(resultados$Valor[resultados$Metrica == "BIAS (°C)"], 2), " °C   |   ",
  "PBIAS: ", round(resultados$Valor[resultados$Metrica == "PBIAS (%)"], 2), " %\n",
  "Pearson (r): ", round(resultados$Valor[resultados$Metrica == "Pearson (r)"], 2), "   |   ",
  "Willmott (d): ", round(resultados$Valor[resultados$Metrica == "Willmott (d)"], 2)
)


ggplot(data = era5_smn_21023)+
    geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red", linewidth = 0.8) +
    geom_point(aes(x=SMN,y=ERA5))+
    labs( x = "SMN",
        y="ERA5",
        title = "Diagrama de dispersión para temperatura media",
        subtitle = "SMN vs. ERA5 para la estación 21023",
        caption = texto_metricas)+
    theme_gray()+
    theme(plot.title = element_text(face = "bold", size = 14))
              
ggsave("./03_OUTPUTS/Imagenes/dispersion_t2m/Dispersión_SMNvsERA5_21023_t2m.png",
    plot = last_plot(), 
    width = 11, height = 8.5,
    units = "in", dpi = 300)

