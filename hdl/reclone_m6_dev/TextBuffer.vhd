----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:06:01 09/10/2016 
-- Design Name: 
-- Module Name:    TextBuffer - Behavioral 
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
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity TextBuffer is
   port
   (
      -- Wishbone slave interface
      RST_I       : in  std_logic;
      CLK_I       : in  std_logic;
      ADR_I       : in  std_logic_vector(12 downto 1);
      DAT_I       : in  std_logic_vector(15 downto 0);
      DAT_O       : out std_logic_vector(15 downto 0);
      WE_I        : in  std_logic;
      SEL_I       : in  std_logic_vector(1 downto 0);
      STB_I       : in  std_logic;
      ACK_O       : out std_logic;
      CYC_I       : in  std_logic;
      
      -- Read-only interface for text renderer
      ClkB        : in  std_logic;
      AddrB       : in  std_logic_vector(11 downto 0);
      DataOutB    : out std_logic_vector(15 downto 0)
   );
end TextBuffer;

architecture Behavioral of TextBuffer is
   
   type ram_type is array (0 to 4095) of std_logic_vector (7 downto 0);
   
   impure function InitRamFromFile (RamFileName : in string; HighByte : in std_logic) return ram_type is
      FILE RamFile : text is in RamFileName;
      variable RamFileLine : line;
      variable RamEntry : std_logic_vector(15 downto 0);
      variable RAM : ram_type;
   begin
      for i in ram_type'range loop
         readline (RamFile, RamFileLine);
         hread (RamFileLine, RamEntry);
         if (HighByte = '1') then
            RAM(i) := RamEntry(15 downto 8);
         else
            RAM(i) := RamEntry(7 downto 0);
         end if;
      end loop;
      return RAM;
   end function;

   signal RAM_H : ram_type := InitRamFromFile("TextBuffer.txt", '1');
   signal RAM_L : ram_type := InitRamFromFile("TextBuffer.txt", '0');
   signal ack_out : std_logic := '0';
   signal dat_a_out : std_logic_vector(15 downto 0) := (others => '0');
   signal dat_b_out : std_logic_vector(15 downto 0) := (others => '0');
   
begin
   
   DAT_O <= dat_a_out;
   ACK_O <= ack_out when (CYC_I = '1' and STB_I = '1') else '0';
   DataOutB <= dat_b_out;
   
   -- Wishbone slave process
   process (CLK_I) begin
      if rising_edge(CLK_I) then
         -- Always read on the rising edge (needed to infer Block RAM)
         dat_a_out <= RAM_H(to_integer(unsigned(ADR_I))) & RAM_L(to_integer(unsigned(ADR_I)));
         
         -- A simple, well-behaved Wishbone slave
         if (RST_I = '1') then
            -- Synchronous reset
            ack_out <= '0';
         else
            if (CYC_I = '1' and STB_I = '1') then
               -- In a bus cycle
               if (WE_I = '1') then
                  -- Write enable is active
                  if (SEL_I(0) = '1') then
                     -- Write low byte
                     RAM_L(to_integer(unsigned(ADR_I))) <= DAT_I(7 downto 0);
                  end if;
                  if (SEL_I(1) = '1') then
                     -- Write high byte
                     RAM_H(to_integer(unsigned(ADR_I))) <= DAT_I(15 downto 8);
                  end if;
               end if;
               -- Tell bus master that we're done reading or writing
               ack_out <= '1';
            elsif (CYC_I = '0' or STB_I = '0') then
               -- We're not done reading or writing
               ack_out <= '0';
            end if;
         end if;
      end if;
   end process;

   -- Text renderer port process
   process (ClkB) begin
      if rising_edge(ClkB) then
         dat_b_out <= RAM_H(to_integer(unsigned(AddrB))) & RAM_L(to_integer(unsigned(AddrB)));
      end if;
   end process;

end Behavioral;

