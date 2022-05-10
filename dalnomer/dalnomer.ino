#define PIN_TRIG 12
#define PIN_ECHO 11
int value;

double TimeOfImpulse, DistanceToObject;
void setup() {
  Serial.begin (9600);
  pinMode(PIN_TRIG, OUTPUT);
  pinMode(PIN_ECHO, INPUT);
}

void loop() {
  digitalWrite(PIN_TRIG, LOW);
  delayMicroseconds(5);
  digitalWrite(PIN_TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(PIN_TRIG, LOW);

  TimeOfImpulse = pulseIn(PIN_ECHO, HIGH);
  DistanceToObject = TimeOfImpulse * 0.034 / 2;

  if (Serial.available() > 0)
  {
    value = Serial.read();
  }

  if (DistanceToObject <= 10)
  {
    Serial.print(1);
    Serial.print(" ");
    Serial.print(DistanceToObject);
    Serial.println(" ");
    Serial.print(value);
  }
  else
  {
    Serial.print(0);
    Serial.print(" ");
    Serial.print(0);
    Serial.println(" ");
    Serial.print(value);
  }
  delay(1);
}
