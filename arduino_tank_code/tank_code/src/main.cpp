#include <Arduino.h>
#include <Stepper.h>
#define stepsPerRevolution 2048

// Creates an instance of stepper class
// Pins entered in sequence IN1-IN3-IN2-IN4 for proper step sequence
Stepper Smotor = Stepper(stepsPerRevolution, 8, 10, 9, 11);


void setup() {
  Serial.begin(9600);
  Smotor.setSpeed(10);
  Serial.println("READY");
}

void loop() {
  if(Serial.available()>0){
    char c = Serial.read();

    if(c=='\r' || c=='\n')return;

    Serial.println("VALUE: ");
    Serial.println(c);

    switch (c)
    {
    case 'a':
      Smotor.step(-10);
      break;
    case 'z':
      Smotor.step(10);
      break;
    case 'q':
      Smotor.step(-100);
      break;
    case 's':
      Smotor.step(100);
      break;
    
    default:
      break;
    }
  }
}
