--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:54:26 09/25/2016
-- Design Name:   
-- Module Name:   C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/hdl/reclone_m6_dev/test/tb_TextBuffer.vhd
-- Project Name:  reclone_m6_dev
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TextBuffer
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
USE ieee.numeric_std.ALL;
 
ENTITY tb_TextBuffer IS
END tb_TextBuffer;
 
ARCHITECTURE behavior OF tb_TextBuffer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TextBuffer
    PORT(
         RST_I : IN  std_logic;
         CLK_I : IN  std_logic;
         ADR_I : IN  std_logic_vector(11 downto 0);
         DAT_I : IN  std_logic_vector(15 downto 0);
         DAT_O : OUT  std_logic_vector(15 downto 0);
         WE_I : IN  std_logic;
         SEL_I : IN  std_logic;
         STB_I : IN  std_logic;
         ACK_O : OUT  std_logic;
         CYC_I : IN  std_logic;
         STALL_O : OUT  std_logic;
         ClkB : IN  std_logic;
         AddrB : IN  std_logic_vector(11 downto 0);
         DataOutB : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RST_I : std_logic := '0';
   signal CLK_I : std_logic := '0';
   signal ADR_I : std_logic_vector(11 downto 0) := (others => '0');
   signal DAT_I : std_logic_vector(15 downto 0) := (others => '0');
   signal WE_I : std_logic := '0';
   signal SEL_I : std_logic := '0';
   signal STB_I : std_logic := '0';
   signal CYC_I : std_logic := '0';
   signal ClkB : std_logic := '0';
   signal AddrB : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal DAT_O : std_logic_vector(15 downto 0);
   signal ACK_O : std_logic;
   signal STALL_O : std_logic;
   signal DataOutB : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_I_period : time := 10 ns;
   constant ClkB_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TextBuffer PORT MAP (
          RST_I => RST_I,
          CLK_I => CLK_I,
          ADR_I => ADR_I,
          DAT_I => DAT_I,
          DAT_O => DAT_O,
          WE_I => WE_I,
          SEL_I => SEL_I,
          STB_I => STB_I,
          ACK_O => ACK_O,
          CYC_I => CYC_I,
          STALL_O => STALL_O,
          ClkB => ClkB,
          AddrB => AddrB,
          DataOutB => DataOutB
        );

   -- Clock process definitions
   CLK_I_process :process
   begin
		CLK_I <= '1';
		wait for CLK_I_period/2;
		CLK_I <= '0';
		wait for CLK_I_period/2;
   end process;
 
   ClkB_process :process
   begin
		ClkB <= '1';
		wait for ClkB_period/2;
		ClkB <= '0';
		wait for ClkB_period/2;
   end process;
 

   -- Stimulus process for Wishbone port
   stim_proc_wb: process
   begin		
      RST_I <= '1';
      SEL_I <= '0';
      -- hold reset state for 100ns.
      wait for CLK_I_period*10;
      RST_I <= '0';

      -- insert stimulus here 
      wait for 1ns;
      
      -- Test pipelined single reads
      for new_addr_wb in 1 to 3 loop
         ADR_I <= std_logic_vector(to_unsigned(new_addr_wb, ADR_I'length));
         STB_I <= '1';
         CYC_I <= '1';
         SEL_I <= '1';
         wait for CLK_I_period;
         ADR_I <= (others => '0');
         STB_I <= '0';
         SEL_I <= '0';
         wait for CLK_I_period;
         CYC_I <= '0';
         wait for CLK_I_period;
      end loop;
      
      -- Test pipelined block read
      STB_I <= '1';
      CYC_I <= '1';
      SEL_I <= '1';
      for new_addr_wb in 1 to 3 loop
         ADR_I <= std_logic_vector(to_unsigned(new_addr_wb, ADR_I'length));
         wait for CLK_I_period;
      end loop;

      STB_I <= '0';
      CYC_I <= '0';
      SEL_I <= '0';

      wait;
   end process;
   
   -- Stimulus process for render port
   stim_proc_render: process
   begin		
      -- hold reset state for 100ns.
      wait for ClkB_period*10;
      
      -- Pretend that addr was generated synchronously on rising edge of clock
      wait for 1ns;
      -- Test reading all the addresses
      for new_addr in 0 to 4095 loop
         AddrB <= std_logic_vector(to_unsigned(new_addr, AddrB'length));
         wait for ClkB_period;
      end loop;

      wait;
   end process;
END;
