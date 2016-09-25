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
      -- FSMC PSRAM interface with STM32F4
      Address     : in     std_logic_vector(23 downto 16);
      AddrData    : inout  std_logic_vector(15 downto 0);
      NOutputEn   : in     std_logic;
      NWriteEn    : in     std_logic;
      NChipSel    : in     std_logic;
      NAddrValid  : in     std_logic;
      NWait       : out    std_logic;
      
      -- Wishbone Master interface
      RST_I       : in  std_logic;
      CLK_I       : in  std_logic;
      ADR_O       : out std_logic_vector(23 downto 0);
      DAT_I       : in  std_logic_vector(15 downto 0);
      DAT_O       : out std_logic_vector(15 downto 0);
      WE_O        : out std_logic;
      STB_O       : out std_logic;
      STALL_I     : in std_logic;
      ACK_I       : in  std_logic;
      CYC_O       : out std_logic
   );
end PsramInterface;

architecture Behavioral of PsramInterface is
   type psram_state_enum is (PSRAM_ADDR, PSRAM_DATA, PSRAM_STALL, PSRAM_ACK, PSRAM_COMPLETE);

   signal psram_state      : psram_state_enum := PSRAM_ADDR;
   signal data_out         : std_logic_vector(15 downto 0);
   signal address_latched  : std_logic_vector(23 downto 0);
begin

   AddrData <= data_out when NOutputEn = '0' else (others => 'Z');

   process (CLK_I) is
   begin
      if rising_edge(CLK_I) then
         if NChipSel = '0' then
            -- Chip select is low (active)
         
            case psram_state is
               when PSRAM_ADDR =>
                  -- When AddrValid is low, get the address
                  if NAddrValid = '0' then
                     address_latched <= Address & AddrData;
                     psram_state <= PSRAM_DATA;
                  end if;
                  
               when PSRAM_DATA =>
                  if (NAddrValid = '1' and NOutputEn = '0') then
                     -- Read
                     NWait <= '0';
                     STB_O <= '1';
                     CYC_O <= '1';
                     psram_state <= PSRAM_STALL;
                  elsif (NAddrValid = '1' and NWriteEn = '0') then
                     -- Write
                     DAT_O <= AddrData;
                     NWait <= '0';
                     STB_O <= '1';
                     CYC_O <= '1';
                     psram_state <= PSRAM_STALL;
                  end if;
               
               when PSRAM_STALL =>
                  -- Wait for the slave to not be stalled
                  if (STALL_I = '0' and ACK_I = '1') then
                     STB_O <= '0';
                     psram_state <= PSRAM_COMPLETE;                  
                  elsif STALL_I = '0' then
                     STB_O <= '0';
                     psram_state <= PSRAM_ACK;
                  end if;
                  
               when PSRAM_ACK =>
                  -- Wait for the slave to ACK
                  if (ACK_I = '1' and NOutputEn = '0') then
                     -- Read is complete
                     data_out <= DAT_I;
                     NWait <= '1';
                     CYC_O <= '0';
                     psram_state <= PSRAM_COMPLETE;
                  elsif (ACK_I = '1' and NWriteEn = '0') then
                     -- Write is complete
                     NWait <= '1';
                     CYC_O <= '0';
                     psram_state <= PSRAM_COMPLETE;
                  end if;
               
               when PSRAM_COMPLETE =>
                  -- Wait for NOutputEn and NWriteEn to de-assert
                  if (NOutputEn = '1' and NWriteEn = '1') then
                     psram_state <= PSRAM_ADDR;
                  end if;
            end case;


         else
            -- Chip select is high (inactive)
            -- Reset the state machine
            NWait <= '1';
            psram_state <= PSRAM_ADDR;
            STB_O <= '0';
            CYC_O <= '0';
         end if;

      end if;
      
   end process;


   
end Behavioral;

