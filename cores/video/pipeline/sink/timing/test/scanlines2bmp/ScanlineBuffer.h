//
// ScanlineBuffer - Frame buffer for RGB scanline data, which can be written to a .bmp file
//
//
// Copyright 2019 Reclone Labs <reclonelabs.com>
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

#ifndef SCANLINEBUFFER_H_
#define SCANLINEBUFFER_H_

#include <stdint.h>

class ScanlineBuffer
{
    public:
        ScanlineBuffer(uint16_t hPixels, uint16_t vPixels, bool interlaced);
        virtual ~ScanlineBuffer();
    
        void processPixel(bool dataEnable, bool hSync, bool vSync, uint8_t red, uint8_t green, uint8_t blue);
        bool writeBitmap(const char * bmpFilename);

    private:
        const uint16_t _hPixels;
        const uint16_t _vPixels;
        const bool _interlaced;
        
        uint16_t _hPos;
        uint16_t _vPos;
        
        uint32_t * _frameBuffer;
};

#endif //SCANLINEBUFFER_H_
