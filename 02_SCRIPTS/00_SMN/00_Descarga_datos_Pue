#!/bin/bash
# Este script descarga los datos de climatología diaria del Servicio Meteorológico Nacional
# Última actualización: 22 de octubre de 2026

# Lista de códigos de estaciones
estaciones=("21020" "21023" "21025" "21026" "21027" "21031" "21033" "21038" 
            "21039" "21040" "21052" "21053" "21056" "21060" "21067" "21072"
            "21073" "21077" "21079" "21080" "21081" "21082" "21093" "21095"
            "21100" "21105" "21117" "21119" "21122" "21145" "21154" "21157"
            "21158" "21159" "21161" "21170" "21171" "21173" "21182" "21184"
            "21200" "21221" "21226" "21244" "29007")

# Descargar cada archivo con wget
for estacion in "${estaciones[@]}"; do
    # Construir la URL con el código de la estación
    url="https://smn.conagua.gob.mx/tools/RESOURCES/Normales_Climatologicas/Diarios/pue/dia${estacion}.txt"
    
    # Descargar el archivo con wget
    echo "Descargando: $url"
    wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36" "$url"
done

echo "Descarga completa."
