----------------------------------------------------------------------------------
-- Module Name:   DvidGen - Behavioral
-- Description:   Generates DVI-D differential output and scan timings
--                from clock inputs and pixel color data.
--
-- Company:       Reclone Gaming
-- Engineer:      angrylemur
-- License:       https://opensource.org/licenses/BSD-2-Clause
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.vcomponents.all;

entity DvidGen is
   port
   (
      PixelClock     : in  std_logic;
      PixelClockX2   : in  std_logic;
      PixelClockX10  : in  std_logic;
      SerStrobe      : in  std_logic;
      RedPix         : in  std_logic_vector (7 downto 0);
      GreenPix       : in  std_logic_vector (7 downto 0);
      BluePix        : in  std_logic_vector (7 downto 0);
      
      HPos        : out std_logic_vector (11 downto 0);
      HRes        : out std_logic_vector (11 downto 0);
      HMax        : out std_logic_vector (11 downto 0);
      VPos        : out std_logic_vector (11 downto 0);
      VRes        : out std_logic_vector (11 downto 0);
      VMax        : out std_logic_vector (11 downto 0);
      
      TmdsRedP    : out std_logic;
      TmdsRedN    : out std_logic;
      TmdsGreenP  : out std_logic;
      TmdsGreenN  : out std_logic;
      TmdsBlueP   : out std_logic;
      TmdsBlueN   : out std_logic;
      TmdsClockP  : out std_logic;
      TmdsClockN  : out std_logic
   );
end DvidGen;

architecture Behavioral of DvidGen is

   component DvidSer
   port
   (
      PixelClock     : in  std_logic;
      DataLoadClock  : in  std_logic;
      IOClock        : in  std_logic;
      SerStrobe      : in  std_logic;
      RedPix         : in  std_logic_vector(7 downto 0);
      GreenPix       : in  std_logic_vector(7 downto 0);
      BluePix        : in  std_logic_vector(7 downto 0);
      Blank          : in  std_logic;
      HSync          : in  std_logic;
      VSync          : in  std_logic;
      RedSer         : out std_logic;
      GreenSer       : out std_logic;
      BlueSer        : out std_logic;
      ClockSer       : out std_logic
   );
   end component;

   signal tmds_out_red     : std_logic;
   signal tmds_out_green   : std_logic;
   signal tmds_out_blue    : std_logic;
   signal tmds_out_clock   : std_logic;
   
   -- Timing may be configurable in the future
   signal h_count          : natural := 0;
   signal h_res            : natural := 1280;
   signal h_sync_start     : natural := 1280+72;
   signal h_sync_end       : natural := 1280+80;
   signal h_max            : natural := 1647;
   signal v_count          : natural := 0;
   signal v_res            : natural := 720;
   signal v_sync_start     : natural := 720+3;
   signal v_sync_end       : natural := 720+5;
   signal v_max            : natural := 749;
   
   signal blank            : std_logic;
   signal hsync            : std_logic;
   signal vsync            : std_logic;
   
   signal red_level        : std_logic_vector(7 downto 0);
   signal green_level      : std_logic_vector(7 downto 0);
   signal blue_level       : std_logic_vector(7 downto 0);

begin

   HPos <= std_logic_vector(to_unsigned(h_count, HPos'length));
   HRes <= std_logic_vector(to_unsigned(h_res, HRes'length));
   HMax <= std_logic_vector(to_unsigned(h_max, HMax'length));
   VPos <= std_logic_vector(to_unsigned(V_count, VPos'length));
   VRes <= std_logic_vector(to_unsigned(V_res, VRes'length));
   VMax <= std_logic_vector(to_unsigned(V_max, VMax'length));

   process (PixelClock) begin
      if rising_edge(PixelClock) then
      
         -- Increment the scan location
         if h_count = h_max then
            h_count <= 0;
            if v_count = v_max then
               v_count <= 0;
            else
               v_count <= v_count+1;
            end if;
         else
            h_count <= h_count+1;
         end if;
         
         if (h_count >= h_res or v_count >= v_res) then
         
            -- In a blanking region; set color to black
            blank <= '1';
            red_level <= (others => '0');
            green_level <= (others => '0');
            blue_level <= (others => '0');
            
            -- Determine HSync
            if (h_count >= h_sync_start and h_count < h_sync_end) then
               hsync <= '1';
            else
               hsync <= '0';
            end if;
            
            -- Determine VSync
            if (v_count >= v_sync_start and v_count < v_sync_end) then
               vsync <= '1';
            else
               vsync <= '0';
            end if;

         else
         
            -- In an active region; let color pass through
            blank <= '0';
            hsync <= '0';
            vsync <= '0';
            red_level <= RedPix;
            green_level <= GreenPix;
            blue_level <= BluePix;
            
         end if;
         
      end if;
   end process;

   dvid_ser: DvidSer port map
   (
      PixelClock     => PixelClock,
      DataLoadClock  => PixelClockX2,
      IOClock        => PixelClockX10,
      SerStrobe      => SerStrobe,

      RedPix         => red_level,
      GreenPix       => green_level,
      BluePix        => blue_level,
      Blank          => blank,
      HSync          => hsync,
      VSync          => vsync,
      
      RedSer         => tmds_out_red,
      GreenSer       => tmds_out_green,
      BlueSer        => tmds_out_blue,
      ClockSer       => tmds_out_clock
   );

   OBUFDS_red   : OBUFDS port map ( O => TmdsRedP,    OB => TmdsRedN,   I => tmds_out_red   );
   OBUFDS_green : OBUFDS port map ( O => TmdsGreenP,  OB => TmdsGreenN, I => tmds_out_green );
   OBUFDS_blue  : OBUFDS port map ( O => TmdsBlueP,   OB => TmdsBlueN,  I => tmds_out_blue  );
   OBUFDS_clock : OBUFDS port map ( O => TmdsClockP,  OB => TmdsClockN, I => tmds_out_clock );

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
