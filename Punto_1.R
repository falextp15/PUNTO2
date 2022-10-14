## Se utilizan librerias que necesitamos para poder usar las funciones como es la libreria caret que me ayuda a poder usar los metodos 
library(tidyverse)
library(dplyr)
library(caret)

## Se agregan las base de datos tanto como la de entrenamiento como la que deseamos predecir 

folder <- dirname(rstudioapi::getSourceEditorContext()$path)
parentFolder <- dirname(folder)

punto1 <- read.csv(paste0(folder
                          
                          ,"/DATASET_TRAIN_2S_DANIEL.csv"))

punto1.1 <- read.csv(paste0(folder
                            
                            ,"/DATASET_PRUEBA_2S_59CM.csv")
                     
                     , stringsAsFactors = TRUE)

## Visualizamos las base de datos viendo que la base de datos 1.1 no tiene la columna de distancia 

punto1
punto1.1
head(punto1)

## Muestra datos del sensor 1 y 2


summary(punto1)

## Realizamos histogramas para ver la diferencia que hay en los datos de nuestros predictores  ademas de ver una grafica que se comparara con nuestra variable que sera la distancia 

hist(punto1$SENSOR1, breaks = 100)
hist(punto1$SENSOR2, breaks = 100)

pairs(punto1[-c(7,8)], pch = 21
      
      , bg = c("red", "green3", "blue")[unclass(punto1$DISTANCIA)])

hist(punto1$SENSOR2, breaks = 50)
hist(punto1$SENSOR1, breaks = 50)

## Vemos el comportamiento que tiene el sensor 1 y el sensor dos con nuestra variable siendo el sensor 2 mejor para predecir nuestra    ## distancia 

library(psych)
pairs.panels(punto1[c("SENSOR1",
                      
                      "SENSOR2",
                      
                      "DISTANCIA")]
             
             ,pch=21, bg=c("red","green3","blue", "orange")[unclass(punto1$DISTACIA)])

predictors <- colnames(punto1)[-3]

sample.index <- sample(1:nrow(punto1)
                       ,nrow(punto1)*0.3
                       ,replace = F)

train.data.2S <- punto1[sample.index,c(predictors,"DISTANCIA"),drop=F]
test.data.2S <- punto1[-sample.index,c(predictors,"DISTANCIA"),drop=F]

## Realizamos nuestro primer modelo en donde tendremos los dos sensores en cuenta sera nuestra regrecion multilineal 

ctrl <-trainControl(method="cv",number=5)
modelo1 <- train(DISTANCIA~.,data = punto1,method="lm",trControl=ctrl)

##  Realizamos nuestro segundo modelo donde sera una regresion lineal donde tendremos en cuenta el sensor 1

modelo2 <- train(DISTANCIA~SENSOR1,data = punto1,method="lm",trControl=ctrl)

## Realizamos nuestro segundo modelo donde sera una regresion lineal donde tendremos en cuenta el sensor 2

modelo3 <- train(DISTANCIA~SENSOR2,data = punto1,method="lm",trControl=ctrl)

##*1.3 validacion de los modelos##

##Se seleccionaron dos modelos uno para cada sensor y se tiene un modelo de regresion multilineal
modelo1
modelo2
modelo3

#Se verifican los rms y los rsquared donde el rms debe ser bajo y el rsquaed debe ser mas cercano a uno como vemos el que mejor cumple esto es el modelo numero 3


# Se realizan  la implrementacion de los modelos a la base de datos que deseamos aplicarle los modelos  usando el modelo 3 para agregarlo a la base de datos 
p1 <- predict(modelo1,newdata=punto1.1)
p1
prediction<-punto1.1$p1 <- c(p1)

p2 <- predict(modelo2,newdata=punto1.1)
p2
prediction<-punto1.1$p2 <- c(p2)

p3 <- predict(modelo3,newdata=punto1.1)
p3
prediction<-punto1.1$p3 <- c(p3)

## El rankind de los 3 modelos sera 

## 1. modelo 3 regresion lineal con el sensor 2

## 2. modelo 2 regresion lineal con el sensor 1

## 3. modelo 1 regresion multilineal 



## se grafica la relacion de los sensores de la base de datos a la cual le emos aplicado el modelo 

ggplot(punto1.1, aes(x=SENSOR2, y=p3)) + 
  geom_point() +
  geom_smooth(method='lm', formula=y~x, se=FALSE, col='dodgerblue1') +
  theme_light()

ggplot(punto1.1, aes(x=SENSOR1+SENSOR2, y=p1)) + 
  geom_point() +
  geom_smooth(method='lm', formula=y~x, se=FALSE, col='dodgerblue1') +
  theme_light()

ggplot(punto1.1, aes(x=SENSOR1, y=p2)) + 
  geom_point() +
  geom_smooth(method='lm', formula=y~x, se=FALSE, col='dodgerblue1') +
  theme_light()
