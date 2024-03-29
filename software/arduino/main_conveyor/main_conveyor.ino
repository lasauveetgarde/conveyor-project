#include <Wire.h>
#include "Adafruit_TCS34725.h"
#include "HX711.h"
#include <L298N.h>
HX711 scale;
#include <Servo.h>
Servo servo1;
Servo servo2;
const int pin_servo1 = 9;
const int pin_servo2 = 10;
const int angle_max = 180;
int count1 = 0;
int count2 = 0;
int count3 = 0;
int count4 = 0;
int count5 = 0;
int pos = 0;

#define PIN_TRIG1 12
#define PIN_ECHO1 11
#define PIN_TRIG2 5
#define PIN_ECHO2 4
uint8_t dataPin = 2;
uint8_t clockPin = 3;
const unsigned int IN1 = 7;
const unsigned int IN2 = 8;
const unsigned int EN = 6;

L298N motor(EN, IN1, IN2);

float value;
float speedneed;

int w1, w2;
long stoptime;

Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_50MS, TCS34725_GAIN_4X);

float TimeOfImpulse, DistanceToObject;
int imptime, stopdistance;

int R = 0;
int G = 0;
int B = 0;

void setup(void) {

  Serial.begin(9600);

  pinMode(PIN_TRIG1, OUTPUT); //
  pinMode(PIN_ECHO1, INPUT);
  pinMode(PIN_TRIG2, OUTPUT);
  pinMode(PIN_ECHO2, INPUT);
  scale.begin(dataPin, clockPin);
  scale.set_scale(1975.0983);
  scale.tare();

  servo1.attach(pin_servo1);
  servo2.attach(pin_servo2);
  servo1.write(180);
  servo2.write(0);
}

void loop() {
  if (Serial.available() > 0)
  {
    value = Serial.read();
  }

  if (value == 1) {
    motor.backward();
    motor.setSpeed(255);
  }
  if (value == 3) {
    if (count1 == 0) {
      servo1.write(45);
      servo2.write(0);
      count1 = 1;
    }
    else {
     motor.backward();
     motor.setSpeed(255);
    }
  }

  if (value == 4) {
    if (count2 == 0) {
      servo2.write(120);
      servo1.write(180);
      count2 = 1;
    }
    else {
      motor.backward();
      motor.setSpeed(255);
    }
  }
  if (value == 5) {
    if (count3 == 0) {
      servo1.write(180);
      servo2.write(0);
      count3 = 1;
    }
    else {
      motor.backward();
      motor.setSpeed(255);
    }
  }
  if (value == 6) {
    if (count4 == 0) {
      servo1.write(120);
      servo2.write(0);
      count4 = 1;
    }
    else {
      motor.backward();
      motor.setSpeed(255);
    }
  }
  if (value == 7) {
    if (count5 == 0) {
      servo1.write(180);
      servo2.write(75);
      count5 = 1;
    }
    else {
      motor.backward();
      motor.setSpeed(255);
    }
  }
  if ((value != 1) && (value != 0) && (value != 2) && (value != 3) && (value != 4) && (value != 5) && (value != 6)&& (value != 7)) {
    motor.backward();
    motor.setSpeed(value);
  }

  if (value == 2) {
    motor.stop();
    count1 = 0;
    count2 = 0;
    count3 = 0;
    count4 = 0;
    count5 = 0;
  }

  uint16_t red, green, blue, clear;
  tcs.getRawData(&red, &green, &blue, &clear);

  double sum = clear;
  double r, g, b;

  r = red;
  r /= sum;

  g = green;
  g /= sum;

  b = blue;
  b /= sum;

  r *= 256;
  g *= 256;
  b *= 256;

  R = r + 100;
  G = g + 100;
  B = b + 100;

  w1 = scale.get_units(1);
  w2 = scale.get_units();
  while (abs(w1 - w2) > 10)
  {
    w1 = w2;
    w2 = scale.get_units();
  }
  if ((w1 < 0.5) || (w1>1100))
  {
    Serial.print(115);
    Serial.print(" ");
  }
  else
  {
    w1 = w1 + 115;
    Serial.print(w1);
    Serial.print(" ");
  }

  digitalWrite(PIN_TRIG1, LOW);
  delayMicroseconds(5);
  digitalWrite(PIN_TRIG1, HIGH);
  delayMicroseconds(10);
  digitalWrite(PIN_TRIG1, LOW);

  TimeOfImpulse = pulseIn(PIN_ECHO1, HIGH);
  DistanceToObject = TimeOfImpulse * 0.034 / 2;

  if (DistanceToObject <= 7)
  {
    Serial.print(1);
    Serial.print(" ");
    Serial.print(DistanceToObject);
  }
  else
  {
    Serial.print(0);
    Serial.print(" ");
    Serial.print(0.00);
  }

  Serial.print(" "); Serial.print(R, DEC); Serial.print(" "); Serial.print(G, DEC);  Serial.print(" "); Serial.print(B, DEC); Serial.print(" ");


  digitalWrite(PIN_TRIG2, LOW);
  delayMicroseconds(5);
  digitalWrite(PIN_TRIG2, HIGH);
  delayMicroseconds(10);
  digitalWrite(PIN_TRIG2, LOW);

  imptime = pulseIn(PIN_ECHO2, HIGH);
  stopdistance = imptime * 0.034 / 2;

  if ((stopdistance >= 80) || (stopdistance <= 10))
  {
    Serial.print(99);
    Serial.println(" ");
  }
  else
  {
    Serial.print(stopdistance);
    Serial.println(" ");
  }

}
