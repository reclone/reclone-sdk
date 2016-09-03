----------------------------------------------------------------------------------
-- Module Name:   AsyncFifo - Behavioral
-- Description:   Implements a first in, first out (FIFO) buffer with separate
--                read and write clocks.  It's a common and necessary memory
--                structure for getting data across clock boundaries.
--                Internally, it uses a dual-port RAM and Gray counters to store
--                the data words and keep track of full/empty status.
--
-- Company:       Reclone Gaming
-- Engineer:      angrylemur
-- License:       BSD 3-clause.  See https://opensource.org/licenses/BSD-3-Clause
-- Credit:        Derived from "Asynchronous FIFO (w/ 2 asynchronous clocks)"
--                by Deepak Kumar Tala and Alexander H Pham.
--                http://www.asic-world.com/examples/vhdl/asyn_fifo.html
--                This implementation is based on the article 
--                 'Asynchronous FIFO in Virtex-II FPGAs'
--                written by Peter Alfke.  This TechXclusive 
--                article can be downloaded from the Xilinx website.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity AsyncFifo is

   generic
   (
      DATA_WIDTH :integer := 8;
      ADDR_WIDTH :integer := 4
   );
   
   port
   (
       -- Reading port.
       DataOut : out std_logic_vector (DATA_WIDTH-1 downto 0);
       Empty   : out std_logic;
       ReadEn  : in  std_logic;
       ReadClk : in  std_logic;
       -- Writing port.
       DataIn  : in  std_logic_vector (DATA_WIDTH-1 downto 0);
       Full    : out std_logic;
       WriteEn : in  std_logic;
       WriteClk: in  std_logic;

       Clear   : in  std_logic
    );
    
end entity;

architecture Behavioral of AsyncFifo is

   constant FIFO_DEPTH :integer := 2**ADDR_WIDTH;

   type RAM is array (integer range <>) of std_logic_vector (DATA_WIDTH-1 downto 0);
   signal mem : RAM (0 to FIFO_DEPTH-1);

   signal next_word_to_write    : std_logic_vector (ADDR_WIDTH-1 downto 0);
   signal next_word_to_read     : std_logic_vector (ADDR_WIDTH-1 downto 0);
   signal equal_addresses       : std_logic;
   signal next_write_address_en : std_logic;
   signal next_read_address_en  : std_logic;
   signal set_status            : std_logic;
   signal rst_status            : std_logic;
   signal status                : std_logic;
   signal preset_full           : std_logic;
   signal preset_empty          : std_logic;
   signal empty_out             : std_logic;
   signal full_out              : std_logic;
   
   
   component GrayCounter is
   generic
   (
      COUNTER_WIDTH :integer := 4
   );
   port
   (
      GrayCount : out std_logic_vector (COUNTER_WIDTH - 1 downto 0);
      Enable    : in  std_logic;
      Clear     : in  std_logic;
      Clk       : in  std_logic
   );
   end component;
   
begin
   --Data ports logic:
   --(Uses a dual-port RAM).
   --'Data_out' logic:
   process (ReadClk) begin
      if (rising_edge(ReadClk)) then
         if (ReadEn = '1' and empty_out = '0') then
            DataOut <= Mem(conv_integer(next_word_to_read));
         end if;
      end if;
   end process;
            
   --'Data_in' logic:
   process (WriteClk) begin
      if (rising_edge(WriteClk)) then
         if (WriteEn = '1' and full_out = '0') then
            Mem(conv_integer(next_word_to_write)) <= DataIn;
         end if;
      end if;
   end process;

   --Fifo addresses support logic: 
   --'Next Addresses' enable logic:
   next_write_address_en <= WriteEn and (not full_out);
   next_read_address_en  <= ReadEn  and (not empty_out);

   --Addreses (Gray counters) logic:
   GrayCounter_pWr : GrayCounter
   port map
   (
      GrayCount => next_word_to_write,
      Enable    => next_write_address_en,
      Clear     => Clear,
      Clk       => WriteClk
   );

   GrayCounter_pRd : GrayCounter
   port map
   (
      GrayCount => next_word_to_read,
      Enable    => next_read_address_en,
      Clear     => Clear,
      Clk       => ReadClk
   );

   --'EqualAddresses' logic:
   equal_addresses <= '1' when (next_word_to_write = next_word_to_read) else '0';

   --'Quadrant selectors' logic:
   process (next_word_to_write, next_word_to_read)
      variable set_status_bit0 :std_logic;
      variable set_status_bit1 :std_logic;
      variable rst_status_bit0 :std_logic;
      variable rst_status_bit1 :std_logic;
   begin
      set_status_bit0 := next_word_to_write(ADDR_WIDTH-2) xnor next_word_to_read(ADDR_WIDTH-1);
      set_status_bit1 := next_word_to_write(ADDR_WIDTH-1) xor  next_word_to_read(ADDR_WIDTH-2);
      set_status <= set_status_bit0 and set_status_bit1;

      rst_status_bit0 := next_word_to_write(ADDR_WIDTH-2) xor  next_word_to_read(ADDR_WIDTH-1);
      rst_status_bit1 := next_word_to_write(ADDR_WIDTH-1) xnor next_word_to_read(ADDR_WIDTH-2);
      rst_status      <= rst_status_bit0 and rst_status_bit1;
   end process;

   --'Status' latch logic:
   process (set_status, rst_status, Clear) begin--D Latch w/ Asynchronous Clear & Preset.
      if (rst_status = '1' or Clear = '1') then
         status <= '0';  --Going 'Empty'.
      elsif (set_status = '1') then
         status <= '1';  --Going 'Full'.
      end if;
   end process;

   --'Full_out' logic for the writing port:
   preset_full <= status and equal_addresses;  --'Full' Fifo.

   process (WriteClk, preset_full) begin --D Flip-Flop w/ Asynchronous Preset.
      if (preset_full = '1') then
         full_out <= '1';
      elsif (rising_edge(WriteClk)) then
         full_out <= '0';
      end if;
   end process;

   Full <= full_out;

   --'Empty_out' logic for the reading port:
   preset_empty <= not status and equal_addresses;  --'Empty' Fifo.

   process (ReadClk, preset_empty) begin --D Flip-Flop w/ Asynchronous Preset.
      if (preset_empty = '1') then
         empty_out <= '1';
      elsif (rising_edge(ReadClk)) then
         empty_out <= '0';
      end if;
   end process;

   Empty <= empty_out;

end architecture;
