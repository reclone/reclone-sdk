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

#include <stdio.h>
#include "BmpPipelineSource.h"

BmpPipelineSource::BmpPipelineSource() :
    _scalerClock(false),
    _lastScalerClock(false),
    _requestFifoReadEnable(false),
    _requestFifoEmpty(true),
    _requestFifoReadData(0),
    _responseFifoWriteEnable(false),
    _responseFifoFull(false),
    _responseFifoWriteData(0)
{
    
}

BmpPipelineSource::~BmpPipelineSource()
{
    
}

void BmpPipelineSource::eval()
{
    if (_scalerClock && !_lastScalerClock)
    {
        // Rising edge of scaler clock
        
        if (_requestFifoReadEnable)
        {
            // Should be a new request available on _requestFifoReadData, so handle it
            // Get the row and chunk numbers
            uint32_t row = _requestFifoReadData >> CHUNKNUM_BITS;
            uint32_t chunk = _requestFifoReadData & ((1 << CHUNKNUM_BITS) - 1);
            //printf("Row %u, chunk %u\n", row, chunk);
            
            // For each pixel in the chunk, push its color value into the response queue
            for (uint32_t col = chunk * CHUNK_SIZE; col < (chunk+1) * CHUNK_SIZE; ++col)
            {
                //printf("(%u,%u)\n", col, row);
                GeneratorBuffer::RgbPixel pix = _buffer.getPixel(col, row);
                _responseQueue.push(((pix.red >> 3) << 11) | ((pix.green >> 2) << 5) | (pix.blue >> 3));
            }
        }
        
        // If the request FIFO is not empty, read the next request
        _requestFifoReadEnable = !_requestFifoEmpty;
        
        // If the response FIFO is not empty, and the downstream response FIFO is not full,
        // then write the next response
        if (!_responseQueue.empty() && !_responseFifoFull)
        {
            _responseFifoWriteData = _responseQueue.front();
            _responseFifoWriteEnable = true;
            _responseQueue.pop();
        }
        else
        {
            _responseFifoWriteEnable = false;
        }
    }
    
    _lastScalerClock = _scalerClock;
}
