----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:56:39 09/11/2016 
-- Design Name: 
-- Module Name:    GlyphRom - Behavioral 
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

entity GlyphRom is
   port
   (
      Clock    : in  std_logic;
      Enable   : in  std_logic;
      Address  : in  std_logic_vector(11 downto 0);
      Data     : out std_logic_vector(7 downto 0)
   );
end GlyphRom;

architecture Behavioral of GlyphRom is
   type rom_type is array (0 to 4095) of std_logic_vector (7 downto 0);
   
   impure function InitRomFromFile (RomFileName : in string) return rom_type is
      FILE RomFile : text is in RomFileName;
      variable RomFileLine : line;
      variable ROM : rom_type;
   begin
      for I in rom_type'range loop
         readline (RomFile, RomFileLine);
         read(RomFileLine, ROM(I));
      end loop;
      return ROM;
   end function;
   
   signal rom : rom_type := InitRomFromFile("GlyphRom.txt");
begin

   process (Clock) begin
      if (Clock'event and Clock = '0') then
         if (Enable = '1') then
            Data <= rom(to_integer(unsigned(Address)));
         end if;
      end if;
   end process;

end Behavioral;

