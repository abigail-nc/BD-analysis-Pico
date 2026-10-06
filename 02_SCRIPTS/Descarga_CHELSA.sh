# bash ---
# Este script descarga datos de CHELSA desde wget
# Última modificación: 05 de octubre de 2026
# DALM

clear
#mkdir ~/PhD_Pico/01_INPUT/03_CHELSA
wdir=~/PhD_Pico/01_INPUT/03_CHELSA
cd $wdir

anio=1941
while [ $anio -le 2025 ]
do
    mes_num=5
    while [ $mes_num -le 12 ]
    do
        mes=$(printf "%02d" $mes_num)
       
        dia_num=1
        while [ $dia_num -le 31 ]
        do
             dia=$(printf "%02d" $dia_num)
            wget https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/${anio}/CHELSA_tas_${dia}_${mes}_${anio}_V.2.1.tif 
	        #wget https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1941/CHELSA_tas_01_01_1941_V.2.1.tif 
            dia_num=$(( $dia_num + 1 ))
        done
        mes_num=$(( $mes_num + 1 ))
    done
    anio=$(( $anio + 1 ))
done

# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_01_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_02_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_03_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_04_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_05_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_06_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_07_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_08_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_09_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_10_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_11_1993_V.2.1.tif 
# https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1993/CHELSA_tas_01_12_1993_V.2.1.tif 

#wget https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1941/CHELSA_tas_30_04_1941_V.2.1.tif 
#wget https://os.unil.cloud.switch.ch/chelsa02/chelsa/global/daily/tas/1941/CHELSA_tas_31_04_1941_V.2.1.tif 