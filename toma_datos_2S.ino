const unsigned int ECHO_PIN_I=12;
const unsigned int TRIG_PIN_I=11;
const unsigned int ECHO_PIN_D=8;
const unsigned int TRIG_PIN_D=7;
const unsigned int BAUD_RATE=9600;

void setup() {
  pinMode(TRIG_PIN_I, OUTPUT);
  pinMode(ECHO_PIN_I, INPUT);
  pinMode(TRIG_PIN_D, OUTPUT);
  pinMode(ECHO_PIN_D, INPUT);
  Serial.begin(BAUD_RATE);
  delay(1000);
 Serial.print("SENSOR1");
 Serial.print(",");
 //Serial.print('"');
 Serial.println("SENSOR2");
 //Serial.print('"');
 delay(500);
}

void loop() {
////////////////////////////////////////////////////////////////////////////////////////////////
  delayMicroseconds(100);
  digitalWrite(TRIG_PIN_I, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN_I, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN_I, LOW);
  const unsigned long duration_I= pulseIn(ECHO_PIN_I, HIGH);
  //delayMicroseconds(20); 
////////////////////////////////////////////////////////////////////////////////////////////////
  delayMicroseconds(100);
  digitalWrite(TRIG_PIN_D, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN_D, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN_D, LOW);
  const unsigned long duration_D= pulseIn(ECHO_PIN_D, HIGH);
  //delayMicroseconds(20); 
//////////////////////////////////////////////////////////////////////////////////////////////// 
 int distancia_I= duration_I/29/2;
 int distancia_D= duration_D/29/2;
Serial.print(duration_I);
Serial.print(",");
//Serial.print('"'); 
Serial.println(duration_D);
//Serial.println('"'); 
//////////////////////////////////////////////////////////////////////////////////////////////// 
//Serial.print("Sensor Izquierda:");
//Serial.println(distancia_I);
//Serial.print("Sensor Medio    :");
//Serial.println(distancia_M);
//Serial.print("Sensor Derecha  :");
//Serial.println(distancia_D);
//////////////////////////////////////////////////////////////////////////////////////////////// 
 delay(300);
 }
