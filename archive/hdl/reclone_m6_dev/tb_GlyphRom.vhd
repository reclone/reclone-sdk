--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:51:31 10/30/2016
-- Design Name:   
-- Module Name:   C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/hdl/reclone_m6_dev/tb_GlyphRom.vhd
-- Project Name:  reclone_m6_dev
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: GlyphRom
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
 
ENTITY tb_GlyphRom IS
END tb_GlyphRom;
 
ARCHITECTURE behavior OF tb_GlyphRom IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT GlyphRom
    PORT(
         Clock : IN  std_logic;
         Enable : IN  std_logic;
         Address : IN  std_logic_vector(11 downto 0);
         Data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clock : std_logic := '0';
   signal Enable : std_logic := '0';
   signal Address : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal Data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: GlyphRom PORT MAP (
          Clock => Clock,
          Enable => Enable,
          Address => Address,
          Data => Data
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for Clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
