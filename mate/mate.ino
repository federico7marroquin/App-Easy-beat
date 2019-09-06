int LedPin = 13;
boolean EstadoLed = true;
const int BOTON0 = 3;
const int BOTON1 = 2;
const int BOTON2 = 5;
const int BOTON3 = 6;
const int BOTON4 = 7;
const int BOTON5 = 8;
const int BOTON6 = 9;
const int BOTON7 = 10;
const int BOTON8 = 11;
const int BOTON9 = 12;
int valor = 20;
int val_old = 20;


int val0 = 0; //val se emplea para almacenar el estado del boton
int old_val0 = 0; // almacena el antiguo valor de val
int val1 = 0; //val se emplea para almacenar el estado del boton
int old_val1 = 0; // almacena el antiguo valor de val
int val2 = 0; //val se emplea para almacenar el estado del boton
int old_val2 = 0; // almacena el antiguo valor de val
int val3 = 0; //val se emplea para almacenar el estado del boton
int old_val3 = 0; // almacena el antiguo valor de val
int val4 = 0; //val se emplea para almacenar el estado del boton
int old_val4 = 0; // almacena el antiguo valor de val
int val5 = 0; //val se emplea para almacenar el estado del boton
int old_val5 = 0; // almacena el antiguo valor de val
int val6 = 0; //val se emplea para almacenar el estado del boton
int old_val6 = 0; // almacena el antiguo valor de val
int val7 = 0; //val se emplea para almacenar el estado del boton
int old_val7 = 0; // almacena el antiguo valor de val
int val8 = 0; //val se emplea para almacenar el estado del boton
int old_val8 = 0; // almacena el antiguo valor de val
int val9 = 0; //val se emplea para almacenar el estado del boton
int old_val9 = 0; // almacena el antiguo valor de val

void setup() {
  Serial.begin(9600);

  pinMode(LedPin, OUTPUT);
  digitalWrite(LedPin, EstadoLed);
  pinMode(BOTON0, INPUT); // y BOTON como señal de entrada
  pinMode(BOTON1, INPUT); // y BOTON como señal de entrada
  pinMode(BOTON2, INPUT); // y BOTON como señal de entrada
  pinMode(BOTON3, INPUT); // y BOTON como señal de entrada
  pinMode(BOTON4, INPUT); // y BOTON como señal de entrada
  pinMode(BOTON5, INPUT); // y BOTON como señal de entrada
  pinMode(BOTON6, INPUT); // y BOTON como señal de entrada
  pinMode(BOTON7, INPUT); // y BOTON como señal de entrada
  pinMode(BOTON8, INPUT); // y BOTON como señal de entrada
  pinMode(BOTON9, INPUT); // y BOTON como señal de entrada

}

void loop() {
  // if (Serial.available()) {
  //   char Letra = Serial.read();
  //   if (Letra == 'a') {
  //     EstadoLed = !EstadoLed;
  //   }
  //   digitalWrite(LedPin, EstadoLed);
  // }
  valor = analogRead(A0);
  val8 = digitalRead(BOTON8);
  val0 = digitalRead(BOTON0); 
  val1 = digitalRead(BOTON1);
  val2 = digitalRead(BOTON2); 
  val3 = digitalRead(BOTON3);
  val4 = digitalRead(BOTON4); 
  val5 = digitalRead(BOTON5); 
  val7 = digitalRead(BOTON7); 
  val9 = digitalRead(BOTON9); 
  val6 = digitalRead(BOTON6); 


  if ((val0 == HIGH) && (old_val0 == LOW)) {
    Serial.write("KICK");
    delay(50);
  }
  else if ((val1 == HIGH) && (old_val1 == LOW)) {
    Serial.write("CLAP");
    delay(50);
  }
  else if ((val2 == HIGH) && (old_val2 == LOW)) {
    Serial.write("SNARE");
    delay(50);
  }
  else if ((val3 == HIGH) && (old_val3 == LOW)) {
    Serial.write("HAT");
    delay(1000);  
    delay(50);
  }
  else if ((val4 == HIGH) && (old_val4 == LOW)) {
    Serial.write("BAJO");
    delay(50);
  }
  else if ((val5 == HIGH) && (old_val5 == LOW)) {
    Serial.write("LOW");
    delay(50);
  }
  else if ((val7 == HIGH) && (old_val7 == LOW)) {
    Serial.write("BAND");
    delay(50);
  } 
  else if ((val6 == HIGH) && (old_val6 == LOW)) {
    Serial.write("HIGH");
    delay(50);
  }  // lee el estado del Boton
  else if ((val8 == HIGH) && (old_val8 == LOW)) {
    Serial.write("REVERB");
    delay(50);
  }
  else if ((val9 == HIGH) && (old_val9 == LOW)) {
    Serial.write("RESET");
    delay(50);
  } else  if ((valor<=val_old-8)||(valor>val_old+8)) {

    val_old = valor;
    //Imprimimos por el monitor serie
    Serial.println(valor);
  }
 delay(200);


}
