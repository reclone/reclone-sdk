----------------------------------------------------------------------------------
-- Module Name:   TextRenderer - Behavioral
-- Description:   Generates pixel color data based on a 128x32 text buffer RAM
--                and a IBM PC Code Page 437 (a.k.a. ANSI) EGA 8x14 character ROM.
--
--                The renderer is designed for 1280x720 screen resolution.  When
--                the characters are scaled by 200% to 16x28, the screen can show
--                80 columns by 25.7 rows of text.  The visible rows are shifted
--                up by 18 pixels so that 25 are centered vertically on the screen.
--                The top and bottom part-rows can be used for special bordering.
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
--                The character ROM stores an 8x14 pixel monochrome glyph for each
--                of the 256 characters in Code Page 437.  The ROM is
--                256*8*14=28672 bits, using 2 16Kb Spartan-6 Block RAMs.
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

entity TextRenderer is
    port ( RedPix : out  STD_LOGIC_VECTOR (7 downto 0);
           GreenPix : out  STD_LOGIC_VECTOR (7 downto 0);
           BluePix : out  STD_LOGIC_VECTOR (7 downto 0);
           PixelClock : in  STD_LOGIC;
           HPos : in  STD_LOGIC_VECTOR (11 downto 0); -- Next horizontal pixel position
           HRes : in  STD_LOGIC_VECTOR (11 downto 0); -- Horizontal visible resolution
           HMax : in  STD_LOGIC_VECTOR (11 downto 0); -- Max horizontal count
           VPos : in  STD_LOGIC_VECTOR (11 downto 0); -- Next vertical pixel position
           VRes : in  STD_LOGIC_VECTOR (11 downto 0); -- Vertical visible resolution
           VMax : in  STD_LOGIC_VECTOR (11 downto 0); -- Max vertical count
           TextBufAddr : out std_logic_vector(11 downto 0); -- Address output for the text buffer RAM
           TextBufData : in std_logic_vector(15 downto 0) -- Data input for the text buffer RAM
         );
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
   signal vpos_shifted : std_logic_vector(11 downto 0);
   signal row_location : std_logic_vector(23 downto 0);
   signal char_blink : std_logic;
   signal blink_timer : unsigned(24 downto 0) := (others => '0');
   signal bgcolor : std_logic_vector(23 downto 0);
   signal fgcolor : std_logic_vector(23 downto 0);
   signal code_point : std_logic_vector(7 downto 0);
   signal glyph_row : std_logic_vector(7 downto 0);
   signal use_foreground_color : std_logic;
   signal rgb : std_logic_vector(23 downto 0);
   signal glyph_rom_addr : std_logic_vector(11 downto 0);
   
begin

   -- Shift up 18 pixels to center the next 25 rows vertically onscreen
   vpos_shifted <= std_logic_vector(unsigned(VPos) + 18);
   
   -- Divide vpos by 28 to determine row location
   -- (1/28) * (2^16) = 2341
   -- So (x/28) ~= (x*2341)>>16
   row_location <= std_logic_vector(unsigned(vpos_shifted) * to_unsigned(2341, 12));
   
   -- Calculate the text buffer address from the pixel position
   TextBufAddr <= row_location(20 downto 16) & HPos(10 downto 4);

   -- Latch the pixel positions on rising edge of the pixel clock
   process (PixelClock) begin
      if rising_edge(PixelClock) then
         hpos_latched <= HPos;
         vpos_latched <= vpos_shifted;
         blink_timer <= blink_timer + 1;
      end if;   
   end process;

   -- Calculate the glyph ROM address from the character code point
   -- and the vertical pixel position.
   glyph_rom_addr <= std_logic_vector((unsigned(code_point) * to_unsigned(14, 4)) 
                     + ((unsigned(vpos_latched) mod 28) srl 1));

   -- Get the pixel data for the current row in the character
   character_rom : GlyphRom port map
   (
      Clock => PixelClock,
      Enable => '1',
      Address => glyph_rom_addr,
      Data => glyph_row
   );
   
   -- Decode the character data retrieved from the text buffer
   char_blink <= TextBufData(15);
   bgcolor <= text_colors(to_integer(unsigned(TextBufData(14 downto 12))));
   fgcolor <= text_colors(to_integer(unsigned(TextBufData(11 downto 8))));
   code_point <= TextBufData(7 downto 0);
   
   -- Determine whether to display the foreground color or
   -- background color at this pixel
   use_foreground_color <= '1' when
      (glyph_row(7 - to_integer(unsigned(hpos_latched(3 downto 1)))) = '1'
       and (char_blink = '0' or blink_timer(24) = '1') ) else '0';
   rgb <= fgcolor when (use_foreground_color = '1') else bgcolor;

   -- Output RGB values for the determined color
   RedPix <= rgb(23 downto 16);
   GreenPix <= rgb(15 downto 8);
   BluePix <= rgb(7 downto 0);
   
end Behavioral;

----------------------------------------------------------------------------------
-- License:       Copyright (c) 2016, Reclone Labs
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


