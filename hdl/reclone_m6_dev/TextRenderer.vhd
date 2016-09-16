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
use IEEE.NUMERIC_STD.ALL;

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

   type palette_type is array (0 to 15) of std_logic_vector (23 downto 0);

   constant character_columns : natural := 128;
   constant character_rows : natural := 32;
   constant text_colors : palette_type :=
   (
      x"000000",  --black
      x"0000A8",  --blue
      x"00A800",  --green
      x"00A8A8",  --cyan
      x"A80000",  --red
      x"A800A8",  --magenta
      x"A8A800",  --brown
      x"D0D0D0",  --white
      x"A8A8A8",  --dark gray
      x"0000FF",  --bright blue
      x"00FF00",  --bright green
      x"00FFFF",  --bright cyan
      x"FF0000",  --bright red
      x"FF00FF",  --bright magenta
      x"FFFF00",  --yellow
      x"FFFFFF"   --bright white
   );
   
   component TextBuffer
   port
   (
      ClkA        : in  std_logic;
      WriteEnable : in  std_logic;
      AddrA       : in  std_logic_vector(11 downto 0);
      DataInA     : in  std_logic_vector(15 downto 0);
      DataOutA    : out std_logic_vector(15 downto 0);
      ClkB        : in  std_logic;
      AddrB       : in  std_logic_vector(11 downto 0);
      DataOutB    : out std_logic_vector(15 downto 0)
   );
   end component;
   
   component GlyphRom
   port
   (
      Clock    : in  std_logic;
      Enable   : in  std_logic;
      Address  : in  std_logic_vector(11 downto 0);
      Data     : out std_logic_vector(7 downto 0)
   );
   end component;

   signal hpos_latched : std_logic_vector(11 downto 0);
   signal vpos_latched : std_logic_vector(11 downto 0);
   signal character_data : std_logic_vector(15 downto 0) := "0000000000000000";
   signal character_addr : std_logic_vector(11 downto 0) := "000000000000";
   signal char_blink : std_logic;
   signal bgcolor : std_logic_vector(23 downto 0);
   signal fgcolor : std_logic_vector(23 downto 0);
   signal code_point : std_logic_vector(7 downto 0);
   signal glyph_row : std_logic_vector(7 downto 0);
   signal use_foreground_color : std_logic;
   signal rgb : std_logic_vector(23 downto 0);
   
begin

   process (PixelClock) begin
      if (PixelClock'event and PixelClock = '1') then
         hpos_latched <= HPos;
         vpos_latched <= VPos;
      end if;   
   end process;

   character_addr <= VPos(9 downto 5) & HPos(10 downto 4);

   text_buffer : TextBuffer port map
   (
      ClkA => '0',
      WriteEnable => '0',
      AddrA => "000000000000",
      DataInA => "0000000000000000",
      DataOutA => open,
      ClkB => PixelClock,
      AddrB => character_addr,
      DataOutB => character_data
   );
   
   character_rom : GlyphRom port map
   (
      Clock => PixelClock,
      Enable => '1',
      Address => code_point & vpos_latched(4 downto 1),
      Data => glyph_row
   );
   
   char_blink <= character_data(15);
   bgcolor <= text_colors(to_integer(unsigned(character_data(14 downto 12))));
   fgcolor <= text_colors(to_integer(unsigned(character_data(11 downto 8))));
   code_point <= character_data(7 downto 0);
   
   use_foreground_color <= glyph_row(7 - to_integer(unsigned(hpos_latched(3 downto 1))));
   
   rgb <= fgcolor when (use_foreground_color = '1') else bgcolor;

   RedPix <= rgb(23 downto 16);
   GreenPix <= rgb(15 downto 8);
   BluePix <= rgb(7 downto 0);
   
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


