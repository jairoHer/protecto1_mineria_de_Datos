# Script del proyecto 1 de mineria de datos - Jairo Hernandez
# Datasets obtenidos de: https://www.ine.gob.gt/encuesta-nacional-agropecuaria/

library(arules)
library(readxl)
library(dplyr)
library(tidyr)
library(fim4r)
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
names(data_2015_limpia)

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


#Se analizara primero la data individualmente, para asi ver su comportamiento año con año
#Luego se agregara una nueva columna llamada año a la data de 2017, 2018 y 2019, que son las 
#que tienen las mismas columnas y se fusionaran, esto para ver el comportamiento y descubrir patrones
#Con estos 3 conjuntos de datos unidos


#--------------------------------Analisis individual-------------------------------
#-------------------------------------2015 ---------------------------------------
names(data_2015_limpia)
View(data_2015_limpia)

#Revisamos los valores maximos y minimos para despues determinar el rango de cada columna
data_2015_limpia %>% summarise_if(is.numeric, max, na.rm = TRUE)
data_2015_limpia %>% summarise_if(is.numeric, min, na.rm = TRUE)

#Descubirmos un pico exorbitante en la data, asi que eliminaremos esta fila para no afectar
#El resto del analisis
data_2015_limpia <- data_2015_limpia[data_2015_limpia$AGRICOLA <= 100,]

#Revision de campo por campo para ver mas informacion y asi poder categorizarlo

#Analisis de columnas de uso de tierras agricolas

data_2015_limpia %>%
  summarise(
    AGRICOLA_max = max(AGRICOLA, na.rm = TRUE),
    AGRICOLA_min = min(AGRICOLA, na.rm = TRUE),
    AGRICOLA_media = mean(AGRICOLA, na.rm = TRUE),
    AGRICOLA_mediana = median(AGRICOLA, na.rm = TRUE),
    AGRICOLA_q1 = quantile(AGRICOLA, 0.25, na.rm = TRUE),
    AGRICOLA_q3 = quantile(AGRICOLA, 0.75, na.rm = TRUE),
    
    FRIJOL_max = max(FRIJOL, na.rm = TRUE),
    FRIJOL_min = min(FRIJOL, na.rm = TRUE),
    FRIJOL_media = mean(FRIJOL, na.rm = TRUE),
    FRIJOL_mediana = median(FRIJOL, na.rm = TRUE),
    FRIJOL_q1 = quantile(FRIJOL, 0.25, na.rm = TRUE),
    FRIJOL_q3 = quantile(FRIJOL, 0.75, na.rm = TRUE),
    
    MAIZ_max = max(MAIZ, na.rm = TRUE),
    MAIZ_min = min(MAIZ, na.rm = TRUE),
    MAIZ_media = mean(MAIZ, na.rm = TRUE),
    MAIZ_mediana = median(MAIZ, na.rm = TRUE),
    MAIZ_q1 = quantile(MAIZ, 0.25, na.rm = TRUE),
    MAIZ_q3 = quantile(MAIZ, 0.75, na.rm = TRUE),
    
    PAPA_max = max(PAPA, na.rm = TRUE),
    PAPA_min = min(PAPA, na.rm = TRUE),
    PAPA_media = mean(PAPA, na.rm = TRUE),
    PAPA_mediana = median(PAPA, na.rm = TRUE),
    PAPA_q1 = quantile(PAPA, 0.25, na.rm = TRUE),
    PAPA_q3 = quantile(PAPA, 0.75, na.rm = TRUE),
    
    HORTALIZAS_max = max(HORTALIZAS, na.rm = TRUE),
    HORTALIZAS_min = min(HORTALIZAS, na.rm = TRUE),
    HORTALIZAS_media = mean(HORTALIZAS, na.rm = TRUE),
    HORTALIZAS_mediana = median(HORTALIZAS, na.rm = TRUE),
    HORTALIZAS_q1 = quantile(HORTALIZAS, 0.25, na.rm = TRUE),
    HORTALIZAS_q3 = quantile(HORTALIZAS, 0.75, na.rm = TRUE),
    
    OTROS_max = max(OTROS_CULTIVOS_ANUALES, na.rm = TRUE),
    OTROS_min = min(OTROS_CULTIVOS_ANUALES, na.rm = TRUE),
    OTROS_media = mean(OTROS_CULTIVOS_ANUALES, na.rm = TRUE),
    OTROS_mediana = median(OTROS_CULTIVOS_ANUALES, na.rm = TRUE),
    OTROS_q1 = quantile(OTROS_CULTIVOS_ANUALES, 0.25, na.rm = TRUE),
    OTROS_q3 = quantile(OTROS_CULTIVOS_ANUALES, 0.75, na.rm = TRUE)
    
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = c("Tierra_cultivo", "Estadistica"),
    names_sep = "_",
    values_to = "Valor"
  ) %>%
  pivot_wider(
    names_from = Estadistica,
    values_from = Valor,
    values_fn = list(Valor = mean)  # Para resolver duplicados, usa la media (o cualquier función de resumen)
  )

##Analisis de columnas de uso de tierras de cultivos permanentes

data_2015_limpia %>%
  summarise(
    CULTIVOS_max = max(CULTIVOS_PERMANENTES, na.rm = TRUE),
    CULTIVOS_min = min(CULTIVOS_PERMANENTES, na.rm = TRUE),
    CULTIVOS_media = mean(CULTIVOS_PERMANENTES, na.rm = TRUE),
    CULTIVOS_mediana = median(CULTIVOS_PERMANENTES, na.rm = TRUE),
    CULTIVOS_q1 = quantile(CULTIVOS_PERMANENTES, 0.25, na.rm = TRUE),
    CULTIVOS_q3 = quantile(CULTIVOS_PERMANENTES, 0.75, na.rm = TRUE),
    
    CAFÉ_max = max(CAFÉ, na.rm = TRUE),
    CAFÉ_min = min(CAFÉ, na.rm = TRUE),
    CAFÉ_media = mean(CAFÉ, na.rm = TRUE),
    CAFÉ_mediana = median(CAFÉ, na.rm = TRUE),
    CAFÉ_q1 = quantile(CAFÉ, 0.25, na.rm = TRUE),
    CAFÉ_q3 = quantile(CAFÉ, 0.75, na.rm = TRUE),
    
    CAÑA_max = max(CAÑA, na.rm = TRUE),
    CAÑA_min = min(CAÑA, na.rm = TRUE),
    CAÑA_media = mean(CAÑA, na.rm = TRUE),
    CAÑA_mediana = median(CAÑA, na.rm = TRUE),
    CAÑA_q1 = quantile(CAÑA, 0.25, na.rm = TRUE),
    CAÑA_q3 = quantile(CAÑA, 0.75, na.rm = TRUE),
    
    CARDA_max = max(CARDAMOMO, na.rm = TRUE),
    CARDA_min = min(CARDAMOMO, na.rm = TRUE),
    CARDA_media = mean(CARDAMOMO, na.rm = TRUE),
    CARDA_mediana = median(CARDAMOMO, na.rm = TRUE),
    CARDA_q1 = quantile(CARDAMOMO, 0.25, na.rm = TRUE),
    CARDA_q3 = quantile(CARDAMOMO, 0.75, na.rm = TRUE),
    
    HULE_max = max(HULE, na.rm = TRUE),
    HULE_min = min(HULE, na.rm = TRUE),
    HULE_media = mean(HULE, na.rm = TRUE),
    HULE_mediana = median(HULE, na.rm = TRUE),
    HULE_q1 = quantile(HULE, 0.25, na.rm = TRUE),
    HULE_q3 = quantile(HULE, 0.75, na.rm = TRUE),
    
    PALMA_max = max(PALMA_AFRICANA, na.rm = TRUE),
    PALMA_min = min(PALMA_AFRICANA, na.rm = TRUE),
    PALMA_media = mean(PALMA_AFRICANA, na.rm = TRUE),
    PALMA_mediana = median(PALMA_AFRICANA, na.rm = TRUE),
    PALMA_q1 = quantile(PALMA_AFRICANA, 0.25, na.rm = TRUE),
    PALMA_q3 = quantile(PALMA_AFRICANA, 0.75, na.rm = TRUE),
    
    OTROS_max = max(OTROS_CULTIVOS_PERMANENTES, na.rm = TRUE),
    OTROS_min = min(OTROS_CULTIVOS_PERMANENTES, na.rm = TRUE),
    OTROS_media = mean(OTROS_CULTIVOS_PERMANENTES, na.rm = TRUE),
    OTROS_mediana = median(OTROS_CULTIVOS_PERMANENTES, na.rm = TRUE),
    OTROS_q1 = quantile(OTROS_CULTIVOS_PERMANENTES, 0.25, na.rm = TRUE),
    OTROS_q3 = quantile(OTROS_CULTIVOS_PERMANENTES, 0.75, na.rm = TRUE)
    
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = c("Tierra_cultivo", "Estadistica"),
    names_sep = "_",
    values_to = "Valor"
  ) %>%
  pivot_wider(
    names_from = Estadistica,
    values_from = Valor,
    values_fn = list(Valor = mean)
  )

##Analisis de columnas de uso de tierras de agricolas sin cultivos

data_2015_limpia %>%
  summarise(
    TIERRAAGS_max = max(TIERRA_AGRICOLA_SIN_CULTIVO, na.rm = TRUE),
    TIERRAAGS_min = min(TIERRA_AGRICOLA_SIN_CULTIVO, na.rm = TRUE),
    TIERRAAGS_media = mean(TIERRA_AGRICOLA_SIN_CULTIVO, na.rm = TRUE),
    TIERRAAGS_mediana = median(TIERRA_AGRICOLA_SIN_CULTIVO, na.rm = TRUE),
    TIERRAAGS_q1 = quantile(TIERRA_AGRICOLA_SIN_CULTIVO, 0.25, na.rm = TRUE),
    TIERRAAGS_q3 = quantile(TIERRA_AGRICOLA_SIN_CULTIVO, 0.75, na.rm = TRUE),
    
    TIERRAPR_max = max(TIERRA_EN_PREPARACION, na.rm = TRUE),
    TIERRAPR_min = min(TIERRA_EN_PREPARACION, na.rm = TRUE),
    TIERRAPR_media = mean(TIERRA_EN_PREPARACION, na.rm = TRUE),
    TIERRAPR_mediana = median(TIERRA_EN_PREPARACION, na.rm = TRUE),
    TIERRAPR_q1 = quantile(TIERRA_EN_PREPARACION, 0.25, na.rm = TRUE),
    TIERRAPR_q3 = quantile(TIERRA_EN_PREPARACION, 0.75, na.rm = TRUE),
    
    RASTROJO_max = max(RASTROJO, na.rm = TRUE),
    RASTROJO_min = min(RASTROJO, na.rm = TRUE),
    RASTROJO_media = mean(RASTROJO, na.rm = TRUE),
    RASTROJO_mediana = median(RASTROJO, na.rm = TRUE),
    RASTROJO_q1 = quantile(RASTROJO, 0.25, na.rm = TRUE),
    RASTROJO_q3 = quantile(RASTROJO, 0.75, na.rm = TRUE),
    
    TIERRADESC_max = max(TIERRA_EN_DESCANSO, na.rm = TRUE),
    TIERRADESC_min = min(TIERRA_EN_DESCANSO, na.rm = TRUE),
    TIERRADESC_media = mean(TIERRA_EN_DESCANSO, na.rm = TRUE),
    TIERRADESC_mediana = median(TIERRA_EN_DESCANSO, na.rm = TRUE),
    TIERRADESC_q1 = quantile(TIERRA_EN_DESCANSO, 0.25, na.rm = TRUE),
    TIERRADESC_q3 = quantile(TIERRA_EN_DESCANSO, 0.75, na.rm = TRUE)
    
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = c("Tierra_cultivo", "Estadistica"),
    names_sep = "_",
    values_to = "Valor"
  ) %>%
  pivot_wider(
    names_from = Estadistica,
    values_from = Valor,
    values_fn = list(Valor = mean)
  )

##Analisis de columnas de uso de tierras de pasto
data_2015_limpia %>%
  summarise(
    PASTO_max = max(PASTO, na.rm = TRUE),
    PASTO_min = min(PASTO, na.rm = TRUE),
    PASTO_media = mean(PASTO, na.rm = TRUE),
    PASTO_mediana = median(PASTO, na.rm = TRUE),
    PASTO_q1 = quantile(PASTO, 0.25, na.rm = TRUE),
    PASTO_q3 = quantile(PASTO, 0.75, na.rm = TRUE),
    
    PASTOCULT_max = max(PASTO_CULTIVADO, na.rm = TRUE),
    PASTOCULT_min = min(PASTO_CULTIVADO, na.rm = TRUE),
    PASTOCULT_media = mean(PASTO_CULTIVADO, na.rm = TRUE),
    PASTOCULT_mediana = median(PASTO_CULTIVADO, na.rm = TRUE),
    PASTOCULT_q1 = quantile(PASTO_CULTIVADO, 0.25, na.rm = TRUE),
    PASTOCULT_q3 = quantile(PASTO_CULTIVADO, 0.75, na.rm = TRUE),
    
    PASTONATUR_max = max(PASTO_NATURAL, na.rm = TRUE),
    PASTONATUR_min = min(PASTO_NATURAL, na.rm = TRUE),
    PASTONATUR_media = mean(PASTO_NATURAL, na.rm = TRUE),
    PASTONATUR_mediana = median(PASTO_NATURAL, na.rm = TRUE),
    PASTONATUR_q1 = quantile(PASTO_NATURAL, 0.25, na.rm = TRUE),
    PASTONATUR_q3 = quantile(PASTO_NATURAL, 0.75, na.rm = TRUE),
    
    BOSQUEPASTO_max = max(BOSQUE_CON_PASTO, na.rm = TRUE),
    BOSQUEPASTO_min = min(BOSQUE_CON_PASTO, na.rm = TRUE),
    BOSQUEPASTO_media = mean(BOSQUE_CON_PASTO, na.rm = TRUE),
    BOSQUEPASTO_mediana = median(BOSQUE_CON_PASTO, na.rm = TRUE),
    BOSQUEPASTO_q1 = quantile(BOSQUE_CON_PASTO, 0.25, na.rm = TRUE),
    BOSQUEPASTO_q3 = quantile(BOSQUE_CON_PASTO, 0.75, na.rm = TRUE)
    
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = c("Tierra_cultivo", "Estadistica"),
    names_sep = "_",
    values_to = "Valor"
  ) %>%
  pivot_wider(
    names_from = Estadistica,
    values_from = Valor,
    values_fn = list(Valor = mean)
  )

##Analisis de columnas de uso de tierras NO AGRICOLAS

data_2015_limpia %>%
  summarise(
    PASTO_max = max(TIERRA_NO_AGRICOLA, na.rm = TRUE),
    PASTO_min = min(TIERRA_NO_AGRICOLA, na.rm = TRUE),
    PASTO_media = mean(TIERRA_NO_AGRICOLA, na.rm = TRUE),
    PASTO_mediana = median(TIERRA_NO_AGRICOLA, na.rm = TRUE),
    PASTO_q1 = quantile(TIERRA_NO_AGRICOLA, 0.25, na.rm = TRUE),
    PASTO_q3 = quantile(TIERRA_NO_AGRICOLA, 0.75, na.rm = TRUE),
    
    PASTOCULT_max = max(MATORRAL, na.rm = TRUE),
    PASTOCULT_min = min(MATORRAL, na.rm = TRUE),
    PASTOCULT_media = mean(MATORRAL, na.rm = TRUE),
    PASTOCULT_mediana = median(MATORRAL, na.rm = TRUE),
    PASTOCULT_q1 = quantile(MATORRAL, 0.25, na.rm = TRUE),
    PASTOCULT_q3 = quantile(MATORRAL, 0.75, na.rm = TRUE),
    
    PASTONATUR_max = max(TIERRA_FORESTAL, na.rm = TRUE),
    PASTONATUR_min = min(TIERRA_FORESTAL, na.rm = TRUE),
    PASTONATUR_media = mean(TIERRA_FORESTAL, na.rm = TRUE),
    PASTONATUR_mediana = median(PASTO_NATURAL, na.rm = TRUE),
    PASTONATUR_q1 = quantile(TIERRA_FORESTAL, 0.25, na.rm = TRUE),
    PASTONATUR_q3 = quantile(TIERRA_FORESTAL, 0.75, na.rm = TRUE),
    
    BOSQUEPASTO_max = max(OTROS_USOS, na.rm = TRUE),
    BOSQUEPASTO_min = min(OTROS_USOS, na.rm = TRUE),
    BOSQUEPASTO_media = mean(OTROS_USOS, na.rm = TRUE),
    BOSQUEPASTO_mediana = median(OTROS_USOS, na.rm = TRUE),
    BOSQUEPASTO_q1 = quantile(OTROS_USOS, 0.25, na.rm = TRUE),
    BOSQUEPASTO_q3 = quantile(OTROS_USOS, 0.75, na.rm = TRUE)
    
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = c("Tierra_cultivo", "Estadistica"),
    names_sep = "_",
    values_to = "Valor"
  ) %>%
  pivot_wider(
    names_from = Estadistica,
    values_from = Valor,
    values_fn = list(Valor = mean)
  )

##---Despues de revisar cada columna, esta se categorizara en 10 tipos
# Tipo 1: 0 - 10 ha
# Tipo 2: 10 - 20 ha
# Tipo 3: 20 - 30 ha
# Tipo 4: 30 - 40 ha
# Tipo 5: 40 - 50 ha
# Tipo 6: 50 - 60 ha
# Tipo 7: 60 - 70 ha
# Tipo 8: 70 - 80 ha
# Tipo 9: 80 - 90 ha
# Tipo 10: 90 - 100 ha


#Colocamos las columnas las cuales categorizaremos
names(data_2015_limpia)
data_2015_limpia_apriori_fp <- data_2015_limpia

columnas_a_categorizar <- c("AGRICOLA", "CULTIVOS_ANUALES","ARROZ","FRIJOL","MAIZ","PAPA"
                            ,"HORTALIZAS","OTROS_CULTIVOS_ANUALES","CULTIVOS_PERMANENTES","CAFÉ"
                            ,"CAÑA","CARDAMOMO","HULE","PALMA_AFRICANA","OTROS_CULTIVOS_PERMANENTES","TIERRA_AGRICOLA_SIN_CULTIVO"
                            ,"TIERRA_EN_PREPARACION","RASTROJO","TIERRA_EN_DESCANSO","PASTO","PASTO_CULTIVADO","PASTO_NATURAL"
                            ,"BOSQUE_CON_PASTO","TIERRA_NO_AGRICOLA","MATORRAL","TIERRA_FORESTAL","OTROS_USOS")

data_2015_limpia_apriori_fp <- data_2015_limpia_apriori_fp %>% mutate_at(vars(all_of(columnas_a_categorizar)), round)

#Esto queda descartado
#data_2015_limpia_apriori_fp[columnas_a_categorizar] <- lapply(data_2015_limpia_apriori_fp[columnas_a_categorizar], function(x) {
#  cut(x, breaks = c(0, 11, 21, 31, 41, 51, 61, 71, 81, 91, 101), labels = 1:10, right = FALSE)
#})

#Cambiamos los valores de la columna estrato de A,B,C,D a 1,2,3,4 respectivamente

data_2015_limpia_apriori_fp$ESTRATO[data_2015_limpia_apriori_fp$ESTRATO == "A"] <- 1
data_2015_limpia_apriori_fp$ESTRATO[data_2015_limpia_apriori_fp$ESTRATO == "B"] <- 2
data_2015_limpia_apriori_fp$ESTRATO[data_2015_limpia_apriori_fp$ESTRATO == "C"] <- 3
data_2015_limpia_apriori_fp$ESTRATO[data_2015_limpia_apriori_fp$ESTRATO == "D"] <- 4

#Enfocare mi analisis al terreno utilizado a nivel departamental, no al municipio
#Esto debido a que en la data muchos municipio repiten numero, aunque pertenezcan a otro departamento
#Lo que puede ocasionar conflictos
#En caso se desee hacer un analisis a nivel de un departamento, se puede dejar esa columna para obtener informacion especifica

data_2015_limpia_apriori_fp <- data_2015_limpia_apriori_fp %>% select(-MUPIO)
names(data_2015_limpia_apriori_fp)

#Me enfocare en el terreno agricola, quito todo lo forestal, y el desglose del pasto, Tambien quito las columas resumen
#de AGRICOLA,CULTIVOS_ANUALES, CULTIVOS_PERMANENTES, TIERRA_AGRICOLA_SIN_CULTIVO

data_2015_limpia_apriori_fp <- data_2015_limpia_apriori_fp %>% select(-AGRICOLA,-CULTIVOS_PERMANENTES
                                                                      ,-CULTIVOS_ANUALES,-TIERRA_AGRICOLA_SIN_CULTIVO)

data_2015_limpia_apriori_fp <- data_2015_limpia_apriori_fp %>% select(-PASTO_CULTIVADO, -PASTO_NATURAL
                                                                      , -BOSQUE_CON_PASTO, -TIERRA_NO_AGRICOLA
                                                                      , -MATORRAL, -TIERRA_FORESTAL, -OTROS_USOS)

names(data_2015_limpia_apriori_fp)


#Ahora ya con la data mas limpia aplicamos APRIORI

# Aumentar el tiempo máximo de ejecución a 60 segundos
reglas_2015_apriori <- apriori(data_2015_limpia_apriori_fp, parameter = list(support = 0.2, confidence = 0.5, maxtime = 60))

#Inspeccionamos las asociaciones resultantes
inspect(reglas_2015_apriori[0:100]) 
inspect(reglas_2015_apriori[100:200]) 
inspect(reglas_2015_apriori[200:300]) 
inspect(reglas_2015_apriori[300:400]) 
inspect(reglas_2015_apriori[400:500]) 
inspect(reglas_2015_apriori[500:600]) 
inspect(reglas_2015_apriori[600:700]) 
inspect(reglas_2015_apriori[700:800]) 
inspect(reglas_2015_apriori[800:900])
inspect(reglas_2015_apriori[900:1000])
inspect(reglas_2015_apriori[1700:1800])

#Aplicacion de fpgrowth a la data de 2015

names(data_2015_limpia_apriori_fp)

#Aplicar fp growth toma 10 minutos
reglas_2015_fp_growth <- fim4r(data_2015_limpia_apriori_fp,method = "fpgrowth",target = "rules", support = 0.2, confidence = 0.5)

#Busco asociaciones en donde aparezca el departamento
reglas_lhs <- subset(reglas_2015_fp_growth, rhs %pin% "DEPTO")

reglas_filtradas <- subset(reglas_2015_fp_growth, subset = support >= 0.2 & confidence >= 0.6 & confidence <= 0.8)

#Reviso otras reglas en donde no se considere PASTO
reglas_filtradas <- subset(reglas_filtradas, !(rhs %pin% "PASTO"))

#Visualizamos las reglas de fp
reglasframe <- as(reglas_filtradas,"data.frame")

inspect(reglas_filtradas[0:100]) 
inspect(reglas_filtradas[100:200])
inspect(reglas_filtradas[200:300]) 
inspect(reglas_filtradas[400:500]) 
inspect(reglas_filtradas[500:600]) 
inspect(reglas_filtradas[600:700]) 
inspect(reglas_filtradas[1200:1300])



#------------------------------Parte de analisis de la data de 2017,2018 y 2019.---------------------------
names(data_2017_limpia)
names(data_2018_limpia)
names(data_2019_normal_limpia)
names(data_2019_permanente_limpia_p2)

#Unificamos la informacion de los años 2017,2018 y 2019

df_data_17_18_19 <- rbind(data_2017_limpia, data_2018_limpia, data_2019_normal_limpia)
names(df_data_17_18_19)

#Eliminamos los decimales de los valores numericos para que los algoritmos apriori y fp growth funcionen correctamente
columnas_a_limpiar <- c("MAIZ_SUPERFICIE", "FRIJOL_SUPERFICIE","ARROZ_SUPERFICIE","OTRO_SUPERFICIE"
                        ,"MAIZ_PRODUCCION","FRIJOL_PRODUCCION","ARROZ_PRODUCCION")

df_data_17_18_19 <- df_data_17_18_19 %>% mutate_at(vars(all_of(columnas_a_limpiar)), round)

#Remplazamos los valores del campo ESTRATO a numerico

df_data_17_18_19$Est[df_data_17_18_19$Est == "A"] <- 1
df_data_17_18_19$Est[df_data_17_18_19$Est == "B"] <- 2
df_data_17_18_19$Est[df_data_17_18_19$Est == "C"] <- 3
df_data_17_18_19$Est[df_data_17_18_19$Est == "D"] <- 4
df_data_17_18_19$Est[df_data_17_18_19$Est == "M"] <- 5
df_data_17_18_19$Est[df_data_17_18_19$Est == "ML"] <- 5

#Quito el campo Seg, ya que este es un ID unico por segmento de tierra a analizar
#Tambien se quita el municipio, ya que se hara el analisis a nivel departamental
df_data_17_18_19 <- df_data_17_18_19 %>% select(-Seg)
df_data_17_18_19 <- df_data_17_18_19 %>% select(-Mun)
names(df_data_17_18_19)

#Ya con la data limpia podemos ejecutar APIORI
reglas_data_17_18_19 <- apriori(df_data_17_18_19, parameter = list(support = 0.2, confidence = 0.5))


#Inspeccionamos las asociaciones resultantes
inspect(reglas_data_17_18_19[0:100]) 
inspect(reglas_data_17_18_19[100:200]) 
inspect(reglas_data_17_18_19[200:300]) 

#Ejecucion de algorito fp growth

reglas_data_17_18_19_fp <-fim4r(df_data_17_18_19,method = "fpgrowth",target = "rules", support = 0.2, confidence = 0.5)

reglasframe <- as(reglas_data_17_18_19_fp,"data.frame")


