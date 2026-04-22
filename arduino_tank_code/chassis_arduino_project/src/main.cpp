#include <Arduino.h>
#include <ArduinoBLE.h>
#include "Motor.hpp"
#include "Tank.hpp"



BLEService ledService("19B10000-E8F2-537E-4F6C-D104768A1214"); // Bluetooth® Low Energy LED Service

// Bluetooth® Low Energy LED Switch Characteristic - custom 128-bit UUID, read and writable by central
BLEByteCharacteristic switchCharacteristic("19B10001-E8F2-537E-4F6C-D104768A1214", BLERead | BLEWrite);

Motor leftMotor(9, 10, 4, 5);
Motor rightMotor(6, 3, 7, 8);
Tank tank = Tank(leftMotor, rightMotor);

void setup() {
	tank.begin();

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

}

void loop() {
  	BLEDevice central = BLE.central();

	if(central){
		while(central.connected()){
			if(switchCharacteristic.written()){
				uint8_t cmd_received = switchCharacteristic.value();
				Direction dir = tank.command(cmd_received); 
				tank.move(dir);
			}
		}
	}
}
