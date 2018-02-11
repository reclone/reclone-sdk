----------------------------------------------------------------------------------
-- Module Name:   TmdsEncoder - Behavioral
-- Description:   Converts 8 color bits, 2 control bits, and 1 blanking bit into
--                10 bits of TMDS-encoded data.  This can be used to encode TMDS
--                video data for DVI-D or HDMI output.
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TmdsEncoder is
   port
   (
      Clk     : in  std_logic;
      Data    : in  std_logic_vector (7 downto 0);
      Ctrl    : in  std_logic_vector (1 downto 0);
      Blank   : in  std_logic;
      Encoded : out std_logic_vector (9 downto 0)
   );
end TmdsEncoder;

architecture Behavioral of TmdsEncoder is

   signal xored  : STD_LOGIC_VECTOR (8 downto 0);
   signal xnored : STD_LOGIC_VECTOR (8 downto 0);
   
   signal ones                : STD_LOGIC_VECTOR (3 downto 0);
   signal data_word           : STD_LOGIC_VECTOR (8 downto 0);
   signal data_word_inv       : STD_LOGIC_VECTOR (8 downto 0);
   signal data_word_disparity : STD_LOGIC_VECTOR (3 downto 0);
   signal dc_bias             : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
   
begin

   -- Work out the two different encodings for the byte
   xored(0) <= Data(0);
   xored(1) <= Data(1) xor xored(0);
   xored(2) <= Data(2) xor xored(1);
   xored(3) <= Data(3) xor xored(2);
   xored(4) <= Data(4) xor xored(3);
   xored(5) <= Data(5) xor xored(4);
   xored(6) <= Data(6) xor xored(5);
   xored(7) <= Data(7) xor xored(6);
   xored(8) <= '1';

   xnored(0) <= Data(0);
   xnored(1) <= Data(1) xnor xnored(0);
   xnored(2) <= Data(2) xnor xnored(1);
   xnored(3) <= Data(3) xnor xnored(2);
   xnored(4) <= Data(4) xnor xnored(3);
   xnored(5) <= Data(5) xnor xnored(4);
   xnored(6) <= Data(6) xnor xnored(5);
   xnored(7) <= Data(7) xnor xnored(6);
   xnored(8) <= '0';
   
   -- Count how many ones are set in data
   ones <= "0000" + Data(0) + Data(1) + Data(2) + Data(3)
                   + Data(4) + Data(5) + Data(6) + Data(7);
 
   -- Decide which encoding to use
   process(ones, Data(0), xnored, xored)
   begin
      if ones > 4 or (ones = 4 and Data(0) = '0') then
         data_word     <= xnored;
         data_word_inv <= NOT(xnored);
      else
         data_word     <= xored;
         data_word_inv <= NOT(xored);
      end if;
   end process;                                          

   -- Work out the DC bias of the dataword;
   data_word_disparity  <= "1100" + data_word(0) + data_word(1) + data_word(2) + data_word(3) 
                                    + data_word(4) + data_word(5) + data_word(6) + data_word(7);
   
   -- Now work out what the output should be
   process(Clk)
   begin
      if rising_edge(Clk) then
         if blank = '1' then 
            -- In the control periods, all values have and have balanced bit count
            case Ctrl is            
               when "00"   => Encoded <= "1101010100";
               when "01"   => Encoded <= "0010101011";
               when "10"   => Encoded <= "0101010100";
               when others => Encoded <= "1010101011";
            end case;
            dc_bias <= (others => '0');
         else
            if dc_bias = "00000" or data_word_disparity = 0 then
               -- dataword has no disparity
               if data_word(8) = '1' then
                  Encoded <= "01" & data_word(7 downto 0);
                  dc_bias <= dc_bias + data_word_disparity;
               else
                  Encoded <= "10" & data_word_inv(7 downto 0);
                  dc_bias <= dc_bias - data_word_disparity;
               end if;
            elsif (dc_bias(3) = '0' and data_word_disparity(3) = '0') or 
                  (dc_bias(3) = '1' and data_word_disparity(3) = '1') then
               Encoded <= '1' & data_word(8) & data_word_inv(7 downto 0);
               dc_bias <= dc_bias + data_word(8) - data_word_disparity;
            else
               Encoded <= '0' & data_word;
               dc_bias <= dc_bias - data_word_inv(8) + data_word_disparity;
            end if;
         end if;
      end if;
   end process;

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
