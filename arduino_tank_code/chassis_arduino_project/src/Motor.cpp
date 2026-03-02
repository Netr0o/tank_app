#include <cstdint>
#include "Motor.hpp"
#include <Arduino.h>


Motor::Motor(uint8_t fwd, uint8_t back, uint8_t en1, uint8_t en2)
    pwmForward(fwd), pwmBackward(back), enable1(en1), enable2(en2){}

void Motor::begin(){
    pinMode(pwmForward, OUTPUT);
    pinMode(pwmBackward, OUTPUT);
    pinMode(enable1, OUTPUT);
    pinMode(enable2, OUTPUT);
}

void Motor::forward(uint8_t){
    analogWrite(pwmForward, 0);
    analogWrite(pwmBackward, speed);
    current = 1;
}

void Motor::backward(uint8_t speed){
    analogWrite(pwmForward, speed);
    analogWrite(pwmBackward, 0);
    current = 2;
}

void Motor::stop(){
    progressiveBrake();
    current = 0;
}

void Motor::progressiveBrake(uint8_t currentSpeed){
    if(current = 1){
        for(int s = currentSpeed; s>=0 ; s-=5){
            analogWrite(pwmForward, s);
            analogWrite(pwmBackward, 0);
            delay(10);
        }
    }else if(current = 2){
        for (int s = currentSpeed; s >= 0 ; s-=5){
            analogWrite(pwmForward, 0);
            analogWrite(pwmBackward, s);
        }
    }
    analogWrite(pwmForward, 0);
    analogWrite(pwmBackward, 0);
}

