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
      ClkA        : in  std_logic;
      WriteEnable : in  std_logic;
      AddrA       : in  std_logic_vector(11 downto 0);
      DataInA     : in  std_logic_vector(15 downto 0);
      DataOutA    : out std_logic_vector(15 downto 0);
      
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
   signal read_addr_a : std_logic_vector(11 downto 0);
   signal read_addr_b : std_logic_vector(11 downto 0);
begin

   process (ClkA) begin
      if (ClkA'event and ClkA = '1') then
         if (WriteEnable = '1') then
            RAM(to_integer(unsigned(AddrA))) <= DataInA;
         end if;
         read_addr_a <= AddrA;
      end if;
   end process;
   
   DataOutA <= RAM(to_integer(unsigned(read_addr_a)));
   
   process (ClkB) begin
      if (ClkB'event and ClkB= '1' ) then
         read_addr_b <= AddrB;
      end if;
   end process;
   
   DataOutB <= RAM(to_integer(unsigned(read_addr_b)));

end Behavioral;

