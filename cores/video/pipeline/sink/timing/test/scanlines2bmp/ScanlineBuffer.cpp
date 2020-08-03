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

#include <cstdio>
#include "ScanlineBuffer.h"


ScanlineBuffer::ScanlineBuffer(uint16_t hPixels, uint16_t vPixels, bool interlaced) :
    _hPixels(hPixels),
    _vPixels(vPixels),
    _interlaced(interlaced),
    _hPos(0),
    _vPos(0),
    _frameBuffer(new uint32_t[static_cast<uint32_t>(hPixels) * static_cast<uint32_t>(vPixels)]())
{
    
}

ScanlineBuffer::~ScanlineBuffer()
{
    delete[] _frameBuffer;
}

void ScanlineBuffer::processPixel(bool dataEnable, bool hSync, bool vSync, uint8_t red, uint8_t green, uint8_t blue)
{
    if (dataEnable)
    {
        // Lines are scanned top to bottom, but stored bottom to top in .bmp
        uint32_t frameBufIdx = static_cast<uint32_t>(_vPixels - _vPos - 1) * _hPixels + _hPos;
        uint32_t rgbValue = (static_cast<uint32_t>(red) << 16) | (static_cast<uint32_t>(green) << 8) | blue;
        
        if (_hPos < _hPixels && _vPos < _vPixels)
        {
            _frameBuffer[frameBufIdx] = rgbValue;
        }
        
        ++_hPos;
    }
    else
    {
        if (hSync && _hPos > 0)
        {
            _hPos = 0;
            ++_vPos;
            if (_interlaced)
            {
                ++_vPos;
            }
        }
        
        if (vSync)
        {
            if (_interlaced && _vPos > 1)
            {
                if (_vPos & 1)
                {
                    // Odd to even
                    _vPos = 0;
                }
                else
                {
                    // Even to odd
                    _vPos = 1;
                }
            }
            else
            {
                _vPos = 0;
            }
        }
    }
}

bool ScanlineBuffer::writeBitmap(const char * bmpFilename)
{
    FILE * fptr = fopen(bmpFilename,"wb");
    if (fptr == nullptr)
    {
        return false;
    }
    
    const unsigned int fileHeaderSize = 14;
    const unsigned int infoHeaderSize = 40;
    const unsigned int headersSize = fileHeaderSize + infoHeaderSize;
    const unsigned int bytesPerPixel = 3;
    const unsigned int hPadding = (((_hPixels * bytesPerPixel) % 4) == 0) ? 0 : (4 - ((_hPixels * bytesPerPixel) % 4));
    const unsigned int imageSize = ((_hPixels * bytesPerPixel) + hPadding) * _vPixels;
    const uint32_t fileSize = headersSize + imageSize;
    const uint32_t width = _hPixels;
    const uint32_t height = _vPixels;
    const uint16_t planes = 1;
    const uint16_t bpp = 24;
    const uint32_t compression = 0;
    const uint32_t hres = 0;
    const uint32_t vres = 0;
    const uint32_t palletteColors = 0;
    const uint32_t importantColors = 0;
    
    uint8_t headers[headersSize];
    headers[0] = 'B';
    headers[1] = 'M';
    headers[2] = static_cast<uint8_t>(fileSize >> 0);
    headers[3] = static_cast<uint8_t>(fileSize >> 8);
    headers[4] = static_cast<uint8_t>(fileSize >> 16);
    headers[5] = static_cast<uint8_t>(fileSize >> 24);
    headers[6] = 0; //reserved
    headers[7] = 0;
    headers[8] = 0;
    headers[9] = 0;
    headers[10] = static_cast<uint8_t>(headersSize >> 0);
    headers[11] = static_cast<uint8_t>(headersSize >> 8);
    headers[12] = static_cast<uint8_t>(headersSize >> 16);
    headers[13] = static_cast<uint8_t>(headersSize >> 24);
    headers[14] = static_cast<uint8_t>(infoHeaderSize >> 0);
    headers[15] = static_cast<uint8_t>(infoHeaderSize >> 8);
    headers[16] = static_cast<uint8_t>(infoHeaderSize >> 16);
    headers[17] = static_cast<uint8_t>(infoHeaderSize >> 24);
    headers[18] = static_cast<uint8_t>(width >> 0);
    headers[19] = static_cast<uint8_t>(width >> 8);
    headers[20] = static_cast<uint8_t>(width >> 16);
    headers[21] = static_cast<uint8_t>(width >> 24);
    headers[22] = static_cast<uint8_t>(height >> 0);
    headers[23] = static_cast<uint8_t>(height >> 8);
    headers[24] = static_cast<uint8_t>(height >> 16);
    headers[25] = static_cast<uint8_t>(height >> 24);
    headers[26] = static_cast<uint8_t>(planes >> 0);
    headers[27] = static_cast<uint8_t>(planes >> 8);
    headers[28] = static_cast<uint8_t>(bpp >> 0);
    headers[29] = static_cast<uint8_t>(bpp >> 8);
    headers[30] = static_cast<uint8_t>(compression >> 0);
    headers[31] = static_cast<uint8_t>(compression >> 8);
    headers[32] = static_cast<uint8_t>(compression >> 16);
    headers[33] = static_cast<uint8_t>(compression >> 24);
    headers[34] = static_cast<uint8_t>(imageSize >> 0);
    headers[35] = static_cast<uint8_t>(imageSize >> 8);
    headers[36] = static_cast<uint8_t>(imageSize >> 16);
    headers[37] = static_cast<uint8_t>(imageSize >> 24);
    headers[38] = static_cast<uint8_t>(hres >> 0);
    headers[39] = static_cast<uint8_t>(hres >> 8);
    headers[40] = static_cast<uint8_t>(hres >> 16);
    headers[41] = static_cast<uint8_t>(hres >> 24);
    headers[42] = static_cast<uint8_t>(vres >> 0);
    headers[43] = static_cast<uint8_t>(vres >> 8);
    headers[44] = static_cast<uint8_t>(vres >> 16);
    headers[45] = static_cast<uint8_t>(vres >> 24);
    headers[46] = static_cast<uint8_t>(palletteColors >> 0);
    headers[47] = static_cast<uint8_t>(palletteColors >> 8);
    headers[48] = static_cast<uint8_t>(palletteColors >> 16);
    headers[49] = static_cast<uint8_t>(palletteColors >> 24);
    headers[50] = static_cast<uint8_t>(importantColors >> 0);
    headers[51] = static_cast<uint8_t>(importantColors >> 8);
    headers[52] = static_cast<uint8_t>(importantColors >> 16);
    headers[53] = static_cast<uint8_t>(importantColors >> 24);
    fwrite(headers, headersSize, 1, fptr);
    
    for (unsigned int vPos = 0; vPos < _vPixels; ++vPos)
    {
        for (unsigned int hPos = 0; hPos < _hPixels; ++hPos)
        {
            unsigned int pixelIdx = vPos * _hPixels + hPos;
            uint8_t red   = static_cast<uint8_t>(_frameBuffer[pixelIdx] >> 16);
            uint8_t green = static_cast<uint8_t>(_frameBuffer[pixelIdx] >> 8);
            uint8_t blue  = static_cast<uint8_t>(_frameBuffer[pixelIdx] >> 0);
            fwrite(&blue, 1, 1, fptr);
            fwrite(&green, 1, 1, fptr);
            fwrite(&red, 1, 1, fptr);
        }
        
        // Each scan line is zero padded to the nearest 4-byte boundary
        const uint8_t padByte = 0x00;
        for (unsigned int padCount = 0; padCount < hPadding; ++padCount)
        {
            fwrite(&padByte, 1, 1, fptr);
        }
    }
    
    if (0 != fclose(fptr))
    {
        return false;
    }
    
    return true;
}