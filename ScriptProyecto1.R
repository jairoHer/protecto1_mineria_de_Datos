# Script del proyecto 1 de mineria de datos - Jairo Hernandez
# Datasets obtenidos de: https://www.ine.gob.gt/encuesta-nacional-agropecuaria/

library(arules)
library(readxl)
library(dplyr)
library(tidyr)
setwd("C:/Users/jairo/Documents/Maestria/Cuarto Trimestre/Introduccion a la mineria de datos/Proyecto 1")
dir()


data_2019_permanente <- read_excel("Base de Datos Permanentes ENA 2019-2020.xlsx", sheet = "2019 Permanentes", skip = 5)
data_2019_normal <- read_excel("Data 2019.xlsx", sheet = "2019", skip = 5)
data_2018 <- read_excel("Base de Datos Superficie ENA 2018-2019.xlsx", sheet = "2018", skip = 5)
data_2017 <- read_excel("Base de Datos Superficie ENA 2017.xlsx", sheet = "Hoja1", skip = 5)
data_2015 <- read_excel("Base de Datos Superficie ENA 2015.xls", sheet = "BDD SUPERFICIE ENA 2015")

#La etapa se refiere a una porcion del año, en los datos de 2018 se divide en 3 segun su pdf

names(data_2019_permanente)
#Cambiamos el nombre de las columnas que tienen el mismo nombre para diferenciarlas
data_2019_permanente <- data_2019_permanente %>% rename(Seg_replica = Seg...5, Seg_segmento = Seg...7)

names(data_2019_normal)
data_2019_normal <- data_2019_normal %>% rename(MAIZ_SUPERFICIE = MAIZ...13, FRIJOL_SUPERFICIE = FRIJ...14,ARROZ_SUPERFICIE = ARROZ...15)
data_2019_normal <- data_2019_normal %>% rename(OTRO_SUPERFICIE = OTRO)
data_2019_normal <- data_2019_normal %>% rename(MAIZ_PRODUCCION = MAIZ...17, FRIJOL_PRODUCCION = FRIJ...18,ARROZ_PRODUCCION = ARROZ...19)


names(data_2018)
#Cambiamos el nombre de las columnas que tienen el mismo nombre para diferenciarlas
#y le colocamos distintivo para ver si se refieren a produccion a superficie cultivada
data_2018 <- data_2018 %>% rename(MAIZ_SUPERFICIE = MAIZ...9, FRIJOL_SUPERFICIE = FRIJ...10,ARROZ_SUPERFICIE = ARROZ...11)
data_2018 <- data_2018 %>% rename(OTRO_SUPERFICIE = OTRO)
data_2018 <- data_2018 %>% rename(MAIZ_PRODUCCION = MAIZ...13, FRIJOL_PRODUCCION = FRIJ...14,ARROZ_PRODUCCION = ARROZ...15)

names(data_2017)
data_2017 <- data_2017 %>% rename(MAIZ_SUPERFICIE = MAIZ...9, FRIJOL_SUPERFICIE = FRIJ...10,ARROZ_SUPERFICIE = ARROZ...11)
data_2017 <- data_2017 %>% rename(OTRO_SUPERFICIE = OTRO)
data_2017 <- data_2017 %>% rename(MAIZ_PRODUCCION = MAIZ...13, FRIJOL_PRODUCCION = FRIJ...14,ARROZ_PRODUCCION = ARROZ...15)

names(data_2015)

View(data_2019)
View(data_2018)
View(data_2017)

#Los codigos de departamentos y municipios estan segun la codigicacion de la INE
#Los tres archivos tienen el campo etapas el cual indica el uso del suelo en diferentes
#etapas del año, los cuales pueden ser 1,2 y 3
#Los archivos indican que la etapa 1 corresponden a 75 dias en campo en los meses de julio a octubre
#La etapa 2 corresponde a 50 dias durante los meses del octubre a diciembre
#La etapa 3 corresponde a 50 dias en los meses de febrero a abril



#Se eliminaran los campos relacionados con los expansores, esto debido a que estos campos
#Son estimaciones  que se refieren a factores o multiplicadores estadísticos 
#que se utilizan para extrapolar los datos obtenidos de la muestra a toda la población. Es decir no son datos reales.

#Limpieza de campos de data_2019
#Eliminamos los campos de Zo: este es un campo de clasificacion creado por la INE
#, NoPOligono, NEST, Nzo, nzo, n, Exp, debido a que son campos estaditisticos usados por la INE
#Los cuales no dejan de manera clara su obtencion, y de los cuales no se tiene su dimensional.
data_2019_normal_limpia <- data_2019_normal %>% select(-c(Zo, Pol,NEST,Nzo,nzo,n,Exp))
names(data_2019_normal_limpia)
#Borramos la columna de segmento de replica, y el Exp. Esto debido a que no hay claridad de lo que siginifican
data_2019_permanente_limpia <- data_2019_permanente %>% select(-c(Seg_replica,Exp))
names(data_2019_permanente)

#Data 2018: En la data de 2018 borramos los campos de universo(N), muestra(n) y expansor(Exp).
data_2018_limpia <- data_2018 %>% select(-c(N,n,Exp))
names(data_2018_limpia)

#Data 2017: En la data de 2017 borramos los campos de universo(N), muestra(n) y expansor(Exp).
data_2017_limpia <- data_2017 %>% select(-c(N,n,Exp))
names(data_2017_limpia)


#Data 2015: Quitamos las columnas de la data de 2015 de la cual no tenemos contexto
data_2015_limpia <- data_2015 %>% select(-c(COD_MUESTRA,ESTZONA,ZONA,REPLICA,COD_SEG,Nhj,rhj,FACTOREXP,AREA_TOTAL))
names(data_2015_limpia)

#Revision que la data de los 3 años a analizar tenga las mismas columnas
names(data_2019_normal_limpia)
names(data_2018_limpia)
names(data_2017_limpia)


#vamos a pivotear el dataframe de data_2019_permanente, para que los productos aparezcan como columnas
names(data_2019_permanente_limpia)

# Agrupar y sumar valores de SUP para cada cultivo
data_2019_permanente_limpia_p2 <- data_2019_permanente_limpia %>%
  group_by(across(-SUP)) %>%  # Agrupa por todas las columnas excepto SUP
  summarise(SUP = sum(SUP, na.rm = TRUE)) %>%  # Suma de SUP por grupo
  ungroup()

names(data_2019_permanente_limpia_p2)

#separamos cada cultivo por columna
data_2019_permanente_limpia_p2 <- data_2019_permanente_limpia_p2 %>%
  pivot_wider(names_from = CULT, values_from = SUP)

names(data_2019_permanente_limpia_p2)
