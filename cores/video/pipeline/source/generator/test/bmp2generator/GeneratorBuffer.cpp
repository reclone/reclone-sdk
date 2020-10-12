//
// GeneratorBuffer - Frame buffer for video generator data, which can be read from a .bmp file
//
//
// Copyright 2020 Reclone Labs <reclonelabs.com>
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

#include <iostream>
#include <cstdio>
#include "GeneratorBuffer.h"


GeneratorBuffer::GeneratorBuffer() :
    _hPixels(0),
    _vPixels(0),
    _frameBuffer(nullptr)
{
    
}

GeneratorBuffer::~GeneratorBuffer()
{
    delete[] _frameBuffer;
}

GeneratorBuffer::RgbPixel GeneratorBuffer::getPixel(int32_t hPos, int32_t vPos)
{
    GeneratorBuffer::RgbPixel retPixel;
    
    if (hPos >= 0 && hPos < _hPixels && vPos >= 0 && vPos < _vPixels)
    {
        // Lines are stored bottom to top in .bmp
        uint32_t frameBufIdx = static_cast<uint32_t>(_vPixels - vPos - 1) * _hPixels + hPos;
        retPixel = _frameBuffer[frameBufIdx];
    }
    
    return retPixel;
}

bool GeneratorBuffer::readBitmap(const char * bmpFilename)
{
    FILE * fptr = fopen(bmpFilename,"rb");
    //std::cout << "Processing file " << bmpFilename << " ...\n";
    if (fptr == nullptr)
    {
        std::cout << "Failed to open file\n";
        return false;
    }
    
    char fileTag[2];
    size_t readSize = fread(fileTag, 1, 2, fptr);
    if (readSize != 2 || 'B' != fileTag[0] || 'M' != fileTag[1])
    {
        std::cout << "BM header didn't match; readSize was " << readSize << 
            ", fileTag[0] was " << fileTag[0] << ", fileTag[1] was " << fileTag[1] << "\n";
        fclose(fptr);
        return false;
    }
    
    const unsigned int fileHeaderSize = 14;
    const unsigned int infoHeaderSize = 40;
    const unsigned int headersSize = fileHeaderSize + infoHeaderSize;
    uint32_t fileSize = 0;
    readSize = fread(&fileSize, 1, sizeof(fileSize), fptr);
    if (readSize != sizeof(fileSize) || fileSize < headersSize)
    {
        std::cout << "fileSize is " << fileSize << "\n";
        fclose(fptr);
        return false;
    }
    
    uint16_t reserved1;
    readSize = fread(&reserved1, 1, sizeof(reserved1), fptr);
    if (readSize != sizeof(reserved1))
    {
        fclose(fptr);
        return false;
    }
    
    uint16_t reserved2;
    readSize = fread(&reserved2, 1, sizeof(reserved2), fptr);
    if (readSize != sizeof(reserved2))
    {
        fclose(fptr);
        return false;
    }
    
    uint32_t offsetToBmpData = 0;
    readSize = fread(&offsetToBmpData, 1, sizeof(offsetToBmpData), fptr);
    if (readSize != sizeof(offsetToBmpData) || offsetToBmpData != headersSize)
    {
        std::cout << "offsetToBmpData is " << offsetToBmpData << "\n";
        fclose(fptr);
        return false;
    }
    
    uint32_t bitmapInfoHeaderSize = 0;
    readSize = fread(&bitmapInfoHeaderSize, 1, sizeof(bitmapInfoHeaderSize), fptr);
    if (readSize != sizeof(bitmapInfoHeaderSize) || bitmapInfoHeaderSize != infoHeaderSize)
    {
        std::cout << "bitmapInfoHeaderSize is " << bitmapInfoHeaderSize << "\n";
        fclose(fptr);
        return false;
    }
    
    int32_t hPixels = 0;
    readSize = fread(&hPixels, 1, sizeof(hPixels), fptr);
    if (readSize != sizeof(hPixels) || hPixels <= 0)
    {
        std::cout << "hPixels is " << hPixels << "\n";
        fclose(fptr);
        return false;
    }
    
    int32_t vPixels = 0;
    readSize = fread(&vPixels, 1, sizeof(vPixels), fptr);
    if (readSize != sizeof(vPixels) || vPixels <= 0)
    {
        std::cout << "vPixels is " << vPixels << "\n";
        fclose(fptr);
        return false;
    }
    
    _hPixels = hPixels;
    _vPixels = vPixels;
    if (_frameBuffer != nullptr)
    {
        delete[] _frameBuffer;
    }
    _frameBuffer = new GeneratorBuffer::RgbPixel[vPixels * hPixels]();
    
    uint16_t planes = 0;
    readSize = fread(&planes, 1, sizeof(planes), fptr);
    if (readSize != sizeof(planes) || planes != 1)
    {
        std::cout << "planes is " << planes << "\n";
        fclose(fptr);
        return false;
    }
    
    // Only 24 bits per pixel format is supported for now
    uint16_t bpp = 0;
    readSize = fread(&bpp, 1, sizeof(bpp), fptr);
    if (readSize != sizeof(bpp) || bpp != 24)
    {
        std::cout << "bpp is " << bpp << "\n";
        fclose(fptr);
        return false;
    }
    
    uint32_t compression = 0;
    readSize = fread(&compression, 1, sizeof(compression), fptr);
    if (readSize != sizeof(compression) || compression != 0)
    {
        std::cout << "compression is " << compression << "\n";
        fclose(fptr);
        return false;
    }
    
    const unsigned int bytesPerPixel = 3;
    unsigned int hPadding = (((hPixels * bytesPerPixel) % 4) == 0) ? 0 : (4 - ((hPixels * bytesPerPixel) % 4));
    uint32_t imageSize = 0;
    int32_t hBytesPadded = hPixels * bytesPerPixel + hPadding;
    uint32_t expectedImageSize = vPixels * hBytesPadded;
    readSize = fread(&imageSize, 1, sizeof(imageSize), fptr);
    if (readSize != sizeof(imageSize) || imageSize != expectedImageSize)
    {
        std::cout << "imageSize is " << imageSize << "\n";
        fclose(fptr);
        return false;
    }
    
    uint32_t hRes = 0;
    readSize = fread(&hRes, 1, sizeof(hRes), fptr);
    if (readSize != sizeof(hRes))
    {
        fclose(fptr);
        return false;
    }

    uint32_t vRes = 0;
    readSize = fread(&vRes, 1, sizeof(vRes), fptr);
    if (readSize != sizeof(vRes))
    {
        fclose(fptr);
        return false;
    }

    uint32_t numPaletteColors = 0;
    readSize = fread(&numPaletteColors, 1, sizeof(numPaletteColors), fptr);
    if (readSize != sizeof(numPaletteColors) || numPaletteColors != 0)
    {
        fclose(fptr);
        return false;
    }

    uint32_t numImportantColors = 0;
    readSize = fread(&numImportantColors, 1, sizeof(numImportantColors), fptr);
    if (readSize != sizeof(numImportantColors))
    {
        fclose(fptr);
        return false;
    }

    for (int vPos = 0; vPos < _vPixels; ++vPos)
    {
        for (int hPos = 0; hPos < _hPixels; ++hPos)
        {
            unsigned int pixelIdx = vPos * _hPixels + hPos;
            GeneratorBuffer::RgbPixel pix;
            fread(&pix.blue, 1, 1, fptr);
            fread(&pix.green, 1, 1, fptr);
            fread(&pix.red, 1, 1, fptr);
            _frameBuffer[pixelIdx] = pix;
        }
        
        // Each scan line is zero padded to the nearest 4-byte boundary
        uint8_t padByte;
        for (unsigned int padCount = 0; padCount < hPadding; ++padCount)
        {
            fread(&padByte, 1, 1, fptr);
        }
    }
    
    if (0 != fclose(fptr))
    {
        return false;
    }
    
    return true;
}