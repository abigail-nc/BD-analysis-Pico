******************************************************************
*
* grads -lc
* ga> interp_vars_WRF.gs var exp nts
* 
* var:  Nombre de la variable 
* exp:  No. de experimento
* nts:  No. de pasos de tiempo
* 
* Por ejemplo:
* ga> interp_vars_WRF.gs t2 01 25
* 
*****************************************************************

function f(args)

var = subwrd(args,1)
exp = subwrd(args,2)
nts = subwrd(args,3)

rmis0 = -9.99e+08
rmiss = -999.99

'reinit'

* Archivo salida de WRF en formato de GrADS 
'open wrfout_d01-Grace_GFS-exp01.ctl'

* Archivo con lista de estaciones:
* Longitud Latitud Altitud Identificador Nombre de la estación
_stations='estac_coord.txt'

fvt2= '%7.2f'
fvt3= '%10.4f'

* Name of variable 

while (1)
  cad = read(_stations)
  what = sublin(cad,1)
  if (what>0)
    if (what!=2)
       say '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
      return
    endif
    break
  endif
  rec = sublin(cad,2)
  llon = subwrd(rec,1)
  llat = subwrd(rec,2)
  iest = subwrd(rec,4)
*  if(llon<0);llon=llon+360;endif

say ' 'llon' 'llat' 'iest
* output file name

_ofile ='ts_'var'_'iest'-'exp'.txt'

ic=1
while(ic<=nts)
'set t '%ic
  lin=sublin(result,1)
  pal=subwrd(lin,4)
  anio=substr(pal,1,4)
  if(substr(pal,5,1)=':'&substr(pal,7,1)=':'&substr(pal,6,1)<10);mes='0'%substr(pal,6,1);endif
  if(substr(pal,5,1)=':'&substr(pal,6,2)>9);mes=substr(pal,6,2);endif
  if(substr(pal,6,1)='9');mes='0'%substr(pal,6,1);endif
'q time'
tim = subwrd(result,3)
aa = substr(tim,9,4)
mo = substr(tim,6,3)
dd = substr(tim,4,2)
hh = substr(tim,1,2)
if(mo='JAN');mm='01';endif
if(mo='FEB');mm='02';endif
if(mo='MAR');mm='03';endif
if(mo='APR');mm='04';endif
if(mo='MAY');mm='05';endif
if(mo='JUN');mm='06';endif
if(mo='JUL');mm='07';endif
if(mo='AUG');mm='08';endif
if(mo='SEP');mm='09';endif
if(mo='OCT');mm='10';endif
if(mo='NOV');mm='11';endif
if(mo='DEC');mm='12';endif
timm = aa' 'mm' 'dd' 'hh
*say ' 'timm
'set gxout grfill'
'd '%var
'q w2gr 'llon' 'llat
xdim=subwrd(result,3)
xdim=0.0+xdim
*say 'xdim = 'xdim
if ( xdim <=  1.) ; xdim=320.+xdim ; endif
ydim=subwrd(result,6)
*say 'ydim = 'ydim

* nearest x dimensions :
  x1= math_int(xdim)
  x2 = x1 + 1

'set x 'x1
lon1=subwrd(result,4)
'set x 'x2
lon2=subwrd(result,4)

*say 'x1 = 'x1
*say 'x2 = 'x2
*say 'lon1 = 'lon1
*say 'lon2 = 'lon2

* the weights are

  xw1= xdim-x1
  xw2= 1.-xw1

*say 'xw1 = 'xw1
*say 'xw2 = 'xw2

* nearest y dimensions :

  y1= math_int(ydim)
  y2 = y1 + 1

'set y 'y1
lat1=subwrd(result,4)
'set y 'y2
lat2=subwrd(result,4)

*say 'y1 = 'y1
*say 'y2 = 'y2
*say 'lat1 = 'lat1
*say 'lat2 = 'lat2

* the weights are

  yw1= ydim-y1
  yw2= 1.-yw1

*say 'yw1 = 'yw1
*say 'yw2 = 'yw2

*  station =           f(x1,y1)*xw2*yw2+
*                      f(x2,y1)*xw1*yw2+
*                      f(x1,y2)*xw2*yw1+
*                      f(x2,y2)*xw1*yw1

'set x 'x1
'set y 'y1
'd 'var
*jMfx1y1=subwrd(result,4)
*say 'x1: 'x1
*say 'y1: 'y1
*say 'result: 'result
fx10y10=sublin(result,1)
fx1y1=subwrd(fx10y10,4)
*say 'fx1y1 'fx1y1

'set x 'x2
'set y 'y1
'd 'var
*jMfx2y1=subwrd(result,4)
*say 'x2: 'x2
*say 'y1: 'y1
*say 'result: 'result
fx20y10=sublin(result,1)
fx2y1=subwrd(fx20y10,4)
*say 'fx2y1 'fx2y1

'set x 'x1
'set y 'y2
'd 'var
*jMfx1y2=subwrd(result,4)
*say 'x1: 'x1
*say 'y2: 'y2
*say 'result: 'result
fx10y20=sublin(result,1)
fx1y2=subwrd(fx10y20,4)
*say 'fx1y2 'fx1y2

'set x 'x2
'set y 'y2
'd 'var
*jMfx2y2=subwrd(result,4)
*say 'x2: 'x2
*say 'y2: 'y2
*say 'result: 'result
fx20y20=sublin(result,1)
fx2y2=subwrd(fx20y20,4)
*say 'fx2y2 'fx2y2

if(fx1y1=rmis0 | fx2y1=rmis0 | fx1y2=rmis0 | fx2y2=rmis0)
var2 = rmiss
else
var2 = fx1y1*xw2*yw2+fx2y1*xw1*yw2+fx1y2*xw2*yw1+fx2y2*xw1*yw1
endif
if(var2=rmis0);var2=rmiss;endif
var22=math_format(fvt2,var2)
*say' 'var2
'define varint = 'var2

rlat=math_format(fvt2,llat)
rlon=math_format(fvt2,llon)
it=math_format(fvt2,ic)
ctw=timm' 'var22

write(_ofile,ctw,append)
ic = ic + 1
endwhile

close(_ofile)

endwhile
'quit'
return
pull res
