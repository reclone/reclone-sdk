//
// BmpPipelineSink - Video pipeline sink that requests and buffers pixel data for a .bmp file
//
//
// Copyright 2021 Reclone Labs <reclonelabs.com>
//
// Redistribution and use in source and binary forms, with or without modification, are permitted
// provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, this list of
//    conditions and the following disclaimer in the documentation and/or other materials
//    provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
// OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#ifndef BMPPIPELINESINK_H_
#define BMPPIPELINESINK_H_

#include <stdint.h>
#include <queue>
#include <utility>

class BmpPipelineSink
{
    public:
        struct RgbPixel
        {
            RgbPixel() : red(0), green(0), blue(0) {}
            uint8_t red;
            uint8_t green;
            uint8_t blue;
        };
    
        BmpPipelineSink(uint32_t width, uint32_t height);
        virtual ~BmpPipelineSink();
        
        RgbPixel getPixel(uint32_t hPos, uint32_t vPos);
        bool writeBitmap(const char * bmpFilename);
        
        void setScalerClock(bool clock) { _clock = clock; }
        
        void setRequestFifoReadEnable(bool readEnable) { _requestFifoReadEnable = readEnable; }
        bool getRequestFifoEmpty() const { return _requestQueue.empty(); }
        uint32_t getRequestFifoReadData() const;
        
        void setResponseFifoWriteEnable(bool writeEnable) { _responseFifoWriteEnable = writeEnable; }
        bool getResponseFifoFull() const { return false; }
        void setResponseFifoWriteData(uint16_t responseData);
        
        void eval();
        void requestFrame();
    
    private:
        const unsigned int VACTIVE_BITS = 11U;
        const unsigned int CHUNKNUM_BITS = 6U;
        const unsigned int CHUNK_SIZE = 32U;
    
        uint32_t _hPixels;
        uint32_t _vPixels;
        RgbPixel * _frameBuffer;
        std::queue<uint32_t> _requestQueue;
        bool _lastClock;
        bool _clock;
        bool _requestFifoReadEnable;
        uint16_t _requestFifoReadData;
        std::queue<std::pair<uint32_t,uint32_t>> _responsePixelQueue; //{hPos,vPos}
        bool _responseFifoWriteEnable;
        uint16_t _responseFifoWriteData;
};




#endif //BMPPIPELINESINK_H_