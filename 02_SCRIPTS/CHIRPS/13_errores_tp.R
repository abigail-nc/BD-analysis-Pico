# DALM
# PhD Pico - 2026
# Este script cálcula errores estadísticos comparando CHIRPS con SMN

setwd("~/PhD_Pico")
library(readr)
library(lubridate)
#install.packages("Metrics")
library(Metrics)
library(ggplot2)



dir_CHIRPS <- "./03_OUTPUTS/CHIRPS_interpolados/"
dir_smn  <- "./03_OUTPUTS/SMN_mensuales/"

estac_ids <- c( "21020", "21023", "21025", "21026", "21027", "21031", "21033", "21038", "21039", "21040", "21052", "21053", "21056", "21060", "21067", "21072", 
                "21073", "21077", "21079", "21080", "21081", "21082", "21093", "21095", "21100", "21105", "21117", "21119", "21145", "21154", "21157", "21158",
                "21159", "21161", "21170", "21171", "21173", "21182", "21184", "21200", "21221", "21226", "21244", "29007", "30004", "30010", "30015", "30017",
                "30026", "30030", "30032", "30036", "30042", "30052", "30053", "30061", "30066", "30072", "30075", "30085", "30087", "30100", "30115", "30119",
                "30120", "30140", "30151", "30155", "30156", "30164", "30175", "30177", "30178", "30179", "30181", "30186", "30187", "30195", "30198", "30200",
                "30206", "30209", "30210", "30212", "30227", "30228", "30238", "30241", "30259", "30274", "30296", "30299", "30311", "30316", "30330", "30336",
                "30342", "30366", "30387", "30391", "30395", "30452", "30453", "30486", "30487") #"21020", esta ya está hecha

df_metricas_todas <- data.frame(
  id_estac         = character(),
  Fecha_ini_CHIRPS = Date(),
  Fecha_fin_CHIRPS = Date(),
  Fecha_ini_SMN    = Date(),
  Fecha_fin_SMN    = Date(),
  NA_CHIRPS        = numeric(),
  NA_SMN           = numeric(),
  RMSE             = numeric(),
  BIAS             = numeric(),
  PBIAS            = numeric(),
  Pearson          = numeric(),
  Willmott         = numeric(),
  Pct_NA           = numeric(),
  stringsAsFactors = FALSE
)


for (id in estac_ids) {
    #---
    path_CHIRPS <- read.csv2(paste0(dir_CHIRPS, "CHIRPS_extracted_81-21_", id, ".csv"))
    path_CHIRPS[c("date")] <- as.Date(path_CHIRPS$date)
    path_CHIRPS[c("value")] <- as.numeric(path_CHIRPS$value)#*30.4375
    
    path_smn <- read_csv(paste0(dir_smn, "SMN_month_", id, ".csv"))
    path_smn$date <- as.Date(paste(path_smn$Anio, path_smn$Mes, "01", sep = "-"))
    path_smn$Tmed <- as.numeric(path_smn$PRECIP_acum)

    f_ini_chirps <- min(path_CHIRPS$date, na.rm = TRUE)
    f_fin_chirps <- max(path_CHIRPS$date, na.rm = TRUE)
    na_chirps    <- sum(is.na(path_CHIRPS$value))

    f_ini_smn    <- min(path_smn$date, na.rm = TRUE)
    f_fin_smn    <- max(path_smn$date, na.rm = TRUE)
    na_smn       <- sum(is.na(path_smn$Tmed))

    path_CHIRPS_tp <- as.data.frame(path_CHIRPS[c("date", "value")])
    path_smn_tp <- as.data.frame(path_smn[c("date","Tmed")])
    
    CHIRPS_path_smn <- merge(path_CHIRPS_tp, path_smn_tp, by = "date", all=TRUE) #base
    colnames(CHIRPS_path_smn) <- c("Fecha", "CHIRPS", "SMN")


    datos_utiles <- 100-(sum((is.na(CHIRPS_path_smn$SMN)/nrow(CHIRPS_path_smn))*100))
    pct_na_calc <- 100 - datos_utiles
    CHIRPS_path_smn <- CHIRPS_path_smn[!is.na(CHIRPS_path_smn$SMN) & !is.na(CHIRPS_path_smn$CHIRPS), ]

    
    # VALIDACIÓN: Si no hay pares completos de datos, registrar NAs y pasar a la siguiente estación
    if (nrow(CHIRPS_path_smn) < 2) {
      warning(paste("La estación", id, " tiene muchos NA. Se salta el cálculo."))
        fila_error <- data.frame(
            id_estac = id,
            Fecha_ini_CHIRPS = f_ini_chirps,
            Fecha_fin_CHIRPS = f_fin_chirps,
            Fecha_ini_SMN    = f_ini_smn,
            Fecha_fin_SMN    = f_fin_smn,
            NA_CHIRPS        = na_chirps,
            NA_SMN           = na_smn,
            RMSE     = NA,
            BIAS     = NA,
            PBIAS    = NA,
            Pearson  = NA,
            Willmott = NA,
            Pct_NA   = pct_na_calc,
            stringsAsFactors = FALSE
        )
        df_metricas_todas <- rbind(df_metricas_todas, fila_error)
        next
    }

    #---
    #datos que sirven (%)

    # 1. RMSE
    #rmse_CHIRPS_smn <- rmse(CHIRPS_path_smn$SMN,CHIRPS_path_smn$CHIRPS)
    rmse <- sqrt(mean((CHIRPS_path_smn$CHIRPS - CHIRPS_path_smn$SMN)^2))
    bias <- mean(CHIRPS_path_smn$CHIRPS - CHIRPS_path_smn$SMN)    
    pbias<- -1*(percent_bias(CHIRPS_path_smn$SMN, CHIRPS_path_smn$CHIRPS)*100)
    pearson <- cor(CHIRPS_path_smn$SMN, CHIRPS_path_smn$CHIRPS, method = "pearson",use = "complete.obs") # R Base

    # 3. Índice de Willmott (d) en R Base
    numerador   <- sum((CHIRPS_path_smn$CHIRPS - CHIRPS_path_smn$SMN)^2)
    denominador <- sum((abs(CHIRPS_path_smn$CHIRPS - mean(CHIRPS_path_smn$SMN)) + abs(CHIRPS_path_smn$SMN - mean(CHIRPS_path_smn$SMN)))^2,na.rm=TRUE)
    d_val       <- 1 - (numerador / denominador)

    
    fila_actual <- data.frame(
        id_estac         = id,
        Fecha_ini_CHIRPS = f_ini_chirps,
        Fecha_fin_CHIRPS = f_fin_chirps,
        Fecha_ini_SMN    = f_ini_smn,
        Fecha_fin_SMN    = f_fin_smn,
        NA_CHIRPS        = na_chirps,
        NA_SMN           = na_smn,
        RMSE             = rmse,
        BIAS             = bias,
        PBIAS            = pbias,
        Pearson          = pearson,
        Willmott         = d_val,
        Pct_NA           = pct_na_calc,
        stringsAsFactors = FALSE
    )
    df_metricas_todas <- rbind(df_metricas_todas, fila_actual)



    # Mostrar resultados resumidos
    # resultados <- data.frame(
    #   Metrica = c("RMSE (mm)", "BIAS (mm)", "PBIAS (%)", "Pearson (r)", "Willmott (d)"),
    #   Valor   = c(rmse, bias, pbias, pearson, d_val)
    # )
    # #print(resultados)


    texto_metricas <- paste0(
      "Métricas de validación:\n",
      "RMSE: ", round(resultados$Valor[resultados$Metrica == "RMSE (mm)"], 2), " °C   |   ",
      "BIAS: ", round(resultados$Valor[resultados$Metrica == "BIAS (mm)"], 2), " °C   |   ",
      "PBIAS: ", round(resultados$Valor[resultados$Metrica == "PBIAS (%)"], 2), " %\n",
      "Pearson (r): ", round(resultados$Valor[resultados$Metrica == "Pearson (r)"], 2), "   |   ",
      "Willmott (d): ", round(resultados$Valor[resultados$Metrica == "Willmott (d)"], 2), " %\n",
      "% de NA: ", round(100-datos_utiles,2)
    )


    # ggplot(data = CHIRPS_path_smn)+
    #     geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red", linewidth = 0.8) +
    #     geom_point(aes(x=SMN,y=CHIRPS))+
    #     labs( x = "SMN",
    #           y="CHIRPS",
    #           title = "Diagrama de dispersión para precipitación acumulada",
    #           subtitle = paste("SMN vs. CHIRPS para la estación",id),
    #           caption = texto_metricas)+
    #     theme_gray()+
    #     theme(plot.title = element_text(face = "bold", size = 14))

    # ggsave(paste("./03_OUTPUTS/Imagenes/CHIRPS/dispersion/Dispersión_SMNvsCHIRPS_",id,"_tp.png"),
    #     plot = last_plot(), 
    #     width = 11, height = 8.5,
    #     units = "in", dpi = 300)
}

# Ver dataframe final y exportar a CSV
print(df_metricas_todas)
write.csv(df_metricas_todas, "./03_OUTPUTS/metricas_CHIRPSvsSMN_tp_v2.csv", row.names = FALSE)

# Warning messages:
# 1: La estación 30210 no tiene suficientes pares de datos completos. Se salta el cálculo. 
# 2: La estación 30238 no tiene suficientes pares de datos completos. Se salta el cálculo. 
# 3: La estación 30387 no tiene suficientes pares de datos completos. Se salta el cálculo. 
# 4: La estación 30391 no tiene suficientes pares de datos completos. Se salta el cálculo. 
# 5: La estación 30395 no tiene suficientes pares de datos completos. Se salta el cálculo. 
# 6: La estación 30487 no tiene suficientes pares de datos completos. Se salta el cálculo. 