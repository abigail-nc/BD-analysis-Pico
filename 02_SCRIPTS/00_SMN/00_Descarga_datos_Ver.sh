#!/bin/bash
# Este script descarga los datos de climatología diaria del Servicio Meteorológico Nacional
# Última actualización: 22 de octubre de 2026


# Lista de códigos de estaciones
estaciones=("30004" "30010" "30015" "30017" "30026" "30030" "30032" "30036" "30042" "30052" 
            "30053" "30061" "30066" "30072" "30075" "30085" "30087" "30100" "30115" "30119" 
            "30120" "30140" "30151" "30155" "30156" "30164" "30175" "30177" "30178" "30179" 
            "30181" "30186" "30187" "30195" "30198" "30200" "30206" "30209" "30210" "30212" 
            "30227" "30228" "30238" "30241" "30259" "30274" "30296" "30299" "30311" "30316" 
            "30330" "30336" "30342" "30366" "30387" "30391" "30395" "30452" "30453" "30486" 
            "30487")

# Descargar cada archivo con wget
for estacion in "${estaciones[@]}"; do
    # Construir la URL con el código de la estación
    url="https://smn.conagua.gob.mx/tools/RESOURCES/Normales_Climatologicas/Diarios/ver/dia${estacion}.txt"
    
    # Descargar el archivo con wget
    echo "Descargando: $url"
    wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36" "$url"
done

echo "Descarga completa."
