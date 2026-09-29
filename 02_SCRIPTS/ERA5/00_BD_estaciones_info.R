# Script de R generado para procesar los 106 archivos .txt en la carpeta 'coso1'
# y consolidar la información en un archivo 'estaciones_coordenadas.csv'

setwd("~/PhD_Pico")

library(dplyr)
library(stringr)

# 1. Definir la ruta de la carpeta con los archivos txt
carpeta <- "./.old_phd/z_input/ClimaDiario_originales/"
archivos <- list.files(path = carpeta, pattern = "\\.txt$", full.names = TRUE)

# 2. Inicializar una lista para guardar los datos de cada archivo
lista_estaciones <- list()

# 3. Iterar sobre cada uno de los 106 archivos
for (i in seq_along(archivos)) {
  # Leer las primeras 30 líneas del archivo (donde está el encabezado)
  lineas <- readLines(archivos[i], n = 30, warn = FALSE)
  
  # Función auxiliar para extraer el valor después de los dos puntos ":"
  extraer_campo <- function(patron, texto) {
    linea <- texto[str_detect(texto, patron)]
    if (length(linea) > 0) {
      valor <- str_split_i(linea, ":", 2) # Extrae lo que está después de ":"
      valor <- str_trim(valor)           # Elimina espacios en blanco sobrantes
      return(valor)
    }
    return(NA)
  }
  
  # Extraer la información requerida de las líneas del encabezado
  num_estacion <- extraer_campo("ESTACIÓN", lineas)
  nombre       <- extraer_campo("NOMBRE", lineas)
  latitud      <- extraer_campo("LATITUD", lineas)
  longitud     <- extraer_campo("LONGITUD", lineas)
  altitud      <- extraer_campo("ALTITUD", lineas)
  
  # Limpieza numérica de coordenadas y altitud (eliminando caracteres como "°" y "msnm")
  lat_num <- as.numeric(str_extract(latitud, "[-?0-9.]+"))
  lon_num <- as.numeric(str_extract(longitud, "[-?0-9.]+"))
  alt_num <- as.numeric(str_extract(altitud, "[-?0-9.]+"))
  
  # Almacenar en la lista como un data.frame de una fila
  lista_estaciones[[i]] <- data.frame(
    ID_Estacion = num_estacion,
    Nombre      = nombre,
    Longitud    = lon_num,
    Latitud     = lat_num,
    Altitud_msnm = alt_num,
    stringsAsFactors = FALSE
  )
}

# 4. Consolidar todos los archivos en un único DataFrame
df_estaciones <- bind_rows(lista_estaciones)

# 5. Guardar el resultado final como un archivo CSV
write.csv(df_estaciones, "./03_OUTPUTS/00_BD_info_estacs.csv", row.names = FALSE, fileEncoding = "UTF-8")

# Mensaje de confirmación
#cat("Proceso terminado. Se procesaron", nrow(df_estaciones), "estaciones y se guardó 'estaciones_coordenadas.csv'.\n")
