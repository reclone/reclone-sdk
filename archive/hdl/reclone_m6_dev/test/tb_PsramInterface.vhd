--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:39:48 09/25/2016
-- Design Name:   
-- Module Name:   C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/hdl/reclone_m6_dev/test/tb_PsramInterface.vhd
-- Project Name:  reclone_m6_dev
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PsramInterface
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
 
ENTITY tb_PsramInterface IS
END tb_PsramInterface;
 
ARCHITECTURE behavior OF tb_PsramInterface IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PsramInterface
    PORT(
         Address : IN  std_logic_vector(23 downto 16);
         AddrData : INOUT  std_logic_vector(15 downto 0);
         NOutputEn : IN  std_logic;
         NWriteEn : IN  std_logic;
         NChipSel : IN  std_logic;
         NAddrValid : IN  std_logic;
         NWait : OUT  std_logic;
         RST_I : IN  std_logic;
         CLK_I : IN  std_logic;
         ADR_O : OUT  std_logic_vector(23 downto 0);
         DAT_I : IN  std_logic_vector(15 downto 0);
         DAT_O : OUT  std_logic_vector(15 downto 0);
         WE_O : OUT  std_logic;
         STB_O : OUT  std_logic;
         STALL_I : IN  std_logic;
         ACK_I : IN  std_logic;
         CYC_O : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Address : std_logic_vector(23 downto 16) := (others => '0');
   signal NOutputEn : std_logic := '1';
   signal NWriteEn : std_logic := '1';
   signal NChipSel : std_logic := '1';
   signal NAddrValid : std_logic := '1';
   signal RST_I : std_logic := '0';
   signal CLK_I : std_logic := '0';
   signal DAT_I : std_logic_vector(15 downto 0) := x"B00B";
   signal STALL_I : std_logic := '0';
   signal ACK_I : std_logic := '0';

	--BiDirs
   signal AddrData : std_logic_vector(15 downto 0);

 	--Outputs
   signal NWait : std_logic;
   signal ADR_O : std_logic_vector(23 downto 0);
   signal DAT_O : std_logic_vector(15 downto 0);
   signal WE_O : std_logic;
   signal STB_O : std_logic;
   signal CYC_O : std_logic;

   -- Clock period definitions
   constant CLK_I_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PsramInterface PORT MAP (
          Address => Address,
          AddrData => AddrData,
          NOutputEn => NOutputEn,
          NWriteEn => NWriteEn,
          NChipSel => NChipSel,
          NAddrValid => NAddrValid,
          NWait => NWait,
          RST_I => RST_I,
          CLK_I => CLK_I,
          ADR_O => ADR_O,
          DAT_I => DAT_I,
          DAT_O => DAT_O,
          WE_O => WE_O,
          STB_O => STB_O,
          STALL_I => STALL_I,
          ACK_I => ACK_I,
          CYC_O => CYC_O
        );

   -- Clock process definitions
   CLK_I_process :process
   begin
		CLK_I <= '1';
		wait for CLK_I_period/2;
		CLK_I <= '0';
		wait for CLK_I_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      RST_I <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_I_period;
      
      RST_I <= '0';

      -- insert stimulus here 
      wait for 1 ns;
      
      -- Read
      Address <= x"5A";
      AddrData <= x"6B7C";
      NAddrValid <= '0';
      NChipSel <= '0';
      
      wait for CLK_I_period*2;
      
      AddrData <= (others => 'Z');
      NAddrValid <= '1';
      
      wait for CLK_I_period;
      
      NOutputEn <= '0';
      
      wait for CLK_I_period*3;
      
      ACK_I <= '1';
      
      wait for CLK_I_period*3;
      
      ACK_I <= '0';
      NOutputEn <= '1';
      NChipSel <= '1';
      
      wait for CLK_I_period;
      
      -- Write
      Address <= x"3D";
      AddrData <= x"4E5F";
      NAddrValid <= '0';
      NChipSel <= '0';
      
      wait for CLK_I_period*2;
      
      NAddrValid <= '1';
      
      wait for CLK_I_period;
      
      AddrData <= x"FACE";
      NWriteEn <= '0';
      
      wait for CLK_I_period*3;
      
      ACK_I <= '1';
      
      wait for CLK_I_period*3;
      
      ACK_I <= '0';
      NWriteEn <= '1';
      NChipSel <= '1';
      
      wait for CLK_I_period;

      wait;
   end process;

END;
