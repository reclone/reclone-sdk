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
   type ram_type is array (0 to 7) of std_logic_vector (7 downto 0);

   signal psram_state      : psram_state_enum := PSRAM_ADDR;
   signal data_out         : std_logic_vector(15 downto 0) := (others => '0');
   signal write_addr       : std_logic_vector(23 downto 0);
   signal write_addr_next  : std_logic_vector(23 downto 0);
   signal read_addr        : std_logic_vector(23 downto 0);
   signal read_addr_next   : std_logic_vector(23 downto 0);
   signal dbg_out          : std_logic_vector(4 downto 0) := (others => '0');
   signal phase_count      : unsigned(4 downto 0) := "00000";
   signal writes_allowed   : std_logic := '0';
   
   signal mem_data_h       : ram_type :=
   (
      0 => "11110000",
      1 => "00001111",
      2 => "00110011",
      3 => "11001100",
      4 => "10101010",
      5 => "01010101",
      6 => "11111111",
      7 => "00101000"
   );
   signal mem_data_l       : ram_type :=
   (
      0 => "11110000",
      1 => "00001111",
      2 => "11001100",
      3 => "00110011",
      4 => "10101010",
      5 => "01010101",
      6 => "01001000",
      7 => "11111111"
   );
begin
   FSMC_NWAIT <= '1';
   FSMC_D <= data_out when (FSMC_NOE = '0') else (others => 'Z');
   --ADR_O <= addr_out;
   dbg <= dbg_out;
   
      
   
   -- FSMC Latch and Write process (rising edge)
   process (FSMC_CLK, FSMC_NE, FSMC_NBL0, FSMC_NBL1, FSMC_NL, FSMC_NWE, writes_allowed) is
   begin
   
      -- On rising edge of FSMC clock, enabled
      if (rising_edge(FSMC_CLK) and FSMC_NE = '0') then
         dbg_out(0) <= '1';
         if (FSMC_NL = '0') then
            -- Reset phase count and latch the read and write addresses
            phase_count <= "00000";
            write_addr_next <= FSMC_A & FSMC_D;
            read_addr <= FSMC_A & FSMC_D;
            --dbg_out <= FSMC_D(4 downto 0);
         else
         
            if (FSMC_NWE = '0' and writes_allowed = '1') then
               dbg_out(1) <= '1';
               
               -- Time to write stuff
               if (FSMC_NBL1 = '0') then
                  -- Write high byte
                  mem_data_h(to_integer(unsigned(write_addr(2 downto 0)))) <= FSMC_D(15 downto 8);
                  dbg_out(2) <= '1';
               end if;
                  
               if (FSMC_NBL0 = '0') then
                  -- Write low byte
                  mem_data_l(to_integer(unsigned(write_addr(2 downto 0)))) <= FSMC_D(7 downto 0);
                  dbg_out(3) <= '1';
               end if;

               -- Auto-increment the address for burst transfers
               write_addr_next <= std_logic_vector(unsigned(write_addr) + 1);
            end if;
         
            -- Increment number of FSMC cycles since address latch
            phase_count <= phase_count + 1;
            -- Update the read address
            read_addr <= read_addr_next;
            --dbg_out <= std_logic_vector(phase_count);
         end if;
            
      end if;
      
   end process;
   
   
   
   -- FSMC Read process (falling edge)
   process (FSMC_CLK, FSMC_NE, FSMC_NOE, phase_count) is
   begin
      -- On falling edge of FSMC clock, enabled
      if (falling_edge(FSMC_CLK) and FSMC_NE = '0') then
         
         -- If in the zeroth phase (determined by rising edge)
         if (phase_count = 0) then
            -- Init the "next" read address (latched on rising edge)
            read_addr_next <= read_addr;
         else
            -- Output the data at the current read_addr
            data_out(15 downto 8) <= mem_data_h(to_integer(unsigned(read_addr(2 downto 0))));
            data_out(7 downto 0) <= mem_data_l(to_integer(unsigned(read_addr(2 downto 0))));
         
            if (FSMC_NOE = '0') then
               -- Auto-increment the read address to support burst transfers
               read_addr_next <= std_logic_vector(unsigned(read_addr) + 1);
            end if;
         end if;
         
         if (phase_count > 1) then
            writes_allowed <= '1';
         else
            writes_allowed <= '0';
         end if;
         write_addr <= write_addr_next;
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

