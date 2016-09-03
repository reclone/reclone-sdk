----------------------------------------------------------------------------------
-- Module Name:   MultiRateFifo - Behavioral
-- Description:   Implements a first in, first out (FIFO) buffer with separate
--                read and write clocks.  It's a common and necessary memory
--                structure for getting data across clock boundaries.
--                Internally, it uses a dual-port RAM and Gray counters to store
--                the data words and keep track of full/empty status.
--
-- Company:       Reclone Gaming
-- Engineer:      angrylemur
-- License:       https://opensource.org/licenses/BSD-2-Clause
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MultiRateFifo is

   generic
   (
      DATA_WIDTH :integer := 8;
      ADDR_WIDTH :integer := 4
   );
   
   port
   (
       DataOut : out std_logic_vector (DATA_WIDTH-1 downto 0);
       Empty   : out std_logic;
       ReadEn  : in  std_logic;
       ReadClk : in  std_logic;

       DataIn  : in  std_logic_vector (DATA_WIDTH-1 downto 0);
       Full    : out std_logic;
       WriteEn : in  std_logic;
       WriteClk: in  std_logic;

       Clear   : in  std_logic
    );
    
end entity;

architecture Behavioral of MultiRateFifo is

   constant FIFO_DEPTH :integer := 2**ADDR_WIDTH;

   type RAM is array (integer range <>) of std_logic_vector (DATA_WIDTH-1 downto 0);
   signal mem : RAM (0 to FIFO_DEPTH-1);

   signal next_word_to_write    : std_logic_vector (ADDR_WIDTH-1 downto 0);
   signal next_word_to_read     : std_logic_vector (ADDR_WIDTH-1 downto 0);
   signal equal_addresses       : std_logic;
   signal next_write_address_en : std_logic;
   signal next_read_address_en  : std_logic;
   signal going_empty           : std_logic;
   signal going_full            : std_logic;
   signal preset_full           : std_logic;
   signal preset_empty          : std_logic;
   signal empty_out             : std_logic;
   signal full_out              : std_logic;
   
   
   component GrayCounter is
   generic
   (
      COUNTER_WIDTH :integer := 4
   );
   port
   (
      GrayCount : out std_logic_vector (COUNTER_WIDTH - 1 downto 0);
      Enable    : in  std_logic;
      Clear     : in  std_logic;
      Clk       : in  std_logic
   );
   end component;
   
begin

   
   process (ReadClk)
      variable going_empty_bit0 : std_logic;
      variable going_empty_bit1 : std_logic;
   begin
      if (rising_edge(ReadClk)) then
         if (ReadEn = '1' and empty_out = '0') then
            DataOut <= Mem(conv_integer(next_word_to_read));
         end if;
         
         going_empty_bit0 := next_word_to_write(ADDR_WIDTH-2) xor  next_word_to_read(ADDR_WIDTH-1);
         going_empty_bit1 := next_word_to_write(ADDR_WIDTH-1) xnor next_word_to_read(ADDR_WIDTH-2);
         if (going_empty_bit0 = '1' and going_empty_bit1 = '1') then
            going_empty <= '1'; -- Write counter is one quadrant ahead of read counter
         elsif (going_full = '1') then
            going_empty <= '0';
         end if;

      end if;
   end process;
            
   process (WriteClk)
      variable going_full_bit0 : std_logic;
      variable going_full_bit1 : std_logic;
   begin
      if (rising_edge(WriteClk)) then
         if (WriteEn = '1' and full_out = '0') then
            Mem(conv_integer(next_word_to_write)) <= DataIn;
         end if;
         
         going_full_bit0 := next_word_to_write(ADDR_WIDTH-2) xnor next_word_to_read(ADDR_WIDTH-1);
         going_full_bit1 := next_word_to_write(ADDR_WIDTH-1) xor  next_word_to_read(ADDR_WIDTH-2);
         if (going_full_bit0 = '1' and going_full_bit1 = '1') then
            going_full <= '1';
         elsif (going_empty = '1') then
            going_full <= '0';
         end if;
         
      end if;
   end process;

   next_write_address_en <= WriteEn and (not full_out);
   next_read_address_en  <= ReadEn  and (not empty_out);

   GrayCounter_pWr : GrayCounter
   port map
   (
      GrayCount => next_word_to_write,
      Enable    => next_write_address_en,
      Clear     => Clear,
      Clk       => WriteClk
   );

   GrayCounter_pRd : GrayCounter
   port map
   (
      GrayCount => next_word_to_read,
      Enable    => next_read_address_en,
      Clear     => Clear,
      Clk       => ReadClk
   );

   equal_addresses <= '1' when (next_word_to_write = next_word_to_read) else '0';

   preset_full <= going_full and equal_addresses;

   process (WriteClk, preset_full) begin
      if (preset_full = '1') then
         full_out <= '1';
      elsif (rising_edge(WriteClk)) then
         full_out <= '0';
      end if;
   end process;

   Full <= full_out;

   preset_empty <= going_empty and equal_addresses;

   process (ReadClk, preset_empty) begin
      if (preset_empty = '1') then
         empty_out <= '1';
      elsif (rising_edge(ReadClk)) then
         empty_out <= '0';
      end if;
   end process;

   Empty <= empty_out;

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