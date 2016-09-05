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

   component DvidGen
   port
   (
      PixelClock     : in  std_logic;
      PixelClockX2   : in  std_logic;
      PixelClockX10  : in  std_logic;
      SerStrobe      : in  std_logic;
      RedPix         : in  std_logic_vector (7 downto 0);
      GreenPix       : in  std_logic_vector (7 downto 0);
      BluePix        : in  std_logic_vector (7 downto 0);
      
      HPos        : out std_logic_vector (11 downto 0);
      HRes        : out std_logic_vector (11 downto 0);
      HMax        : out std_logic_vector (11 downto 0);
      VPos        : out std_logic_vector (11 downto 0);
      VRes        : out std_logic_vector (11 downto 0);
      VMax        : out std_logic_vector (11 downto 0);
      
      TmdsRedP    : out std_logic;
      TmdsRedN    : out std_logic;
      TmdsGreenP  : out std_logic;
      TmdsGreenN  : out std_logic;
      TmdsBlueP   : out std_logic;
      TmdsBlueN   : out std_logic;
      TmdsClockP  : out std_logic;
      TmdsClockN  : out std_logic
   );
   end component;
   
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

   
   Inst_DvidGen : DvidGen port map
   (
      PixelClock => pixel_clock_t,
      PixelClockX2 => data_load_clock_t,
      PixelClockX10 => ioclock_t,
      SerStrobe => serdes_strobe_t,
      RedPix => (others => '0'),
      GreenPix => (others => '0'),
      BluePix => std_logic_vector(to_unsigned(255, 8)),
      HPos => open,
      HRes => open,
      HMax => open,
      VPos => open,
      VRes => open,
      VMax => open,

      TmdsBlueP => TMDS_Out_P(0),
      TmdsBlueN => TMDS_Out_N(0),
      TmdsGreenP => TMDS_Out_P(1),
      TmdsGreenN => TMDS_Out_N(1),
      TmdsRedP => TMDS_Out_P(2),
      TmdsRedN => TMDS_Out_N(2),
      TmdsClockP => TMDS_Out_P(3),
      TmdsClockN => TMDS_Out_N(3)
   );


end Behavioral;

