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

   COMPONENT dvid_out
   PORT(
      pixel_clock     : IN std_logic;
      data_load_clock : IN std_logic;
      ioclock         : IN std_logic;
      serdes_strobe   : IN std_logic;
      red_p : IN std_logic_vector(7 downto 0);
      green_p : IN std_logic_vector(7 downto 0);
      blue_p : IN std_logic_vector(7 downto 0);
      blank : IN std_logic;
      hsync : IN std_logic;
      vsync : IN std_logic;          
      red_s : OUT std_logic;
      green_s : OUT std_logic;
      blue_s : OUT std_logic;
      clock_s : OUT std_logic
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

      

i_dvid_out: dvid_out PORT MAP(
      pixel_clock     => pixel_clock_t,
      data_load_clock => data_load_clock_t,
      ioclock         => ioclock_t,
      serdes_strobe   => serdes_strobe_t,

      red_p           => red_t,
      green_p         => green_t,
      blue_p          => blue_t,
      blank           => blank_t,
      hsync           => hsync_t,
      vsync           => vsync_t,
      
      red_s           => tmds_out_red_t,
      green_s         => tmds_out_green_t,
      blue_s          => tmds_out_blue_t,
      clock_s         => tmds_out_clock_t
   );
   
  
OBUFDS_blue  : OBUFDS port map ( O  => tmds_out_p(0), OB => tmds_out_n(0), I  => tmds_out_blue_t);
OBUFDS_red   : OBUFDS port map ( O  => tmds_out_p(1), OB => tmds_out_n(1), I  => tmds_out_green_t);
OBUFDS_green : OBUFDS port map ( O  => tmds_out_p(2), OB => tmds_out_n(2), I  => tmds_out_red_t);
OBUFDS_clock : OBUFDS port map ( O  => tmds_out_p(3), OB => tmds_out_n(3), I  => tmds_out_clock_t);

end Behavioral;

