#include "Motor.hpp"


Motor::Motor(uint8_t fwd, uint8_t back, uint8_t en1, uint8_t en2) :
    pwmForward(fwd), pwmBackward(back), enable1(en1), enable2(en2){}

void Motor::begin(){
    pinMode(pwmForward, OUTPUT);
    pinMode(pwmBackward, OUTPUT);
    pinMode(enable1, OUTPUT);
    pinMode(enable2, OUTPUT);

    digitalWrite(enable1, HIGH); 
    digitalWrite(enable2, HIGH);
}

void Motor::forward(uint8_t speed){
    analogWrite(pwmForward, speed);
    analogWrite(pwmBackward, 0);
    state = 1;
    currentSpeed = speed;
}

void Motor::backward(uint8_t speed){
    analogWrite(pwmForward, 0);
    analogWrite(pwmBackward, speed);
    state = 2;
    currentSpeed = speed;
}

void Motor::stop(){
    progressiveBrake();
    state = 0;
    currentSpeed = 0;
}

void Motor::progressiveBrake(){
    if(state == 1){
        for(int s = currentSpeed; s>=0 ; s-=5){
            analogWrite(pwmForward, s);
            analogWrite(pwmBackward, 0);
            delay(10);
        }
    }else if(state == 2){
        for (int s = currentSpeed; s >= 0 ; s-=5){
            analogWrite(pwmForward, 0);
            analogWrite(pwmBackward, s);
        }
    }
    analogWrite(pwmForward, 0);
    analogWrite(pwmBackward, 0);
}

