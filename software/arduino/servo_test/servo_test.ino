#include <Servo.h>
Servo servo1;
Servo servo2;
const int pin_servo1 = 9;
const int pin_servo2 = 10;
int pos = 0;
int count = 0;

void setup(void) {

  Serial.begin(9600);
  servo1.attach(pin_servo1);
  servo2.attach(pin_servo2);
}

void loop() {

  for (pos = 0; pos <= 180; pos += 1) {
    servo1.write(pos);
    delay (15);
  }
  for (pos = 180; pos >= 0; pos -= 1) {
    servo1.write(pos);
    delay (15);
  }
  for (pos = 0; pos <= 180; pos += 1) {
    servo2.write(pos);
    delay (15);
  }
  for (pos = 180; pos >= 0; pos -= 1) {
    servo2.write(pos);
    delay (15);
  }


  //    for (pos = 0; pos <= 30; pos += 1) {
  //      servo1.write(pos);
  //      delay (15);
  //    }
  //
  //    for (pos = 0; pos <= 10; pos += 1) {
  //      servo2.write(pos);
  //      delay (15);
  //    }


}

//  Serial.print(count);
