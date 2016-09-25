----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:34:17 09/19/2016 
-- Design Name: 
-- Module Name:    PsramInterface - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PsramInterface is
   port
   (
      Address     : in     std_logic_vector(23 downto 16);
      AddrData    : inout  std_logic_vector(15 downto 0);
      Clock       : in     std_logic;
      NOutputEn   : in     std_logic;
      NWriteEn    : in     std_logic;
      NChipSel    : in     std_logic;
      NAddrValid  : in     std_logic;
      NWait       : out    std_logic
   );
end PsramInterface;

architecture Behavioral of PsramInterface is
   type psram_state_enum is (PSRAM_ADDR, PSRAM_DATA, PSRAM_STALL);

   signal psram_state      : psram_state_enum := PSRAM_ADDR;
   signal wait_out         : std_logic := '1';
   signal data_out         : std_logic_vector(15 downto 0);
   signal address_latched  : std_logic_vector(23 downto 0);
begin

   Data <= data_out when NOutputEn = '0' else (others => 'Z');
   NWait <= wait_out;

   process (Clock) is
   begin
      if rising_edge(Clock) then
         if NChipSel = '0' then
            -- Chip select is low (active)
         
            case psram_state is
               when PSRAM_ADDR =>
                  -- When AddrValid is low, get the address
                  if NAddrValid = '0' then
                     address_latched <= Address & Data;
                  end if;
                  
                  
               when PSRAM_DATA =>
               
               when PSRAM_STALL =>
               
            end case;


         else
            -- Chip select is high (inactive)
            -- Reset the little state machine
            wait_out <= '1';
            psram_state <= PSRAM_ADDR;
         end if;
      
      
      end if;
   end process;


end Behavioral;

