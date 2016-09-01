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
   signal count50 : unsigned(25 downto 0) := (others => '0');
   signal count32 : unsigned(25 downto 0) := (others => '0');
begin

   process(Clk50) begin
      if rising_edge(Clk50) then
         count50 <= count50 + 1;
         LEDs(3 downto 0)  <= STD_LOGIC_VECTOR(count50(count50'high downto count50'high-3));      
      end if;
   end process;
   
   process(Clk32) begin
      if rising_edge(Clk32) then
         count32 <= count32 + 1;
         LEDs(7 downto 4)  <= STD_LOGIC_VECTOR(count32(count32'high downto count32'high-3));      
      end if;
   end process;

end Behavioral;

