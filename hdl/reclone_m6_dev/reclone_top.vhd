----------------------------------------------------------------------------------
-- Company:       Reclone Gaming
-- Engineer:      angrylemur
-- License:       BSD 3-clause.  See https://opensource.org/licenses/BSD-3-Clause
-- 
-- Module Name:   reclone_top - Behavioral
-- Description:   
--
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

entity reclone_top is
    Port (
            Clk50       : in  STD_LOGIC;
            Clk32       : in  STD_LOGIC;
            LEDs        : out STD_LOGIC_VECTOR(7 downto 0);
            TMDS_Out_P  : out STD_LOGIC_VECTOR(3 downto 0);
            TMDS_Out_N  : out STD_LOGIC_VECTOR(3 downto 0);
            Switches    : in  STD_LOGIC_VECTOR(3 downto 0)
         );
end reclone_top;

architecture Behavioral of reclone_top is
   signal count50 : unsigned(25 downto 0) := (others => '0');
   signal count32 : unsigned(25 downto 0) := (others => '0');
   
   signal pixel_clock_t     : std_logic;
   signal data_load_clock_t : std_logic;
   signal ioclock_t         : std_logic;
   signal serdes_strobe_t   : std_logic;
   
   signal red_mux   : std_logic_vector(7 downto 0);

   signal red_t   : std_logic_vector(7 downto 0);
   signal green_t : std_logic_vector(7 downto 0);
   signal blue_t  : std_logic_vector(7 downto 0);
   signal blank_t : std_logic;
   signal hsync_t : std_logic;
   signal vsync_t : std_logic;

   signal tmds_out_red_t   : std_logic;
   signal tmds_out_green_t : std_logic;
   signal tmds_out_blue_t  : std_logic;
   signal tmds_out_clock_t : std_logic;
   
     COMPONENT vga_gen
   PORT(
      clk75 : IN std_logic;          
      red   : OUT std_logic_vector(7 downto 0);
      green : OUT std_logic_vector(7 downto 0);
      blue  : OUT std_logic_vector(7 downto 0);
      blank : OUT std_logic;
      hsync : OUT std_logic;
      vsync : OUT std_logic;
      pattern  : in STD_LOGIC_VECTOR (3 downto 0)

      );
   END COMPONENT;

   COMPONENT clocking
   PORT(
      clk32m          : IN  std_logic;
      pixel_clock     : OUT std_logic;
      data_load_clock : OUT std_logic;
      ioclock         : OUT std_logic;
      serdes_strobe   : OUT std_logic
      );
   END COMPONENT;

   COMPONENT DvidSer
   PORT(
      PixelClock     : IN std_logic;
      DataLoadClock : IN std_logic;
      IOClock         : IN std_logic;
      SerStrobe   : IN std_logic;
      RedPix : IN std_logic_vector(7 downto 0);
      GreenPix : IN std_logic_vector(7 downto 0);
      BluePix : IN std_logic_vector(7 downto 0);
      Blank : IN std_logic;
      HSync : IN std_logic;
      VSync : IN std_logic;          
      RedSer : OUT std_logic;
      GreenSer : OUT std_logic;
      BlueSer : OUT std_logic;
      ClockSer : OUT std_logic
      );
   END COMPONENT;


   
begin

   process(Clk50) begin
      if rising_edge(Clk50) then
         count50 <= count50 + 1;
         LEDs(3 downto 0)  <= STD_LOGIC_VECTOR(count50(count50'high downto count50'high-3));      
      end if;
   end process;
   
   process(pixel_clock_t) begin
      if rising_edge(pixel_clock_t) then
         count32 <= count32 + 1;
         LEDs(7 downto 4)  <= STD_LOGIC_VECTOR(count32(count32'high downto count32'high-3));      
      end if;
   end process;

Inst_clocking: clocking PORT MAP(
      clk32m          => Clk32,
      pixel_clock     => pixel_clock_t,
      data_load_clock => data_load_clock_t,
      ioclock         => ioclock_t,
      serdes_strobe   => serdes_strobe_t
   );

   
i_vga_gen: vga_gen PORT MAP(
      clk75 => pixel_clock_t,
      red   => green_t,
      green => red_t,
      blue  => blue_t,
      blank => blank_t,
      hsync => hsync_t,
      vsync => vsync_t,
      pattern => Switches
   );

      

i_dvid_out: DvidSer PORT MAP(
      PixelClock     => pixel_clock_t,
      DataLoadClock => data_load_clock_t,
      IOClock         => ioclock_t,
      SerStrobe   => serdes_strobe_t,

      RedPix           => red_t,
      GreenPix         => green_t,
      BluePix          => blue_t,
      Blank           => blank_t,
      HSync           => hsync_t,
      VSync           => vsync_t,
      
      RedSer           => tmds_out_red_t,
      GreenSer         => tmds_out_green_t,
      BlueSer          => tmds_out_blue_t,
      ClockSer         => tmds_out_clock_t
   );
   
  
OBUFDS_blue  : OBUFDS port map ( O  => tmds_out_p(0), OB => tmds_out_n(0), I  => tmds_out_blue_t);
OBUFDS_red   : OBUFDS port map ( O  => tmds_out_p(1), OB => tmds_out_n(1), I  => tmds_out_green_t);
OBUFDS_green : OBUFDS port map ( O  => tmds_out_p(2), OB => tmds_out_n(2), I  => tmds_out_red_t);
OBUFDS_clock : OBUFDS port map ( O  => tmds_out_p(3), OB => tmds_out_n(3), I  => tmds_out_clock_t);

end Behavioral;

