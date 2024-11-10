# Instalación de R y RStudio

## Requisitos Previos
Para poder usar este script se debe instalar R y Rstudio, asi como diversos paquetes que permite realizar las diversas operaciones de mineria y clusterizacion, para ello seguir las siguientes instrucciones.

## Instalación de R

1. Dirígete a la página oficial de descarga de R: [https://cran.r-project.org/](https://cran.r-project.org/)
2. Selecciona tu sistema operativo:
   - **Windows**: Haz clic en **Download R for Windows** y luego en **base**. Descarga el archivo `.exe` y ejecútalo para iniciar el asistente de instalación.
   - **macOS**: Haz clic en **Download R for (Mac) OS X**. Descarga el archivo `.pkg` y ábrelo para iniciar la instalación.
   - **Linux**: Sigue las instrucciones específicas de tu distribución. Para Ubuntu, puedes ejecutar:
     ```bash
     sudo apt update
     sudo apt install r-base
     ```
3. Sigue los pasos del asistente de instalación para completar la configuración.

## Instalación de RStudio

1. Ve a la página oficial de descarga de RStudio: [https://posit.co/download/rstudio-desktop/](https://posit.co/download/rstudio-desktop/)
2. Descarga el instalador adecuado para tu sistema operativo:
   - **Windows**: Descarga el archivo `.exe` y ejecútalo.
   - **macOS**: Descarga el archivo `.dmg` y ábrelo.
   - **Linux**: Descarga el archivo `.deb` o `.rpm` según tu distribución y usa el siguiente comando para instalar el `.deb` en Ubuntu:
     ```bash
     sudo dpkg -i rstudio-*.deb
     ```
3. Completa la instalación siguiendo las instrucciones del asistente.

## Verificación de la Instalación

1. Abre **RStudio**.
2. En la consola de R, escribe el siguiente comando para verificar que R está instalado correctamente:
	```r
	version
	```

## Instalación y Uso de Paquetes en R

Este proyecto utiliza varios paquetes en R para realizar diversas tareas de análisis de datos. A continuación se detallan los pasos para instalar y cargar estos paquetes.

## Instalación de Paquetes

Para instalar los paquetes, abre R o RStudio y ejecuta el siguiente código en la consola. 
Esto se asegurará de que todos los paquetes requeridos estén instalados en tu sistema.

```r
# Instalación de paquetes
install.packages("arules")
install.packages("readxl")
install.packages("dplyr")
install.packages("tidyr")
install.packages("ggplot2")

# Fim4R se instala desde GitHub
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
devtools::install_github("mhahsler/fim4r")
```

Ya con R instalado, y con los paquetes instalados se deberia poder ejecutar el archivo .R con normalidad

## Data a utilizar

Para poder ejecutar el proyecto debes descargar cargar los siguientes archivos que se encuentran en el repositorio:

```r
data_2019_permanente <- read_excel("Base de Datos Permanentes ENA 2019-2020.xlsx", sheet = "2019 Permanentes", skip = 5)
data_2019_normal <- read_excel("Data 2019.xlsx", sheet = "2019", skip = 5)
data_2018 <- read_excel("Base de Datos Superficie ENA 2018-2019.xlsx", sheet = "2018", skip = 5)
data_2017 <- read_excel("Base de Datos Superficie ENA 2017.xlsx", sheet = "Hoja1", skip = 5)
data_2015 <- read_excel("Base de Datos Superficie ENA 2015.xls", sheet = "BDD SUPERFICIE ENA 2015")
```

Estos archivos son los que contienen la informacion sobre los cultivos y la superficie utilizada para producirlos en el pais de Guatemala

La limpieza y manipulacion se encuentra mas detallada en el archivo ScriptProyecto1.R en forma de comentarios