# Instalación de R y RStudio

## Requisitos Previos
Antes de comenzar, asegúrate de tener permisos de administrador en tu sistema y una conexión a Internet activa.

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
