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
            Switches    : in  STD_LOGIC_VECTOR(3 downto 0);
            
            FSMC_D      : inout STD_LOGIC_VECTOR(15 downto 0);
            FSMC_A      : in  STD_LOGIC_VECTOR(22 downto 16);
            FSMC_NOE    : in  STD_LOGIC;
            FSMC_NWE    : in  STD_LOGIC;
            FSMC_NWAIT  : out  STD_LOGIC;
            FSMC_NE1_NCE2: in STD_LOGIC;
            FSMC_NL     : in  STD_LOGIC;
            FSMC_CLK    : in  STD_LOGIC;
            FSMC_NBL1   : in  STD_LOGIC;
            FSMC_NBL0   : in  STD_LOGIC
         );
end reclone_top;

architecture Behavioral of reclone_top is
   signal count50 : unsigned(25 downto 0) := (others => '0');
   signal count32 : unsigned(25 downto 0) := (others => '0');
   
   signal pixel_clock_t     : std_logic;
   signal data_load_clock_t : std_logic;
   signal ioclock_t         : std_logic;
   signal serdes_strobe_t   : std_logic;
   
   signal red_val   : std_logic_vector(7 downto 0);
   signal green_val   : std_logic_vector(7 downto 0);
   signal blue_val   : std_logic_vector(7 downto 0);
   
   signal h_pos : std_logic_vector(11 downto 0);
   signal h_res : std_logic_vector(11 downto 0);
   signal h_max : std_logic_vector(11 downto 0);
   signal v_pos : std_logic_vector(11 downto 0);
   signal v_res : std_logic_vector(11 downto 0);
   signal v_max : std_logic_vector(11 downto 0);
   
   signal character_data : std_logic_vector(15 downto 0) := "0000000000000000";
   signal character_addr : std_logic_vector(11 downto 0) := "000000000000";
   
   signal textbuf_rst_i : std_logic;
   signal textbuf_clk_i : std_logic;
   signal textbuf_adr_o : std_logic_vector(23 downto 0) := (others => '0');
   signal textbuf_dat_i : std_logic_vector(15 downto 0);
   signal textbuf_dat_o : std_logic_vector(15 downto 0) := (others => '0');
   signal textbuf_we_o  : std_logic := '0';
   signal textbuf_stb_o : std_logic := '0';
   signal textbuf_stall_i : std_logic;
   signal textbuf_ack_i : std_logic;
   signal textbuf_cyc_o : std_logic := '0';

   signal fsmc_addr : std_logic_vector(23 downto 16);
   
   signal fsmc_dbg : std_logic_vector(4 downto 0);

   COMPONENT clocking
   PORT(
      clk32m          : IN  std_logic;
      pixel_clock     : OUT std_logic;
      data_load_clock : OUT std_logic;
      ioclock         : OUT std_logic;
      serdes_strobe   : OUT std_logic
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
   
   component TextRenderer
    port ( RedPix : out  STD_LOGIC_VECTOR (7 downto 0);
           GreenPix : out  STD_LOGIC_VECTOR (7 downto 0);
           BluePix : out  STD_LOGIC_VECTOR (7 downto 0);
           PixelClock : in  STD_LOGIC;
           HPos : in  STD_LOGIC_VECTOR (11 downto 0); -- Next horizontal pixel position
           HRes : in  STD_LOGIC_VECTOR (11 downto 0); -- Horizontal visible resolution
           HMax : in  STD_LOGIC_VECTOR (11 downto 0); -- Max horizontal count
           VPos : in  STD_LOGIC_VECTOR (11 downto 0); -- Next vertical pixel position
           VRes : in  STD_LOGIC_VECTOR (11 downto 0); -- Vertical visible resolution
           VMax : in  STD_LOGIC_VECTOR (11 downto 0);-- Max vertical count
           TextBufAddr : out std_logic_vector(11 downto 0); -- Address output for the text buffer RAM
           TextBufData : in std_logic_vector(15 downto 0) -- Data input for the text buffer RAM
         );
   
   end component;
   
   component PsramInterface
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
   end component;
   
   component TextBuffer
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
   end component;
   
begin

   LEDs(4 downto 0) <= fsmc_dbg;
   LEDs(5) <= '0';

   process(Clk50) begin
      if rising_edge(Clk50) then
         count50 <= count50 + 1;
         LEDs(6)  <= count50(count50'high);      
      end if;
   end process;
   
   process(pixel_clock_t) begin
      if rising_edge(pixel_clock_t) then
         count32 <= count32 + 1;
         LEDs(7)  <= count32(count32'high);      
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
      RedPix => red_val,
      GreenPix => green_val,
      BluePix => blue_val,
      HPos => h_pos,
      HRes => h_res,
      HMax => h_max,
      VPos => v_pos,
      VRes => v_res,
      VMax => v_max,

      TmdsBlueP => TMDS_Out_P(0),
      TmdsBlueN => TMDS_Out_N(0),
      TmdsGreenP => TMDS_Out_P(1),
      TmdsGreenN => TMDS_Out_N(1),
      TmdsRedP => TMDS_Out_P(2),
      TmdsRedN => TMDS_Out_N(2),
      TmdsClockP => TMDS_Out_P(3),
      TmdsClockN => TMDS_Out_N(3)
   );

   renderer : TextRenderer port map
   (
      RedPix => red_val,
      GreenPix => green_val,
      BluePix => blue_val,
      PixelClock => pixel_clock_t,
      HPos => h_pos,
      HRes => h_res,
      HMax => h_max,
      VPos => v_pos,
      VRes => v_res,
      VMax => v_max,
      TextBufAddr => character_addr,
      TextBufData => character_data
   );
   
   text_buffer : TextBuffer port map
   (
      RST_I => '0',
      CLK_I => pixel_clock_t,
      WE_I => textbuf_we_o,
      ADR_I => textbuf_adr_o(11 downto 0),
      DAT_I => textbuf_dat_o,
      DAT_O => textbuf_dat_i,
      SEL_I => '1',
      STB_I => textbuf_stb_o,
      ACK_O => textbuf_ack_i,
      CYC_I => textbuf_cyc_o,
      STALL_O  => textbuf_stall_i,
      ClkB => pixel_clock_t,
      AddrB => character_addr,
      DataOutB => character_data
   );
   
   fsmc_addr(23) <= '0';
   fsmc_addr(22 downto 16) <= FSMC_A(22 downto 16);
   
   psramif : PsramInterface port map
   (
      RST_I => '0',
      CLK_I => pixel_clock_t,
      ADR_O => textbuf_adr_o,
      DAT_I => textbuf_dat_i,
      DAT_O => textbuf_dat_o,
      WE_O => textbuf_we_o,
      STB_O => textbuf_stb_o,
      STALL_I => textbuf_stall_i,
      ACK_I => textbuf_ack_i,
      CYC_O => textbuf_cyc_o,
      FSMC_A => fsmc_addr(23 downto 16),
      FSMC_D => FSMC_D(15 downto 0),
      FSMC_NOE => FSMC_NOE,
      FSMC_NWE => FSMC_NWE,
      FSMC_NE => FSMC_NE1_NCE2,
      FSMC_NL => FSMC_NL,
      FSMC_CLK => FSMC_CLK,
      FSMC_NBL1 => FSMC_NBL1,
      FSMC_NBL0 => FSMC_NBL0,
      FSMC_NWAIT => FSMC_NWAIT,
      dbg => fsmc_dbg
   );

end Behavioral;

