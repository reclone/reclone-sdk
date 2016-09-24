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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TextBuffer is
   port
   (
      -- Wishbone slave interface
      RST_I       : in  std_logic;
      CLK_I       : in  std_logic;
      ADR_I       : in  std_logic_vector(11 downto 0);
      DAT_I       : in  std_logic_vector(15 downto 0);
      DAT_O       : out std_logic_vector(15 downto 0);
      WE_I        : in  std_logic;
      SEL_I       : in  std_logic;
      STB_I       : in  std_logic;
      ACK_O       : out std_logic;
      CYC_I       : in  std_logic;
      STALL_O     : out std_logic;
      
      -- Read-only interface for text renderer
      ClkB        : in  std_logic;
      AddrB       : in  std_logic_vector(11 downto 0);
      DataOutB    : out std_logic_vector(15 downto 0)
   );
end TextBuffer;

architecture Behavioral of TextBuffer is
   
   type ram_type is array (0 to 4095) of std_logic_vector (15 downto 0);
   
   impure function InitRamFromFile (RamFileName : in string) return ram_type is
      FILE RamFile : text is in RamFileName;
      variable RamFileLine : line;
      variable RAM : ram_type;
   begin
      for I in ram_type'range loop
         readline (RamFile, RamFileLine);
         hread (RamFileLine, RAM(I));
      end loop;
      return RAM;
   end function;

   
   signal RAM : ram_type := InitRamFromFile("TextBuffer.txt");
   signal ack_out : std_logic := '0';
   signal dat_a_out : std_logic_vector(15 downto 0) := (others => '0');
   signal dat_b_out : std_logic_vector(15 downto 0) := (others => '0');
begin

   process (CLK_I) begin
      if rising_edge(CLK_I) then
         if (RST_I = '1') then
            ack_out <= '0';
         else
            if (SEL_I = '1' and CYC_I = '1' and STB_I = '1') then
               if (WE_I = '1') then
                  RAM(to_integer(unsigned(ADR_I))) <= DAT_I;
               else
                  dat_a_out <= RAM(to_integer(unsigned(ADR_I)));
               end if;
               ack_out <= '1';
            else
               ack_out <= '0';
            end if;
         end if;
      end if;
   end process;
   
   DAT_O <= dat_a_out;
   STALL_O <= '0';
   
   process (ClkB) begin
      if rising_edge(ClkB) then
         dat_b_out <= RAM(to_integer(unsigned(AddrB)));
      end if;
   end process;
   
   DataOutB <= dat_b_out;

end Behavioral;

