# ---
# Este script convierte los archivo tif a netCDF
# Última actualización 

wdir=~/PhD_Pico/01_INPUT/03_CHELSA

anio=1941
while [ $anio -le 1941 ]
do
    mes_num=6
    while [ $mes_num -le 12 ]
    do
        mes=$(printf "%02d" $mes_num)
        
        for file in "${wdir}"/*_${mes}_${anio}_*.tif; do
            # Validar que el archivo exista para evitar errores si no hay coincidencias
            [ -e "$file" ] || continue
            
            name=$(basename "$file" .tif)
            echo "Convirtiendo: ${name}.tif ---> ${name}.nc"
            gdal_translate -of NetCDF -co "FORMAT=NC4" "$file" "${wdir}/netCDF/${name}.nc" && rm "$file"
        done
        mes_num=$(( mes_num + 1 ))
    done 
    
    anio=$(( anio + 1 ))
done 

echo "Listoooo!!"
