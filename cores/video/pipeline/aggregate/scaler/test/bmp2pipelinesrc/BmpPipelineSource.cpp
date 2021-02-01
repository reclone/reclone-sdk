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

#include "BmpPipelineSource.h"

BmpPipelineSource::BmpPipelineSource() : _lastScalerClock(false)
{
    
}

BmpPipelineSource::~BmpPipelineSource()
{
    
}

void BmpPipelineSource::eval()
{
    
    if (_source.scalerClock && !_lastScalerClock)
    {
        // Rising edge of scaler clock
        // Update dataEnableDelayed
        _source.dataEnableDelayed = _source.dataEnable;
        
        if (_source.dataEnable)
        {
            // Get RGB data for the selected pixel
            GeneratorBuffer::RgbPixel pixel = _buffer.getPixel(_source.hPos, _source.vPos);
            _source.r = pixel.red;
            _source.g = pixel.green;
            _source.b = pixel.blue;
        }
    }
    
    // Evaluate the generator source module.  This should update hPos, vPos, and dataEnable
    _source.eval();
    
    _lastScalerClock = _source.scalerClock;
}
