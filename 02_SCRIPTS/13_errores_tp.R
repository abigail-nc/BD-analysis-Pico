# DALM
# PhD Pico - 2026
# Este script cálcula errores estadísticos comparando ERA5 con SMN

setwd("~/PhD_Pico")
library(readr)
library(lubridate)
#install.packages("Metrics")
library(Metrics)
library(ggplot2)



dir_era5 <- "./03_OUTPUTS/ERA5_interpolados/tp/"
dir_smn  <- "./03_OUTPUTS/SMN_mensuales/"

estac_ids <- c( "21020", "21023", "21025", "21026", "21027", "21031", "21033", "21038", "21039", "21040", "21052", "21053", "21056", "21060", "21067", "21072", 
                "21073", "21077", "21079", "21080", "21081", "21082", "21093", "21095", "21100", "21105", "21117", "21119", "21145", "21154", "21157", "21158",
                "21159", "21161", "21170", "21171", "21173", "21182", "21184", "21200", "21221", "21226", "21244", "29007", "30004", "30010", "30015", "30017",
                "30026", "30030", "30032", "30036", "30042", "30052", "30053", "30061", "30066", "30072", "30075", "30085", "30087", "30100", "30115", "30119",
                "30120", "30140", "30151", "30155", "30156", "30164", "30175", "30177", "30178", "30179", "30181", "30186", "30187", "30195", "30198", "30200",
                "30206", "30209", "30210", "30212", "30227", "30228", "30238", "30241", "30259", "30274", "30296", "30299", "30311", "30316", "30330", "30336",
                "30342", "30366", "30387", "30391", "30395", "30452", "30453", "30486", "30487") #"21020", esta ya está hecha

df_metricas_todas <- data.frame(
  id_estac = character(),
  RMSE     = numeric(),
  BIAS     = numeric(),
  PBIAS    = numeric(),
  Pearson  = numeric(),
  Willmott = numeric(),
  Pct_NA   = numeric(),
  stringsAsFactors = FALSE
)


for (id in estac_ids) {
    #---
    path_era5 <- read.csv2(paste0(dir_era5, "ERA5_extracted_50-25_", id, "_tp.csv"))
    path_era5[c("date")] <- as.Date(path_era5$date)
    path_era5[c("value")] <- as.numeric(path_era5$value)*30.4375
    
    path_smn <- read_csv(paste0(dir_smn, "SMN_month_", id, ".csv"))
    path_smn$date <- as.Date(paste(path_smn$Anio, path_smn$Mes, "01", sep = "-"))
    path_smn$Tmed <- as.numeric(path_smn$PRECIP_acum)

    path_era5_tp <- as.data.frame(path_era5[c("date", "value")])
    path_smn_tp <- as.data.frame(path_smn[c("date","Tmed")])
    
    era5_path_smn <- merge(path_era5_tp, path_smn_tp, by = "date", all=TRUE) #base
    colnames(era5_path_smn) <- c("Fecha", "ERA5", "SMN")
    datos_utiles <- 100-(sum((is.na(era5_path_smn$SMN)/nrow(era5_path_smn))*100))
    era5_path_smn <- era5_path_smn[!is.na(era5_path_smn$SMN) & !is.na(era5_path_smn$ERA5), ]

    
    # VALIDACIÓN: Si no hay pares completos de datos, registrar NAs y pasar a la siguiente estación
    if (nrow(era5_path_smn) < 2) {
      warning(paste("La estación", id, "no tiene suficientes pares de datos completos. Se salta el cálculo."))
    
        fila_actual <- data.frame(
            id_estac = id,
            RMSE     = rmse,
            BIAS     = bias,
            PBIAS    = pbias,
            Pearson  = pearson,
            Willmott = d_val,
            Pct_NA   = 100 - datos_utiles
            )
        df_metricas_todas <- rbind(df_metricas_todas, fila_actual)
    next}

    #---
    #datos que sirven (%)

    # 1. RMSE
    #rmse_era5_smn <- rmse(era5_path_smn$SMN,era5_path_smn$ERA5)
    rmse <- sqrt(mean((era5_path_smn$ERA5 - era5_path_smn$SMN)^2))
    bias <- mean(era5_path_smn$ERA5 - era5_path_smn$SMN)    
    pbias<- -1*(percent_bias(era5_path_smn$SMN, era5_path_smn$ERA5)*100)
    pearson <- cor(era5_path_smn$SMN, era5_path_smn$ERA5, method = "pearson",use = "complete.obs") # R Base

    # 3. Índice de Willmott (d) en R Base
    numerador   <- sum((era5_path_smn$ERA5 - era5_path_smn$SMN)^2)
    denominador <- sum((abs(era5_path_smn$ERA5 - mean(era5_path_smn$SMN)) + abs(era5_path_smn$SMN - mean(era5_path_smn$SMN)))^2,na.rm=TRUE)
    d_val       <- 1 - (numerador / denominador)

    
    # Mostrar resultados resumidos
    resultados <- data.frame(
      Metrica = c("RMSE (mm)", "BIAS (mm)", "PBIAS (%)", "Pearson (r)", "Willmott (d)"),
      Valor   = c(rmse, bias, pbias, pearson, d_val)
    )
    #print(resultados)


    texto_metricas <- paste0(
      "Métricas de validación:\n",
      "RMSE: ", round(resultados$Valor[resultados$Metrica == "RMSE (mm)"], 2), " °C   |   ",
      "BIAS: ", round(resultados$Valor[resultados$Metrica == "BIAS (mm)"], 2), " °C   |   ",
      "PBIAS: ", round(resultados$Valor[resultados$Metrica == "PBIAS (%)"], 2), " %\n",
      "Pearson (r): ", round(resultados$Valor[resultados$Metrica == "Pearson (r)"], 2), "   |   ",
      "Willmott (d): ", round(resultados$Valor[resultados$Metrica == "Willmott (d)"], 2), " %\n",
      "% de NA: ", round(100-datos_utiles,2)
    )


    #ggplot(data = era5_path_smn)+
    #    geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red", linewidth = 0.8) +
    #    geom_point(aes(x=SMN,y=ERA5))+
    #    labs( x = "SMN",
    #          y="ERA5",
    #          title = "Diagrama de dispersión para precipitación acumulada",
    #          subtitle = paste("SMN vs. ERA5 para la estación",id),
    #          caption = texto_metricas)+
    #    theme_gray()+
    #    theme(plot.title = element_text(face = "bold", size = 14))
#
    #ggsave(paste("./03_OUTPUTS/Imagenes/dispersion_tp/Dispersión_SMNvsERA5_",id,"_tp.png"),
    #    plot = last_plot(), 
    #    width = 11, height = 8.5,
    #    units = "in", dpi = 300)
}

# Ver dataframe final y exportar a CSV
print(df_metricas_todas)
write.csv(df_metricas_todas, "./03_OUTPUTS/metricas_ERA5vsSMN_tp.csv", row.names = FALSE)

# Warning messages:
# 1: La estación 30210 no tiene suficientes pares de datos completos. Se salta el cálculo. 
# 2: La estación 30238 no tiene suficientes pares de datos completos. Se salta el cálculo. 
# 3: La estación 30387 no tiene suficientes pares de datos completos. Se salta el cálculo. 
# 4: La estación 30391 no tiene suficientes pares de datos completos. Se salta el cálculo. 
# 5: La estación 30395 no tiene suficientes pares de datos completos. Se salta el cálculo. 
# 6: La estación 30487 no tiene suficientes pares de datos completos. Se salta el cálculo. 