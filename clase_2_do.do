******************************
**		CURSO DE STATA		**
*******************************

******************************
**			Clase 2 		**
******************************

//change directory
clear
cd "C:\Users\DELL GAMER\Desktop\clases_stata"

//begin log file
log using Clase2.txt, replace text


//Call up data
*clear matrix
set maxvar 20000
cd "C:\Users\DELL GAMER\Desktop\clases_stata"
use randhrs1992_2014v2

**REVISIÓN DE COMANDOS 
des
tab 
sum 
tab , sum
list var1
edit
reg 



******************************************************************************************
//BASIC GRAPHIC

*BAR
graph bar var1,  blabel(bar)
graph bar var1 , over(var2) blabel(bar)
graph bar var1 , over(var2 label(labsize(small)))
graph bar var1 , over(var2, label(angle(forty_five) labsize(small)))

graph bar s1educ , over( s1gender , label(angle(forty_five) labsize(small))) blabel(bar, format(%9.1f)) ytitle(Porcentajes) title(Educación y
>  Genero, color(black) span) subtitle((En porcentaje), span) caption(FUENTE: Propia)

*PIE 
graph pie var1 , over(var2)
graph pie s1dyear , over( s1gender )

*HISTOGRAMAS
hist s1gender , normal title(Gender) name(g1)
hist s1relig,  normal title(Religión) name(r1)

*DIAGRAMAS DE CAJA

graph hbox s1relig, title(Religión H) name(box1)


*GRÁFICA DE CUANTIL
qnorm s1relig


*GRÁFICA COMBINADA
graph combine g1 r1 box1, cols(2) title(Graficos Conbinados) subtitle(En porcentajes) caption(Fuente: Propia) name(c1)


*Efectos Marginales
*marginsplot



*WORKING WITH DATA
clear
cd "C:\Users\DELL GAMER\Desktop\clases_stata"
use Nations.dta 


*GRAFICO DE DOS VARIABLES
scatter var1 var2
scatter gdp pop 
scatter gdp pop if pop<= 5000000

save scatter.gph, replace

twoway (scatter gdp pop) (lfit gdp pop) 

**Generando variables
gen incomeper=gdp/pop

*RENOMBRAR VARIABLES
ren incomeper ingreso
sum 
*ren (eda ent anios_esc) (edad estado esc)
*sum 

*GUARDANDO LA BASE DE DATOS
save Nations2.dta

*ETIQUETAS DE LAS VARIABLES 
label define regionlab 1 "Africa" 2 "Americas" 3 "Asia" 4 "Europe" 5 "Oceania"
label values region regionlab
tab region

*INSTALACIÓN DE PAQUETES
ssc install tabout

*Summary statistics
eststo clear
estpost summarize adfert chldmort life pop urban femlab literacy co2 gini gdp incomeper   
esttab using summary.doc, cells("mean sd min max") label title({Summary Statistics}) nonumber replace

***If you want it on LaTeX
esttab using summary.tex 

*****************************************

**********************
log close
**********************



//you can always use google to understand syntax of Stata. Just ask Google!
//The best sources are the stata tutorials of Princeton, UCLA, and Stata itself. 


