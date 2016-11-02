--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:55:54 10/30/2016
-- Design Name:   
-- Module Name:   C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/hdl/reclone_m6_dev/tb_reclone_top.vhd
-- Project Name:  reclone_m6_dev
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reclone_top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_reclone_top IS
END tb_reclone_top;
 
ARCHITECTURE behavior OF tb_reclone_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reclone_top
    PORT(
         Clk50 : IN  std_logic;
         Clk32 : IN  std_logic;
         LEDs : OUT  std_logic_vector(7 downto 0);
         TMDS_Out_P : OUT  std_logic_vector(3 downto 0);
         TMDS_Out_N : OUT  std_logic_vector(3 downto 0);
         Switches : IN  std_logic_vector(3 downto 0);
         FSMC_D : INOUT  std_logic_vector(15 downto 0);
         FSMC_A : IN  std_logic_vector(22 downto 16);
         FSMC_NOE : IN  std_logic;
         FSMC_NWE : IN  std_logic;
         FSMC_NWAIT : IN  std_logic;
         FSMC_NE1_NCE2 : IN  std_logic;
         FSMC_NL : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Clk50 : std_logic := '0';
   signal Clk32 : std_logic := '0';
   signal Switches : std_logic_vector(3 downto 0) := (others => '0');
   signal FSMC_A : std_logic_vector(22 downto 16) := (others => '0');
   signal FSMC_NOE : std_logic := '1';
   signal FSMC_NWE : std_logic := '1';
   signal FSMC_NWAIT : std_logic := '1';
   signal FSMC_NE1_NCE2 : std_logic := '1';
   signal FSMC_NL : std_logic := '1';

	--BiDirs
   signal FSMC_D : std_logic_vector(15 downto 0);

 	--Outputs
   signal LEDs : std_logic_vector(7 downto 0);
   signal TMDS_Out_P : std_logic_vector(3 downto 0);
   signal TMDS_Out_N : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant Clk50_period : time := 10 ns;
   constant Clk32_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reclone_top PORT MAP (
          Clk50 => Clk50,
          Clk32 => Clk32,
          LEDs => LEDs,
          TMDS_Out_P => TMDS_Out_P,
          TMDS_Out_N => TMDS_Out_N,
          Switches => Switches,
          FSMC_D => FSMC_D,
          FSMC_A => FSMC_A,
          FSMC_NOE => FSMC_NOE,
          FSMC_NWE => FSMC_NWE,
          FSMC_NWAIT => FSMC_NWAIT,
          FSMC_NE1_NCE2 => FSMC_NE1_NCE2,
          FSMC_NL => FSMC_NL
        );

   -- Clock process definitions
   Clk50_process :process
   begin
		Clk50 <= '0';
		wait for Clk50_period/2;
		Clk50 <= '1';
		wait for Clk50_period/2;
   end process;
 
   Clk32_process :process
   begin
		Clk32 <= '0';
		wait for Clk32_period/2;
		Clk32 <= '1';
		wait for Clk32_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for Clk50_period*10;

      -- insert stimulus here 
      
      FSMC_NE1_NCE2 <= '0';
      FSMC_D <= (others => '0');
      wait for Clk50_period;
      FSMC_NL <= '0';
      wait for Clk50_period * 4;
      FSMC_NL <= '1';
      wait for Clk50_period * 4;
      FSMC_D <= (others => 'Z');
      FSMC_NOE <= '0';
      wait for Clk50_period * 4;
      FSMC_NOE <= '1';
      wait for Clk50_period * 4;
      FSMC_NE1_NCE2 <= '1';
      

      wait;
   end process;

END;
