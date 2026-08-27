# DALM + Gemini
# PhD Pico
#script para hacer mapa de calor de disnponibilidad de datos con la siguiente nomenclatura
# 🔴 Rojo: Solo hay datos de ERA5.
# 🔵 Azul: Solo hay datos de SMN.
# 🟢 Verde: Coinciden ambas fuentes .
# ⚪ Gris/Blanco: No hay datos en ninguna de las dos fuentes.


library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)

# 1. Configurar directorios de trabajo (Ajustados a tu PhD_Pico)
setwd("~/PhD_Pico")

dir_era5 <- "./03_OUTPUTS/ERA5_interpolados/t2m/"
dir_smn  <- "./03_OUTPUTS/SMN_mensuales/"

# Lista vacía para ir guardando el resumen de cada estación
lista_estaciones <- list()
estac_ids <- c( "21020", "21023", "21025", "21026", "21027", "21031", "21033", "21038", "21039", "21040", "21052", "21053", "21056", "21060", "21067", "21072", 
                "21073", "21077", "21079", "21080", "21081", "21082", "21093", "21095", "21100", "21105", "21117", "21119", "21145", "21154", "21157", "21158",
                "21159", "21161", "21170", "21171", "21173", "21182", "21184", "21200", "21221", "21226", "21244", "29007", "30004", "30010", "30015", "30017",
                "30026", "30030", "30032", "30036", "30042", "30052", "30053", "30061", "30066", "30072", "30075", "30085", "30087", "30100", "30115", "30119",
                "30120", "30140", "30151", "30155", "30156", "30164", "30175", "30177", "30178", "30179", "30181", "30186", "30187", "30195", "30198", "30200",
                "30206", "30209", "30210", "30212", "30227", "30228", "30238", "30241", "30259", "30274", "30296", "30299", "30311", "30316", "30330", "30336",
                "30342", "30366", "30387", "30391", "30395", "30452", "30453", "30486", "30487")


# 2. Bucle iterando sobre tus IDs (Asegúrate de que 'mis_ids' exista en tu entorno)
for (id in estac_ids) {
  
  # Construir las rutas exactas de los archivos
  path_era5 <- paste0(dir_era5, "ERA5_extracted_50-25_", id, "_t2m.csv")
  path_smn  <- paste0(dir_smn, "SMN_month_", id, ".csv")
  
  # Inicializar tablas de disponibilidad vacías para este ID
  disp_era5 <- data.frame(date = as.Date(character()), has_era5 = logical())
  disp_smn  <- data.frame(date = as.Date(character()), has_smn = logical())
  
  # --- PROCESAR ERA5 ---
  if (file.exists(path_era5)) {
    # Usamos read_delim para ignorar de manera segura el ';' inicial y mapear nombres limpios
    df_era5 <- read_delim(path_era5, delim = ";", col_types = cols(), trim_ws = TRUE)
    
    # Si la primera columna se leyó sin nombre debido al ';' inicial, corregimos los nombres manualmente
    if ("X1" %in% names(df_era5) || "" %in% names(df_era5)) {
      # Forzamos la lectura limpia eliminando columnas vacías si R creó desfases
      df_era5 <- df_era5[, !names(df_era5) %in% c("X1", "")]
    }
    
    # Conversión explícita y segura a formato fecha
    df_era5$date <- as.Date(df_era5$date)
    df_era5$value <- as.numeric(df_era5$value)
    
    # Filtrar solo registros donde el dato de temperatura (value) y la fecha sean válidos
    disp_era5 <- df_era5 %>%
      filter(!is.na(value) & !is.na(date)) %>%
      select(date) %>%
      distinct(date) %>%
      mutate(has_era5 = TRUE)
  }
  
  # --- PROCESAR SMN ---
  if (file.exists(path_smn)) {
    # Leemos el archivo SMN separado por comas
    df_smn <- read_csv(path_smn, na = c("NA", ""), show_col_types = FALSE)
    
    # Construir la columna 'date' unificando Anio y Mes en formato estándar YYYY-MM-01
    df_smn <- df_smn %>%
      mutate(
        date = as.Date(paste(Anio, Mes, "01", sep = "-")),
        # Calculamos la temperatura media mensual
        tmed = (as.numeric(TMAX_prom) + as.numeric(TMIN_prom)) / 2
      )
    
    # Filtrar solo registros donde la temperatura media calculada sea válida
    disp_smn <- df_smn %>%
      filter(!is.na(tmed) & !is.na(date)) %>%
      select(date) %>%
      distinct(date) %>%
      mutate(has_smn = TRUE)
  }
  
  # --- COMBINAR AMBAS FUENTES MEDIANTE FULL JOIN ---
  if (nrow(disp_era5) > 0 || nrow(disp_smn) > 0) {
    combinado <- full_join(disp_era5, disp_smn, by = "date") %>%
      mutate(
        has_era5 = tidyr::replace_na(has_era5, FALSE),
        has_smn  = tidyr::replace_na(has_smn, FALSE)
      ) %>%
      # Evaluar las condiciones lógicas de disponibilidad
      mutate(status = case_when(
        has_era5 & has_smn  ~ "Coinciden ambas",
        has_era5 & !has_smn ~ "Solo ERA5",
        !has_era5 & has_smn ~ "Solo SMN",
        TRUE                ~ "Sin Datos"
      )) %>%
      select(date, status) %>%
      mutate(estacion = as.character(id))
    
    # Almacenar los resultados del ID actual en la lista global
    lista_estaciones[[as.character(id)]] <- combinado
  }
}

# 3. Consolidar todas las estaciones en una gran base de datos
df_mapa_calor <- bind_rows(lista_estaciones)

# Rellenar explícitamente los huecos temporales absolutos como "Sin Datos"
df_mapa_calor <- df_mapa_calor %>%
  complete(estacion, date, fill = list(status = "Sin Datos"))

# Convertir la columna 'status' a factor para fijar los colores de la leyenda
df_mapa_calor$status <- factor(df_mapa_calor$status, 
                               levels = c("Solo ERA5", "Solo SMN", "Coinciden ambas", "Sin Datos"))

# 4. Diseñar el mapa de calor final en ggplot2
p_final <- ggplot(df_mapa_calor, aes(x = date, y = estacion, fill = status)) +
  geom_tile() +
  # Paleta de colores solicitada: Rojo (ERA5), Azul (SMN), Verde (Coincidencia), Gris (Sin Datos)
  scale_fill_manual(values = c(
    "Solo ERA5"       = "#7d929e", 
    "Solo SMN"        = "#0f3b59",  
    "Coinciden ambas" = "#dba12c",
    "Sin Datos"       = "#dbd4cc"
  )) +
  # Eje X configurado cada 10 años para dar espacio a series de tiempo largas (desde los 40s)
  scale_x_date(date_breaks = "5 years", date_labels = "%Y") +
  labs(
    title = "Heatmap disponibilidad de registros de temperatura media: ERA5 vs SMN",
    subtitle = paste("Series temporales mensuales para", length(unique(df_mapa_calor$estacion)), "estaciones"),
    x = "Fechas",
    y = "ID Estación",
    fill = "Disponibilidad"
  ) +
  theme_dark() +
  theme(
    axis.text.y = element_text(size = 5), # Texto de tamaño reducido para legibilidad de los 106 IDs
    panel.grid = element_blank(),
    legend.position = "bottom",
    plot.title = element_text(face = "bold", size = 14)
  )

# Renderizar el gráfico resultante en RStudio
print(p_final)


ggsave(
    "./03_OUTPUTS/Heatmap_ERA5vsSMN_t2m.png", 
    plot = last_plot(), 
    width = 8.5,           # Ancho
    height = 11,           # Alto
    units = "in",         # Unidades: "in" (pulgadas), "cm", o "mm"
    dpi = 300             # Resolución para alta calidad
)
