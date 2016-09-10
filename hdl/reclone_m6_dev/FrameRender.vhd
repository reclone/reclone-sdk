
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FrameRender is
    Port ( RedPix : out  STD_LOGIC_VECTOR (7 downto 0);
           GreenPix : out  STD_LOGIC_VECTOR (7 downto 0);
           BluePix : out  STD_LOGIC_VECTOR (7 downto 0);
           PixelClock : in  STD_LOGIC;
           HPos : in  STD_LOGIC_VECTOR (11 downto 0);
           HRes : in  STD_LOGIC_VECTOR (11 downto 0);
           HMax : in  STD_LOGIC_VECTOR (11 downto 0);
           VPos : in  STD_LOGIC_VECTOR (11 downto 0);
           VRes : in  STD_LOGIC_VECTOR (11 downto 0);
           VMax : in  STD_LOGIC_VECTOR (11 downto 0));
end FrameRender;

architecture Behavioral of FrameRender is
   signal h_pos : natural;
   signal v_pos : natural;
begin

   h_pos <= to_integer(unsigned(HPos));
   v_pos <= to_integer(unsigned(VPos));

   process (PixelClock) begin
      if rising_edge(PixelClock) then
         if (h_pos = 0 or h_pos = 40 or h_pos = 1279 or h_pos = 1240) then
            RedPix <= std_logic_vector(to_unsigned(255, 8));
         else
            RedPix <= (others => '0');
         end if;
         
         if (v_pos = 0 or v_pos = 20 or h_pos = 1279 or h_pos = 1240) then
            GreenPix <= std_logic_vector(to_unsigned(255, 8));
         else
            GreenPix <= (others => '0');
         end if;
         
         if (v_pos = 719 or v_pos = 700) then
            BluePix <= std_logic_vector(to_unsigned(255, 8));
         else
            BluePix <= (others => '0');
         end if;
      end if;

   end process;
   
end Behavioral;

