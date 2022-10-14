library(tidyverse)
library(serial)
library(magrittr)
library(plotly)
library(dplyr)
library(openxlsx)
listPorts()
# CONEXION SERIAL
ardi <- serialConnection (
  port ="COM6",
  mode = "9600,n,8,1" ,
  buffering = "none",
  newline = TRUE,
  eof = "",
  translation = "cr",
  handshake = "none",
  buffersize = 4096
)
dataFromArduino <- 0;

# ABRIR Y PROBAR LA CONEXION
open(ardi)
isOpen(ardi)
# CREANDO DATA
# CERRANDO Y ABRIENDO LOS PUERTOS DEL ARDUINO
close(ardi)
open(ardi)
flush(ardi)
# TIEMPO PARA QUE LA PLACA SE RESETE UNA VEZ INICIADA LA INTERFAZ SERIAL Y ESCRITURA DE VALORES
Sys.sleep(1)
for (r in seq_len(n)){
  Sys.sleep(0.25)
  write.serialConnection(ardi, paste(arduinoInput[r,], collapse = ''))
}
dataFromArduino <- 0;
dataFromArduino <- tibble(
  capture.output(cat(read.serialConnection(ardi,n=0)))
)

####################################

# SELECT FIRST NINE ROWS, ASSIGN VALUES TO THEIR LEDS AND RENAME FIRST COLUMN
#dataFromArduino %>% 
#  slice_head(n = 5)

write.csv(dataFromArduino,"data_1.csv")
