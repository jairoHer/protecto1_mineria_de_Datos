# Script del proyecto 1 de mineria de datos - Jairo Hernandez
# Datasets obtenidos de: https://www.ine.gob.gt/encuesta-nacional-agropecuaria/

library(arules)
library(readxl)
library(dplyr)
setwd("C:/Users/jairo/Documents/Maestria/Cuarto Trimestre/Introduccion a la mineria de datos/Proyecto 1")
dir()


data_2019 <- read_excel("Base de Datos Permanentes ENA 2019-2020.xlsx", sheet = "2019 Permanentes", skip = 5)
data_2018 <- read_excel("Base de Datos Superficie ENA 2018-2019.xlsx", sheet = "2018", skip = 5)
data_2017 <- read_excel("Base de Datos Superficie ENA 2017.xlsx", sheet = "Hoja1", skip = 5)

#La etapa se refiere a una porcion del año, en los datos de 2018 se divide en 3 segun su pdf

names(data_2019)
names(data_2018)
names(data_2017)

View(data_2019)
View(data_2018)
View(data_2017)

#Los codigos de departamentos y municipios estan segun la codigicacion de la INE

