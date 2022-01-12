#define SIGNAL_PIN 2
String result;


void setup()
{
  Serial.begin(9600);
  pinMode(SIGNAL_PIN, INPUT);
}

void loop() {
  if(digitalRead(SIGNAL_PIN)==HIGH) {    
      result='1';
   }

  
  if(digitalRead(SIGNAL_PIN)==LOW) {
     result='0';
  }
  delay(100);
 Serial.print(result);
  Serial.println(" ");
}
