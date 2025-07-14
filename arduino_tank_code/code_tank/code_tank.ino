#include <ArduinoBLE.h>

BLEService ledService("19B10000-E8F2-537E-4F6C-D104768A1214"); // Bluetooth® Low Energy LED Service

// Bluetooth® Low Energy LED Switch Characteristic - custom 128-bit UUID, read and writable by central
BLEByteCharacteristic switchCharacteristic("19B10001-E8F2-537E-4F6C-D104768A1214", BLERead | BLEWrite);

const int rRPWM = 9;
const int rLPWM = 10;
const int rR_EN = 4;
const int rL_EN = 5;

const int lRPWM = 6;
const int lLPWM = 3;
const int lR_EN = 7;
const int lL_EN = 8;

int speedValue = 150;

enum Direction {
  NONE, FORWARD, BACKWARD, ROTATE_LEFT, ROTATE_RIGHT,
  TURN_LEFT, TURN_RIGHT, TURN_LEFT_BACK, TURN_RIGHT_BACK
};

Direction current = NONE;

void setup() {
  Serial.begin(9600);
  while (!Serial);

  pinMode(rRPWM, OUTPUT);
  pinMode(rLPWM, OUTPUT);
  pinMode(rR_EN, OUTPUT);
  pinMode(rL_EN, OUTPUT);

  pinMode(lRPWM, OUTPUT);
  pinMode(lLPWM, OUTPUT);
  pinMode(lR_EN, OUTPUT);
  pinMode(lL_EN, OUTPUT);

  digitalWrite(rR_EN, HIGH);
  digitalWrite(rL_EN, HIGH);

  digitalWrite(lR_EN, HIGH);
  digitalWrite(lL_EN, HIGH);
  
  Serial.println("motors ready");

  if (!BLE.begin()) {
    Serial.println("starting Bluetooth® Low Energy module failed!");

    while (1);
  }

  // set advertised local name and service UUID:
  BLE.setLocalName("MOUHAHA");
  BLE.setAdvertisedService(ledService);

  // add the characteristic to the service
  ledService.addCharacteristic(switchCharacteristic);

  // add service
  BLE.addService(ledService);

  // set the initial value for the characteristic:
  switchCharacteristic.writeValue(0);

  // start advertising
  BLE.advertise();

  Serial.println("BLE LED Peripheral");

}

void loop() {
  // listen for Bluetooth® Low Energy peripherals to connect:
  BLEDevice central = BLE.central();

  // if a central is connected to peripheral:
  if (central) {
    Serial.print("Connected to central: ");
    // print the central's MAC address:
    Serial.println(central.address());

    // while the central is still connected to peripheral:
    while (central.connected()) {
      // if the remote device wrote to the characteristic,
      // use the value to control the LED:
      if (switchCharacteristic.written()) {
        uint8_t command = switchCharacteristic.value();

        switch (command) {
          case 0: stop(); break;
          case 1: forward(); break;
          case 2: backward(); break;
          case 3: turnLeft(); break;
          case 4: turnRight(); break;
          case 5 ... 14:
            speedValue = map(command, 5, 14, 50, 255);
            Serial.print("Speed set to: ");
            Serial.println(speedValue);
            break;
          case 15: rotateLeft(); break;
          case 16: rotateRight(); break;
          case 17: turnLeftBack(); break;
          case 18: turnRightBack(); break;
          default:
            stop();
  }
}
    }
      // when the central disconnects, print it out:
    Serial.print(F("Disconnected from central: "));
    Serial.println(central.address());
  }
}

void forward() {
  analogWrite(rRPWM, 0);
  analogWrite(rLPWM, speedValue);
  analogWrite(lRPWM, 0);
  analogWrite(lLPWM, speedValue);
  current = FORWARD;
}

void backward() {
  analogWrite(rRPWM, speedValue);
  analogWrite(rLPWM, 0);
  analogWrite(lRPWM, speedValue);
  analogWrite(lLPWM, 0);
  current = BACKWARD;
}

void turnLeft() {
  analogWrite(rRPWM, 0);
  analogWrite(rLPWM, speedValue);
  analogWrite(lRPWM, 0);
  analogWrite(lLPWM, 0);
  current = TURN_LEFT;
}

void turnRight() {
  analogWrite(rRPWM, 0);
  analogWrite(rLPWM, 0);
  analogWrite(lRPWM, 0);
  analogWrite(lLPWM, speedValue);
  current = TURN_RIGHT;  
}

void turnLeftBack() {
  analogWrite(rRPWM, speedValue);
  analogWrite(rLPWM, 0);
  analogWrite(lRPWM, 0);
  analogWrite(lLPWM, 0);
  current = TURN_LEFT_BACK;
}

void turnRightBack() {
  analogWrite(rRPWM, 0);
  analogWrite(rLPWM, 0);
  analogWrite(lRPWM, speedValue);
  analogWrite(lLPWM, 0);
  current = TURN_RIGHT_BACK;  
}

void rotateLeft() {
  analogWrite(rRPWM, 0);
  analogWrite(rLPWM, speedValue);
  analogWrite(lRPWM, speedValue);
  analogWrite(lLPWM, 0);
  current = ROTATE_LEFT;
}

void rotateRight() {
  analogWrite(rRPWM, speedValue);
  analogWrite(rLPWM, 0);
  analogWrite(lRPWM, 0);
  analogWrite(lLPWM, speedValue);
  current = ROTATE_RIGHT;
}

void stop() {
  int a1, p1, a2, p2;

  if (current == FORWARD) {
    a1 = rLPWM ; p1 = rRPWM ; a2 = lLPWM ; p2 = lRPWM; // forward
  } else if (current == BACKWARD) {
    a1 = rRPWM ; p1 = rLPWM ; a2 = lRPWM ; p2 = lLPWM; // backward
  } // =======
  else if (current == ROTATE_LEFT) {
    a1 = rLPWM ; p1 = rRPWM ; a2 = lRPWM ; p2 = lLPWM; // rotate left
  } else if (current == ROTATE_RIGHT) {
    a1 = rRPWM ; p1 = rLPWM ; a2 = lLPWM ; p2 = lRPWM; // rotate right
  } // =======
  else if (current == TURN_LEFT) {
    a1 = rLPWM ; p1 = rRPWM ; a2 = 0 ; p2 = lRPWM; // turn left - one track activated
  } else if (current == TURN_RIGHT) {
    a1 = lLPWM ; p1 = rLPWM ; a2 = 0 ; p2 = lRPWM; // rotate right - one track activated
  } // =======
  else if (current == TURN_LEFT_BACK) {
    a1 = rRPWM ; p1 = rLPWM ; a2 = 0 ; p2 = lRPWM; // turn back left - one track activated
  } else if (current == TURN_RIGHT_BACK) {
    a1 = lRPWM ; p1 = rLPWM ; a2 = 0 ; p2 = lLPWM; // rotate back right - one track activated
  }
  progressiveBrake(a1, p1, a2, p2);
}

void progressiveBrake(int active1, int passive1, int active2, int passive2) {
  int steps = speedValue / 3;
  if (active2 == 0) {
    for (int i = 0; i <= steps; i++) {
      int pwm = max(speedValue - 3 * i, 0);
      analogWrite(active1, pwm);
      analogWrite(passive1, 0);
      analogWrite(active2, 0);
      analogWrite(passive2, 0);
      delay(10);
  }
  } else {for (int i = 0; i <= steps; i++) {
    int pwm = max(speedValue - 3 * i, 0);
    analogWrite(active1, pwm);
    analogWrite(passive1, 0);
    analogWrite(active2, pwm);
    analogWrite(passive2, 0);
    delay(10);
    }
  }
  analogWrite(rRPWM, 0);
  analogWrite(rLPWM, 0);
  analogWrite(lRPWM, 0);
  analogWrite(lLPWM, 0);

  current = NONE;
}
