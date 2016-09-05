----------------------------------------------------------------------------------
-- Module Name:   DvidSer - Behavioral
-- Description:   Serializes VGA signals into DVI-D bitstreams.
--                Timing inputs are:
--                 - The pixel clock (74.175MHz or 74.25MHz for 720p, 1080i, 1080p30)
--                 - The data load clock (pixel clock x2)
--                 - The I/O clock (pixel clock x10)
--                 - The serializer strobe (twice per pixel clock to load serializers)
--                VGA inputs are:
--                 - 24-bit pixel color (8-bit Red, Green, and Blue values)
--                 - Horizonal Sync, Vertical Sync, and Blank signals
--                Serialized outputs are:
--                 - Red, Green, Blue, and Clock DVI-D channels (at the I/O clock rate)
--
-- Company:       Reclone Gaming
-- Engineer:      angrylemur
-- License:       https://opensource.org/licenses/BSD-2-Clause
--
-- Credit:        Thanks to Mike Field <hamster@snap.net.nz>. DVID-output example at
--                http://hamsterworks.co.nz/mediawiki/index.php/MiniSpartan6%2B_DVID_Output
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity DvidSer is
   port
   (
      PixelClock     : in  std_logic;
      DataLoadClock  : in  std_logic;
      IOClock        : in  std_logic;
      SerStrobe      : in  std_logic;
      RedPix         : in  std_logic_vector (7 downto 0);
      GreenPix       : in  std_logic_vector (7 downto 0);
      BluePix        : in  std_logic_vector (7 downto 0);
      Blank          : in  std_logic;
      HSync          : in  std_logic;
      VSync          : in  std_logic;
      RedSer         : out std_logic;
      GreenSer       : out std_logic;
      BlueSer        : out std_logic;
      ClockSer       : out std_logic
   );
end DvidSer;

architecture Behavioral of DvidSer is

   component TmdsEncoder
   port
   (
      Clk     : in  std_logic;
      Data    : in  std_logic_vector(7 downto 0);
      Ctrl    : in  std_logic_vector(1 downto 0);
      Blank   : in  std_logic;
      Encoded : out std_logic_vector(9 downto 0)
   );
   end component;

   component MultiRateFifo
      generic
      (
         DATA_WIDTH :integer := 8;
         ADDR_WIDTH :integer := 4
      );
      port
      (
         DataOut     :out std_logic_vector (DATA_WIDTH-1 downto 0);
         Empty       :out std_logic;
         ReadEn      :in  std_logic;
         ReadClk     :in  std_logic;
         DataIn      :in  std_logic_vector (DATA_WIDTH-1 downto 0);
         Full        :out std_logic;
         WriteEn     :in  std_logic;
         WriteClk    :in  std_logic;
         Clear       :in  std_logic
      );
   end component;

   component OutputSerializer5Bit
      port
      (
         LoadClk     : in  std_logic;
         OutputClk   : in  std_logic;
         Strobe      : in  std_logic;
         SerData     : in  std_logic_vector(4 downto 0);
         SerOutput   : out std_logic
      );
   end component;

   signal encoded_red, encoded_green, encoded_blue : std_logic_vector(9 downto 0);
   signal latched_red, latched_green, latched_blue : std_logic_vector(9 downto 0) := (others => '0');
   signal ser_in_red,  ser_in_green,  ser_in_blue, ser_in_clock   : std_logic_vector(4 downto 0) := (others => '0');
   signal fifo_in       : std_logic_vector(29 downto 0);
   signal fifo_out      : std_logic_vector(29 downto 0);
   signal rd_enable     : std_logic := '0';
   signal not_ready_yet : std_logic;
   
   constant CTRL_RED       : std_logic_vector(1 downto 0) := (others => '0');
   constant CTRL_GREEN     : std_logic_vector(1 downto 0) := (others => '0');
   signal   ctrl_blue      : std_logic_vector(1 downto 0);

begin

   -- Send the pixels to the encoder
   ctrl_blue <= vsync & hsync;
   TMDS_encoder_red:   TmdsEncoder port map(Clk => PixelClock, Data => RedPix,   Ctrl => CTRL_RED,   Blank => Blank, Encoded => encoded_red);
   TMDS_encoder_green: TmdsEncoder port map(Clk => PixelClock, Data => GreenPix, Ctrl => CTRL_GREEN, Blank => Blank, Encoded => encoded_green);
   TMDS_encoder_blue:  TmdsEncoder port map(Clk => PixelClock, Data => BluePix,  Ctrl => ctrl_blue,  Blank => Blank, Encoded => encoded_blue);

   -- Concatenate encoded TMDS data into a 30-bit word
   fifo_in <= encoded_red & encoded_green & encoded_blue;

   -- Then to a small FIFO, which bridges clock domains from
   -- PixelClock to DataLoadClock
   out_fifo: MultiRateFifo
   generic map
   (
      DATA_WIDTH => 30,
      ADDR_WIDTH => 4
   )
   port map
   (
      WriteEn    => '1',
      WriteClk   => PixelClock,
      DataIn     => fifo_in,
      ReadEn     => rd_enable,
      ReadClk    => DataLoadCLock,
      DataOut    => fifo_out,
      Empty      => not_ready_yet,
      Full       => open,
      Clear      => '0'
   );
   
   -- Now at a DataLoadClock (pixel clock x2),
   -- send the data from the fifo to the serialisers
   process (DataLoadClock) begin
      if rising_edge(DataLoadClock) then
         if not_ready_yet = '0' then
            if rd_enable = '1' then
               ser_in_red   <= fifo_out(29 downto 25);
               ser_in_green <= fifo_out(19 downto 15);
               ser_in_blue  <= fifo_out( 9 downto  5);
               ser_in_clock <= "11111";
               rd_enable <= '0';
            else
               ser_in_red   <= fifo_out(24 downto 20);
               ser_in_green <= fifo_out(14 downto 10);
               ser_in_blue  <= fifo_out( 4 downto  0);
               ser_in_clock <= "00000";
               rd_enable <= '1';
            end if;
         end if;
      end if;
   end process;

   output_serializer_r: OutputSerializer5Bit port map(LoadClk => DataLoadClock, OutputClk => IOClock, Strobe => SerStrobe, SerData => ser_in_red,   SerOutput => RedSer);
   output_serializer_g: OutputSerializer5Bit port map(LoadClk => DataLoadClock, OutputClk => IOClock, Strobe => SerStrobe, SerData => ser_in_green, SerOutput => GreenSer);
   output_serializer_b: OutputSerializer5Bit port map(LoadClk => DataLoadClock, OutputClk => IOClock, Strobe => SerStrobe, SerData => ser_in_blue,  SerOutput => BlueSer);
   output_serializer_c: OutputSerializer5Bit port map(LoadClk => DataLoadClock, OutputClk => IOClock, Strobe => SerStrobe, SerData => ser_in_clock, SerOutput => ClockSer);
   
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