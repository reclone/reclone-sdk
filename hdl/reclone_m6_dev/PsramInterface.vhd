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
use IEEE.NUMERIC_STD.ALL;


entity PsramInterface is
   port
   (
      -- FSMC Asynchronous PSRAM interface with STM32F4
      FSMC_CLK    : in     std_logic;
      FSMC_A      : in     std_logic_vector(23 downto 16);
      FSMC_D      : inout  std_logic_vector(15 downto 0) := (others => 'Z');
      FSMC_NOE    : in     std_logic;
      FSMC_NWE    : in     std_logic;
      FSMC_NE     : in     std_logic;
      FSMC_NL     : in     std_logic;
      FSMC_NBL    : in     std_logic_vector(1 downto 0);
      FSMC_NWAIT  : out    std_logic;
      
      -- Wishbone Master interface
      RST_I       : in  std_logic;
      CLK_I       : in  std_logic;
      ADR_O       : out std_logic_vector(31 downto 1);
      DAT_I       : in  std_logic_vector(15 downto 0);
      DAT_O       : out std_logic_vector(15 downto 0);
      WE_O        : out std_logic := '0';
      STB_O       : out std_logic := '0';
      SEL_O       : out std_logic_vector(1 downto 0) := "00";
      ACK_I       : in  std_logic;
      CYC_O       : out std_logic := '0';
      
      -- LEDs for debug
      dbg         : out std_logic_vector(5 downto 0)
   );
end PsramInterface;

architecture Behavioral of PsramInterface is
   type psram_state_enum is (PSRAM_IDLE, PSRAM_READ, PSRAM_COMPLETE);
   type ram_type is array (0 to 7) of std_logic_vector (7 downto 0);

   signal psram_state      : psram_state_enum := PSRAM_IDLE;
   signal data_out         : std_logic_vector(15 downto 0) := (others => '0');
   signal latched_addr     : std_logic_vector(23 downto 0);
   
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
   
   process (CLK_I) is
   begin
      -- On rising edge of Wishbone clock
      if rising_edge(CLK_I) then

         if (RST_I = '1') then
            -- Synchronous reset
            data_out <= (others => '0');
            FSMC_NWAIT <= '1';
            FSMC_D <= (others => 'Z');
            dbg <= (others => '0');
            ADR_O <= (others => '0');
            DAT_O <= (others => '0');
            WE_O <= '0';
            STB_O <= '0';
            SEL_O <= "00";
            CYC_O <= '0';
            psram_state <= PSRAM_IDLE;
         else
            if (FSMC_NE = '0') then
               -- Chip select is active
               
               -- Latch the address
               if (FSMC_NL = '0') then
                  latched_addr <= FSMC_A & FSMC_D;
                  dbg(5 downto 3) <= FSMC_D(2 downto 0);
               end if;
               
               if (FSMC_NOE = '0') then
                  FSMC_D <= data_out;
               else
                  FSMC_D <= (others => 'Z');
               end if;

               if (FSMC_NL = '1') then
                
                  CYC_O <= '1';
                  STB_O <= '1';
                  ADR_O <= "0000000" & latched_addr;
                  dbg(2 downto 0) <= latched_addr(2 downto 0);
                  data_out <= DAT_I;
                                          
                  if (FSMC_NWE = '0') then
                     WE_O <= '1';
                     SEL_O(1) <= not FSMC_NBL(1);
                     SEL_O(0) <= not FSMC_NBL(0);
                     DAT_O <= FSMC_D;
                  else
                     WE_O <= '0';
                     SEL_O <= "11";
                  end if;
                  
                  if (ACK_I = '1') then
                     FSMC_NWAIT <= '1';
                  else
                     FSMC_NWAIT <= '0';
                  end if;  

               else
                  STB_O <= '0';
                  SEL_O <= "00";
                  CYC_O <= '0';
                  FSMC_NWAIT <= '1';
               end if;
               
               
               
            else
               -- Chip select is inactive
               -- Reset state machine
               FSMC_NWAIT <= '1';
               WE_O <= '0';
               STB_O <= '0';
               SEL_O <= "00";
               CYC_O <= '0';
               psram_state <= PSRAM_IDLE;
               FSMC_D <= (others => 'Z');
            end if;
         end if;
      end if;
   end process;

   
end Behavioral;

