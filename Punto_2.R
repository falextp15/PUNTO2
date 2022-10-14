library(tidyverse)
library(dplyr)
library(caret)

## get parent script folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
parentFolder <- dirname(folder)

punto2 <- read.csv(paste0(folder
                          
                          ,"/DATASET_TRAIN_3S.csv"))

punto2.1 <- read.csv(paste0(folder
                            
                            ,"/DATASET_PRUEBA_3S_CONVEXO.csv")
                     
                     , stringsAsFactors = TRUE)

head(punto2)
## MUESTRA DATOS DE SENSOR 1 Y SENSOR
summary(punto2)
## HISTOGRAMAS
hist(punto2$SENSOR1, breaks = 100)
hist(punto2$SENSOR2, breaks = 100)
hist(punto2$SENSOR3, breaks = 100)


#
library(psych)
pairs.panels(punto2[c("SENSOR1",
                      
                      "SENSOR2",
                      
                      "SENSOR3",
                      
                      "TIPO")]
             
             ,pch=21, bg=c("red","green3","blue", "orange")[unclass(punto2$TIPO)])

predictors <- colnames(punto2)[-3]

sample.index <- sample(1:nrow(punto2)
                       ,nrow(punto2)*0.3
                       ,replace = F)

train.data <- punto2[sample.index,c(predictors,"TIPO"),drop=F]
test.data <- punto2[-sample.index,c(predictors,"TIPO"),drop=F]

##modelo 1 knn sin procesamiento

ctrl <-trainControl(method="cv",number=5)


modelo2k <- train(TIPO~.,data = punto2,method="knn",trControl=ctrl)
modelo2k

## modelo 2 knn con procesamiento

modelo3 <- train(TIPO~.,data = punto2,method="knn",preProcess=c("center","scale"),trControl=ctrl)
modelo3

## modelo 3 knn con grid knn

knnGrid <- expand.grid(k=c(1,5,10,30))
modelo4 <- train(TIPO~.,data = punto2,method="knn",preProcess=c("center","scale"),tuneGrid=knnGrid,trControl=ctrl)
modelo4

P1 <- predict(modelo2k,newdata=punto2.1,)
P1
prediction<-punto2.1$P1 <- c(P1)
P2 <- predict(modelo3,newdata=punto2.1,)
P2
prediction<-punto2.1$P2 <- c(P2)
P3 <- predict(modelo4,newdata=punto2.1,)
P3
prediction<-punto2.1$P3 <- c(P3)

