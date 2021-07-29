******************************
**		CURSO DE STATA		**
******************************

******************************
** 		  CLASE 1			**
******************************

**Cambiar el color de la pantalla
**Edición -> Preferencias -> Preferencias Generales -> Color


**Ventanas 
**Se pueden acomodar con el cursor 

******************************

*** 1) Do-files ***

*¿Cuál es la importancia de trabajar "siempre" con archivos do?
*Permite una fácil replicación
*Permite volver atrás y reejecutar comandos, hacer análisis y hacer modificaciones


*** 2) Cambio de Directorio Change Directory (cd)

cd "C:\Users\ASUS\Documents\DOKTORA\Teaching2019\Development Economic 2019\Intro Stata"
cd "C:\Users\DELL GAMER\Desktop\clases_stata"
ls // indica donde estoy

*** 3) Introducción a la sintaxis de Stata ***

* Crear un archivo de registro para almacenar los resultados LOG FILE
 * Recuperar el resultado de su trabajo 
 * Mantener un registro de su trabajo .
 cap log close /* esto asegura que si cualquier otro archivo de registro ya está abierto, se cerrará */

 
 //begin log file
log using Clase1.txt, replace text
*pause / resume logging with "log on" / "log off"
log off 
*Close lot with "log close"
log close // you can use it at the end
 
 
 *** 4) Llamar y abrir los datos
*si el formato de los datos es Stata:
*esto buscaría los datos en la carpeta llamada data ubicada en el directorio de trabajo
*si su directorio de trabajo ya está configurado y previamente def

use Nations.dta 
clear

*datos de internet
use http://www.ats.ucla.edu/stat/data/hsO

* if data format is excel or text
clear
import excel using Nations.xls, sheet("Sheet1") firstrow 
* if data format is delimited text file
clear
import delimited using Nations.csv, delimiter(";") 


*** 5) Change the maximum number of admissible variables **      clear
set more off // Tell Stata to pause or not pause for --more-- messages
cd "C:\Users\DELL GAMER\Desktop\Clases STATA"
use "rand.dta"
set maxvar 20000


*** 6) Trick: if you want to save the data and results in different folders, create them in your working directory and define them in macros **

glo data "Datos21"			
glo results "Resultados21"		

**************************************************************

** 7) Revisión de Comandos 







