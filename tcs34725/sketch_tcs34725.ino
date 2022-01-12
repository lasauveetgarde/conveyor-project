#include <Wire.h>
#include "Adafruit_TCS34725.h"
#define SIGNAL_PIN 2
Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_50MS, TCS34725_GAIN_4X);
 
 int R = 0;
 int G = 0;
 int B = 0; 
 
void setup(void) {
  Serial.begin(9600);
   pinMode(SIGNAL_PIN, INPUT);
}

void loop(void) {
  uint16_t red, green, blue, clear;
  //tcs.setInterrupt(false);
  delay (200);
  tcs.getRawData(&red, &green, &blue, &clear);
  //tcs.setInterrupt(true);
  String result;

uint32_t sum = clear;
float r, g, b;

r = red;
r /= sum;

g= green;
g/= sum;

b = blue;
b /= sum;

r *= 256;
g *= 256;
b *= 256;

R = r;
G = g;
B = b;

  if(digitalRead(SIGNAL_PIN)==HIGH) {    
      result='1';
   }

  
  if(digitalRead(SIGNAL_PIN)==LOW) {
     result='0';
  }
  delay(200);
  
 Serial.print(R, DEC); Serial.print(" ");Serial.print(G, DEC);  Serial.print(" "); Serial.print(B, DEC);Serial.print(" ");Serial.print(result);Serial.print(" ");
 //Serial.print(result);
 Serial.println(" ");
}
