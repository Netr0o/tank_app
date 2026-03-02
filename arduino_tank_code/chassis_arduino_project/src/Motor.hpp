#ifndef DEF_MOTOR
#define DEF_MOTOR

#include <cstdint>
#include <Arduino.h>

class Motor{
    private:
        uint8_t pwmForward;
        uint8_t pwmBackward;
        uint8_t enable1;
        uint8_t enable2;
        uint8_t current;
        
    public:
        Motor(uint8_t fwd, uint8_t back, uint8_t en1, uint8_t en2) : 
            pwmForward(fwd), pwmBackward(back), enable1(en1), enable2(en2){}

        void begin(){}

        void forward(uint8_t speed){}

        void backward(uint8_t speed){}

        void stop(){}

        void progressiveBrake(uint8_t currentSpeed){}
}


#endif