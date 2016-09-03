----------------------------------------------------------------------------------
-- Module Name:   OutputSerializer5Bit - Behavioral
-- Description:   Implements a high speed 5-bit SDR output serializer using
--                two 4-bit OSERDES2 circuits.
--
-- Company:       Reclone Gaming
-- Engineer:      angrylemur
-- License:       https://opensource.org/licenses/BSD-2-Clause
--
-- Credit:        Thanks to Mike Field <hamster@snap.net.nz>. DVID-output example at
--                http://hamsterworks.co.nz/mediawiki/index.php/MiniSpartan6%2B_DVID_Output
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity OutputSerializer5Bit is
   port
   (
      LoadClk    : in  std_logic;
      OutputClk  : in  std_logic;
      Strobe     : in  std_logic;
      SerData    : in  std_logic_vector (4 downto 0);
      SerOutput  : out std_logic
   );
end OutputSerializer5Bit;

architecture Behavioral of OutputSerializer5Bit is

   signal cascade1, cascade2, cascade3, cascade4 : std_logic;

begin
   
   OSERDES2_master : OSERDES2
      generic map
      (
         BYPASS_GCLK_FF => FALSE,       -- Bypass CLKDIV syncronization registers (TRUE/FALSE)
         DATA_RATE_OQ => "SDR",         -- Output Data Rate ("SDR" or "DDR")
         DATA_RATE_OT => "SDR",         -- 3-state Data Rate ("SDR" or "DDR")
         DATA_WIDTH => 5,               -- Parallel data width (2-8)
         OUTPUT_MODE => "SINGLE_ENDED", -- "SINGLE_ENDED" or "DIFFERENTIAL" 
         SERDES_MODE => "MASTER",       -- "NONE", "MASTER" or "SLAVE" 
         TRAIN_PATTERN => 0             -- Training Pattern (0-15)
      )
      port map
      (
         OQ        => SerOutput,   -- 1-bit output: Data output to pad or IODELAY2
         SHIFTOUT1 => cascade1,     -- 1-bit output: Cascade data output
         SHIFTOUT2 => cascade2,     -- 1-bit output: Cascade 3-state output
         SHIFTOUT3 => open,         -- 1-bit output: Cascade differential data output
         SHIFTOUT4 => open,         -- 1-bit output: Cascade differential 3-state output
         SHIFTIN1  => '1',          -- 1-bit input: Cascade data input
         SHIFTIN2  => '1',          -- 1-bit input: Cascade 3-state input
         SHIFTIN3  => cascade3,     -- 1-bit input: Cascade differential data input
         SHIFTIN4  => cascade4,     -- 1-bit input: Cascade differential 3-state input
         TQ        => open,         -- 1-bit output: 3-state output to pad or IODELAY2
         CLK0      => OutputClk,    -- 1-bit input: I/O clock input
         CLK1      => '0',          -- 1-bit input: Secondary I/O clock input
         CLKDIV    => LoadClk,      -- 1-bit input: Logic domain clock input
         -- D1 - D4: 1-bit (each) input: Parallel data inputs
         D1        => SerData(4),
         D2        => '0',
         D3        => '0',
         D4        => '0',
         IOCE      => strobe,   -- 1-bit input: Data strobe input
         OCE       => '1',      -- 1-bit input: Clock enable input
         RST       => '0',      -- 1-bit input: Asynchrnous reset input
         -- T1 - T4: 1-bit (each) input: 3-state control inputs
         T1       => '0',
         T2       => '0',
         T3       => '0',
         T4       => '0',
         TCE      => '1',       -- 1-bit input: 3-state clock enable input
         TRAIN    => '0'        -- 1-bit input: Training pattern enable input
      );

   OSERDES2_slave : OSERDES2
      generic map
      (
         BYPASS_GCLK_FF => FALSE,       -- Bypass CLKDIV syncronization registers (TRUE/FALSE)
         DATA_RATE_OQ => "SDR",         -- Output Data Rate ("SDR" or "DDR")
         DATA_RATE_OT => "SDR",         -- 3-state Data Rate ("SDR" or "DDR")
         DATA_WIDTH => 5,               -- Parallel data width (2-8)
         OUTPUT_MODE => "SINGLE_ENDED", -- "SINGLE_ENDED" or "DIFFERENTIAL" 
         SERDES_MODE => "SLAVE",       -- "NONE", "MASTER" or "SLAVE" 
         TRAIN_PATTERN => 0             -- Training Pattern (0-15)
      )
      port map
      (
         OQ        => open,            -- 1-bit output: Data output to pad or IODELAY2
         SHIFTOUT1 => open,     -- 1-bit output: Cascade data output
         SHIFTOUT2 => open,     -- 1-bit output: Cascade 3-state output
         SHIFTOUT3 => cascade3, -- 1-bit output: Cascade differential data output
         SHIFTOUT4 => cascade4, -- 1-bit output: Cascade differential 3-state output
         SHIFTIN1  => cascade1, -- 1-bit input: Cascade data input
         SHIFTIN2  => cascade2, -- 1-bit input: Cascade 3-state input
         SHIFTIN3  => '1',      -- 1-bit input: Cascade differential data input
         SHIFTIN4  => '1',      -- 1-bit input: Cascade differential 3-state input
         TQ        => open,      -- 1-bit output: 3-state output to pad or IODELAY2
         CLK0      => OutputClk,      -- 1-bit input: I/O clock input
         CLK1      => '0',       -- 1-bit input: Secondary I/O clock input
         CLKDIV    => LoadClk,    -- 1-bit input: Logic domain clock input
         -- D1 - D4: 1-bit (each) input: Parallel data inputs
         D1        => SerData(0),
         D2        => SerData(1),
         D3        => SerData(2),
         D4        => SerData(3),
         IOCE      => Strobe,     -- 1-bit input: Data strobe input
         OCE       => '1',        -- 1-bit input: Clock enable input
         RST       => '0',        -- 1-bit input: Asynchrnous reset input
         -- T1 - T4: 1-bit (each) input: 3-state control inputs
         T1        => '0',
         T2        => '0',
         T3        => '0',
         T4        => '0',
         TCE       => '1',             -- 1-bit input: 3-state clock enable input
         TRAIN     => '0'             -- 1-bit input: Training pattern enable input
      );

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
