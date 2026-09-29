#codido para calcular promedio decadal para cada mes de la malla de 1950 a 2025

#prcip
cdo -f nc ymonmean -selyear,1950/1959 ERA5_0.25x0.25_prcp_Pico.nc ERA5_0.25x0.25_month50_prcp.nc
cdo -f nc ymonmean -selyear,1960/1969 ERA5_0.25x0.25_prcp_Pico.nc ERA5_0.25x0.25_month60_prcp.nc
cdo -f nc ymonmean -selyear,1970/1979 ERA5_0.25x0.25_prcp_Pico.nc ERA5_0.25x0.25_month70_prcp.nc
cdo -f nc ymonmean -selyear,1980/1989 ERA5_0.25x0.25_prcp_Pico.nc ERA5_0.25x0.25_month80_prcp.nc
cdo -f nc ymonmean -selyear,1990/1999 ERA5_0.25x0.25_prcp_Pico.nc ERA5_0.25x0.25_month90_prcp.nc
cdo -f nc ymonmean -selyear,2000/2009 ERA5_0.25x0.25_prcp_Pico.nc ERA5_0.25x0.25_month20_prcp.nc
cdo -f nc ymonmean -selyear,2010/2019 ERA5_0.25x0.25_prcp_Pico.nc ERA5_0.25x0.25_month21_prcp.nc
cdo -f nc ymonmean -selyear,2020/2025 ERA5_0.25x0.25_prcp_Pico.nc ERA5_0.25x0.25_month22_prcp.nc

#t2m
cdo -f nc ymonmean -selyear,1950/1959 ERA5_0.25x0.25_tmp_Pico.nc ERA5_0.25x0.25_month50_temp.nc
cdo -f nc ymonmean -selyear,1960/1969 ERA5_0.25x0.25_tmp_Pico.nc ERA5_0.25x0.25_month60_temp.nc
cdo -f nc ymonmean -selyear,1970/1979 ERA5_0.25x0.25_tmp_Pico.nc ERA5_0.25x0.25_month70_temp.nc
cdo -f nc ymonmean -selyear,1980/1989 ERA5_0.25x0.25_tmp_Pico.nc ERA5_0.25x0.25_month80_temp.nc
cdo -f nc ymonmean -selyear,1990/1999 ERA5_0.25x0.25_tmp_Pico.nc ERA5_0.25x0.25_month90_temp.nc
cdo -f nc ymonmean -selyear,2000/2009 ERA5_0.25x0.25_tmp_Pico.nc ERA5_0.25x0.25_month20_temp.nc
cdo -f nc ymonmean -selyear,2010/2019 ERA5_0.25x0.25_tmp_Pico.nc ERA5_0.25x0.25_month21_temp.nc
cdo -f nc ymonmean -selyear,2020/2025 ERA5_0.25x0.25_tmp_Pico.nc ERA5_0.25x0.25_month22_temp.nc
