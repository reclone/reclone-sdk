----------------------------------------------------------------------------------
-- Company:       Reclone Gaming
-- Engineer:      angrylemur
-- License:       BSD 3-clause.  See https://opensource.org/licenses/BSD-3-Clause
-- 
-- Module Name:   reclone_top - Behavioral
-- Description:   
--
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reclone_top is
    Port (
            Clk50 : in  STD_LOGIC;
            Clk32 : in  STD_LOGIC;
            LEDs : out  STD_LOGIC_VECTOR (7 downto 0)
         );
end reclone_top;

architecture Behavioral of reclone_top is
   signal count : unsigned(29 downto 0) := (others => '0');
begin

   process(clk50) begin
      if rising_edge(clk50) then
         count <= count+1;
         leds  <= STD_LOGIC_VECTOR(count(count'high downto count'high-7));      
      end if;
   end process;

end Behavioral;

