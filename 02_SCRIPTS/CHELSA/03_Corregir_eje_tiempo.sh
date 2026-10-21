# --- bash
# Este script corrige el eje de tiempo de los datos CHELSA
# Última actualización: 05 de octubre de 2026
# DALM


#mkdir -p corregidos
#dia=0

mes_num=1
while [ $mes_num -le 6 ]
do
    mes=$(printf "%02d" $mes_num)

    for d in {01..31}; do
        mes=$(printf "%02d" $mes_num)
        archivo_origen="corregidos/CHELSA_tas_${d}_${mes}_1941_V.2.1-cut.nc"
        archivo_destino="CHELSA_tas_${d}_${mes}_1941_V.2.1-cut.nc"
        
        if [ -f "$archivo_origen" ]; then
       
            dia=$(printf "%02d" $dia_num)
            cdo -setreftime,1941-${mes}-${d},00:00:00,1day \
                -settaxis,1941-${mes}-${d},00:00:00,1day \
                -shifttime,${dia}days "$archivo_origen" "$archivo_destino"
                
            dia=$((dia + 1))
        fi
    done
    mes_num=$(( mes_num + 1 ))
cdo -f nc mergetime CHELSA_tas_??_${mes}_1941_V.2.1-cut.nc CHELSA_tas_${mes}_1941_final.nc && rm CHELSA_tas_??_${mes}_1941_V.2.1-cut.nc

done

echo "¡Proceso terminado con éxito!"



# cdo -setreftime,1941-01-31,00:00:00,1day -settaxis,1941-01-31,00:00:00,1day -shifttime,31days CHELSA_tas_31_01_1941_V.2.1-cut.nc corregidos/CHELSA_tas_31_01_1941_V.2.1-cut.nc
# cdo -setreftime,1941-03-31,00:00:00,1day -settaxis,1941-03-31,00:00:00,1day -shifttime,31days CHELSA_tas_31_03_1941_V.2.1-cut.nc corregidos/CHELSA_tas_31_03_1941_V.2.1-cut.nc
# cdo -setreftime,1941-05-31,00:00:00,1day -settaxis,1941-05-31,00:00:00,1day -shifttime,31days CHELSA_tas_31_05_1941_V.2.1-cut.nc corregidos/CHELSA_tas_31_05_1941_V.2.1-cut.nc