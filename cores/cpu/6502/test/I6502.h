
#include <cstdint>

class I6502
{
    public:
        virtual void reset() = 0;
        
        virtual void step() = 0;
        
        virtual uint16_t getPC() = 0;
        virtual uint8_t getA() = 0;
        virtual uint8_t getX() = 0;
        virtual uint8_t getY() = 0;
        virtual uint8_t getSP() = 0;
        virtual uint8_t getP() = 0;
        virtual bool getRW() = 0;
        virtual uint16_t getAddressBus() = 0;
        virtual uint8_t getIR() = 0;
        
        virtual void setMemoryByte(uint16_t address, uint8_t byte) = 0;
        virtual uint8_t getMemoryByte(uint16_t address) = 0;
};