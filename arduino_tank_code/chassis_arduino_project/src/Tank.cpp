#include "Tank.hpp"

Tank::Tank(Motor& l, Motor& r)  : left(l), right(r) {}

void Tank::begin(){
    left.begin();
    right.begin();
}

void Tank::setSpeed(uint8_t s){
    speed = s;
}

void Tank::movStop(){
    left.stop();
    right.stop();
    current = Direction::None;        
}

Direction Tank::command(uint8_t cmd){
    switch(cmd){
        case 1: return Direction::Forward;
        case 2: return Direction::Backward;
        case 3: return Direction::RotateLeft;
        case 4: return Direction::RotateRight;
        default: return Direction::None;
    }
}

void Tank::move(Direction dir){
    if (dir==current) return;
    
    switch (dir){
        case Direction::Forward:
            left.forward(speed);
            right.forward(speed);
            break;
        
        case Direction::Backward:
            left.backward(speed);
            right.backward(speed);
            break;
        
        case Direction::RotateLeft:
            left.backward(speed);
            right.forward(speed);
            break;

        case Direction::RotateRight:
            left.forward(speed);
            right.backward(speed);
            break;

        default:
            left.stop();
            right.stop();
    }
    current = dir;
}
