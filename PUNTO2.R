library(tidyverse)
library(dplyr)
library(caret)


## get parent script folder
folder <- dirname(rstudioapi::getSourceEditorContext()$path)
parentFolder <- dirname(folder)

punto2 <- read.csv(paste0(folder
                          
                          ,"/BASE_DATOS_TRAIN.csv"))

punto2.1 <- read.csv(paste0(folder
                            
                            ,"/DATASET_PRUEBA.csv")
                     
                     , stringsAsFactors = TRUE)

head(punto2)
## MUESTRA DATOS DE SENSOR 1 Y SENSOR
summary(punto2)
## HISTOGRAMAS
hist(punto2$SENSOR1, breaks = 100)
hist(punto2$SENSOR2, breaks = 100)
hist(punto2$SENSOR3, breaks = 100)


##### Normalisation #####
normData <- punto2
standardData <- punto2
### min-max
#standardize Sepal.Width and Sepal.Length 
normData <-normData %>% mutate_each_(list(~scale(.) %>% as.vector),
                                     vars = c("SENSOR2","SENSOR1"))



### z-score standardisation

standardData$SENSOR1 <-
  scale(standardData$SENSOR1)
standardData$SENSOR2<-
  scale(standardData$SENSOR2)
standardData$SENSOR3<-
  scale(standardData$SENSOR3)

#index for random sampling
sample.index <- sample(1:nrow(punto2)
                       ,nrow(punto2)*0.7
                       ,replace = F)
k <- 1
predictors <- c("SENSOR1",
                
                "SENSOR2",
                
                "SENSOR3")

# original data
train.data <-
  punto2[sample.index,c(predictors,"SENSOR2"),drop=F]
test.data <-
  
  punto2[-sample.index,c(predictors,"SENSOR2"),drop=F]

library(class)
prediction <- knn(train = train.data[predictors]
                  
                  , test = test.data[predictors]
                  ,cl = train.data$SENSOR2, k=k)



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

##modelo 2 knn sin procesamiento

ctrl <-trainControl(method="cv",number=5)


modelo2k <- train(TIPO~.,data = punto2,method="knn",trControl=ctrl)
modelo2k

## modelo 3 knn con procesamiento

modelo3 <- train(TIPO~.,data = punto2,method="knn",preProcess=c("center","scale"),trControl=ctrl)
modelo3

## modelo 4 knn con grid knn

knnGrid <- expand.grid(k=c(1,5,10,30))
modelo4 <- train(TIPO~.,data = punto2,method="knn",preProcess=c("center","scale"),tuneGrid=knnGrid,trControl=ctrl)
modelo4

P1 <- predict(modelo2k,newdata=punto2.1,)
P1

P2 <- predict(modelo3,newdata=punto2.1,)
P2
prediction<-punto2.1$P2 <- c(P2)


P3 <- predict(modelo4,newdata=punto2.1,)
P3

