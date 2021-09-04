//
// TextOverlayGeneratorTests - Unit tests for verilated TextOverlayGenerator module
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

#include <verilated_vcd_c.h>
#include "gtest/gtest.h"
#include "VTextOverlayGenerator.h"
#include "VVideoFormatTiming.h"
#include "ScanlineBuffer.h"

class TextOverlayGeneratorTests : public ::testing::Test
{
    public:
        TextOverlayGeneratorTests() : _tickCount(1)
        {
            Verilated::traceEverOn(true);
        }
        
        virtual ~TextOverlayGeneratorTests()
        {
            _uut.final();
        }
        
    protected:
        VTextOverlayGenerator _uut;
        VVideoFormatTiming _timing;
        unsigned int _tickCount;
};

TEST_F(TextOverlayGeneratorTests, TextCharacterSet720p)
{
    VerilatedVcdC vcd_trace;
    ScanlineBuffer scanlines(1280, 720, false);
    
    _uut.trace(&vcd_trace, 99);
    vcd_trace.open("TextCharacterSet720p.vcd");

    _timing.clock = 0;
    _timing.reset = 0;
    _timing.hFrontPorch = 110;
    _timing.hSyncPulse = 40;
    _timing.hBackPorch = 220;
    _timing.hActive = 1280;
    _timing.vFrontPorch = 5;
    _timing.vSyncPulse = 5;
    _timing.vBackPorch = 20;
    _timing.vActive = 720;
    _timing.isInterlaced = 0;
    _timing.eval();
    
    _uut.reset = 0;
    _uut.pixelClock = 0;
    _uut.videoDataEnableIn = 0;
    _uut.hSyncIn = 0;
    _uut.vSyncIn = 0;
    _uut.hPosIn = 0;
    _uut.vPosIn = 0;
    _uut.activeVideoPreambleIn = 0;
    _uut.activeVideoGuardBandIn = 0;
    _uut.upstreamRed = 0x80;
    _uut.upstreamGreen = 0x00;
    _uut.upstreamBlue = 0x00;
    _uut.blinkIsBackgroundIntensity = 1;
    _uut.enableCursor = 0;
    _uut.cursorScanLineStart = 11;
    _uut.cursorScanLineEnd = 13;
    _uut.cursorPositionColumn = 0;
    _uut.cursorPositionRow = 0;
    _uut.glyphHeight = 16;
    _uut.hScaleFactor = 2;
    _uut.vScaleFactor = 2;
    _uut.leftPadding = 0;
    _uut.topPadding = 0;
    _uut.colorAlphas = 0xFFFFFFFF;
    _uut.glyphRamData = 0xAA;
    _uut.screenRamData = 0x0700;
    _uut.eval();
    
    vcd_trace.dump(_tickCount++);
    vcd_trace.flush();

    for (unsigned int frameCount = 0; frameCount < 2; ++frameCount)
    {
        for (unsigned int vCount = 0; vCount < static_cast<unsigned int>(_timing.vFrontPorch + _timing.vSyncPulse + _timing.vBackPorch + _timing.vActive); ++vCount)
        {
            for (unsigned int hCount = 0; hCount < static_cast<unsigned int>(_timing.hFrontPorch + _timing.hSyncPulse + _timing.hBackPorch + _timing.hActive); ++hCount)
            {
                _timing.clock = 1;
                _timing.eval();
                _uut.pixelClock = _timing.clock;
                _uut.videoDataEnableIn = _timing.dataEnable;
                _uut.hSyncIn = _timing.hSync;
                _uut.vSyncIn = _timing.vSync;
                _uut.activeVideoPreambleIn = _timing.activeVideoPreamble;
                _uut.activeVideoGuardBandIn = _timing.activeVideoGuardBand;
                _uut.hPosIn = _timing.hPos;
                _uut.vPosIn = _timing.vPos;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                scanlines.processPixel(_uut.videoDataEnableOut, _uut.hSyncOut, _uut.vSyncOut, _uut.red, _uut.green, _uut.blue);
                
                //TODO service screen and glyph ram requests
                
                _timing.clock = 0;
                _timing.eval();
                _uut.pixelClock = _timing.clock;
                _uut.videoDataEnableIn = _timing.dataEnable;
                _uut.hSyncIn = _timing.hSync;
                _uut.vSyncIn = _timing.vSync;
                _uut.activeVideoPreambleIn = _timing.activeVideoPreamble;
                _uut.activeVideoGuardBandIn = _timing.activeVideoGuardBand;
                _uut.hPosIn = _timing.hPos;
                _uut.vPosIn = _timing.vPos;
                _uut.eval();
                vcd_trace.dump(_tickCount++);
                
                //vcd_trace.flush();
            }
        }
        vcd_trace.flush();
    }
    
    EXPECT_TRUE(scanlines.writeBitmap("TextCharacterSet720p.bmp"));
    
    vcd_trace.close();
}



