#pragma once
#ifndef DEF_TANK
#define DEF_TANK

#include <Arduino.h>
#include "Motor.hpp"

enum class Direction {
    None,
    Forward,
    Backward,
    RotateLeft,
    RotateRight,
    TurnLeft,
    TurnRight,
    TurnLeftBack,
    TurnRightBack
};

class Tank{
    private: 
        Motor& left;
        Motor& right;
        Direction current = Direction::None;
        uint8_t speed = 150;

    public: 
        Tank(Motor& l, Motor& r);

        void begin();

        void setSpeed(uint8_t s);

        Direction command(uint8_t cmd);

        void move(Direction dir);

        void movStop();
};

#endif