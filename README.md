## Análisis de bases de datos climáticas para el Pico de Orizaba

Este repositorio resguarda los scripts utilizados y los productos generados en cada parte del proceso de análisis de bases de datos climáticas para el Pico de Orizaba (considerando un radio de 50 km). Cada base de datos descrita a continuación, se comparó con los **datos de la climatología diaria** del Servicio Meteorológico nacional para las estaciones descritas en [este documento](./03_OUTPUTS/00_BD_info_estacs.csv)



### Descripción de las bases de datos

| Base de datos | Descripción | Resolución espacial | Resolución temporal | Fecha de inicio | Fecha de término | Se decarga con... | Prodcuctos obtenidos | 
|---------------|-------------|---------------------|---------------------|-----------------|------------------|-------------------|----------------------|
| ERA5 monthly averaged data on single levels from 1940 to present | Reanálisis promedios mensuales | Reanalysis: 0.25° x 0.25° (atmosphere), 0.5° x 0.5° (ocean waves)| Mensual | 01 de enero de 1950 | 31 de diciembre de 205 | Desde la [Copernicus Data Store](https://cds.climate.copernicus.eu/datasets)| * [Datos ERA5 mensuales para cada estación para temperatura media](./03_OUTPUTS/ERA5_interpolados/t2m/) <br> * [Datos ERA5 mensuales para cada estación para precipitación mm/dia](./03_OUTPUTS/ERA5_interpolados/tp/)<br> * [Agregados mensuales del SMN de temperatura media mensual y precipitación diaria](./03_OUTPUTS/SMN_mensuales/)<br> * [Mapa de calor de disponibilidad y coincidencia de información ERA5 vs SMN para temperatura](./03_OUTPUTS/Imagenes/time_serie_t2m/Heatmap_ERA5vsSMN_t2m.png)<br> * [Mapa de calor de disponibilidad y coincidencia de información ERA5 vs SMN para precipitación](./03_OUTPUTS/Imagenes/time_serie_tp/Heatmap_ERA5vsSMN_tp.png)<br> * [Gráfico de series de tiempo del ERA5 y SMN para temperatura](./03_OUTPUTS/Imagenes/time_serie_t2m/)<br> * [Gráfico de series de tiempo del ERA5 y SMN para precipitación](./03_OUTPUTS/Imagenes/time_serie_tp/)<br> * [Gráficos de dispersión ERA5 vs SMN para temperatura](./03_OUTPUTS/Imagenes/dispersion_t2m/)<br> * [Gráficos de dispersión ERA5 vs SMN para precipitación](./03_OUTPUTS/Imagenes/dispersion_tp/)<br> * [Cálculo de errores para cada estación para temperatura](./03_OUTPUTS/metricas_ERA5vsSMN_t2m.csv)<br>|


### Sobre las estaciones del SMN

Para conocer información adicional sobre todas las estaciones utilizadas en este proyecto, [consulta este documento](./03_OUTPUTS/00_BD_info_estacs.csv)