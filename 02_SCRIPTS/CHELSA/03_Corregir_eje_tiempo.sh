# bash---
# Este script corrige el eje de tiempo de los datos CHELSA
# Última actualización: 05 de octubre de 2026
# DALM


mkdir -p corregidos
dia=0
mes=2
# 3. Bucle numérico estricto del día 01 al 30 de junio de 1941
for d in {01..30}; do
    archivo_origen="CHELSA_tas_${d}_${mes}_1941_V.2.1-cut.nc"
    archivo_destino="corregidos/CHELSA_tas_${d}_${mes}_1941_V.2.1-cut.nc"
    
    if [ -f "$archivo_origen" ]; then
        # 1. Establecemos la fecha base del archivo y sus unidades compatibles con GrADS
        # 2. Desplazamos el tiempo según el acumulado de días
        cdo -setreftime,1941-${mes}-01,00:00:00,1day \
            -settaxis,1941-${mes}-01,00:00:00,1day \
            -shifttime,${dia}days "$archivo_origen" "$archivo_destino"
            
        dia=$((dia + 1))
    fi
done
# 4. Ahora los archivos temporales se llaman tmp_20.nc, tmp_21.nc... 
# Al listarlos numéricamente el orden es perfecto. Los unimos:
cdo mergetime corregidos/tmp_*.nc CHELSA_tas_${mes}_1941_final.nc

# 5. Limpiamos la carpeta temporal
rm -rf corregidos

echo "¡Proceso terminado con éxito!"
