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