----------------------------------------------------------------------------------
-- Module Name:   TextRenderer - Behavioral
-- Description:   Generates pixel color data based on a text buffer RAM and a
--                Code Page 437 (a.k.a. ANSI) 8x16 character ROM.
--
--                Each character in the text buffer is 16 bits wide:
--                 15     8 7      0
--                |--------|--------|
--                Bit  15    - Blink
--                Bits 14-12 - Background color
--                Bits 11- 8 - Foreground color
--                Bits  7- 0 - Code point
--
--                The text buffer is sized to show 128 columns by 32 rows.
--                With 16 bits per character, the RAM is
--                128*32*16=65536 bits, or exactly 4 16Kb Spartan-6 Block RAMs.
--
--                The character ROM stores an 8x16 pixel monochrome glyph for each
--                of the 256 characters in Code Page 437.  The ROM is
--                256*8*16=32768 bits, or exactly 2 16Kb Spartan-6 Block RAMs.
--
--                On each rising edge of the PixelClock, the next pixel location
--                is available on HPos and VPos.  Based on that location, the
--                location of the next character is calculated, and is used as an
--                address to read a 16-bit display character from the text buffer.
--
--                On each falling edge of PixelClock, the 8-bit code point
--                of the next character, along with pixel row, is used as an address
--                to read an 8-bit glyph row from character ROM.  One bit of the
--                glyph, and the blink information, is used to determine which of
--                the foreground or background color should be displayed on the next
--                pixel.  Finally, the character's foreground or background color is
--                set on the RedPix, GreenPix, and BluePix outputs.
--
-- Company:       Reclone Gaming
-- Engineer:      angrylemur
-- License:       https://opensource.org/licenses/BSD-2-Clause
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TextRenderer is
    port ( RedPix : out  STD_LOGIC_VECTOR (7 downto 0);
           GreenPix : out  STD_LOGIC_VECTOR (7 downto 0);
           BluePix : out  STD_LOGIC_VECTOR (7 downto 0);
           PixelClock : in  STD_LOGIC;
           HPos : in  STD_LOGIC_VECTOR (11 downto 0);
           HRes : in  STD_LOGIC_VECTOR (11 downto 0);
           HMax : in  STD_LOGIC_VECTOR (11 downto 0);
           VPos : in  STD_LOGIC_VECTOR (11 downto 0);
           VRes : in  STD_LOGIC_VECTOR (11 downto 0);
           VMax : in  STD_LOGIC_VECTOR (11 downto 0));
end TextRenderer;

architecture Behavioral of TextRenderer is

begin


end Behavioral;

----------------------------------------------------------------------------------
-- License:       Copyright (c) 2016, Reclone Gaming
--                All rights reserved.
--                Redistribution and use in source and binary forms, with or without
--                modification, are permitted provided that the following conditions are met:
--                1. Redistributions of source code must retain the above copyright notice,
--                   this list of conditions and the following disclaimer.
--                2. Redistributions in binary form must reproduce the above copyright notice,
--                   this list of conditions and the following disclaimer in the documentation
--                   and/or other materials provided with the distribution.
--                THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--                AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--                IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--                ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--                LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--                CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--                SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--                INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--                CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--                ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--                POSSIBILITY OF SUCH DAMAGE.
--                https://opensource.org/licenses/BSD-2-Clause
----------------------------------------------------------------------------------
