library(tidyverse)
library(dplyr)
library(caret)


## get parent script folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
parentFolder <- dirname(folder)

punto1 <- read.csv(paste0(folder
                             
                             ,"/base-de-datos-1punto-_1_ (1).csv"))
                   
punto1.1 <- read.csv(paste0(folder
                            
                            ,"/base-de-datos-muestreo.csv")
                      
                      , stringsAsFactors = TRUE)
head(punto1)
## MUESTRA DATOS DE SENSOR 1 Y SENSOR
summary(punto1)
## HISTOGRAMAS
hist(punto1$SENSOR1, breaks = 100)
hist(punto1$SENSOR2, breaks = 100)

pairs(punto1[-c(7,8)], pch = 21
      
      , bg = c("red", "green3", "blue")[unclass(punto1$DISTANCIA)])

hist(punto1$SENSOR2, breaks = 50)
hist(punto1$SENSOR1, breaks = 50)




##COMPORTAMIENTO DE SENSORE CONCORDE A LA DISTANCIA MOSTRANDO QUE EL SENSOR 2 ES MEJOR PREDICTOR QUE EL SENSOR 1

library(psych)
pairs.panels(punto1[c("SENSOR1",
                         
                         "SENSOR2",
                      
                          "DISTANCIA")]
             
             ,pch=21, bg=c("red","green3","blue", "orange")[unclass(punto1$DISTACIA)])

predictors <- colnames(punto1)[-3]

sample.index <- sample(1:nrow(punto1)
                       ,nrow(punto1)*0.3
                       ,replace = F)

train.data <- punto1[sample.index,c(predictors,"DISTANCIA"),drop=F]
test.data <- punto1[-sample.index,c(predictors,"DISTANCIA"),drop=F]

## REGRESION MULTILINEAL MODELO 3

ctrl <-trainControl(method="cv",number=5)
modelo3 <- train(DISTANCIA~.,data = punto1,method="lm",trControl=ctrl)
modelo3

## MODELO 1  REGRECION LINEAL SENSOR 1

modelo1 <- train(DISTANCIA~SENSOR1,data = punto1,method="lm",trControl=ctrl)
modelo1
## MODELO 2 REGRECION LINEAL CON EL SENSOR 2 

modelo2 <- train(DISTANCIA~SENSOR2,data = punto1,method="lm",trControl=ctrl)
modelo2



p1 <- predict(modelo1,newdata=punto1.1)
p1

p2 <- predict(modelo2,newdata=punto1.1)
p2
prediction<-punto1.1$p2 <- c(p2)

p3 <- predict(modelo3,newdata=punto1.1)
p3

ggplot(punto1, aes(x=SENSOR2, y=DISTANCIA)) + 
  geom_point() +
  geom_smooth(method='lm', formula=y~x, se=FALSE, col='dodgerblue1') +
  theme_light()

ggplot(punto1, aes(x=SENSOR1+SENSOR2, y=DISTANCIA)) + 
  geom_point() +
  geom_smooth(method='lm', formula=y~x, se=FALSE, col='dodgerblue1') +
  theme_light()

ggplot(punto1, aes(x=SENSOR1, y=DISTANCIA)) + 
  geom_point() +
  geom_smooth(method='lm', formula=y~x, se=FALSE, col='dodgerblue1') +
  theme_light()



