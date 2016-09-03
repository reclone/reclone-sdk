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
-- License:       BSD 3-clause.  See https://opensource.org/licenses/BSD-3-Clause
-- Credit:        Derived from "Code Gray counter" by Alex Carlos F. and
--                Alexander H Pham. http://www.asic-world.com/examples/vhdl/asyn_fifo.html
--
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
