#include <Arduino.h>
#include <Stepper.h>
#define stepsPerRevolution 2048

// Creates an instance of stepper class
// Pins entered in sequence IN1-IN3-IN2-IN4 for proper step sequence
Stepper myStepper = Stepper(stepsPerRevolution, 8, 10, 9, 11);


void setup() {
  // put your setup code here, to run once:
}

void loop() {
    // put your main code here, to run repeatedly:
      // Rotate CW slowly at 5 RPM
    myStepper.setSpeed(20);
    myStepper.step(stepsPerRevolution);
    delay(1000);
}
