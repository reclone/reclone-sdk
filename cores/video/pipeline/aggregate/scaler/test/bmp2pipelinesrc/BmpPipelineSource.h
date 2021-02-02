//
// BmpPipelineSource - Video pipeline source that supplies pixel data loaded from a .bmp file
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

#include <stdint.h>
#include <queue>
#include "GeneratorBuffer.h"

class BmpPipelineSource
{
    public:
        BmpPipelineSource();
        virtual ~BmpPipelineSource();
        
        bool readBitmap(const char * bmpFilename) { return _buffer.readBitmap(bmpFilename); }
        int32_t getWidth() const { return _buffer.getWidth(); }
        int32_t getHeight() const { return _buffer.getHeight(); }
        
        void setScalerClock(bool clock) { _scalerClock = clock; }
        
        bool getRequestFifoReadEnable() const { return _requestFifoReadEnable; }
        void setRequestFifoEmpty(bool fifoEmpty) { _requestFifoEmpty = fifoEmpty; }
        void setRequestFifoReadData(uint32_t readData) { _requestFifoReadData = readData; }
        
        bool getResponseFifoWriteEnable() const { return _responseFifoWriteEnable; }
        void setResponseFifoFull(bool fifoFull) { _responseFifoFull = fifoFull; }
        uint16_t getResponseFifoWriteData() const { return _responseFifoWriteData; }
        
        void eval();

    private:
        static const unsigned int VACTIVE_BITS = 11U;
        static const unsigned int CHUNKNUM_BITS = 6U;
        static const unsigned int CHUNK_SIZE = 32U;
    
        GeneratorBuffer _buffer;
        
        bool _scalerClock;
        bool _lastScalerClock;
        
        std::queue<uint16_t> _responseQueue;
        
        bool _requestFifoReadEnable;
        bool _requestFifoEmpty;
        uint32_t _requestFifoReadData;
        bool _responseFifoWriteEnable;
        bool _responseFifoFull;
        uint16_t _responseFifoWriteData;
        
        
};
