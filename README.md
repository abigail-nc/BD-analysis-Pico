
## Análisis de Bases de Datos Climáticas para la Región del Pico de Orizaba

Este repositorio resguarda los scripts de análisis, el flujo de trabajo computacional y los criterios metodológicos para la descarga, homogeneización, limpieza y recorte de bases de datos climáticas globales y nacionales aplicadas a la región de alta montaña del Pico de Orizaba, México.

El área de estudio está delimitada por un dominio cuadrangular con un radio aproximado de 50 km alrededor del Citlaltépetl, abarcando las coordenadas geográficas de longitud -97.72501° a -96.775° E y latitud 18.575° a 19.52499° N.

### 📊 Estado de los Módulos de Datos

La información y el código de procesamiento se organizan según su estatus actual de validación y publicación oficial:

#### 🟢 Publicadas (con registro oficial)

* CHIRPS (Daily):
  
	* Malla de precipitación diaria acumulada (1981-2021) en formato NetCDF (.nc) a resolución de 0.05° (~5 km).

	* Dataset alojado de forma abierta en [Zenodo](https://zenodo.org/records/23539068)

	* Consulta el código y los detalles de descarga en el [README específico de CHIRPS](./02_SCRIPTS/CHIRPS/README_CHIRPS.md).

#### 🟡 En validación


* SMN (Daily): Datos observacionales diarios de estaciones meteorológicas superficiales en tierra, limpios y formateados.

* ERA5 (Monthly): Reanálisis global de promedios mensuales (1950-2025) para temperatura media (t2m) y precipitación (tp).


#### En proceso
* CHELSA (Daily): Climatologías diarias de alta resolución corregidas por topografía.


#### Por iniciar
* Daymet: Datos climáticos diarios estimados por interpolación topográfica.
  
* ERA5-Land: Reanálisis terrestre global por horas, mayor resolución espacial.


### Infraestructura Técnica

* **R**: Procesamiento estadístico, análisis de series de tiempo, cálculo de métricas de error y generación de gráficos.

* **Shell + Python**: Descarga automatizada, manipulación, acoplamiento temporal y recorte espacial de archivos masivos NetCDF.
