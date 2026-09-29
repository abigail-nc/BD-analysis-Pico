#este archivo recorta chirps usando cdo
#agradecemos a Citlalli Falfán por habernos compartido los datos descargados de CHIRPS y los scripts para recortar al área de estudio. // By: DALM

clear
wdir=~/PhD_Pico/01_INPUT/02_CHIRPS
cd $wdir
di=1982
m=0
while [ $m -le 39 ]
do
	cdo sellonlatbox,-97.76,-96.76,18.53,19.53 chirps-v2.0.$((${di}+${m})).days_p05.nc ~/PhD_Pico/01_INPUT/02_CHIRPS/chirps-v2.0.$((${di}+${m})).days_p05-cut.nc
	m=$(( $m + 1 ))
done

#sellonlatbox,lon1,lon2,lat1,lat2 infile outfile
