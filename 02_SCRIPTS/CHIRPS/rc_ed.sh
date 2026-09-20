#este archivo recorta chirps usando cdo
clear
wdir=/home/citlali/data-CHIRPS-1981-2020/
cd $wdir
di=1981
m=0
while [ $m -le 40 ]
do
	cdo sellonlatbox,0,25,1,25, chirps-v2.0.$((${di}+${m})).days_p05.nc chirps-v2.0.$((${di}+${m})).days_p05-cut.nc
	m=$(( $m + 1 ))
done
