#---
# Este script hace una sola base de datos (df) 
# de todas las estaciones de la zona de estudio con datos de CHIRPS
# Última actualización: 05 de octubre de 2026
# --- DALM


setwd("~/PhD_Pico")
library(dplyr)
library(readr)


ids_estacs <- c("21020", "21023", "21025", "21026", "21027", "21031", "21033", "21038", "21039", "21040", "21052", "21053", "21056", "21060", "21067", "21072", 
                "21073", "21077", "21079", "21080", "21081", "21082", "21093", "21095", "21100", "21105", "21117", "21119", "21145", "21154", "21157", "21158",
                "21159", "21161", "21170", "21171", "21173", "21182", "21184", "21200", "21221", "21226", "21244", "29007", "30004", "30010", "30015", "30017",
                "30026", "30030", "30032", "30036", "30042", "30052", "30053", "30061", "30066", "30072", "30075", "30085", "30087", "30100", "30115", "30119",
                "30120", "30140", "30151", "30155", "30156", "30164", "30175", "30177", "30178", "30179", "30181", "30186", "30187", "30195", "30198", "30200",
                "30206", "30209", "30210", "30212", "30227", "30228", "30238", "30241", "30259", "30274", "30296", "30299", "30311", "30316", "30330", "30336",
                "30342", "30366", "30387", "30391", "30395", "30452", "30453", "30486", "30487")

#para tener el índice del dataframe
id_base <- ids_estacs[1]
estac_base_path <- paste0("./03_OUTPUTS/CHIRPS_interpolados/CHIRPS_extracted_81-21_", id_base, ".csv")
df_estacs <- read.csv(estac_base_path, header = TRUE, sep = ";")
df_estacs <- df_estacs[c("date", "value")] 
colnames(df_estacs) <- c("date", paste0("estac", id_base))


for(id in ids_estacs[2:length(ids_estacs)]) {
  
  estacs_path <- paste0("./03_OUTPUTS/CHIRPS_interpolados/CHIRPS_extracted_81-21_", id, ".csv")
  temporal <- read.csv(estacs_path, header = TRUE, sep = ";")
  temporal <- temporal[c("date", "value")]
  colnames(temporal) <- c("date", paste0("estac", id)) # Renombrar columna al vuelo
  
  df_estacs <- left_join(df_estacs, temporal, by = "date")
}

head(df_estacs)
write.csv2(df_estacs, "./03_OUTPUTS/CHIRPS_bd_precip.csv", col.names  = TRUE, dec = ".")


# LINEAS BASE
# estac21020 <- read.csv("./03_OUTPUTS/CHIRPS_interpolados/CHIRPS_extracted_81-21_21020.csv", header = TRUE, sep = ";")
# estac21020 <- estac21020[c("date", "lon", "lat", "value")]
# precip21020 <- estac21020[c("date","value")]

# estac21023 <- read.csv("./03_OUTPUTS/CHIRPS_interpolados/CHIRPS_extracted_81-21_21023.csv", header = TRUE, sep = ";")
# estac21023 <- estac21023[c("date", "lon", "lat", "value")]
# precip21023 <- estac21023[c("date","value")]

# df_estacs <- left_join(precip21020, precip21023, by = "date")
# colnames(df_estacs) <- c("date","estac21020","estac21023")
