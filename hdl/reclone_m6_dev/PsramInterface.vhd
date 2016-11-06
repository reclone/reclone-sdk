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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PsramInterface is
   port
   (
      -- FSMC Synchronous PSRAM interface with STM32F4
      FSMC_CLK    : in     std_logic;
      FSMC_A      : in     std_logic_vector(23 downto 16);
      FSMC_D      : inout  std_logic_vector(15 downto 0);
      FSMC_NOE    : in     std_logic;
      FSMC_NWE    : in     std_logic;
      FSMC_NE     : in     std_logic;
      FSMC_NL     : in     std_logic;
      FSMC_NBL1   : in     std_logic;
      FSMC_NBL0   : in     std_logic;
      FSMC_NWAIT  : out    std_logic;
      
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
      CYC_O       : out std_logic;
      
      -- LEDs for debug
      dbg         : out std_logic_vector(4 downto 0)
   );
end PsramInterface;

architecture Behavioral of PsramInterface is
   type psram_state_enum is (PSRAM_ADDR, PSRAM_DATA, PSRAM_WRITE, PSRAM_STALL, PSRAM_ACK, PSRAM_COMPLETE);
   type ram_type is array (0 to 7) of std_logic_vector (15 downto 0);

   signal psram_state      : psram_state_enum := PSRAM_ADDR;
   signal data_out         : std_logic_vector(15 downto 0) := (others => '0');
   signal write_addr       : std_logic_vector(23 downto 0);
   signal read_addr        : std_logic_vector(23 downto 0);
   signal read_addr_next   : std_logic_vector(23 downto 0);
   signal dbg_out          : std_logic_vector(4 downto 0) := (others => '0');
   signal phase_count      : unsigned(4 downto 0) := "00000";
   
   signal mem_data         : ram_type :=
   (
      0 => "1111000011110000",
      1 => "0000111100001111",
      2 => "0011001111001100",
      3 => "1100110000110011",
      4 => "1010101010101010",
      5 => "0101010101010101",
      6 => "1111111101001000",
      7 => "0010100011111111"
   );
begin
   FSMC_NWAIT <= '1';
   FSMC_D <= data_out when (FSMC_NOE = '0') else (others => 'Z');
   --ADR_O <= addr_out;
   dbg <= dbg_out;
   
      
   
   -- FSMC Write process
   process (FSMC_CLK) is
   begin
   
      -- On rising edge of FSMC clock
      if rising_edge(FSMC_CLK) then
      
         -- If chip select is active
         if (FSMC_NE = '0') then
            
            if (FSMC_NL = '0') then
               -- Reset phase count and latch the write address
               phase_count <= "00000";
               write_addr <= FSMC_A & FSMC_D;
               --dbg_out <= FSMC_D(4 downto 0);
            else
               -- Increment number of FSMC cycles since address latch
               phase_count <= phase_count + 1;
               dbg_out <= std_logic_vector(phase_count);
            end if;
            
--            if (FSMC_NL = '1' and FSMC_NWE = '0' and phase_count > "00001") then
--               -- Time to write stuff
--               if (FSMC_NBL1 = '0') then
--                  -- Write high byte
--                  mem_data(to_integer(unsigned(write_addr)))(15 downto 8) <= FSMC_D(15 downto 8);
--               end if;
--               if (FSMC_NBL0 = '0') then
--                  -- Write low byte
--                  mem_data(to_integer(unsigned(write_addr)))(7 downto 0) <= FSMC_D(7 downto 0);
--               end if;
--               -- Write whole word for now
--               --mem_data(to_integer(unsigned(write_addr))) <= FSMC_D;
--               
--               -- Auto-increment the address for burst transfers
--               write_addr <= std_logic_vector(unsigned(write_addr) + 1);
--            end if;
            

         end if;
         
      end if;
      
   end process;
   
   
   
   -- FSMC Read process
   process (FSMC_CLK) is
   begin
      -- On falling edge of FSMC clock
      if falling_edge(FSMC_CLK) then
         
         -- If in the zeroth phase (determined by rising edge)
         if (phase_count = 0) then
            -- Copy the read address
            read_addr_next <= read_addr;
         elsif (FSMC_NE = '0') then
            data_out <= mem_data(to_integer(unsigned(read_addr(2 downto 0))));
         
            if (FSMC_NOE = '0') then
               read_addr_next <= std_logic_vector(unsigned(read_addr) + 1);
               
            end if;
         end if;
            
      end if;
      
      if rising_edge(FSMC_CLK) then
         -- If chip select is active
         if (FSMC_NE = '0') then
            
            if (FSMC_NL = '0') then
               read_addr <= FSMC_A & FSMC_D;
            else
               read_addr <= read_addr_next;
               --dbg_out(2 downto 0) <= read_addr_next(2 downto 0);
            end if;
         end if;
      end if;
   end process;

   
   
   -- Wishbone Master process
   process (CLK_I) is
   begin
      -- On rising edge of Wishbone clock
      if rising_edge(CLK_I) then
         --TODO: actually read/write with the slave
      end if;
   end process;

   
end Behavioral;

