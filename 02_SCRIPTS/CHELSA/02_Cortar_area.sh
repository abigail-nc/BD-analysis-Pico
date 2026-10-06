# ---
# Este script corta los netCDF de CHELSA al area de estudio del Pico (buffer 50 km)
# Última actualización 

clear
wdir=~/PhD_Pico/01_INPUT/03_CHELSA/netCDF
anio=1941
while [ $anio -le 1941 ]
do
    mes_num=1
    while [ $mes_num -le 6 ]
    do
        mes=$(printf "%02d" $mes_num)

        dia_num=2
        while [ $dia_num -le 31 ]
        do
             dia=$(printf "%02d" $dia_num)
            
        cdo sellonlatbox,-97.76,-96.76,18.53,19.53 ${wdir}/CHELSA_tas_${dia}_${mes}_${anio}_V.2.1.nc ${wdir}/cut/CHELSA_tas_${dia}_${mes}_${anio}_V.2.1-cut.nc
        rm ${wdir}/CHELSA_tas_${dia}_${mes}_${anio}_V.2.1.nc
        dia_num=$(( $dia_num + 1 ))
        done
        mes_num=$(( mes_num + 1 ))
    done 
    
    anio=$(( anio + 1 ))
done 

echo "Listoooo!!"
