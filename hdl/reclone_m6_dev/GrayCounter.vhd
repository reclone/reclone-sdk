----------------------------------------------------------------------------------
-- Module Name:   GrayCounter - Behavioral
-- Description:   Implements a simple reflected binary code (aka. Gray code) counter 
--                of generic width.  It's useful when used as buffer indices for
--                stacks, fifos, etc. because when the counter is incremented, 
--                only one bit changes at a time, so signals like "full"
--                and "empty" won't have false transitions.
--
-- Company:       Reclone Gaming
-- Engineer:      angrylemur
-- License:       https://opensource.org/licenses/BSD-2-Clause
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity GrayCounter is

   generic
   (
      COUNTER_WIDTH :integer := 4
   );
   
   port
   (
      Enable      : in  std_logic;
      Clear       : in  std_logic;
      Clk         : in  std_logic;
      GrayCount   : out std_logic_vector(COUNTER_WIDTH-1 downto 0)
   );
   
end entity;

architecture Behavioral of GrayCounter is

   signal binary_count : std_logic_vector(COUNTER_WIDTH-1 downto 0);
   
begin

   process (Clk) begin
      if ( rising_edge(Clk) ) then
         if ( Clear = '1' ) then
            binary_count <= ( others => '0' );
            GrayCount <= ( others => '0' );
         elsif ( Enable = '1' ) then
            binary_count <= binary_count + 1;
            GrayCount <= ( binary_count( COUNTER_WIDTH - 1 ) & 
                           binary_count( COUNTER_WIDTH - 2 downto 0 ) xor 
                           binary_count( COUNTER_WIDTH - 1 downto 1 ) );
         end if;
      end if;
   end process;

end architecture;

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
