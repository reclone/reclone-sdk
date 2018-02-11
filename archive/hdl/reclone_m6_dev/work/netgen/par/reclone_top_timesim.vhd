--------------------------------------------------------------------------------
-- Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: P.20131013
--  \   \         Application: netgen
--  /   /         Filename: reclone_top_timesim.vhd
-- /___/   /\     Timestamp: Sun Sep 25 12:50:22 2016
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -filter C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/hdl/reclone_m6_dev/iseconfig/filter.filter -intstyle ise -s 3 -pcf reclone_top.pcf -rpw 100 -tpw 0 -ar Structure -tm reclone_top -insert_pp_buffers true -w -dir netgen/par -ofmt vhdl -sim reclone_top.ncd reclone_top_timesim.vhd 
-- Device	: 6slx25ftg256-3 (PRODUCTION 1.23 2013-10-13)
-- Input file	: reclone_top.ncd
-- Output file	: C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\hdl\reclone_m6_dev\work\netgen\par\reclone_top_timesim.vhd
-- # of Entities	: 1
-- Design Name	: reclone_top
-- Xilinx	: C:\Xilinx\14.7\ISE_DS\ISE\
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library SIMPRIM;
use SIMPRIM.VCOMPONENTS.ALL;
use SIMPRIM.VPACKAGE.ALL;

entity reclone_top is
  port (
    Clk50 : in STD_LOGIC := 'X'; 
    Clk32 : in STD_LOGIC := 'X'; 
    Switches : in STD_LOGIC_VECTOR ( 3 downto 0 ); 
    LEDs : out STD_LOGIC_VECTOR ( 7 downto 0 ); 
    TMDS_Out_P : out STD_LOGIC_VECTOR ( 3 downto 0 ); 
    TMDS_Out_N : out STD_LOGIC_VECTOR ( 3 downto 0 ) 
  );
end reclone_top;

architecture Structure of reclone_top is
  signal Inst_DvidGen_blue_level_5_Q : STD_LOGIC; 
  signal Inst_DvidGen_blue_level_6_Q : STD_LOGIC; 
  signal Inst_DvidGen_blue_level_2_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_cy_0_0 : STD_LOGIC; 
  signal N82 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_03 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31 : STD_LOGIC; 
  signal Inst_DvidGen_green_level_2_Q : STD_LOGIC; 
  signal Inst_DvidGen_green_level_5_Q : STD_LOGIC; 
  signal Inst_DvidGen_green_level_6_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_not_ready_yet_inv : STD_LOGIC; 
  signal data_load_clock_t : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_rd_enable_2504 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_ser_in_blue_2_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21 : STD_LOGIC; 
  signal Inst_DvidGen_green_level_7_Q : STD_LOGIC; 
  signal N136_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21 : STD_LOGIC; 
  signal Inst_DvidGen_red_level_5_Q : STD_LOGIC; 
  signal Inst_DvidGen_red_level_7_Q : STD_LOGIC; 
  signal Inst_DvidGen_red_level_6_Q : STD_LOGIC; 
  signal Inst_DvidGen_red_level_2_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_ser_in_blue_4_0 : STD_LOGIC; 
  signal Inst_DvidGen_blank_2524 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525 : STD_LOGIC; 
  signal Inst_DvidGen_hsync_2526 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_3_Q : STD_LOGIC; 
  signal Inst_DvidGen_vsync_2528 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31 : STD_LOGIC; 
  signal pixel_clock_t : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_9_Q : STD_LOGIC; 
  signal renderer_use_foreground_color_0 : STD_LOGIC; 
  signal renderer_Mram_bgcolor23 : STD_LOGIC; 
  signal renderer_Mram_bgcolor7 : STD_LOGIC; 
  signal renderer_Mram_bgcolor15 : STD_LOGIC; 
  signal N63_0 : STD_LOGIC; 
  signal Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_DataOut_25_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_ser_in_red_0_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_ser_in_green_2_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_DataOut_27_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_DataOut_26_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_ser_in_red_2_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_ser_in_green_4_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_DataOut_24_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_ser_in_red_4_0 : STD_LOGIC; 
  signal N80 : STD_LOGIC; 
  signal Inst_DvidGen_blue_level_7_Q : STD_LOGIC; 
  signal N134 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_Q : STD_LOGIC; 
  signal N84 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1 : STD_LOGIC; 
  signal N107 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_06 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_8_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1 : STD_LOGIC; 
  signal N113 : STD_LOGIC; 
  signal N138_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_preset_full_2621 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_going_full_2622 : STD_LOGIC; 
  signal N53 : STD_LOGIC; 
  signal Clk50_BUFGP : STD_LOGIC; 
  signal Mcount_count50_cy_3_Q_2663 : STD_LOGIC; 
  signal Mcount_count50_cy_7_Q_2668 : STD_LOGIC; 
  signal Mcount_count50_cy_11_Q_2673 : STD_LOGIC; 
  signal Mcount_count50_cy_15_Q_2678 : STD_LOGIC; 
  signal Mcount_count50_cy_19_Q_2683 : STD_LOGIC; 
  signal Mcount_count50_cy_23_Q_2688 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_11_GND_9_o_equal_16_o : STD_LOGIC; 
  signal Inst_DvidGen_Mcount_v_next_cy_3_Q_2696 : STD_LOGIC; 
  signal Inst_DvidGen_n0071 : STD_LOGIC; 
  signal Inst_DvidGen_Result_4_0 : STD_LOGIC; 
  signal Inst_DvidGen_Result_6_0 : STD_LOGIC; 
  signal Inst_DvidGen_Mcount_v_next_cy_7_Q_2702 : STD_LOGIC; 
  signal Inst_DvidGen_Result_7_0 : STD_LOGIC; 
  signal Inst_DvidGen_Result_9_0 : STD_LOGIC; 
  signal Inst_DvidGen_Mcount_h_next_cy_3_Q_2710 : STD_LOGIC; 
  signal Inst_DvidGen_Mcount_h_next_cy_7_Q_2712 : STD_LOGIC; 
  signal Mcount_count32_cy_3_Q_2715 : STD_LOGIC; 
  signal Mcount_count32_cy_7_Q_2720 : STD_LOGIC; 
  signal Mcount_count32_cy_11_Q_2725 : STD_LOGIC; 
  signal Mcount_count32_cy_15_Q_2730 : STD_LOGIC; 
  signal Mcount_count32_cy_19_Q_2735 : STD_LOGIC; 
  signal Mcount_count32_cy_23_Q_2740 : STD_LOGIC; 
  signal Switches_0_IBUF_0 : STD_LOGIC; 
  signal Switches_1_IBUF_0 : STD_LOGIC; 
  signal Switches_2_IBUF_0 : STD_LOGIC; 
  signal Switches_3_IBUF_0 : STD_LOGIC; 
  signal Inst_DvidGen_OBUFDS_blue_SLAVEBUF_DIFFOUT : STD_LOGIC; 
  signal Inst_DvidGen_OBUFDS_green_SLAVEBUF_DIFFOUT : STD_LOGIC; 
  signal Inst_DvidGen_OBUFDS_red_SLAVEBUF_DIFFOUT : STD_LOGIC; 
  signal Inst_DvidGen_OBUFDS_clock_SLAVEBUF_DIFFOUT : STD_LOGIC; 
  signal Inst_DvidGen_tmds_out_blue : STD_LOGIC; 
  signal Inst_DvidGen_tmds_out_green : STD_LOGIC; 
  signal Inst_DvidGen_tmds_out_red : STD_LOGIC; 
  signal Inst_DvidGen_tmds_out_clock : STD_LOGIC; 
  signal Clk32_IBUFG_0 : STD_LOGIC; 
  signal Clk50_BUFGP_IBUFG_0 : STD_LOGIC; 
  signal LEDs_0_2758 : STD_LOGIC; 
  signal LEDs_1_2759 : STD_LOGIC; 
  signal LEDs_2_2760 : STD_LOGIC; 
  signal LEDs_3_2761 : STD_LOGIC; 
  signal LEDs_4_2762 : STD_LOGIC; 
  signal LEDs_5_2763 : STD_LOGIC; 
  signal LEDs_6_2764 : STD_LOGIC; 
  signal LEDs_7_2765 : STD_LOGIC; 
  signal ioclock_t : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_cascade3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_cascade4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_cascade2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_cascade1 : STD_LOGIC; 
  signal serdes_strobe_t : STD_LOGIC; 
  signal Inst_clocking_clk32m_buffered : STD_LOGIC; 
  signal Inst_clocking_clk_s1_feedback : STD_LOGIC; 
  signal Inst_clocking_clk25p6m_unbuffered : STD_LOGIC; 
  signal Inst_clocking_clk25p6m_buffered : STD_LOGIC; 
  signal Inst_clocking_clk_s2_feedback : STD_LOGIC; 
  signal Inst_clocking_pll_s2_locked : STD_LOGIC; 
  signal Inst_clocking_clock_x1_unbuffered : STD_LOGIC; 
  signal Inst_clocking_clock_x2_unbuffered : STD_LOGIC; 
  signal Inst_clocking_clock_x10_unbuffered : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_cascade3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_cascade4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_cascade2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_cascade1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_cascade3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_cascade4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_cascade2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_cascade1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_cascade3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_cascade4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_cascade2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_cascade1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_1_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_0_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_2_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_6_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_5_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_4_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_4_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_7_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_6_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_8_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_8_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_1_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_10_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_3_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_12_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_6_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_5_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_14_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_4_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_7_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_16_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_9_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_18_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_1_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_20_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_3_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_22_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_6_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_5_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_24_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_4_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_7_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_26_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_9_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_28_0 : STD_LOGIC; 
  signal N34 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_empty_out_2848 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_going_empty_2849 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_06 : STD_LOGIC; 
  signal N146 : STD_LOGIC; 
  signal N49 : STD_LOGIC; 
  signal Inst_DvidGen_n00712_2856 : STD_LOGIC; 
  signal Inst_DvidGen_n00711_2857 : STD_LOGIC; 
  signal N19 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1 : STD_LOGIC; 
  signal N128 : STD_LOGIC; 
  signal N132 : STD_LOGIC; 
  signal N130 : STD_LOGIC; 
  signal Inst_DvidGen_GND_9_o_h_count_11_LessThan_9_o : STD_LOGIC; 
  signal Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o : STD_LOGIC; 
  signal Inst_DvidGen_v_count_11_GND_9_o_LessThan_12_o : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_full_out_2886 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_06 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_preset_empty_2889 : STD_LOGIC; 
  signal Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o1 : STD_LOGIC; 
  signal N47 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1 : STD_LOGIC; 
  signal N114 : STD_LOGIC; 
  signal N57 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_O_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_O_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_O_0 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_O_0 : STD_LOGIC; 
  signal N101 : STD_LOGIC; 
  signal N40 : STD_LOGIC; 
  signal N105 : STD_LOGIC; 
  signal N150 : STD_LOGIC; 
  signal N32 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_2 : STD_LOGIC; 
  signal N17 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_2 : STD_LOGIC; 
  signal N61 : STD_LOGIC; 
  signal N59 : STD_LOGIC; 
  signal N103 : STD_LOGIC; 
  signal Inst_DvidGen_v_count_11_GND_9_o_LessThan_12_o11_2910 : STD_LOGIC; 
  signal N108 : STD_LOGIC; 
  signal N110 : STD_LOGIC; 
  signal N111 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_O_0 : STD_LOGIC; 
  signal Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o1_2916 : STD_LOGIC; 
  signal Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o_0 : STD_LOGIC; 
  signal N148 : STD_LOGIC; 
  signal N4 : STD_LOGIC; 
  signal Inst_DvidGen_h_count_11_GND_9_o_LessThan_10_o1 : STD_LOGIC; 
  signal renderer_hpos_latched_3_inv : STD_LOGIC; 
  signal renderer_character_rom_Mram_rom1_INV_renderer_character_rom_Mram_rom1CLKA : STD_LOGIC; 
  signal renderer_character_rom_Mram_rom2_INV_renderer_character_rom_Mram_rom2CLKA : STD_LOGIC; 
  signal count50_2_rt_263 : STD_LOGIC; 
  signal count50_1_rt_259 : STD_LOGIC; 
  signal count50_3_rt_251 : STD_LOGIC; 
  signal ProtoComp25_CYINITGND_0 : STD_LOGIC; 
  signal count50_7_rt_294 : STD_LOGIC; 
  signal count50_6_rt_282 : STD_LOGIC; 
  signal count50_5_rt_275 : STD_LOGIC; 
  signal count50_4_rt_274 : STD_LOGIC; 
  signal count50_11_rt_321 : STD_LOGIC; 
  signal count50_10_rt_309 : STD_LOGIC; 
  signal count50_9_rt_302 : STD_LOGIC; 
  signal count50_8_rt_301 : STD_LOGIC; 
  signal count50_15_rt_348 : STD_LOGIC; 
  signal count50_14_rt_336 : STD_LOGIC; 
  signal count50_13_rt_329 : STD_LOGIC; 
  signal count50_12_rt_328 : STD_LOGIC; 
  signal count50_19_rt_375 : STD_LOGIC; 
  signal count50_18_rt_363 : STD_LOGIC; 
  signal count50_17_rt_356 : STD_LOGIC; 
  signal count50_16_rt_355 : STD_LOGIC; 
  signal count50_23_rt_402 : STD_LOGIC; 
  signal count50_22_rt_390 : STD_LOGIC; 
  signal count50_21_rt_383 : STD_LOGIC; 
  signal count50_20_rt_382 : STD_LOGIC; 
  signal count50_24_rt_417 : STD_LOGIC; 
  signal count50_25_rt_414 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_1_rt_439 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_2_rt_435 : STD_LOGIC; 
  signal ProtoComp28_CYINITGND_0 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_3_rt_423 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_4_rt_469 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_5_rt_466 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_6_rt_462 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_7_rt_451 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_8_rt_495 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_9_rt_491 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_10_rt_488 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_11_rt_478 : STD_LOGIC; 
  signal count32_0_rt_520 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_1_rt_517 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_2_rt_513 : STD_LOGIC; 
  signal Inst_DvidGen_Result_1_1 : STD_LOGIC; 
  signal Inst_DvidGen_Result_2_1 : STD_LOGIC; 
  signal Inst_DvidGen_Result_3_1 : STD_LOGIC; 
  signal ProtoComp31_CYINITGND_0 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_3_rt_503 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_4_rt_548 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_5_rt_544 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_6_rt_540 : STD_LOGIC; 
  signal Inst_DvidGen_Result_4_1 : STD_LOGIC; 
  signal Inst_DvidGen_Result_5_1 : STD_LOGIC; 
  signal Inst_DvidGen_Result_6_1 : STD_LOGIC; 
  signal Inst_DvidGen_Result_7_1 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_7_rt_529 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_8_rt_569 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_9_rt_565 : STD_LOGIC; 
  signal Inst_DvidGen_h_next_10_rt_562 : STD_LOGIC; 
  signal Inst_DvidGen_Result_8_1 : STD_LOGIC; 
  signal Inst_DvidGen_Result_9_1 : STD_LOGIC; 
  signal Inst_DvidGen_Result_10_1 : STD_LOGIC; 
  signal Result_3_1 : STD_LOGIC; 
  signal Result_2_1 : STD_LOGIC; 
  signal Result_1_1 : STD_LOGIC; 
  signal Result_0_1 : STD_LOGIC; 
  signal count32_2_rt_590 : STD_LOGIC; 
  signal count32_1_rt_586 : STD_LOGIC; 
  signal Mcount_count32_lut_0_1 : STD_LOGIC; 
  signal count32_3_rt_578 : STD_LOGIC; 
  signal count32_3_ProtoComp25_CYINITGND_0 : STD_LOGIC; 
  signal count32_7_rt_621 : STD_LOGIC; 
  signal Result_7_1 : STD_LOGIC; 
  signal Result_6_1 : STD_LOGIC; 
  signal Result_5_1 : STD_LOGIC; 
  signal Result_4_1 : STD_LOGIC; 
  signal count32_6_rt_609 : STD_LOGIC; 
  signal count32_5_rt_602 : STD_LOGIC; 
  signal count32_4_rt_601 : STD_LOGIC; 
  signal count32_11_rt_648 : STD_LOGIC; 
  signal Result_11_1 : STD_LOGIC; 
  signal Result_10_1 : STD_LOGIC; 
  signal Result_9_1 : STD_LOGIC; 
  signal Result_8_1 : STD_LOGIC; 
  signal count32_10_rt_636 : STD_LOGIC; 
  signal count32_9_rt_629 : STD_LOGIC; 
  signal count32_8_rt_628 : STD_LOGIC; 
  signal count32_15_rt_675 : STD_LOGIC; 
  signal Result_15_1 : STD_LOGIC; 
  signal Result_14_1 : STD_LOGIC; 
  signal Result_13_1 : STD_LOGIC; 
  signal Result_12_1 : STD_LOGIC; 
  signal count32_14_rt_663 : STD_LOGIC; 
  signal count32_13_rt_656 : STD_LOGIC; 
  signal count32_12_rt_655 : STD_LOGIC; 
  signal count32_19_rt_702 : STD_LOGIC; 
  signal Result_19_1 : STD_LOGIC; 
  signal Result_18_1 : STD_LOGIC; 
  signal Result_17_1 : STD_LOGIC; 
  signal Result_16_1 : STD_LOGIC; 
  signal count32_18_rt_690 : STD_LOGIC; 
  signal count32_17_rt_683 : STD_LOGIC; 
  signal count32_16_rt_682 : STD_LOGIC; 
  signal count32_23_rt_729 : STD_LOGIC; 
  signal Result_23_1 : STD_LOGIC; 
  signal Result_22_1 : STD_LOGIC; 
  signal Result_21_1 : STD_LOGIC; 
  signal Result_20_1 : STD_LOGIC; 
  signal count32_22_rt_717 : STD_LOGIC; 
  signal count32_21_rt_710 : STD_LOGIC; 
  signal count32_20_rt_709 : STD_LOGIC; 
  signal count32_24_rt_744 : STD_LOGIC; 
  signal count32_25_rt_741 : STD_LOGIC; 
  signal Result_24_1 : STD_LOGIC; 
  signal Result_25_1 : STD_LOGIC; 
  signal Switches_0_IBUF_749 : STD_LOGIC; 
  signal Switches_1_IBUF_752 : STD_LOGIC; 
  signal Switches_2_IBUF_755 : STD_LOGIC; 
  signal Switches_3_IBUF_758 : STD_LOGIC; 
  signal Clk32_IBUFG_781 : STD_LOGIC; 
  signal Clk50_BUFGP_IBUFG_784 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_SHIFTOUT4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_SHIFTOUT3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_TQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_SHIFTIN2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_CLK0_INT : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_SHIFTIN1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO0 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO2 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO3 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO4 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO5 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO6 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO7 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO8 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO9 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO10 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO11 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO12 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO13 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO14 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO15 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_LOCKED : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM0 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUT2 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUT4 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKFBDCM : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM5 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DRDY : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM2 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUT5 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUT1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM4 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM3 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUT3 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI0 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI2 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI3 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI4 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI5 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI6 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI7 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI8 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI9 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI10 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI11 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI12 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI13 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI14 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI15 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DADDR0 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DADDR1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DADDR2 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DADDR3 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DADDR4 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKIN1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DWE : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_RST_INT : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DEN : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DCLK : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKFBIN_INT : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO0 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO2 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO3 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO4 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO5 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO6 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO7 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO8 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO9 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO10 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO11 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO12 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO13 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO14 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DO15 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM0 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUT4 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKFBDCM : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM5 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DRDY : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM2 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUT5 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM4 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM3 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUT3 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI0 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI2 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI3 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI4 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI5 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI6 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI7 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI8 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI9 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI10 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI11 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI12 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI13 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI14 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DI15 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DADDR0 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DADDR1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DADDR2 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DADDR3 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DADDR4 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKIN1 : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DWE : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_RST_INT : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DEN : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_DCLK : STD_LOGIC; 
  signal Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKFBIN_INT : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_SHIFTOUT2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_OQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_TQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_SHIFTOUT1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_CLK0_INT : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_SHIFTIN3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_SHIFTIN4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_SHIFTOUT4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_SHIFTOUT3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_TQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_SHIFTIN2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_CLK0_INT : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_SHIFTIN1 : STD_LOGIC; 
  signal Inst_clocking_BUFPLL_inst_LOCK : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_SHIFTOUT4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_SHIFTOUT3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_TQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_SHIFTIN2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_CLK0_INT : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_SHIFTIN1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_SHIFTOUT2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_OQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_TQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_SHIFTOUT1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_CLK0_INT : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_SHIFTIN3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_SHIFTIN4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_SHIFTOUT4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_SHIFTOUT3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_TQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_SHIFTIN2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_CLK0_INT : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_SHIFTIN1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_SHIFTOUT2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_OQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_TQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_SHIFTOUT1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_CLK0_INT : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_SHIFTIN3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_SHIFTIN4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_SHIFTOUT2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_OQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_TQ : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_SHIFTOUT1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_CLK0_INT : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_SHIFTIN3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_SHIFTIN4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd6_cy_0_pack_5 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111 : STD_LOGIC; 
  signal red_val_3_Q : STD_LOGIC; 
  signal red_val_0_Q : STD_LOGIC; 
  signal N63 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_0_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_0_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_2_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_1_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_4_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_3_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_lut_1_pack_9 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_7_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_8_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_06_pack_10 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_6_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_9_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_O : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_O : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_O : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_O : STD_LOGIC; 
  signal red_val_4_Q : STD_LOGIC; 
  signal red_val_7_Q : STD_LOGIC; 
  signal N138 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_0_pack_2 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_5_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_4_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_1_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_3_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_2_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_1_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_0_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_3_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_4_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_5_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_4_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_1_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_3_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_9_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_8_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_7_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_6_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_24_rt_1607 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_27_rt_1597 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_25_rt_1592 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035_26_rt_1588 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_rd_enable_INV_46_o : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_2_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_1_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_4_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_3_Q : STD_LOGIC; 
  signal N134_pack_9 : STD_LOGIC; 
  signal green_val_4_Q : STD_LOGIC; 
  signal blue_val_0_Q : STD_LOGIC; 
  signal N105_pack_8 : STD_LOGIC; 
  signal green_val_7_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_7_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_8_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1_pack_8 : STD_LOGIC; 
  signal N53_pack_4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_2_pack_6 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_GND_19_o_xor_1_OUT_2_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_GND_19_o_xor_1_OUT_1_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_pack_3 : STD_LOGIC; 
  signal green_val_3_Q : STD_LOGIC; 
  signal blue_val_3_Q : STD_LOGIC; 
  signal N61_pack_7 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21 : STD_LOGIC; 
  signal blue_val_7_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111 : STD_LOGIC; 
  signal blue_val_4_Q : STD_LOGIC; 
  signal green_val_0_Q : STD_LOGIC; 
  signal N103_pack_9 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_4_glue_rst_1993 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_6_glue_rst_1981 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_7_glue_rst_1979 : STD_LOGIC; 
  signal Inst_DvidGen_v_next_9_glue_rst_1967 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_5_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_6_Q : STD_LOGIC; 
  signal N153 : STD_LOGIC; 
  signal N152 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_4_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd6_cy_0_pack_9 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_O : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_going_full_rstpot_2132 : STD_LOGIC; 
  signal Inst_DvidGen_vsync_rstpot_2182 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd6_cy_0_pack_5 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_1_Q : STD_LOGIC; 
  signal N148_pack_12 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_9_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_3_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_cy_0_pack_8 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_going_empty_rstpot_2264 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_0_pack_4 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_GND_19_o_xor_1_OUT_1_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_GND_19_o_xor_1_OUT_2_Q : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Result_1_1_2301 : STD_LOGIC; 
  signal Inst_DvidGen_h_count_10_pack_4 : STD_LOGIC; 
  signal Inst_DvidGen_hsync_Inst_DvidGen_h_next_10_rt_2382 : STD_LOGIC; 
  signal Inst_DvidGen_hsync_rstpot_2381 : STD_LOGIC; 
  signal N136 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Result_0_1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_pack_3 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Result_3_1 : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_out_fifo_Result_2_1 : STD_LOGIC; 
  signal renderer_Mmux_use_foreground_color_3_2426 : STD_LOGIC; 
  signal renderer_Mmux_use_foreground_color_4_2417 : STD_LOGIC; 
  signal renderer_use_foreground_color : STD_LOGIC; 
  signal Inst_DvidGen_dvid_ser_ser_in_clock_4_rstpot_2439 : STD_LOGIC; 
  signal NlwBufferSignal_renderer_text_buffer_Mram_RAM1_CLKB : STD_LOGIC; 
  signal NlwBufferSignal_renderer_text_buffer_Mram_RAM2_CLKB : STD_LOGIC; 
  signal NlwBufferSignal_renderer_text_buffer_Mram_RAM3_CLKB : STD_LOGIC; 
  signal NlwBufferSignal_renderer_text_buffer_Mram_RAM4_CLKB : STD_LOGIC; 
  signal NlwBufferSignal_renderer_character_rom_Mram_rom1_CLKA : STD_LOGIC; 
  signal NlwBufferSignal_renderer_character_rom_Mram_rom2_CLKA : STD_LOGIC; 
  signal NlwBufferSignal_count50_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_11_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_10_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_9_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_8_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_15_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_14_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_13_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_12_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_19_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_18_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_17_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_16_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_23_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_22_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_21_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_20_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_25_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count50_24_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_11_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_10_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_8_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_next_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_next_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_next_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_next_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_next_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_next_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_next_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_next_10_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_next_9_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_next_8_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_11_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_10_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_9_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_8_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_15_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_14_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_13_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_12_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_19_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_18_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_17_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_16_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_23_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_22_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_21_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_20_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_25_CLK : STD_LOGIC; 
  signal NlwBufferSignal_count32_24_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_OBUFDS_blue_OBUFDS_I : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_OBUFDS_green_OBUFDS_I : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_OBUFDS_red_OBUFDS_I : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_OBUFDS_clock_OBUFDS_I : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_0_OBUF_I : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_1_OBUF_I : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_2_OBUF_I : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_3_OBUF_I : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_4_OBUF_I : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_5_OBUF_I : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_6_OBUF_I : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_7_OBUF_I : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_CLKDIV : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_D1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKIN2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_clocking_BUFG_clk25p6m_IN : STD_LOGIC; 
  signal NlwBufferSignal_Clk50_BUFGP_BUFG_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKIN2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_CLKDIV : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D4 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_clocking_BUFG_pclockx2_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_CLKDIV : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_D1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_clocking_BUFPLL_inst_PLLIN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_clocking_BUFPLL_inst_GCLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_clocking_BUFPLL_inst_LOCKED : STD_LOGIC; 
  signal NlwBufferSignal_Inst_clocking_BUFG_clk32m_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_clocking_BUFG_pclock_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_CLKDIV : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_D1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_CLKDIV : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D4 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_CLKDIV : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_D1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_CLKDIV : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D4 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_CLKDIV : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D4 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_red_level_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_red_level_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_8_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_9_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_7_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_6_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_5_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_4_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_23_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_23_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_22_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_22_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_21_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_21_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_20_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_20_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_29_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_29_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_28_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_28_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_red_level_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_red_level_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_11_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_11_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_10_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_10_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_9_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_9_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_8_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_8_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_9_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_27_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_18_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_18_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_26_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_17_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_17_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_25_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_16_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_16_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_24_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_15_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_15_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_14_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_14_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_13_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_13_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_12_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_12_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_rd_enable_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_green_level_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_blue_level_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_green_level_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_8_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_3_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_empty_out_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_blue_level_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_green_level_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_blue_level_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_green_level_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_blue_level_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_full_out_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_9_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_next_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR0 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR1 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR2 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR3 : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_3_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_2_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_0_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_going_full_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_7_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_6_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_5_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_4_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_blank_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_vsync_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_9_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_going_empty_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_11_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_11_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_10_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_10_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_9_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_9_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_8_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_8_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_7_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_6_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_5_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_4_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_3_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_2_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_1_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_v_count_0_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_hsync_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_10_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_9_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_9_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_8_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_h_count_8_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_renderer_hpos_latched_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_renderer_hpos_latched_3_IN : STD_LOGIC; 
  signal NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_clock_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_7_CLK : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_7_IN : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_6_CLK : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_6_IN : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_5_CLK : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_5_IN : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_4_CLK : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_4_IN : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_3_CLK : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_3_IN : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_2_CLK : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_2_IN : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_1_CLK : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_1_IN : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_0_CLK : STD_LOGIC; 
  signal NlwBufferSignal_LEDs_0_IN : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_ADDRA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_ADDRA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_ADDRB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_ADDRB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DIPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM1_DOPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_ADDRA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_ADDRA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_ADDRB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_ADDRB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DIPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM2_DOPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_ADDRA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_ADDRA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_ADDRB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_ADDRB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DIPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM3_DOPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_ADDRA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_ADDRA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_ADDRB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_ADDRB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DIPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_text_buffer_Mram_RAM4_DOPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ADDRB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_CLKB_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DIPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_DOPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_ENB_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_REGCEB_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_RSTB_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_WEB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_WEB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_WEB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom1_WEB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ADDRB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_CLKB_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DIPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOA_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_10_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_11_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_12_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_13_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_14_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_15_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_16_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_17_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_18_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_19_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_20_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_21_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_22_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_23_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_24_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_25_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_26_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_27_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_28_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_29_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_30_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_31_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_4_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_5_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_6_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_7_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_8_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOB_9_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOPA_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOPA_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOPA_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOPA_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOPB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOPB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOPB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_DOPB_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_ENB_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_REGCEB_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_RSTB_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_WEB_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_WEB_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_WEB_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_renderer_character_rom_Mram_rom2_WEB_3_UNCONNECTED : STD_LOGIC; 
  signal VCC : STD_LOGIC; 
  signal GND : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_5_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_3_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_3_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_3_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_4_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_3_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_N0_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_9_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_7_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_7_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_7_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_8_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_7_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_6_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_13_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_11_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_11_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_11_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_12_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_11_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_10_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_17_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_15_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_15_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_15_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_16_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_15_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_14_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_21_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_19_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_19_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_19_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_20_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_19_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_18_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_25_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_23_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_23_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_cy_23_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_24_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_23_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_22_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_CO_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_DI_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_DI_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_DI_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_O_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_O_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_S_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count50_xor_25_S_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_26_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_60_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_cy_3_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_cy_3_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_cy_3_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_61_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_62_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_N0_3_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_56_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_cy_7_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_cy_7_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_cy_7_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_57_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_58_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_59_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_xor_11_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_xor_11_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_xor_11_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_xor_11_CO_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_v_next_xor_11_DI_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_53_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_54_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_55_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_71_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_cy_3_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_cy_3_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_cy_3_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_cy_3_O_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_72_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_73_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_N0_4_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_67_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_cy_7_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_cy_7_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_cy_7_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_68_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_69_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_70_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_xor_10_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_xor_10_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_xor_10_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_xor_10_CO_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_xor_10_DI_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_xor_10_DI_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_xor_10_O_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_Mcount_h_next_xor_10_S_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_65_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_66_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_31_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_3_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_3_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_3_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_30_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_29_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_N0_2_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_35_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_7_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_7_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_7_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_34_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_33_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_32_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_39_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_11_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_11_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_11_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_38_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_37_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_36_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_43_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_15_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_15_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_15_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_42_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_41_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_40_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_47_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_19_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_19_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_19_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_46_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_45_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_44_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_51_D5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_23_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_23_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_cy_23_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_50_C5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_49_B5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_48_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_CO_0_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_CO_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_CO_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_CO_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_DI_1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_DI_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_DI_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_O_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_O_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_S_2_UNCONNECTED : STD_LOGIC; 
  signal NLW_Mcount_count32_xor_25_S_3_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_52_A5LUT_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_CLK1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_REL_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_clocking_PLL_BASE_inst_PLL_ADV_REL_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_CLK1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_CLK1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_CLK1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_CLK1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_CLK1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_CLK1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_CLK1_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_O_UNCONNECTED : STD_LOGIC; 
  signal NLW_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_O_UNCONNECTED : STD_LOGIC; 
  signal NlwRenamedSig_IO_Switches : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_lut : STD_LOGIC_VECTOR ( 1 downto 1 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_data_word_inv : STD_LOGIC_VECTOR ( 7 downto 7 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_lut : STD_LOGIC_VECTOR ( 1 downto 1 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_cy : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_out_fifo_DataOut : STD_LOGIC_VECTOR ( 29 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_ser_in_blue : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal renderer_character_data : STD_LOGIC_VECTOR ( 11 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_ser_in_green : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_ser_in_red : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_data_word_inv : STD_LOGIC_VECTOR ( 7 downto 7 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_lut : STD_LOGIC_VECTOR ( 1 downto 1 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_cy : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd6_cy : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_cy : STD_LOGIC_VECTOR ( 1 downto 1 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd6_cy : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Inst_DvidGen_v_next : STD_LOGIC_VECTOR ( 11 downto 0 ); 
  signal Inst_DvidGen_h_next : STD_LOGIC_VECTOR ( 10 downto 1 ); 
  signal renderer_glyph_row : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal Inst_DvidGen_v_count : STD_LOGIC_VECTOR ( 11 downto 0 ); 
  signal count50 : STD_LOGIC_VECTOR ( 25 downto 0 ); 
  signal count32 : STD_LOGIC_VECTOR ( 25 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_ser_in_clock : STD_LOGIC_VECTOR ( 4 downto 4 ); 
  signal Inst_DvidGen_dvid_ser_out_fifo_n0035 : STD_LOGIC_VECTOR ( 29 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_xored : STD_LOGIC_VECTOR ( 5 downto 5 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_cy : STD_LOGIC_VECTOR ( 1 downto 1 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_xored : STD_LOGIC_VECTOR ( 5 downto 5 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_cy : STD_LOGIC_VECTOR ( 1 downto 1 ); 
  signal Inst_DvidGen_h_count : STD_LOGIC_VECTOR ( 10 downto 4 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd6_cy : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_lut : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal renderer_hpos_latched : STD_LOGIC_VECTOR ( 3 downto 3 ); 
  signal Result : STD_LOGIC_VECTOR ( 25 downto 0 ); 
  signal Mcount_count50_lut : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Inst_DvidGen_Mcount_v_next_lut : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Inst_DvidGen_Result : STD_LOGIC_VECTOR ( 11 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_red_Result : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Result : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_cy : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_TMDS_encoder_green_Result : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal Inst_DvidGen_dvid_ser_out_fifo_Result : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB : STD_LOGIC_VECTOR ( 13 downto 2 ); 
  signal NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB : STD_LOGIC_VECTOR ( 13 downto 2 ); 
  signal NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB : STD_LOGIC_VECTOR ( 13 downto 2 ); 
  signal NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB : STD_LOGIC_VECTOR ( 13 downto 2 ); 
  signal NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA : STD_LOGIC_VECTOR ( 13 downto 2 ); 
  signal NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA : STD_LOGIC_VECTOR ( 13 downto 2 ); 
begin
  NlwRenamedSig_IO_Switches(3) <= Switches(3);
  NlwRenamedSig_IO_Switches(2) <= Switches(2);
  NlwRenamedSig_IO_Switches(1) <= Switches(1);
  NlwRenamedSig_IO_Switches(0) <= Switches(0);
  TMDS_Out_N(3) <= Inst_DvidGen_OBUFDS_clock_SLAVEBUF_DIFFOUT;
  TMDS_Out_N(2) <= Inst_DvidGen_OBUFDS_red_SLAVEBUF_DIFFOUT;
  TMDS_Out_N(1) <= Inst_DvidGen_OBUFDS_green_SLAVEBUF_DIFFOUT;
  TMDS_Out_N(0) <= Inst_DvidGen_OBUFDS_blue_SLAVEBUF_DIFFOUT;
  renderer_text_buffer_Mram_RAM1 : X_RAMB16BWER
    generic map(
      DATA_WIDTH_A => 4,
      DATA_WIDTH_B => 4,
      DOA_REG => 0,
      DOB_REG => 0,
      EN_RSTRAM_A => TRUE,
      EN_RSTRAM_B => TRUE,
      RST_PRIORITY_A => "CE",
      RST_PRIORITY_B => "CE",
      RSTTYPE => "SYNC",
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_00 => X"00000000000000000000000000000000FEDCBA9876543210FEDCBA9876543210",
      INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02 => X"00000000000000000000000000000000FEDCBA9876543210FEDCBA9876543210",
      INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04 => X"00000000000000000000000000000000FEDCBA9876543210FEDCBA9876543210",
      INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06 => X"00000000000000000000000000000000FEDCBA9876543210FEDCBA9876543210",
      INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08 => X"00000000000000000000000000000000FEDCBA9876543210FEDCBA9876543210",
      INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A => X"00000000000000000000000000000000FEDCBA9876543210FEDCBA9876543210",
      INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C => X"00000000000000000000000000000000FEDCBA9876543210FEDCBA9876543210",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"00000000000000000000000000000000FEDCBA9876543210FEDCBA9876543210",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "SPARTAN6",
      INIT_FILE => "NONE",
      LOC => "RAMB16_X0Y22"
    )
    port map (
      CLKA => '0',
      CLKB => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_CLKB,
      ENA => '1',
      ENB => '1',
      REGCEA => '0',
      REGCEB => '0',
      RSTA => '0',
      RSTB => '0',
      ADDRA(13) => '0',
      ADDRA(12) => '0',
      ADDRA(11) => '0',
      ADDRA(10) => '0',
      ADDRA(9) => '0',
      ADDRA(8) => '0',
      ADDRA(7) => '0',
      ADDRA(6) => '0',
      ADDRA(5) => '0',
      ADDRA(4) => '0',
      ADDRA(3) => '0',
      ADDRA(2) => '0',
      ADDRA(1) => NLW_renderer_text_buffer_Mram_RAM1_ADDRA_1_UNCONNECTED,
      ADDRA(0) => NLW_renderer_text_buffer_Mram_RAM1_ADDRA_0_UNCONNECTED,
      ADDRB(13) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(13),
      ADDRB(12) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(12),
      ADDRB(11) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(11),
      ADDRB(10) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(10),
      ADDRB(9) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(9),
      ADDRB(8) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(8),
      ADDRB(7) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(7),
      ADDRB(6) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(6),
      ADDRB(5) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(5),
      ADDRB(4) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(4),
      ADDRB(3) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(3),
      ADDRB(2) => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(2),
      ADDRB(1) => NLW_renderer_text_buffer_Mram_RAM1_ADDRB_1_UNCONNECTED,
      ADDRB(0) => NLW_renderer_text_buffer_Mram_RAM1_ADDRB_0_UNCONNECTED,
      DIA(31) => NLW_renderer_text_buffer_Mram_RAM1_DIA_31_UNCONNECTED,
      DIA(30) => NLW_renderer_text_buffer_Mram_RAM1_DIA_30_UNCONNECTED,
      DIA(29) => NLW_renderer_text_buffer_Mram_RAM1_DIA_29_UNCONNECTED,
      DIA(28) => NLW_renderer_text_buffer_Mram_RAM1_DIA_28_UNCONNECTED,
      DIA(27) => NLW_renderer_text_buffer_Mram_RAM1_DIA_27_UNCONNECTED,
      DIA(26) => NLW_renderer_text_buffer_Mram_RAM1_DIA_26_UNCONNECTED,
      DIA(25) => NLW_renderer_text_buffer_Mram_RAM1_DIA_25_UNCONNECTED,
      DIA(24) => NLW_renderer_text_buffer_Mram_RAM1_DIA_24_UNCONNECTED,
      DIA(23) => NLW_renderer_text_buffer_Mram_RAM1_DIA_23_UNCONNECTED,
      DIA(22) => NLW_renderer_text_buffer_Mram_RAM1_DIA_22_UNCONNECTED,
      DIA(21) => NLW_renderer_text_buffer_Mram_RAM1_DIA_21_UNCONNECTED,
      DIA(20) => NLW_renderer_text_buffer_Mram_RAM1_DIA_20_UNCONNECTED,
      DIA(19) => NLW_renderer_text_buffer_Mram_RAM1_DIA_19_UNCONNECTED,
      DIA(18) => NLW_renderer_text_buffer_Mram_RAM1_DIA_18_UNCONNECTED,
      DIA(17) => NLW_renderer_text_buffer_Mram_RAM1_DIA_17_UNCONNECTED,
      DIA(16) => NLW_renderer_text_buffer_Mram_RAM1_DIA_16_UNCONNECTED,
      DIA(15) => NLW_renderer_text_buffer_Mram_RAM1_DIA_15_UNCONNECTED,
      DIA(14) => NLW_renderer_text_buffer_Mram_RAM1_DIA_14_UNCONNECTED,
      DIA(13) => NLW_renderer_text_buffer_Mram_RAM1_DIA_13_UNCONNECTED,
      DIA(12) => NLW_renderer_text_buffer_Mram_RAM1_DIA_12_UNCONNECTED,
      DIA(11) => NLW_renderer_text_buffer_Mram_RAM1_DIA_11_UNCONNECTED,
      DIA(10) => NLW_renderer_text_buffer_Mram_RAM1_DIA_10_UNCONNECTED,
      DIA(9) => NLW_renderer_text_buffer_Mram_RAM1_DIA_9_UNCONNECTED,
      DIA(8) => NLW_renderer_text_buffer_Mram_RAM1_DIA_8_UNCONNECTED,
      DIA(7) => NLW_renderer_text_buffer_Mram_RAM1_DIA_7_UNCONNECTED,
      DIA(6) => NLW_renderer_text_buffer_Mram_RAM1_DIA_6_UNCONNECTED,
      DIA(5) => NLW_renderer_text_buffer_Mram_RAM1_DIA_5_UNCONNECTED,
      DIA(4) => NLW_renderer_text_buffer_Mram_RAM1_DIA_4_UNCONNECTED,
      DIA(3) => '0',
      DIA(2) => '0',
      DIA(1) => '0',
      DIA(0) => '0',
      DIB(31) => NLW_renderer_text_buffer_Mram_RAM1_DIB_31_UNCONNECTED,
      DIB(30) => NLW_renderer_text_buffer_Mram_RAM1_DIB_30_UNCONNECTED,
      DIB(29) => NLW_renderer_text_buffer_Mram_RAM1_DIB_29_UNCONNECTED,
      DIB(28) => NLW_renderer_text_buffer_Mram_RAM1_DIB_28_UNCONNECTED,
      DIB(27) => NLW_renderer_text_buffer_Mram_RAM1_DIB_27_UNCONNECTED,
      DIB(26) => NLW_renderer_text_buffer_Mram_RAM1_DIB_26_UNCONNECTED,
      DIB(25) => NLW_renderer_text_buffer_Mram_RAM1_DIB_25_UNCONNECTED,
      DIB(24) => NLW_renderer_text_buffer_Mram_RAM1_DIB_24_UNCONNECTED,
      DIB(23) => NLW_renderer_text_buffer_Mram_RAM1_DIB_23_UNCONNECTED,
      DIB(22) => NLW_renderer_text_buffer_Mram_RAM1_DIB_22_UNCONNECTED,
      DIB(21) => NLW_renderer_text_buffer_Mram_RAM1_DIB_21_UNCONNECTED,
      DIB(20) => NLW_renderer_text_buffer_Mram_RAM1_DIB_20_UNCONNECTED,
      DIB(19) => NLW_renderer_text_buffer_Mram_RAM1_DIB_19_UNCONNECTED,
      DIB(18) => NLW_renderer_text_buffer_Mram_RAM1_DIB_18_UNCONNECTED,
      DIB(17) => NLW_renderer_text_buffer_Mram_RAM1_DIB_17_UNCONNECTED,
      DIB(16) => NLW_renderer_text_buffer_Mram_RAM1_DIB_16_UNCONNECTED,
      DIB(15) => NLW_renderer_text_buffer_Mram_RAM1_DIB_15_UNCONNECTED,
      DIB(14) => NLW_renderer_text_buffer_Mram_RAM1_DIB_14_UNCONNECTED,
      DIB(13) => NLW_renderer_text_buffer_Mram_RAM1_DIB_13_UNCONNECTED,
      DIB(12) => NLW_renderer_text_buffer_Mram_RAM1_DIB_12_UNCONNECTED,
      DIB(11) => NLW_renderer_text_buffer_Mram_RAM1_DIB_11_UNCONNECTED,
      DIB(10) => NLW_renderer_text_buffer_Mram_RAM1_DIB_10_UNCONNECTED,
      DIB(9) => NLW_renderer_text_buffer_Mram_RAM1_DIB_9_UNCONNECTED,
      DIB(8) => NLW_renderer_text_buffer_Mram_RAM1_DIB_8_UNCONNECTED,
      DIB(7) => NLW_renderer_text_buffer_Mram_RAM1_DIB_7_UNCONNECTED,
      DIB(6) => NLW_renderer_text_buffer_Mram_RAM1_DIB_6_UNCONNECTED,
      DIB(5) => NLW_renderer_text_buffer_Mram_RAM1_DIB_5_UNCONNECTED,
      DIB(4) => NLW_renderer_text_buffer_Mram_RAM1_DIB_4_UNCONNECTED,
      DIB(3) => NLW_renderer_text_buffer_Mram_RAM1_DIB_3_UNCONNECTED,
      DIB(2) => NLW_renderer_text_buffer_Mram_RAM1_DIB_2_UNCONNECTED,
      DIB(1) => NLW_renderer_text_buffer_Mram_RAM1_DIB_1_UNCONNECTED,
      DIB(0) => NLW_renderer_text_buffer_Mram_RAM1_DIB_0_UNCONNECTED,
      DIPA(3) => NLW_renderer_text_buffer_Mram_RAM1_DIPA_3_UNCONNECTED,
      DIPA(2) => NLW_renderer_text_buffer_Mram_RAM1_DIPA_2_UNCONNECTED,
      DIPA(1) => NLW_renderer_text_buffer_Mram_RAM1_DIPA_1_UNCONNECTED,
      DIPA(0) => NLW_renderer_text_buffer_Mram_RAM1_DIPA_0_UNCONNECTED,
      DIPB(3) => NLW_renderer_text_buffer_Mram_RAM1_DIPB_3_UNCONNECTED,
      DIPB(2) => NLW_renderer_text_buffer_Mram_RAM1_DIPB_2_UNCONNECTED,
      DIPB(1) => NLW_renderer_text_buffer_Mram_RAM1_DIPB_1_UNCONNECTED,
      DIPB(0) => NLW_renderer_text_buffer_Mram_RAM1_DIPB_0_UNCONNECTED,
      DOA(31) => NLW_renderer_text_buffer_Mram_RAM1_DOA_31_UNCONNECTED,
      DOA(30) => NLW_renderer_text_buffer_Mram_RAM1_DOA_30_UNCONNECTED,
      DOA(29) => NLW_renderer_text_buffer_Mram_RAM1_DOA_29_UNCONNECTED,
      DOA(28) => NLW_renderer_text_buffer_Mram_RAM1_DOA_28_UNCONNECTED,
      DOA(27) => NLW_renderer_text_buffer_Mram_RAM1_DOA_27_UNCONNECTED,
      DOA(26) => NLW_renderer_text_buffer_Mram_RAM1_DOA_26_UNCONNECTED,
      DOA(25) => NLW_renderer_text_buffer_Mram_RAM1_DOA_25_UNCONNECTED,
      DOA(24) => NLW_renderer_text_buffer_Mram_RAM1_DOA_24_UNCONNECTED,
      DOA(23) => NLW_renderer_text_buffer_Mram_RAM1_DOA_23_UNCONNECTED,
      DOA(22) => NLW_renderer_text_buffer_Mram_RAM1_DOA_22_UNCONNECTED,
      DOA(21) => NLW_renderer_text_buffer_Mram_RAM1_DOA_21_UNCONNECTED,
      DOA(20) => NLW_renderer_text_buffer_Mram_RAM1_DOA_20_UNCONNECTED,
      DOA(19) => NLW_renderer_text_buffer_Mram_RAM1_DOA_19_UNCONNECTED,
      DOA(18) => NLW_renderer_text_buffer_Mram_RAM1_DOA_18_UNCONNECTED,
      DOA(17) => NLW_renderer_text_buffer_Mram_RAM1_DOA_17_UNCONNECTED,
      DOA(16) => NLW_renderer_text_buffer_Mram_RAM1_DOA_16_UNCONNECTED,
      DOA(15) => NLW_renderer_text_buffer_Mram_RAM1_DOA_15_UNCONNECTED,
      DOA(14) => NLW_renderer_text_buffer_Mram_RAM1_DOA_14_UNCONNECTED,
      DOA(13) => NLW_renderer_text_buffer_Mram_RAM1_DOA_13_UNCONNECTED,
      DOA(12) => NLW_renderer_text_buffer_Mram_RAM1_DOA_12_UNCONNECTED,
      DOA(11) => NLW_renderer_text_buffer_Mram_RAM1_DOA_11_UNCONNECTED,
      DOA(10) => NLW_renderer_text_buffer_Mram_RAM1_DOA_10_UNCONNECTED,
      DOA(9) => NLW_renderer_text_buffer_Mram_RAM1_DOA_9_UNCONNECTED,
      DOA(8) => NLW_renderer_text_buffer_Mram_RAM1_DOA_8_UNCONNECTED,
      DOA(7) => NLW_renderer_text_buffer_Mram_RAM1_DOA_7_UNCONNECTED,
      DOA(6) => NLW_renderer_text_buffer_Mram_RAM1_DOA_6_UNCONNECTED,
      DOA(5) => NLW_renderer_text_buffer_Mram_RAM1_DOA_5_UNCONNECTED,
      DOA(4) => NLW_renderer_text_buffer_Mram_RAM1_DOA_4_UNCONNECTED,
      DOA(3) => NLW_renderer_text_buffer_Mram_RAM1_DOA_3_UNCONNECTED,
      DOA(2) => NLW_renderer_text_buffer_Mram_RAM1_DOA_2_UNCONNECTED,
      DOA(1) => NLW_renderer_text_buffer_Mram_RAM1_DOA_1_UNCONNECTED,
      DOA(0) => NLW_renderer_text_buffer_Mram_RAM1_DOA_0_UNCONNECTED,
      DOB(31) => NLW_renderer_text_buffer_Mram_RAM1_DOB_31_UNCONNECTED,
      DOB(30) => NLW_renderer_text_buffer_Mram_RAM1_DOB_30_UNCONNECTED,
      DOB(29) => NLW_renderer_text_buffer_Mram_RAM1_DOB_29_UNCONNECTED,
      DOB(28) => NLW_renderer_text_buffer_Mram_RAM1_DOB_28_UNCONNECTED,
      DOB(27) => NLW_renderer_text_buffer_Mram_RAM1_DOB_27_UNCONNECTED,
      DOB(26) => NLW_renderer_text_buffer_Mram_RAM1_DOB_26_UNCONNECTED,
      DOB(25) => NLW_renderer_text_buffer_Mram_RAM1_DOB_25_UNCONNECTED,
      DOB(24) => NLW_renderer_text_buffer_Mram_RAM1_DOB_24_UNCONNECTED,
      DOB(23) => NLW_renderer_text_buffer_Mram_RAM1_DOB_23_UNCONNECTED,
      DOB(22) => NLW_renderer_text_buffer_Mram_RAM1_DOB_22_UNCONNECTED,
      DOB(21) => NLW_renderer_text_buffer_Mram_RAM1_DOB_21_UNCONNECTED,
      DOB(20) => NLW_renderer_text_buffer_Mram_RAM1_DOB_20_UNCONNECTED,
      DOB(19) => NLW_renderer_text_buffer_Mram_RAM1_DOB_19_UNCONNECTED,
      DOB(18) => NLW_renderer_text_buffer_Mram_RAM1_DOB_18_UNCONNECTED,
      DOB(17) => NLW_renderer_text_buffer_Mram_RAM1_DOB_17_UNCONNECTED,
      DOB(16) => NLW_renderer_text_buffer_Mram_RAM1_DOB_16_UNCONNECTED,
      DOB(15) => NLW_renderer_text_buffer_Mram_RAM1_DOB_15_UNCONNECTED,
      DOB(14) => NLW_renderer_text_buffer_Mram_RAM1_DOB_14_UNCONNECTED,
      DOB(13) => NLW_renderer_text_buffer_Mram_RAM1_DOB_13_UNCONNECTED,
      DOB(12) => NLW_renderer_text_buffer_Mram_RAM1_DOB_12_UNCONNECTED,
      DOB(11) => NLW_renderer_text_buffer_Mram_RAM1_DOB_11_UNCONNECTED,
      DOB(10) => NLW_renderer_text_buffer_Mram_RAM1_DOB_10_UNCONNECTED,
      DOB(9) => NLW_renderer_text_buffer_Mram_RAM1_DOB_9_UNCONNECTED,
      DOB(8) => NLW_renderer_text_buffer_Mram_RAM1_DOB_8_UNCONNECTED,
      DOB(7) => NLW_renderer_text_buffer_Mram_RAM1_DOB_7_UNCONNECTED,
      DOB(6) => NLW_renderer_text_buffer_Mram_RAM1_DOB_6_UNCONNECTED,
      DOB(5) => NLW_renderer_text_buffer_Mram_RAM1_DOB_5_UNCONNECTED,
      DOB(4) => NLW_renderer_text_buffer_Mram_RAM1_DOB_4_UNCONNECTED,
      DOB(3) => renderer_character_data(3),
      DOB(2) => renderer_character_data(2),
      DOB(1) => renderer_character_data(1),
      DOB(0) => renderer_character_data(0),
      DOPA(3) => NLW_renderer_text_buffer_Mram_RAM1_DOPA_3_UNCONNECTED,
      DOPA(2) => NLW_renderer_text_buffer_Mram_RAM1_DOPA_2_UNCONNECTED,
      DOPA(1) => NLW_renderer_text_buffer_Mram_RAM1_DOPA_1_UNCONNECTED,
      DOPA(0) => NLW_renderer_text_buffer_Mram_RAM1_DOPA_0_UNCONNECTED,
      DOPB(3) => NLW_renderer_text_buffer_Mram_RAM1_DOPB_3_UNCONNECTED,
      DOPB(2) => NLW_renderer_text_buffer_Mram_RAM1_DOPB_2_UNCONNECTED,
      DOPB(1) => NLW_renderer_text_buffer_Mram_RAM1_DOPB_1_UNCONNECTED,
      DOPB(0) => NLW_renderer_text_buffer_Mram_RAM1_DOPB_0_UNCONNECTED,
      WEA(3) => '0',
      WEA(2) => '0',
      WEA(1) => '0',
      WEA(0) => '0',
      WEB(3) => '0',
      WEB(2) => '0',
      WEB(1) => '0',
      WEB(0) => '0'
    );
  renderer_text_buffer_Mram_RAM2 : X_RAMB16BWER
    generic map(
      DATA_WIDTH_A => 4,
      DATA_WIDTH_B => 4,
      DOA_REG => 0,
      DOB_REG => 0,
      EN_RSTRAM_A => TRUE,
      EN_RSTRAM_B => TRUE,
      RST_PRIORITY_A => "CE",
      RST_PRIORITY_B => "CE",
      RSTTYPE => "SYNC",
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_00 => X"0000000000000000000000000000000011111111111111110000000000000000",
      INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02 => X"0000000000000000000000000000000033333333333333332222222222222222",
      INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04 => X"0000000000000000000000000000000055555555555555554444444444444444",
      INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06 => X"0000000000000000000000000000000077777777777777776666666666666666",
      INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08 => X"0000000000000000000000000000000099999999999999998888888888888888",
      INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A => X"00000000000000000000000000000000BBBBBBBBBBBBBBBBAAAAAAAAAAAAAAAA",
      INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C => X"00000000000000000000000000000000DDDDDDDDDDDDDDDDCCCCCCCCCCCCCCCC",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"00000000000000000000000000000000FFFFFFFFFFFFFFFFEEEEEEEEEEEEEEEE",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A => X"000000000000000000000000000000000000000000000000000000000000000B",
      INIT_2B => X"000000000000000000000000000000000000000000000000B000000000000000",
      INIT_2C => X"000000000000000000000000000000000000000000000000000000000000000B",
      INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "SPARTAN6",
      INIT_FILE => "NONE",
      LOC => "RAMB16_X1Y22"
    )
    port map (
      CLKA => '0',
      CLKB => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_CLKB,
      ENA => '1',
      ENB => '1',
      REGCEA => '0',
      REGCEB => '0',
      RSTA => '0',
      RSTB => '0',
      ADDRA(13) => '0',
      ADDRA(12) => '0',
      ADDRA(11) => '0',
      ADDRA(10) => '0',
      ADDRA(9) => '0',
      ADDRA(8) => '0',
      ADDRA(7) => '0',
      ADDRA(6) => '0',
      ADDRA(5) => '0',
      ADDRA(4) => '0',
      ADDRA(3) => '0',
      ADDRA(2) => '0',
      ADDRA(1) => NLW_renderer_text_buffer_Mram_RAM2_ADDRA_1_UNCONNECTED,
      ADDRA(0) => NLW_renderer_text_buffer_Mram_RAM2_ADDRA_0_UNCONNECTED,
      ADDRB(13) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(13),
      ADDRB(12) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(12),
      ADDRB(11) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(11),
      ADDRB(10) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(10),
      ADDRB(9) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(9),
      ADDRB(8) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(8),
      ADDRB(7) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(7),
      ADDRB(6) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(6),
      ADDRB(5) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(5),
      ADDRB(4) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(4),
      ADDRB(3) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(3),
      ADDRB(2) => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(2),
      ADDRB(1) => NLW_renderer_text_buffer_Mram_RAM2_ADDRB_1_UNCONNECTED,
      ADDRB(0) => NLW_renderer_text_buffer_Mram_RAM2_ADDRB_0_UNCONNECTED,
      DIA(31) => NLW_renderer_text_buffer_Mram_RAM2_DIA_31_UNCONNECTED,
      DIA(30) => NLW_renderer_text_buffer_Mram_RAM2_DIA_30_UNCONNECTED,
      DIA(29) => NLW_renderer_text_buffer_Mram_RAM2_DIA_29_UNCONNECTED,
      DIA(28) => NLW_renderer_text_buffer_Mram_RAM2_DIA_28_UNCONNECTED,
      DIA(27) => NLW_renderer_text_buffer_Mram_RAM2_DIA_27_UNCONNECTED,
      DIA(26) => NLW_renderer_text_buffer_Mram_RAM2_DIA_26_UNCONNECTED,
      DIA(25) => NLW_renderer_text_buffer_Mram_RAM2_DIA_25_UNCONNECTED,
      DIA(24) => NLW_renderer_text_buffer_Mram_RAM2_DIA_24_UNCONNECTED,
      DIA(23) => NLW_renderer_text_buffer_Mram_RAM2_DIA_23_UNCONNECTED,
      DIA(22) => NLW_renderer_text_buffer_Mram_RAM2_DIA_22_UNCONNECTED,
      DIA(21) => NLW_renderer_text_buffer_Mram_RAM2_DIA_21_UNCONNECTED,
      DIA(20) => NLW_renderer_text_buffer_Mram_RAM2_DIA_20_UNCONNECTED,
      DIA(19) => NLW_renderer_text_buffer_Mram_RAM2_DIA_19_UNCONNECTED,
      DIA(18) => NLW_renderer_text_buffer_Mram_RAM2_DIA_18_UNCONNECTED,
      DIA(17) => NLW_renderer_text_buffer_Mram_RAM2_DIA_17_UNCONNECTED,
      DIA(16) => NLW_renderer_text_buffer_Mram_RAM2_DIA_16_UNCONNECTED,
      DIA(15) => NLW_renderer_text_buffer_Mram_RAM2_DIA_15_UNCONNECTED,
      DIA(14) => NLW_renderer_text_buffer_Mram_RAM2_DIA_14_UNCONNECTED,
      DIA(13) => NLW_renderer_text_buffer_Mram_RAM2_DIA_13_UNCONNECTED,
      DIA(12) => NLW_renderer_text_buffer_Mram_RAM2_DIA_12_UNCONNECTED,
      DIA(11) => NLW_renderer_text_buffer_Mram_RAM2_DIA_11_UNCONNECTED,
      DIA(10) => NLW_renderer_text_buffer_Mram_RAM2_DIA_10_UNCONNECTED,
      DIA(9) => NLW_renderer_text_buffer_Mram_RAM2_DIA_9_UNCONNECTED,
      DIA(8) => NLW_renderer_text_buffer_Mram_RAM2_DIA_8_UNCONNECTED,
      DIA(7) => NLW_renderer_text_buffer_Mram_RAM2_DIA_7_UNCONNECTED,
      DIA(6) => NLW_renderer_text_buffer_Mram_RAM2_DIA_6_UNCONNECTED,
      DIA(5) => NLW_renderer_text_buffer_Mram_RAM2_DIA_5_UNCONNECTED,
      DIA(4) => NLW_renderer_text_buffer_Mram_RAM2_DIA_4_UNCONNECTED,
      DIA(3) => '0',
      DIA(2) => '0',
      DIA(1) => '0',
      DIA(0) => '0',
      DIB(31) => NLW_renderer_text_buffer_Mram_RAM2_DIB_31_UNCONNECTED,
      DIB(30) => NLW_renderer_text_buffer_Mram_RAM2_DIB_30_UNCONNECTED,
      DIB(29) => NLW_renderer_text_buffer_Mram_RAM2_DIB_29_UNCONNECTED,
      DIB(28) => NLW_renderer_text_buffer_Mram_RAM2_DIB_28_UNCONNECTED,
      DIB(27) => NLW_renderer_text_buffer_Mram_RAM2_DIB_27_UNCONNECTED,
      DIB(26) => NLW_renderer_text_buffer_Mram_RAM2_DIB_26_UNCONNECTED,
      DIB(25) => NLW_renderer_text_buffer_Mram_RAM2_DIB_25_UNCONNECTED,
      DIB(24) => NLW_renderer_text_buffer_Mram_RAM2_DIB_24_UNCONNECTED,
      DIB(23) => NLW_renderer_text_buffer_Mram_RAM2_DIB_23_UNCONNECTED,
      DIB(22) => NLW_renderer_text_buffer_Mram_RAM2_DIB_22_UNCONNECTED,
      DIB(21) => NLW_renderer_text_buffer_Mram_RAM2_DIB_21_UNCONNECTED,
      DIB(20) => NLW_renderer_text_buffer_Mram_RAM2_DIB_20_UNCONNECTED,
      DIB(19) => NLW_renderer_text_buffer_Mram_RAM2_DIB_19_UNCONNECTED,
      DIB(18) => NLW_renderer_text_buffer_Mram_RAM2_DIB_18_UNCONNECTED,
      DIB(17) => NLW_renderer_text_buffer_Mram_RAM2_DIB_17_UNCONNECTED,
      DIB(16) => NLW_renderer_text_buffer_Mram_RAM2_DIB_16_UNCONNECTED,
      DIB(15) => NLW_renderer_text_buffer_Mram_RAM2_DIB_15_UNCONNECTED,
      DIB(14) => NLW_renderer_text_buffer_Mram_RAM2_DIB_14_UNCONNECTED,
      DIB(13) => NLW_renderer_text_buffer_Mram_RAM2_DIB_13_UNCONNECTED,
      DIB(12) => NLW_renderer_text_buffer_Mram_RAM2_DIB_12_UNCONNECTED,
      DIB(11) => NLW_renderer_text_buffer_Mram_RAM2_DIB_11_UNCONNECTED,
      DIB(10) => NLW_renderer_text_buffer_Mram_RAM2_DIB_10_UNCONNECTED,
      DIB(9) => NLW_renderer_text_buffer_Mram_RAM2_DIB_9_UNCONNECTED,
      DIB(8) => NLW_renderer_text_buffer_Mram_RAM2_DIB_8_UNCONNECTED,
      DIB(7) => NLW_renderer_text_buffer_Mram_RAM2_DIB_7_UNCONNECTED,
      DIB(6) => NLW_renderer_text_buffer_Mram_RAM2_DIB_6_UNCONNECTED,
      DIB(5) => NLW_renderer_text_buffer_Mram_RAM2_DIB_5_UNCONNECTED,
      DIB(4) => NLW_renderer_text_buffer_Mram_RAM2_DIB_4_UNCONNECTED,
      DIB(3) => NLW_renderer_text_buffer_Mram_RAM2_DIB_3_UNCONNECTED,
      DIB(2) => NLW_renderer_text_buffer_Mram_RAM2_DIB_2_UNCONNECTED,
      DIB(1) => NLW_renderer_text_buffer_Mram_RAM2_DIB_1_UNCONNECTED,
      DIB(0) => NLW_renderer_text_buffer_Mram_RAM2_DIB_0_UNCONNECTED,
      DIPA(3) => NLW_renderer_text_buffer_Mram_RAM2_DIPA_3_UNCONNECTED,
      DIPA(2) => NLW_renderer_text_buffer_Mram_RAM2_DIPA_2_UNCONNECTED,
      DIPA(1) => NLW_renderer_text_buffer_Mram_RAM2_DIPA_1_UNCONNECTED,
      DIPA(0) => NLW_renderer_text_buffer_Mram_RAM2_DIPA_0_UNCONNECTED,
      DIPB(3) => NLW_renderer_text_buffer_Mram_RAM2_DIPB_3_UNCONNECTED,
      DIPB(2) => NLW_renderer_text_buffer_Mram_RAM2_DIPB_2_UNCONNECTED,
      DIPB(1) => NLW_renderer_text_buffer_Mram_RAM2_DIPB_1_UNCONNECTED,
      DIPB(0) => NLW_renderer_text_buffer_Mram_RAM2_DIPB_0_UNCONNECTED,
      DOA(31) => NLW_renderer_text_buffer_Mram_RAM2_DOA_31_UNCONNECTED,
      DOA(30) => NLW_renderer_text_buffer_Mram_RAM2_DOA_30_UNCONNECTED,
      DOA(29) => NLW_renderer_text_buffer_Mram_RAM2_DOA_29_UNCONNECTED,
      DOA(28) => NLW_renderer_text_buffer_Mram_RAM2_DOA_28_UNCONNECTED,
      DOA(27) => NLW_renderer_text_buffer_Mram_RAM2_DOA_27_UNCONNECTED,
      DOA(26) => NLW_renderer_text_buffer_Mram_RAM2_DOA_26_UNCONNECTED,
      DOA(25) => NLW_renderer_text_buffer_Mram_RAM2_DOA_25_UNCONNECTED,
      DOA(24) => NLW_renderer_text_buffer_Mram_RAM2_DOA_24_UNCONNECTED,
      DOA(23) => NLW_renderer_text_buffer_Mram_RAM2_DOA_23_UNCONNECTED,
      DOA(22) => NLW_renderer_text_buffer_Mram_RAM2_DOA_22_UNCONNECTED,
      DOA(21) => NLW_renderer_text_buffer_Mram_RAM2_DOA_21_UNCONNECTED,
      DOA(20) => NLW_renderer_text_buffer_Mram_RAM2_DOA_20_UNCONNECTED,
      DOA(19) => NLW_renderer_text_buffer_Mram_RAM2_DOA_19_UNCONNECTED,
      DOA(18) => NLW_renderer_text_buffer_Mram_RAM2_DOA_18_UNCONNECTED,
      DOA(17) => NLW_renderer_text_buffer_Mram_RAM2_DOA_17_UNCONNECTED,
      DOA(16) => NLW_renderer_text_buffer_Mram_RAM2_DOA_16_UNCONNECTED,
      DOA(15) => NLW_renderer_text_buffer_Mram_RAM2_DOA_15_UNCONNECTED,
      DOA(14) => NLW_renderer_text_buffer_Mram_RAM2_DOA_14_UNCONNECTED,
      DOA(13) => NLW_renderer_text_buffer_Mram_RAM2_DOA_13_UNCONNECTED,
      DOA(12) => NLW_renderer_text_buffer_Mram_RAM2_DOA_12_UNCONNECTED,
      DOA(11) => NLW_renderer_text_buffer_Mram_RAM2_DOA_11_UNCONNECTED,
      DOA(10) => NLW_renderer_text_buffer_Mram_RAM2_DOA_10_UNCONNECTED,
      DOA(9) => NLW_renderer_text_buffer_Mram_RAM2_DOA_9_UNCONNECTED,
      DOA(8) => NLW_renderer_text_buffer_Mram_RAM2_DOA_8_UNCONNECTED,
      DOA(7) => NLW_renderer_text_buffer_Mram_RAM2_DOA_7_UNCONNECTED,
      DOA(6) => NLW_renderer_text_buffer_Mram_RAM2_DOA_6_UNCONNECTED,
      DOA(5) => NLW_renderer_text_buffer_Mram_RAM2_DOA_5_UNCONNECTED,
      DOA(4) => NLW_renderer_text_buffer_Mram_RAM2_DOA_4_UNCONNECTED,
      DOA(3) => NLW_renderer_text_buffer_Mram_RAM2_DOA_3_UNCONNECTED,
      DOA(2) => NLW_renderer_text_buffer_Mram_RAM2_DOA_2_UNCONNECTED,
      DOA(1) => NLW_renderer_text_buffer_Mram_RAM2_DOA_1_UNCONNECTED,
      DOA(0) => NLW_renderer_text_buffer_Mram_RAM2_DOA_0_UNCONNECTED,
      DOB(31) => NLW_renderer_text_buffer_Mram_RAM2_DOB_31_UNCONNECTED,
      DOB(30) => NLW_renderer_text_buffer_Mram_RAM2_DOB_30_UNCONNECTED,
      DOB(29) => NLW_renderer_text_buffer_Mram_RAM2_DOB_29_UNCONNECTED,
      DOB(28) => NLW_renderer_text_buffer_Mram_RAM2_DOB_28_UNCONNECTED,
      DOB(27) => NLW_renderer_text_buffer_Mram_RAM2_DOB_27_UNCONNECTED,
      DOB(26) => NLW_renderer_text_buffer_Mram_RAM2_DOB_26_UNCONNECTED,
      DOB(25) => NLW_renderer_text_buffer_Mram_RAM2_DOB_25_UNCONNECTED,
      DOB(24) => NLW_renderer_text_buffer_Mram_RAM2_DOB_24_UNCONNECTED,
      DOB(23) => NLW_renderer_text_buffer_Mram_RAM2_DOB_23_UNCONNECTED,
      DOB(22) => NLW_renderer_text_buffer_Mram_RAM2_DOB_22_UNCONNECTED,
      DOB(21) => NLW_renderer_text_buffer_Mram_RAM2_DOB_21_UNCONNECTED,
      DOB(20) => NLW_renderer_text_buffer_Mram_RAM2_DOB_20_UNCONNECTED,
      DOB(19) => NLW_renderer_text_buffer_Mram_RAM2_DOB_19_UNCONNECTED,
      DOB(18) => NLW_renderer_text_buffer_Mram_RAM2_DOB_18_UNCONNECTED,
      DOB(17) => NLW_renderer_text_buffer_Mram_RAM2_DOB_17_UNCONNECTED,
      DOB(16) => NLW_renderer_text_buffer_Mram_RAM2_DOB_16_UNCONNECTED,
      DOB(15) => NLW_renderer_text_buffer_Mram_RAM2_DOB_15_UNCONNECTED,
      DOB(14) => NLW_renderer_text_buffer_Mram_RAM2_DOB_14_UNCONNECTED,
      DOB(13) => NLW_renderer_text_buffer_Mram_RAM2_DOB_13_UNCONNECTED,
      DOB(12) => NLW_renderer_text_buffer_Mram_RAM2_DOB_12_UNCONNECTED,
      DOB(11) => NLW_renderer_text_buffer_Mram_RAM2_DOB_11_UNCONNECTED,
      DOB(10) => NLW_renderer_text_buffer_Mram_RAM2_DOB_10_UNCONNECTED,
      DOB(9) => NLW_renderer_text_buffer_Mram_RAM2_DOB_9_UNCONNECTED,
      DOB(8) => NLW_renderer_text_buffer_Mram_RAM2_DOB_8_UNCONNECTED,
      DOB(7) => NLW_renderer_text_buffer_Mram_RAM2_DOB_7_UNCONNECTED,
      DOB(6) => NLW_renderer_text_buffer_Mram_RAM2_DOB_6_UNCONNECTED,
      DOB(5) => NLW_renderer_text_buffer_Mram_RAM2_DOB_5_UNCONNECTED,
      DOB(4) => NLW_renderer_text_buffer_Mram_RAM2_DOB_4_UNCONNECTED,
      DOB(3) => renderer_character_data(7),
      DOB(2) => renderer_character_data(6),
      DOB(1) => renderer_character_data(5),
      DOB(0) => renderer_character_data(4),
      DOPA(3) => NLW_renderer_text_buffer_Mram_RAM2_DOPA_3_UNCONNECTED,
      DOPA(2) => NLW_renderer_text_buffer_Mram_RAM2_DOPA_2_UNCONNECTED,
      DOPA(1) => NLW_renderer_text_buffer_Mram_RAM2_DOPA_1_UNCONNECTED,
      DOPA(0) => NLW_renderer_text_buffer_Mram_RAM2_DOPA_0_UNCONNECTED,
      DOPB(3) => NLW_renderer_text_buffer_Mram_RAM2_DOPB_3_UNCONNECTED,
      DOPB(2) => NLW_renderer_text_buffer_Mram_RAM2_DOPB_2_UNCONNECTED,
      DOPB(1) => NLW_renderer_text_buffer_Mram_RAM2_DOPB_1_UNCONNECTED,
      DOPB(0) => NLW_renderer_text_buffer_Mram_RAM2_DOPB_0_UNCONNECTED,
      WEA(3) => '0',
      WEA(2) => '0',
      WEA(1) => '0',
      WEA(0) => '0',
      WEB(3) => '0',
      WEB(2) => '0',
      WEB(1) => '0',
      WEB(0) => '0'
    );
  renderer_text_buffer_Mram_RAM3 : X_RAMB16BWER
    generic map(
      DATA_WIDTH_A => 4,
      DATA_WIDTH_B => 4,
      DOA_REG => 0,
      DOB_REG => 0,
      EN_RSTRAM_A => TRUE,
      EN_RSTRAM_B => TRUE,
      RST_PRIORITY_A => "CE",
      RST_PRIORITY_B => "CE",
      RSTTYPE => "SYNC",
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_00 => X"00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
      INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02 => X"00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
      INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04 => X"00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
      INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06 => X"00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
      INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08 => X"00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
      INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A => X"00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
      INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C => X"00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A => X"000000000000000000000000000000000000000000000000000000000000000E",
      INIT_2B => X"000000000000000000000000000000000000000000000000E000000000000000",
      INIT_2C => X"000000000000000000000000000000000000000000000000000000000000000E",
      INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "SPARTAN6",
      INIT_FILE => "NONE",
      LOC => "RAMB16_X0Y24"
    )
    port map (
      CLKA => '0',
      CLKB => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_CLKB,
      ENA => '1',
      ENB => '1',
      REGCEA => '0',
      REGCEB => '0',
      RSTA => '0',
      RSTB => '0',
      ADDRA(13) => '0',
      ADDRA(12) => '0',
      ADDRA(11) => '0',
      ADDRA(10) => '0',
      ADDRA(9) => '0',
      ADDRA(8) => '0',
      ADDRA(7) => '0',
      ADDRA(6) => '0',
      ADDRA(5) => '0',
      ADDRA(4) => '0',
      ADDRA(3) => '0',
      ADDRA(2) => '0',
      ADDRA(1) => NLW_renderer_text_buffer_Mram_RAM3_ADDRA_1_UNCONNECTED,
      ADDRA(0) => NLW_renderer_text_buffer_Mram_RAM3_ADDRA_0_UNCONNECTED,
      ADDRB(13) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(13),
      ADDRB(12) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(12),
      ADDRB(11) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(11),
      ADDRB(10) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(10),
      ADDRB(9) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(9),
      ADDRB(8) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(8),
      ADDRB(7) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(7),
      ADDRB(6) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(6),
      ADDRB(5) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(5),
      ADDRB(4) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(4),
      ADDRB(3) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(3),
      ADDRB(2) => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(2),
      ADDRB(1) => NLW_renderer_text_buffer_Mram_RAM3_ADDRB_1_UNCONNECTED,
      ADDRB(0) => NLW_renderer_text_buffer_Mram_RAM3_ADDRB_0_UNCONNECTED,
      DIA(31) => NLW_renderer_text_buffer_Mram_RAM3_DIA_31_UNCONNECTED,
      DIA(30) => NLW_renderer_text_buffer_Mram_RAM3_DIA_30_UNCONNECTED,
      DIA(29) => NLW_renderer_text_buffer_Mram_RAM3_DIA_29_UNCONNECTED,
      DIA(28) => NLW_renderer_text_buffer_Mram_RAM3_DIA_28_UNCONNECTED,
      DIA(27) => NLW_renderer_text_buffer_Mram_RAM3_DIA_27_UNCONNECTED,
      DIA(26) => NLW_renderer_text_buffer_Mram_RAM3_DIA_26_UNCONNECTED,
      DIA(25) => NLW_renderer_text_buffer_Mram_RAM3_DIA_25_UNCONNECTED,
      DIA(24) => NLW_renderer_text_buffer_Mram_RAM3_DIA_24_UNCONNECTED,
      DIA(23) => NLW_renderer_text_buffer_Mram_RAM3_DIA_23_UNCONNECTED,
      DIA(22) => NLW_renderer_text_buffer_Mram_RAM3_DIA_22_UNCONNECTED,
      DIA(21) => NLW_renderer_text_buffer_Mram_RAM3_DIA_21_UNCONNECTED,
      DIA(20) => NLW_renderer_text_buffer_Mram_RAM3_DIA_20_UNCONNECTED,
      DIA(19) => NLW_renderer_text_buffer_Mram_RAM3_DIA_19_UNCONNECTED,
      DIA(18) => NLW_renderer_text_buffer_Mram_RAM3_DIA_18_UNCONNECTED,
      DIA(17) => NLW_renderer_text_buffer_Mram_RAM3_DIA_17_UNCONNECTED,
      DIA(16) => NLW_renderer_text_buffer_Mram_RAM3_DIA_16_UNCONNECTED,
      DIA(15) => NLW_renderer_text_buffer_Mram_RAM3_DIA_15_UNCONNECTED,
      DIA(14) => NLW_renderer_text_buffer_Mram_RAM3_DIA_14_UNCONNECTED,
      DIA(13) => NLW_renderer_text_buffer_Mram_RAM3_DIA_13_UNCONNECTED,
      DIA(12) => NLW_renderer_text_buffer_Mram_RAM3_DIA_12_UNCONNECTED,
      DIA(11) => NLW_renderer_text_buffer_Mram_RAM3_DIA_11_UNCONNECTED,
      DIA(10) => NLW_renderer_text_buffer_Mram_RAM3_DIA_10_UNCONNECTED,
      DIA(9) => NLW_renderer_text_buffer_Mram_RAM3_DIA_9_UNCONNECTED,
      DIA(8) => NLW_renderer_text_buffer_Mram_RAM3_DIA_8_UNCONNECTED,
      DIA(7) => NLW_renderer_text_buffer_Mram_RAM3_DIA_7_UNCONNECTED,
      DIA(6) => NLW_renderer_text_buffer_Mram_RAM3_DIA_6_UNCONNECTED,
      DIA(5) => NLW_renderer_text_buffer_Mram_RAM3_DIA_5_UNCONNECTED,
      DIA(4) => NLW_renderer_text_buffer_Mram_RAM3_DIA_4_UNCONNECTED,
      DIA(3) => '0',
      DIA(2) => '0',
      DIA(1) => '0',
      DIA(0) => '0',
      DIB(31) => NLW_renderer_text_buffer_Mram_RAM3_DIB_31_UNCONNECTED,
      DIB(30) => NLW_renderer_text_buffer_Mram_RAM3_DIB_30_UNCONNECTED,
      DIB(29) => NLW_renderer_text_buffer_Mram_RAM3_DIB_29_UNCONNECTED,
      DIB(28) => NLW_renderer_text_buffer_Mram_RAM3_DIB_28_UNCONNECTED,
      DIB(27) => NLW_renderer_text_buffer_Mram_RAM3_DIB_27_UNCONNECTED,
      DIB(26) => NLW_renderer_text_buffer_Mram_RAM3_DIB_26_UNCONNECTED,
      DIB(25) => NLW_renderer_text_buffer_Mram_RAM3_DIB_25_UNCONNECTED,
      DIB(24) => NLW_renderer_text_buffer_Mram_RAM3_DIB_24_UNCONNECTED,
      DIB(23) => NLW_renderer_text_buffer_Mram_RAM3_DIB_23_UNCONNECTED,
      DIB(22) => NLW_renderer_text_buffer_Mram_RAM3_DIB_22_UNCONNECTED,
      DIB(21) => NLW_renderer_text_buffer_Mram_RAM3_DIB_21_UNCONNECTED,
      DIB(20) => NLW_renderer_text_buffer_Mram_RAM3_DIB_20_UNCONNECTED,
      DIB(19) => NLW_renderer_text_buffer_Mram_RAM3_DIB_19_UNCONNECTED,
      DIB(18) => NLW_renderer_text_buffer_Mram_RAM3_DIB_18_UNCONNECTED,
      DIB(17) => NLW_renderer_text_buffer_Mram_RAM3_DIB_17_UNCONNECTED,
      DIB(16) => NLW_renderer_text_buffer_Mram_RAM3_DIB_16_UNCONNECTED,
      DIB(15) => NLW_renderer_text_buffer_Mram_RAM3_DIB_15_UNCONNECTED,
      DIB(14) => NLW_renderer_text_buffer_Mram_RAM3_DIB_14_UNCONNECTED,
      DIB(13) => NLW_renderer_text_buffer_Mram_RAM3_DIB_13_UNCONNECTED,
      DIB(12) => NLW_renderer_text_buffer_Mram_RAM3_DIB_12_UNCONNECTED,
      DIB(11) => NLW_renderer_text_buffer_Mram_RAM3_DIB_11_UNCONNECTED,
      DIB(10) => NLW_renderer_text_buffer_Mram_RAM3_DIB_10_UNCONNECTED,
      DIB(9) => NLW_renderer_text_buffer_Mram_RAM3_DIB_9_UNCONNECTED,
      DIB(8) => NLW_renderer_text_buffer_Mram_RAM3_DIB_8_UNCONNECTED,
      DIB(7) => NLW_renderer_text_buffer_Mram_RAM3_DIB_7_UNCONNECTED,
      DIB(6) => NLW_renderer_text_buffer_Mram_RAM3_DIB_6_UNCONNECTED,
      DIB(5) => NLW_renderer_text_buffer_Mram_RAM3_DIB_5_UNCONNECTED,
      DIB(4) => NLW_renderer_text_buffer_Mram_RAM3_DIB_4_UNCONNECTED,
      DIB(3) => NLW_renderer_text_buffer_Mram_RAM3_DIB_3_UNCONNECTED,
      DIB(2) => NLW_renderer_text_buffer_Mram_RAM3_DIB_2_UNCONNECTED,
      DIB(1) => NLW_renderer_text_buffer_Mram_RAM3_DIB_1_UNCONNECTED,
      DIB(0) => NLW_renderer_text_buffer_Mram_RAM3_DIB_0_UNCONNECTED,
      DIPA(3) => NLW_renderer_text_buffer_Mram_RAM3_DIPA_3_UNCONNECTED,
      DIPA(2) => NLW_renderer_text_buffer_Mram_RAM3_DIPA_2_UNCONNECTED,
      DIPA(1) => NLW_renderer_text_buffer_Mram_RAM3_DIPA_1_UNCONNECTED,
      DIPA(0) => NLW_renderer_text_buffer_Mram_RAM3_DIPA_0_UNCONNECTED,
      DIPB(3) => NLW_renderer_text_buffer_Mram_RAM3_DIPB_3_UNCONNECTED,
      DIPB(2) => NLW_renderer_text_buffer_Mram_RAM3_DIPB_2_UNCONNECTED,
      DIPB(1) => NLW_renderer_text_buffer_Mram_RAM3_DIPB_1_UNCONNECTED,
      DIPB(0) => NLW_renderer_text_buffer_Mram_RAM3_DIPB_0_UNCONNECTED,
      DOA(31) => NLW_renderer_text_buffer_Mram_RAM3_DOA_31_UNCONNECTED,
      DOA(30) => NLW_renderer_text_buffer_Mram_RAM3_DOA_30_UNCONNECTED,
      DOA(29) => NLW_renderer_text_buffer_Mram_RAM3_DOA_29_UNCONNECTED,
      DOA(28) => NLW_renderer_text_buffer_Mram_RAM3_DOA_28_UNCONNECTED,
      DOA(27) => NLW_renderer_text_buffer_Mram_RAM3_DOA_27_UNCONNECTED,
      DOA(26) => NLW_renderer_text_buffer_Mram_RAM3_DOA_26_UNCONNECTED,
      DOA(25) => NLW_renderer_text_buffer_Mram_RAM3_DOA_25_UNCONNECTED,
      DOA(24) => NLW_renderer_text_buffer_Mram_RAM3_DOA_24_UNCONNECTED,
      DOA(23) => NLW_renderer_text_buffer_Mram_RAM3_DOA_23_UNCONNECTED,
      DOA(22) => NLW_renderer_text_buffer_Mram_RAM3_DOA_22_UNCONNECTED,
      DOA(21) => NLW_renderer_text_buffer_Mram_RAM3_DOA_21_UNCONNECTED,
      DOA(20) => NLW_renderer_text_buffer_Mram_RAM3_DOA_20_UNCONNECTED,
      DOA(19) => NLW_renderer_text_buffer_Mram_RAM3_DOA_19_UNCONNECTED,
      DOA(18) => NLW_renderer_text_buffer_Mram_RAM3_DOA_18_UNCONNECTED,
      DOA(17) => NLW_renderer_text_buffer_Mram_RAM3_DOA_17_UNCONNECTED,
      DOA(16) => NLW_renderer_text_buffer_Mram_RAM3_DOA_16_UNCONNECTED,
      DOA(15) => NLW_renderer_text_buffer_Mram_RAM3_DOA_15_UNCONNECTED,
      DOA(14) => NLW_renderer_text_buffer_Mram_RAM3_DOA_14_UNCONNECTED,
      DOA(13) => NLW_renderer_text_buffer_Mram_RAM3_DOA_13_UNCONNECTED,
      DOA(12) => NLW_renderer_text_buffer_Mram_RAM3_DOA_12_UNCONNECTED,
      DOA(11) => NLW_renderer_text_buffer_Mram_RAM3_DOA_11_UNCONNECTED,
      DOA(10) => NLW_renderer_text_buffer_Mram_RAM3_DOA_10_UNCONNECTED,
      DOA(9) => NLW_renderer_text_buffer_Mram_RAM3_DOA_9_UNCONNECTED,
      DOA(8) => NLW_renderer_text_buffer_Mram_RAM3_DOA_8_UNCONNECTED,
      DOA(7) => NLW_renderer_text_buffer_Mram_RAM3_DOA_7_UNCONNECTED,
      DOA(6) => NLW_renderer_text_buffer_Mram_RAM3_DOA_6_UNCONNECTED,
      DOA(5) => NLW_renderer_text_buffer_Mram_RAM3_DOA_5_UNCONNECTED,
      DOA(4) => NLW_renderer_text_buffer_Mram_RAM3_DOA_4_UNCONNECTED,
      DOA(3) => NLW_renderer_text_buffer_Mram_RAM3_DOA_3_UNCONNECTED,
      DOA(2) => NLW_renderer_text_buffer_Mram_RAM3_DOA_2_UNCONNECTED,
      DOA(1) => NLW_renderer_text_buffer_Mram_RAM3_DOA_1_UNCONNECTED,
      DOA(0) => NLW_renderer_text_buffer_Mram_RAM3_DOA_0_UNCONNECTED,
      DOB(31) => NLW_renderer_text_buffer_Mram_RAM3_DOB_31_UNCONNECTED,
      DOB(30) => NLW_renderer_text_buffer_Mram_RAM3_DOB_30_UNCONNECTED,
      DOB(29) => NLW_renderer_text_buffer_Mram_RAM3_DOB_29_UNCONNECTED,
      DOB(28) => NLW_renderer_text_buffer_Mram_RAM3_DOB_28_UNCONNECTED,
      DOB(27) => NLW_renderer_text_buffer_Mram_RAM3_DOB_27_UNCONNECTED,
      DOB(26) => NLW_renderer_text_buffer_Mram_RAM3_DOB_26_UNCONNECTED,
      DOB(25) => NLW_renderer_text_buffer_Mram_RAM3_DOB_25_UNCONNECTED,
      DOB(24) => NLW_renderer_text_buffer_Mram_RAM3_DOB_24_UNCONNECTED,
      DOB(23) => NLW_renderer_text_buffer_Mram_RAM3_DOB_23_UNCONNECTED,
      DOB(22) => NLW_renderer_text_buffer_Mram_RAM3_DOB_22_UNCONNECTED,
      DOB(21) => NLW_renderer_text_buffer_Mram_RAM3_DOB_21_UNCONNECTED,
      DOB(20) => NLW_renderer_text_buffer_Mram_RAM3_DOB_20_UNCONNECTED,
      DOB(19) => NLW_renderer_text_buffer_Mram_RAM3_DOB_19_UNCONNECTED,
      DOB(18) => NLW_renderer_text_buffer_Mram_RAM3_DOB_18_UNCONNECTED,
      DOB(17) => NLW_renderer_text_buffer_Mram_RAM3_DOB_17_UNCONNECTED,
      DOB(16) => NLW_renderer_text_buffer_Mram_RAM3_DOB_16_UNCONNECTED,
      DOB(15) => NLW_renderer_text_buffer_Mram_RAM3_DOB_15_UNCONNECTED,
      DOB(14) => NLW_renderer_text_buffer_Mram_RAM3_DOB_14_UNCONNECTED,
      DOB(13) => NLW_renderer_text_buffer_Mram_RAM3_DOB_13_UNCONNECTED,
      DOB(12) => NLW_renderer_text_buffer_Mram_RAM3_DOB_12_UNCONNECTED,
      DOB(11) => NLW_renderer_text_buffer_Mram_RAM3_DOB_11_UNCONNECTED,
      DOB(10) => NLW_renderer_text_buffer_Mram_RAM3_DOB_10_UNCONNECTED,
      DOB(9) => NLW_renderer_text_buffer_Mram_RAM3_DOB_9_UNCONNECTED,
      DOB(8) => NLW_renderer_text_buffer_Mram_RAM3_DOB_8_UNCONNECTED,
      DOB(7) => NLW_renderer_text_buffer_Mram_RAM3_DOB_7_UNCONNECTED,
      DOB(6) => NLW_renderer_text_buffer_Mram_RAM3_DOB_6_UNCONNECTED,
      DOB(5) => NLW_renderer_text_buffer_Mram_RAM3_DOB_5_UNCONNECTED,
      DOB(4) => NLW_renderer_text_buffer_Mram_RAM3_DOB_4_UNCONNECTED,
      DOB(3) => renderer_character_data(11),
      DOB(2) => renderer_character_data(10),
      DOB(1) => renderer_character_data(9),
      DOB(0) => renderer_character_data(8),
      DOPA(3) => NLW_renderer_text_buffer_Mram_RAM3_DOPA_3_UNCONNECTED,
      DOPA(2) => NLW_renderer_text_buffer_Mram_RAM3_DOPA_2_UNCONNECTED,
      DOPA(1) => NLW_renderer_text_buffer_Mram_RAM3_DOPA_1_UNCONNECTED,
      DOPA(0) => NLW_renderer_text_buffer_Mram_RAM3_DOPA_0_UNCONNECTED,
      DOPB(3) => NLW_renderer_text_buffer_Mram_RAM3_DOPB_3_UNCONNECTED,
      DOPB(2) => NLW_renderer_text_buffer_Mram_RAM3_DOPB_2_UNCONNECTED,
      DOPB(1) => NLW_renderer_text_buffer_Mram_RAM3_DOPB_1_UNCONNECTED,
      DOPB(0) => NLW_renderer_text_buffer_Mram_RAM3_DOPB_0_UNCONNECTED,
      WEA(3) => '0',
      WEA(2) => '0',
      WEA(1) => '0',
      WEA(0) => '0',
      WEB(3) => '0',
      WEB(2) => '0',
      WEB(1) => '0',
      WEB(0) => '0'
    );
  renderer_text_buffer_Mram_RAM4 : X_RAMB16BWER
    generic map(
      DATA_WIDTH_A => 4,
      DATA_WIDTH_B => 4,
      DOA_REG => 0,
      DOB_REG => 0,
      EN_RSTRAM_A => TRUE,
      EN_RSTRAM_B => TRUE,
      RST_PRIORITY_A => "CE",
      RST_PRIORITY_B => "CE",
      RSTTYPE => "SYNC",
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_00 => X"0000000000000000000000000000000011111111111111111111111111111111",
      INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02 => X"0000000000000000000000000000000011111111111111111111111111111111",
      INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04 => X"0000000000000000000000000000000011111111111111111111111111111111",
      INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06 => X"0000000000000000000000000000000011111111111111111111111111111111",
      INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08 => X"0000000000000000000000000000000011111111111111111111111111111111",
      INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A => X"0000000000000000000000000000000011111111111111111111111111111111",
      INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C => X"0000000000000000000000000000000011111111111111111111111111111111",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"0000000000000000000000000000000011111111111111111111111111111111",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000002",
      INIT_2B => X"0000000000000000000000000000000000000000000000002000000000000000",
      INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000004",
      INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "SPARTAN6",
      INIT_FILE => "NONE",
      LOC => "RAMB16_X0Y26"
    )
    port map (
      CLKA => '0',
      CLKB => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_CLKB,
      ENA => '1',
      ENB => '1',
      REGCEA => '0',
      REGCEB => '0',
      RSTA => '0',
      RSTB => '0',
      ADDRA(13) => '0',
      ADDRA(12) => '0',
      ADDRA(11) => '0',
      ADDRA(10) => '0',
      ADDRA(9) => '0',
      ADDRA(8) => '0',
      ADDRA(7) => '0',
      ADDRA(6) => '0',
      ADDRA(5) => '0',
      ADDRA(4) => '0',
      ADDRA(3) => '0',
      ADDRA(2) => '0',
      ADDRA(1) => NLW_renderer_text_buffer_Mram_RAM4_ADDRA_1_UNCONNECTED,
      ADDRA(0) => NLW_renderer_text_buffer_Mram_RAM4_ADDRA_0_UNCONNECTED,
      ADDRB(13) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(13),
      ADDRB(12) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(12),
      ADDRB(11) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(11),
      ADDRB(10) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(10),
      ADDRB(9) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(9),
      ADDRB(8) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(8),
      ADDRB(7) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(7),
      ADDRB(6) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(6),
      ADDRB(5) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(5),
      ADDRB(4) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(4),
      ADDRB(3) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(3),
      ADDRB(2) => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(2),
      ADDRB(1) => NLW_renderer_text_buffer_Mram_RAM4_ADDRB_1_UNCONNECTED,
      ADDRB(0) => NLW_renderer_text_buffer_Mram_RAM4_ADDRB_0_UNCONNECTED,
      DIA(31) => NLW_renderer_text_buffer_Mram_RAM4_DIA_31_UNCONNECTED,
      DIA(30) => NLW_renderer_text_buffer_Mram_RAM4_DIA_30_UNCONNECTED,
      DIA(29) => NLW_renderer_text_buffer_Mram_RAM4_DIA_29_UNCONNECTED,
      DIA(28) => NLW_renderer_text_buffer_Mram_RAM4_DIA_28_UNCONNECTED,
      DIA(27) => NLW_renderer_text_buffer_Mram_RAM4_DIA_27_UNCONNECTED,
      DIA(26) => NLW_renderer_text_buffer_Mram_RAM4_DIA_26_UNCONNECTED,
      DIA(25) => NLW_renderer_text_buffer_Mram_RAM4_DIA_25_UNCONNECTED,
      DIA(24) => NLW_renderer_text_buffer_Mram_RAM4_DIA_24_UNCONNECTED,
      DIA(23) => NLW_renderer_text_buffer_Mram_RAM4_DIA_23_UNCONNECTED,
      DIA(22) => NLW_renderer_text_buffer_Mram_RAM4_DIA_22_UNCONNECTED,
      DIA(21) => NLW_renderer_text_buffer_Mram_RAM4_DIA_21_UNCONNECTED,
      DIA(20) => NLW_renderer_text_buffer_Mram_RAM4_DIA_20_UNCONNECTED,
      DIA(19) => NLW_renderer_text_buffer_Mram_RAM4_DIA_19_UNCONNECTED,
      DIA(18) => NLW_renderer_text_buffer_Mram_RAM4_DIA_18_UNCONNECTED,
      DIA(17) => NLW_renderer_text_buffer_Mram_RAM4_DIA_17_UNCONNECTED,
      DIA(16) => NLW_renderer_text_buffer_Mram_RAM4_DIA_16_UNCONNECTED,
      DIA(15) => NLW_renderer_text_buffer_Mram_RAM4_DIA_15_UNCONNECTED,
      DIA(14) => NLW_renderer_text_buffer_Mram_RAM4_DIA_14_UNCONNECTED,
      DIA(13) => NLW_renderer_text_buffer_Mram_RAM4_DIA_13_UNCONNECTED,
      DIA(12) => NLW_renderer_text_buffer_Mram_RAM4_DIA_12_UNCONNECTED,
      DIA(11) => NLW_renderer_text_buffer_Mram_RAM4_DIA_11_UNCONNECTED,
      DIA(10) => NLW_renderer_text_buffer_Mram_RAM4_DIA_10_UNCONNECTED,
      DIA(9) => NLW_renderer_text_buffer_Mram_RAM4_DIA_9_UNCONNECTED,
      DIA(8) => NLW_renderer_text_buffer_Mram_RAM4_DIA_8_UNCONNECTED,
      DIA(7) => NLW_renderer_text_buffer_Mram_RAM4_DIA_7_UNCONNECTED,
      DIA(6) => NLW_renderer_text_buffer_Mram_RAM4_DIA_6_UNCONNECTED,
      DIA(5) => NLW_renderer_text_buffer_Mram_RAM4_DIA_5_UNCONNECTED,
      DIA(4) => NLW_renderer_text_buffer_Mram_RAM4_DIA_4_UNCONNECTED,
      DIA(3) => '0',
      DIA(2) => '0',
      DIA(1) => '0',
      DIA(0) => '0',
      DIB(31) => NLW_renderer_text_buffer_Mram_RAM4_DIB_31_UNCONNECTED,
      DIB(30) => NLW_renderer_text_buffer_Mram_RAM4_DIB_30_UNCONNECTED,
      DIB(29) => NLW_renderer_text_buffer_Mram_RAM4_DIB_29_UNCONNECTED,
      DIB(28) => NLW_renderer_text_buffer_Mram_RAM4_DIB_28_UNCONNECTED,
      DIB(27) => NLW_renderer_text_buffer_Mram_RAM4_DIB_27_UNCONNECTED,
      DIB(26) => NLW_renderer_text_buffer_Mram_RAM4_DIB_26_UNCONNECTED,
      DIB(25) => NLW_renderer_text_buffer_Mram_RAM4_DIB_25_UNCONNECTED,
      DIB(24) => NLW_renderer_text_buffer_Mram_RAM4_DIB_24_UNCONNECTED,
      DIB(23) => NLW_renderer_text_buffer_Mram_RAM4_DIB_23_UNCONNECTED,
      DIB(22) => NLW_renderer_text_buffer_Mram_RAM4_DIB_22_UNCONNECTED,
      DIB(21) => NLW_renderer_text_buffer_Mram_RAM4_DIB_21_UNCONNECTED,
      DIB(20) => NLW_renderer_text_buffer_Mram_RAM4_DIB_20_UNCONNECTED,
      DIB(19) => NLW_renderer_text_buffer_Mram_RAM4_DIB_19_UNCONNECTED,
      DIB(18) => NLW_renderer_text_buffer_Mram_RAM4_DIB_18_UNCONNECTED,
      DIB(17) => NLW_renderer_text_buffer_Mram_RAM4_DIB_17_UNCONNECTED,
      DIB(16) => NLW_renderer_text_buffer_Mram_RAM4_DIB_16_UNCONNECTED,
      DIB(15) => NLW_renderer_text_buffer_Mram_RAM4_DIB_15_UNCONNECTED,
      DIB(14) => NLW_renderer_text_buffer_Mram_RAM4_DIB_14_UNCONNECTED,
      DIB(13) => NLW_renderer_text_buffer_Mram_RAM4_DIB_13_UNCONNECTED,
      DIB(12) => NLW_renderer_text_buffer_Mram_RAM4_DIB_12_UNCONNECTED,
      DIB(11) => NLW_renderer_text_buffer_Mram_RAM4_DIB_11_UNCONNECTED,
      DIB(10) => NLW_renderer_text_buffer_Mram_RAM4_DIB_10_UNCONNECTED,
      DIB(9) => NLW_renderer_text_buffer_Mram_RAM4_DIB_9_UNCONNECTED,
      DIB(8) => NLW_renderer_text_buffer_Mram_RAM4_DIB_8_UNCONNECTED,
      DIB(7) => NLW_renderer_text_buffer_Mram_RAM4_DIB_7_UNCONNECTED,
      DIB(6) => NLW_renderer_text_buffer_Mram_RAM4_DIB_6_UNCONNECTED,
      DIB(5) => NLW_renderer_text_buffer_Mram_RAM4_DIB_5_UNCONNECTED,
      DIB(4) => NLW_renderer_text_buffer_Mram_RAM4_DIB_4_UNCONNECTED,
      DIB(3) => NLW_renderer_text_buffer_Mram_RAM4_DIB_3_UNCONNECTED,
      DIB(2) => NLW_renderer_text_buffer_Mram_RAM4_DIB_2_UNCONNECTED,
      DIB(1) => NLW_renderer_text_buffer_Mram_RAM4_DIB_1_UNCONNECTED,
      DIB(0) => NLW_renderer_text_buffer_Mram_RAM4_DIB_0_UNCONNECTED,
      DIPA(3) => NLW_renderer_text_buffer_Mram_RAM4_DIPA_3_UNCONNECTED,
      DIPA(2) => NLW_renderer_text_buffer_Mram_RAM4_DIPA_2_UNCONNECTED,
      DIPA(1) => NLW_renderer_text_buffer_Mram_RAM4_DIPA_1_UNCONNECTED,
      DIPA(0) => NLW_renderer_text_buffer_Mram_RAM4_DIPA_0_UNCONNECTED,
      DIPB(3) => NLW_renderer_text_buffer_Mram_RAM4_DIPB_3_UNCONNECTED,
      DIPB(2) => NLW_renderer_text_buffer_Mram_RAM4_DIPB_2_UNCONNECTED,
      DIPB(1) => NLW_renderer_text_buffer_Mram_RAM4_DIPB_1_UNCONNECTED,
      DIPB(0) => NLW_renderer_text_buffer_Mram_RAM4_DIPB_0_UNCONNECTED,
      DOA(31) => NLW_renderer_text_buffer_Mram_RAM4_DOA_31_UNCONNECTED,
      DOA(30) => NLW_renderer_text_buffer_Mram_RAM4_DOA_30_UNCONNECTED,
      DOA(29) => NLW_renderer_text_buffer_Mram_RAM4_DOA_29_UNCONNECTED,
      DOA(28) => NLW_renderer_text_buffer_Mram_RAM4_DOA_28_UNCONNECTED,
      DOA(27) => NLW_renderer_text_buffer_Mram_RAM4_DOA_27_UNCONNECTED,
      DOA(26) => NLW_renderer_text_buffer_Mram_RAM4_DOA_26_UNCONNECTED,
      DOA(25) => NLW_renderer_text_buffer_Mram_RAM4_DOA_25_UNCONNECTED,
      DOA(24) => NLW_renderer_text_buffer_Mram_RAM4_DOA_24_UNCONNECTED,
      DOA(23) => NLW_renderer_text_buffer_Mram_RAM4_DOA_23_UNCONNECTED,
      DOA(22) => NLW_renderer_text_buffer_Mram_RAM4_DOA_22_UNCONNECTED,
      DOA(21) => NLW_renderer_text_buffer_Mram_RAM4_DOA_21_UNCONNECTED,
      DOA(20) => NLW_renderer_text_buffer_Mram_RAM4_DOA_20_UNCONNECTED,
      DOA(19) => NLW_renderer_text_buffer_Mram_RAM4_DOA_19_UNCONNECTED,
      DOA(18) => NLW_renderer_text_buffer_Mram_RAM4_DOA_18_UNCONNECTED,
      DOA(17) => NLW_renderer_text_buffer_Mram_RAM4_DOA_17_UNCONNECTED,
      DOA(16) => NLW_renderer_text_buffer_Mram_RAM4_DOA_16_UNCONNECTED,
      DOA(15) => NLW_renderer_text_buffer_Mram_RAM4_DOA_15_UNCONNECTED,
      DOA(14) => NLW_renderer_text_buffer_Mram_RAM4_DOA_14_UNCONNECTED,
      DOA(13) => NLW_renderer_text_buffer_Mram_RAM4_DOA_13_UNCONNECTED,
      DOA(12) => NLW_renderer_text_buffer_Mram_RAM4_DOA_12_UNCONNECTED,
      DOA(11) => NLW_renderer_text_buffer_Mram_RAM4_DOA_11_UNCONNECTED,
      DOA(10) => NLW_renderer_text_buffer_Mram_RAM4_DOA_10_UNCONNECTED,
      DOA(9) => NLW_renderer_text_buffer_Mram_RAM4_DOA_9_UNCONNECTED,
      DOA(8) => NLW_renderer_text_buffer_Mram_RAM4_DOA_8_UNCONNECTED,
      DOA(7) => NLW_renderer_text_buffer_Mram_RAM4_DOA_7_UNCONNECTED,
      DOA(6) => NLW_renderer_text_buffer_Mram_RAM4_DOA_6_UNCONNECTED,
      DOA(5) => NLW_renderer_text_buffer_Mram_RAM4_DOA_5_UNCONNECTED,
      DOA(4) => NLW_renderer_text_buffer_Mram_RAM4_DOA_4_UNCONNECTED,
      DOA(3) => NLW_renderer_text_buffer_Mram_RAM4_DOA_3_UNCONNECTED,
      DOA(2) => NLW_renderer_text_buffer_Mram_RAM4_DOA_2_UNCONNECTED,
      DOA(1) => NLW_renderer_text_buffer_Mram_RAM4_DOA_1_UNCONNECTED,
      DOA(0) => NLW_renderer_text_buffer_Mram_RAM4_DOA_0_UNCONNECTED,
      DOB(31) => NLW_renderer_text_buffer_Mram_RAM4_DOB_31_UNCONNECTED,
      DOB(30) => NLW_renderer_text_buffer_Mram_RAM4_DOB_30_UNCONNECTED,
      DOB(29) => NLW_renderer_text_buffer_Mram_RAM4_DOB_29_UNCONNECTED,
      DOB(28) => NLW_renderer_text_buffer_Mram_RAM4_DOB_28_UNCONNECTED,
      DOB(27) => NLW_renderer_text_buffer_Mram_RAM4_DOB_27_UNCONNECTED,
      DOB(26) => NLW_renderer_text_buffer_Mram_RAM4_DOB_26_UNCONNECTED,
      DOB(25) => NLW_renderer_text_buffer_Mram_RAM4_DOB_25_UNCONNECTED,
      DOB(24) => NLW_renderer_text_buffer_Mram_RAM4_DOB_24_UNCONNECTED,
      DOB(23) => NLW_renderer_text_buffer_Mram_RAM4_DOB_23_UNCONNECTED,
      DOB(22) => NLW_renderer_text_buffer_Mram_RAM4_DOB_22_UNCONNECTED,
      DOB(21) => NLW_renderer_text_buffer_Mram_RAM4_DOB_21_UNCONNECTED,
      DOB(20) => NLW_renderer_text_buffer_Mram_RAM4_DOB_20_UNCONNECTED,
      DOB(19) => NLW_renderer_text_buffer_Mram_RAM4_DOB_19_UNCONNECTED,
      DOB(18) => NLW_renderer_text_buffer_Mram_RAM4_DOB_18_UNCONNECTED,
      DOB(17) => NLW_renderer_text_buffer_Mram_RAM4_DOB_17_UNCONNECTED,
      DOB(16) => NLW_renderer_text_buffer_Mram_RAM4_DOB_16_UNCONNECTED,
      DOB(15) => NLW_renderer_text_buffer_Mram_RAM4_DOB_15_UNCONNECTED,
      DOB(14) => NLW_renderer_text_buffer_Mram_RAM4_DOB_14_UNCONNECTED,
      DOB(13) => NLW_renderer_text_buffer_Mram_RAM4_DOB_13_UNCONNECTED,
      DOB(12) => NLW_renderer_text_buffer_Mram_RAM4_DOB_12_UNCONNECTED,
      DOB(11) => NLW_renderer_text_buffer_Mram_RAM4_DOB_11_UNCONNECTED,
      DOB(10) => NLW_renderer_text_buffer_Mram_RAM4_DOB_10_UNCONNECTED,
      DOB(9) => NLW_renderer_text_buffer_Mram_RAM4_DOB_9_UNCONNECTED,
      DOB(8) => NLW_renderer_text_buffer_Mram_RAM4_DOB_8_UNCONNECTED,
      DOB(7) => NLW_renderer_text_buffer_Mram_RAM4_DOB_7_UNCONNECTED,
      DOB(6) => NLW_renderer_text_buffer_Mram_RAM4_DOB_6_UNCONNECTED,
      DOB(5) => NLW_renderer_text_buffer_Mram_RAM4_DOB_5_UNCONNECTED,
      DOB(4) => NLW_renderer_text_buffer_Mram_RAM4_DOB_4_UNCONNECTED,
      DOB(3) => NLW_renderer_text_buffer_Mram_RAM4_DOB_3_UNCONNECTED,
      DOB(2) => renderer_Mram_bgcolor23,
      DOB(1) => renderer_Mram_bgcolor15,
      DOB(0) => renderer_Mram_bgcolor7,
      DOPA(3) => NLW_renderer_text_buffer_Mram_RAM4_DOPA_3_UNCONNECTED,
      DOPA(2) => NLW_renderer_text_buffer_Mram_RAM4_DOPA_2_UNCONNECTED,
      DOPA(1) => NLW_renderer_text_buffer_Mram_RAM4_DOPA_1_UNCONNECTED,
      DOPA(0) => NLW_renderer_text_buffer_Mram_RAM4_DOPA_0_UNCONNECTED,
      DOPB(3) => NLW_renderer_text_buffer_Mram_RAM4_DOPB_3_UNCONNECTED,
      DOPB(2) => NLW_renderer_text_buffer_Mram_RAM4_DOPB_2_UNCONNECTED,
      DOPB(1) => NLW_renderer_text_buffer_Mram_RAM4_DOPB_1_UNCONNECTED,
      DOPB(0) => NLW_renderer_text_buffer_Mram_RAM4_DOPB_0_UNCONNECTED,
      WEA(3) => '0',
      WEA(2) => '0',
      WEA(1) => '0',
      WEA(0) => '0',
      WEB(3) => '0',
      WEB(2) => '0',
      WEB(1) => '0',
      WEB(0) => '0'
    );
  INV_renderer_character_rom_Mram_rom1CLKA : X_INV
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => renderer_character_rom_Mram_rom1_INV_renderer_character_rom_Mram_rom1CLKA
    );
  renderer_character_rom_Mram_rom1 : X_RAMB16BWER
    generic map(
      DATA_WIDTH_A => 4,
      DATA_WIDTH_B => 0,
      DOA_REG => 0,
      DOB_REG => 0,
      EN_RSTRAM_A => TRUE,
      EN_RSTRAM_B => TRUE,
      RST_PRIORITY_A => "CE",
      RST_PRIORITY_B => "CE",
      RSTTYPE => "SYNC",
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_00 => X"000008CEEEEC00000000EFF73FFBFE000000E119D1151E000000000000000000",
      INIT_01 => X"0000008CC80000000000C88EFFEC80000000C88777CC80000000008CEC800000",
      INIT_02 => X"00008CCCC82AEE00FFFFF39DD93FFFFF00000C6226C00000FFFFFF7337FFFFFF",
      INIT_03 => X"000088BC7CB8800000006773333F3F0000000000000F3F00000088E8C6666C00",
      INIT_04 => X"0006606666666600000008CE888EC800000026EEEEEEE620000000008E800000",
      INIT_05 => X"0000E8CE888EC8000000EEEE00000000000C6C8C66C806C00000BBBBBBBBBF00",
      INIT_06 => X"00000000E00000000000008CEC80000000008CE88888880000008888888EC800",
      INIT_07 => X"00000088CCEE000000000EECC88000000000008CEC800000000000E000000000",
      INIT_08 => X"0000CCECCCECC00000000000000466600000880888CCC8000000000000000000",
      INIT_09 => X"000000000000000000006CCCC68CC800000066008C6200000088C6666C026C88",
      INIT_0A => X"00000088E88000000000006CFC600000000008CCCCCC80000000C80000008C00",
      INIT_0B => X"000000008C6200000000880000000000000000000E0000000008880000000000",
      INIT_0C => X"0000C6666C666C000000E60008C66C000000E8888888880000008C666666C800",
      INIT_0D => X"000000008C666E000000C6666C0008000000C6666C000E000000ECCCECCCCC00",
      INIT_0E => X"0000088000880000000008800088000000008C666E666C000000C6666C666C00",
      INIT_0F => X"0000880888C66C000000008C6C8000000000000E00E0000000006C80008C6000",
      INIT_10 => X"0000C62000026C000000C6666C666C0000006666E66C80000000C0CEEE66E000",
      INIT_11 => X"0000A666E0026C000000000088826E000000E62088826E0000008C666666C800",
      INIT_12 => X"0000666C88C6660000008CCCCCCCCE000000C88888888C00000066666E666600",
      INIT_13 => X"0000C66666666C0000006666EEE666000000666666EEE6000000E62000000000",
      INIT_14 => X"0000C666C8066C0000006666CC666C0000ECCE6666666C00000000000C666C00",
      INIT_15 => X"0000CEE666666600000008C6666666000000C666666666000000C888888AEE00",
      INIT_16 => X"0000C00000000C000000E62008C66E000000C8888C666600000066CC88CC6600",
      INIT_17 => X"0F000000000000000000000000006C800000CCCCCCCCCC00000026EC80000000",
      INIT_18 => X"0000C60006C000000000C6666C80000000006CCCCC8000000000000000000800",
      INIT_19 => X"08CCCCCCCC600000000000000004C8000000C600E6C0000000006CCCCCCCCC00",
      INIT_1A => X"000066C88C6000000C66666666E066000000C888888088000000666666C00000",
      INIT_1B => X"0000C66666C000000000666666C00000000066666EC000000000C88888888800",
      INIT_1C => X"0000C6C806C000000000000066C000000ECCCCCCCC6000000000C66666C00000",
      INIT_1D => X"0000CE666660000000008C666660000000006CCCCCC000000000C60000C00000",
      INIT_1E => X"0000E88880888E000000E6008CE0000008C6E6666660000000006C888C600000",
      INIT_1F => X"00000E666C800000000000000000C600000008888E8880000000888880888800",
      INIT_20 => X"00006CCCCC80C8000000C600E6C008C000006CCCCCC00C0000C6CC6200026C00",
      INIT_21 => X"000C6CC6006C000000006CCCCC808C8000006CCCCC80800000006CCCCC800C00",
      INIT_22 => X"0000C888888006000000C600E6C080000000C600E6C006000000C600E6C0C800",
      INIT_23 => X"0000666E66C808C80000666E66C800600000C888888080000000C88888806C80",
      INIT_24 => X"0000C66666C0C8000000ECCCCECCCE000000E88E66C000000000E600C06E0008",
      INIT_25 => X"00006CCCCCC0800000006CCCCCC0C8000000C66666C080000000C66666C00600",
      INIT_26 => X"000088C60006C8800000C666666660600000C6666666C06008C6E66666600600",
      INIT_27 => X"000888888E888BE000006CCCEC48CC800000888E8E8C66000000C60000004C80",
      INIT_28 => X"00006CCCCCC000800000C66666C000800000C888888008C000006CCCCC800080",
      INIT_29 => X"000000000C08CC80000000000E0ECCC00000666EEE6660C60000666666C0C600",
      INIT_2A => X"00E8C6C008C62000000006666E000000000000000E0000000000C66000000000",
      INIT_2B => X"0000008C6C8000000000006C8C60000000008CCC888088000066EEE608C62000",
      INIT_2C => X"88888888888888887D7D7D7D7D7D7D7DA5A5A5A5A5A5A5A54141414141414141",
      INIT_2D => X"66666666E0000000666666666666666688888888888888888888888888888888",
      INIT_2E => X"6666666666E00000666666666666666666666666666666668888888888800000",
      INIT_2F => X"8888888880000000000000008888888800000000E666666600000000E6666666",
      INIT_30 => X"88888888F888888888888888F000000000000000F888888800000000F8888888",
      INIT_31 => X"666666667666666688888888F8F8888888888888F888888800000000F0000000",
      INIT_32 => X"6666666670F0000000000000F07666666666666670F0000000000000F0766666",
      INIT_33 => X"00000000F0F88888666666667076666600000000F0F000006666666670766666",
      INIT_34 => X"00000000F666666666666666F000000088888888F0F0000000000000F6666666",
      INIT_35 => X"66666666F666666666666666F000000088888888F8F0000000000000F8F88888",
      INIT_36 => X"FFFFFFFFFFFFFFFF88888888F0000000000000008888888888888888F8F88888",
      INIT_37 => X"000000000FFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFF0000000",
      INIT_38 => X"0000CCCCCCCE00000000000000066E000000C666C8CCC80000006C888C600000",
      INIT_39 => X"0000888888C60000000000C6666600000000088888E000000000E6008006E000",
      INIT_3A => X"0000C6666EC80E000000ECCCC666C80000008C66E66C80000000E8C666C8E000",
      INIT_3B => X"000066666666C0000000C0000C000C00000000E3BBE63000000000EBBBE00000",
      INIT_3C => X"0000E0C80008C0000000E008C6C800000000F0088E88000000000E00E00E0000",
      INIT_3D => X"000000C60C60000000000880E0880000000008888888888888888888888BBE00",
      INIT_3E => X"0000CCCCCCCCCCF000000008000000000000000880000000000000000008CC80",
      INIT_3F => X"000000000000000000000CCCCCCC00000000000008800800000000000CCCCC80",
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "SPARTAN6",
      INIT_FILE => "NONE",
      LOC => "RAMB16_X1Y18"
    )
    port map (
      CLKA => NlwBufferSignal_renderer_character_rom_Mram_rom1_CLKA,
      CLKB => NLW_renderer_character_rom_Mram_rom1_CLKB_UNCONNECTED,
      ENA => '1',
      ENB => NLW_renderer_character_rom_Mram_rom1_ENB_UNCONNECTED,
      REGCEA => '0',
      REGCEB => NLW_renderer_character_rom_Mram_rom1_REGCEB_UNCONNECTED,
      RSTA => '0',
      RSTB => NLW_renderer_character_rom_Mram_rom1_RSTB_UNCONNECTED,
      ADDRA(13) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(13),
      ADDRA(12) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(12),
      ADDRA(11) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(11),
      ADDRA(10) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(10),
      ADDRA(9) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(9),
      ADDRA(8) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(8),
      ADDRA(7) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(7),
      ADDRA(6) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(6),
      ADDRA(5) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(5),
      ADDRA(4) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(4),
      ADDRA(3) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(3),
      ADDRA(2) => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(2),
      ADDRA(1) => NLW_renderer_character_rom_Mram_rom1_ADDRA_1_UNCONNECTED,
      ADDRA(0) => NLW_renderer_character_rom_Mram_rom1_ADDRA_0_UNCONNECTED,
      ADDRB(13) => NLW_renderer_character_rom_Mram_rom1_ADDRB_13_UNCONNECTED,
      ADDRB(12) => NLW_renderer_character_rom_Mram_rom1_ADDRB_12_UNCONNECTED,
      ADDRB(11) => NLW_renderer_character_rom_Mram_rom1_ADDRB_11_UNCONNECTED,
      ADDRB(10) => NLW_renderer_character_rom_Mram_rom1_ADDRB_10_UNCONNECTED,
      ADDRB(9) => NLW_renderer_character_rom_Mram_rom1_ADDRB_9_UNCONNECTED,
      ADDRB(8) => NLW_renderer_character_rom_Mram_rom1_ADDRB_8_UNCONNECTED,
      ADDRB(7) => NLW_renderer_character_rom_Mram_rom1_ADDRB_7_UNCONNECTED,
      ADDRB(6) => NLW_renderer_character_rom_Mram_rom1_ADDRB_6_UNCONNECTED,
      ADDRB(5) => NLW_renderer_character_rom_Mram_rom1_ADDRB_5_UNCONNECTED,
      ADDRB(4) => NLW_renderer_character_rom_Mram_rom1_ADDRB_4_UNCONNECTED,
      ADDRB(3) => NLW_renderer_character_rom_Mram_rom1_ADDRB_3_UNCONNECTED,
      ADDRB(2) => NLW_renderer_character_rom_Mram_rom1_ADDRB_2_UNCONNECTED,
      ADDRB(1) => NLW_renderer_character_rom_Mram_rom1_ADDRB_1_UNCONNECTED,
      ADDRB(0) => NLW_renderer_character_rom_Mram_rom1_ADDRB_0_UNCONNECTED,
      DIA(31) => NLW_renderer_character_rom_Mram_rom1_DIA_31_UNCONNECTED,
      DIA(30) => NLW_renderer_character_rom_Mram_rom1_DIA_30_UNCONNECTED,
      DIA(29) => NLW_renderer_character_rom_Mram_rom1_DIA_29_UNCONNECTED,
      DIA(28) => NLW_renderer_character_rom_Mram_rom1_DIA_28_UNCONNECTED,
      DIA(27) => NLW_renderer_character_rom_Mram_rom1_DIA_27_UNCONNECTED,
      DIA(26) => NLW_renderer_character_rom_Mram_rom1_DIA_26_UNCONNECTED,
      DIA(25) => NLW_renderer_character_rom_Mram_rom1_DIA_25_UNCONNECTED,
      DIA(24) => NLW_renderer_character_rom_Mram_rom1_DIA_24_UNCONNECTED,
      DIA(23) => NLW_renderer_character_rom_Mram_rom1_DIA_23_UNCONNECTED,
      DIA(22) => NLW_renderer_character_rom_Mram_rom1_DIA_22_UNCONNECTED,
      DIA(21) => NLW_renderer_character_rom_Mram_rom1_DIA_21_UNCONNECTED,
      DIA(20) => NLW_renderer_character_rom_Mram_rom1_DIA_20_UNCONNECTED,
      DIA(19) => NLW_renderer_character_rom_Mram_rom1_DIA_19_UNCONNECTED,
      DIA(18) => NLW_renderer_character_rom_Mram_rom1_DIA_18_UNCONNECTED,
      DIA(17) => NLW_renderer_character_rom_Mram_rom1_DIA_17_UNCONNECTED,
      DIA(16) => NLW_renderer_character_rom_Mram_rom1_DIA_16_UNCONNECTED,
      DIA(15) => NLW_renderer_character_rom_Mram_rom1_DIA_15_UNCONNECTED,
      DIA(14) => NLW_renderer_character_rom_Mram_rom1_DIA_14_UNCONNECTED,
      DIA(13) => NLW_renderer_character_rom_Mram_rom1_DIA_13_UNCONNECTED,
      DIA(12) => NLW_renderer_character_rom_Mram_rom1_DIA_12_UNCONNECTED,
      DIA(11) => NLW_renderer_character_rom_Mram_rom1_DIA_11_UNCONNECTED,
      DIA(10) => NLW_renderer_character_rom_Mram_rom1_DIA_10_UNCONNECTED,
      DIA(9) => NLW_renderer_character_rom_Mram_rom1_DIA_9_UNCONNECTED,
      DIA(8) => NLW_renderer_character_rom_Mram_rom1_DIA_8_UNCONNECTED,
      DIA(7) => NLW_renderer_character_rom_Mram_rom1_DIA_7_UNCONNECTED,
      DIA(6) => NLW_renderer_character_rom_Mram_rom1_DIA_6_UNCONNECTED,
      DIA(5) => NLW_renderer_character_rom_Mram_rom1_DIA_5_UNCONNECTED,
      DIA(4) => NLW_renderer_character_rom_Mram_rom1_DIA_4_UNCONNECTED,
      DIA(3) => '0',
      DIA(2) => '0',
      DIA(1) => '0',
      DIA(0) => '0',
      DIB(31) => NLW_renderer_character_rom_Mram_rom1_DIB_31_UNCONNECTED,
      DIB(30) => NLW_renderer_character_rom_Mram_rom1_DIB_30_UNCONNECTED,
      DIB(29) => NLW_renderer_character_rom_Mram_rom1_DIB_29_UNCONNECTED,
      DIB(28) => NLW_renderer_character_rom_Mram_rom1_DIB_28_UNCONNECTED,
      DIB(27) => NLW_renderer_character_rom_Mram_rom1_DIB_27_UNCONNECTED,
      DIB(26) => NLW_renderer_character_rom_Mram_rom1_DIB_26_UNCONNECTED,
      DIB(25) => NLW_renderer_character_rom_Mram_rom1_DIB_25_UNCONNECTED,
      DIB(24) => NLW_renderer_character_rom_Mram_rom1_DIB_24_UNCONNECTED,
      DIB(23) => NLW_renderer_character_rom_Mram_rom1_DIB_23_UNCONNECTED,
      DIB(22) => NLW_renderer_character_rom_Mram_rom1_DIB_22_UNCONNECTED,
      DIB(21) => NLW_renderer_character_rom_Mram_rom1_DIB_21_UNCONNECTED,
      DIB(20) => NLW_renderer_character_rom_Mram_rom1_DIB_20_UNCONNECTED,
      DIB(19) => NLW_renderer_character_rom_Mram_rom1_DIB_19_UNCONNECTED,
      DIB(18) => NLW_renderer_character_rom_Mram_rom1_DIB_18_UNCONNECTED,
      DIB(17) => NLW_renderer_character_rom_Mram_rom1_DIB_17_UNCONNECTED,
      DIB(16) => NLW_renderer_character_rom_Mram_rom1_DIB_16_UNCONNECTED,
      DIB(15) => NLW_renderer_character_rom_Mram_rom1_DIB_15_UNCONNECTED,
      DIB(14) => NLW_renderer_character_rom_Mram_rom1_DIB_14_UNCONNECTED,
      DIB(13) => NLW_renderer_character_rom_Mram_rom1_DIB_13_UNCONNECTED,
      DIB(12) => NLW_renderer_character_rom_Mram_rom1_DIB_12_UNCONNECTED,
      DIB(11) => NLW_renderer_character_rom_Mram_rom1_DIB_11_UNCONNECTED,
      DIB(10) => NLW_renderer_character_rom_Mram_rom1_DIB_10_UNCONNECTED,
      DIB(9) => NLW_renderer_character_rom_Mram_rom1_DIB_9_UNCONNECTED,
      DIB(8) => NLW_renderer_character_rom_Mram_rom1_DIB_8_UNCONNECTED,
      DIB(7) => NLW_renderer_character_rom_Mram_rom1_DIB_7_UNCONNECTED,
      DIB(6) => NLW_renderer_character_rom_Mram_rom1_DIB_6_UNCONNECTED,
      DIB(5) => NLW_renderer_character_rom_Mram_rom1_DIB_5_UNCONNECTED,
      DIB(4) => NLW_renderer_character_rom_Mram_rom1_DIB_4_UNCONNECTED,
      DIB(3) => NLW_renderer_character_rom_Mram_rom1_DIB_3_UNCONNECTED,
      DIB(2) => NLW_renderer_character_rom_Mram_rom1_DIB_2_UNCONNECTED,
      DIB(1) => NLW_renderer_character_rom_Mram_rom1_DIB_1_UNCONNECTED,
      DIB(0) => NLW_renderer_character_rom_Mram_rom1_DIB_0_UNCONNECTED,
      DIPA(3) => NLW_renderer_character_rom_Mram_rom1_DIPA_3_UNCONNECTED,
      DIPA(2) => NLW_renderer_character_rom_Mram_rom1_DIPA_2_UNCONNECTED,
      DIPA(1) => NLW_renderer_character_rom_Mram_rom1_DIPA_1_UNCONNECTED,
      DIPA(0) => NLW_renderer_character_rom_Mram_rom1_DIPA_0_UNCONNECTED,
      DIPB(3) => NLW_renderer_character_rom_Mram_rom1_DIPB_3_UNCONNECTED,
      DIPB(2) => NLW_renderer_character_rom_Mram_rom1_DIPB_2_UNCONNECTED,
      DIPB(1) => NLW_renderer_character_rom_Mram_rom1_DIPB_1_UNCONNECTED,
      DIPB(0) => NLW_renderer_character_rom_Mram_rom1_DIPB_0_UNCONNECTED,
      DOA(31) => NLW_renderer_character_rom_Mram_rom1_DOA_31_UNCONNECTED,
      DOA(30) => NLW_renderer_character_rom_Mram_rom1_DOA_30_UNCONNECTED,
      DOA(29) => NLW_renderer_character_rom_Mram_rom1_DOA_29_UNCONNECTED,
      DOA(28) => NLW_renderer_character_rom_Mram_rom1_DOA_28_UNCONNECTED,
      DOA(27) => NLW_renderer_character_rom_Mram_rom1_DOA_27_UNCONNECTED,
      DOA(26) => NLW_renderer_character_rom_Mram_rom1_DOA_26_UNCONNECTED,
      DOA(25) => NLW_renderer_character_rom_Mram_rom1_DOA_25_UNCONNECTED,
      DOA(24) => NLW_renderer_character_rom_Mram_rom1_DOA_24_UNCONNECTED,
      DOA(23) => NLW_renderer_character_rom_Mram_rom1_DOA_23_UNCONNECTED,
      DOA(22) => NLW_renderer_character_rom_Mram_rom1_DOA_22_UNCONNECTED,
      DOA(21) => NLW_renderer_character_rom_Mram_rom1_DOA_21_UNCONNECTED,
      DOA(20) => NLW_renderer_character_rom_Mram_rom1_DOA_20_UNCONNECTED,
      DOA(19) => NLW_renderer_character_rom_Mram_rom1_DOA_19_UNCONNECTED,
      DOA(18) => NLW_renderer_character_rom_Mram_rom1_DOA_18_UNCONNECTED,
      DOA(17) => NLW_renderer_character_rom_Mram_rom1_DOA_17_UNCONNECTED,
      DOA(16) => NLW_renderer_character_rom_Mram_rom1_DOA_16_UNCONNECTED,
      DOA(15) => NLW_renderer_character_rom_Mram_rom1_DOA_15_UNCONNECTED,
      DOA(14) => NLW_renderer_character_rom_Mram_rom1_DOA_14_UNCONNECTED,
      DOA(13) => NLW_renderer_character_rom_Mram_rom1_DOA_13_UNCONNECTED,
      DOA(12) => NLW_renderer_character_rom_Mram_rom1_DOA_12_UNCONNECTED,
      DOA(11) => NLW_renderer_character_rom_Mram_rom1_DOA_11_UNCONNECTED,
      DOA(10) => NLW_renderer_character_rom_Mram_rom1_DOA_10_UNCONNECTED,
      DOA(9) => NLW_renderer_character_rom_Mram_rom1_DOA_9_UNCONNECTED,
      DOA(8) => NLW_renderer_character_rom_Mram_rom1_DOA_8_UNCONNECTED,
      DOA(7) => NLW_renderer_character_rom_Mram_rom1_DOA_7_UNCONNECTED,
      DOA(6) => NLW_renderer_character_rom_Mram_rom1_DOA_6_UNCONNECTED,
      DOA(5) => NLW_renderer_character_rom_Mram_rom1_DOA_5_UNCONNECTED,
      DOA(4) => NLW_renderer_character_rom_Mram_rom1_DOA_4_UNCONNECTED,
      DOA(3) => renderer_glyph_row(3),
      DOA(2) => renderer_glyph_row(2),
      DOA(1) => renderer_glyph_row(1),
      DOA(0) => renderer_glyph_row(0),
      DOB(31) => NLW_renderer_character_rom_Mram_rom1_DOB_31_UNCONNECTED,
      DOB(30) => NLW_renderer_character_rom_Mram_rom1_DOB_30_UNCONNECTED,
      DOB(29) => NLW_renderer_character_rom_Mram_rom1_DOB_29_UNCONNECTED,
      DOB(28) => NLW_renderer_character_rom_Mram_rom1_DOB_28_UNCONNECTED,
      DOB(27) => NLW_renderer_character_rom_Mram_rom1_DOB_27_UNCONNECTED,
      DOB(26) => NLW_renderer_character_rom_Mram_rom1_DOB_26_UNCONNECTED,
      DOB(25) => NLW_renderer_character_rom_Mram_rom1_DOB_25_UNCONNECTED,
      DOB(24) => NLW_renderer_character_rom_Mram_rom1_DOB_24_UNCONNECTED,
      DOB(23) => NLW_renderer_character_rom_Mram_rom1_DOB_23_UNCONNECTED,
      DOB(22) => NLW_renderer_character_rom_Mram_rom1_DOB_22_UNCONNECTED,
      DOB(21) => NLW_renderer_character_rom_Mram_rom1_DOB_21_UNCONNECTED,
      DOB(20) => NLW_renderer_character_rom_Mram_rom1_DOB_20_UNCONNECTED,
      DOB(19) => NLW_renderer_character_rom_Mram_rom1_DOB_19_UNCONNECTED,
      DOB(18) => NLW_renderer_character_rom_Mram_rom1_DOB_18_UNCONNECTED,
      DOB(17) => NLW_renderer_character_rom_Mram_rom1_DOB_17_UNCONNECTED,
      DOB(16) => NLW_renderer_character_rom_Mram_rom1_DOB_16_UNCONNECTED,
      DOB(15) => NLW_renderer_character_rom_Mram_rom1_DOB_15_UNCONNECTED,
      DOB(14) => NLW_renderer_character_rom_Mram_rom1_DOB_14_UNCONNECTED,
      DOB(13) => NLW_renderer_character_rom_Mram_rom1_DOB_13_UNCONNECTED,
      DOB(12) => NLW_renderer_character_rom_Mram_rom1_DOB_12_UNCONNECTED,
      DOB(11) => NLW_renderer_character_rom_Mram_rom1_DOB_11_UNCONNECTED,
      DOB(10) => NLW_renderer_character_rom_Mram_rom1_DOB_10_UNCONNECTED,
      DOB(9) => NLW_renderer_character_rom_Mram_rom1_DOB_9_UNCONNECTED,
      DOB(8) => NLW_renderer_character_rom_Mram_rom1_DOB_8_UNCONNECTED,
      DOB(7) => NLW_renderer_character_rom_Mram_rom1_DOB_7_UNCONNECTED,
      DOB(6) => NLW_renderer_character_rom_Mram_rom1_DOB_6_UNCONNECTED,
      DOB(5) => NLW_renderer_character_rom_Mram_rom1_DOB_5_UNCONNECTED,
      DOB(4) => NLW_renderer_character_rom_Mram_rom1_DOB_4_UNCONNECTED,
      DOB(3) => NLW_renderer_character_rom_Mram_rom1_DOB_3_UNCONNECTED,
      DOB(2) => NLW_renderer_character_rom_Mram_rom1_DOB_2_UNCONNECTED,
      DOB(1) => NLW_renderer_character_rom_Mram_rom1_DOB_1_UNCONNECTED,
      DOB(0) => NLW_renderer_character_rom_Mram_rom1_DOB_0_UNCONNECTED,
      DOPA(3) => NLW_renderer_character_rom_Mram_rom1_DOPA_3_UNCONNECTED,
      DOPA(2) => NLW_renderer_character_rom_Mram_rom1_DOPA_2_UNCONNECTED,
      DOPA(1) => NLW_renderer_character_rom_Mram_rom1_DOPA_1_UNCONNECTED,
      DOPA(0) => NLW_renderer_character_rom_Mram_rom1_DOPA_0_UNCONNECTED,
      DOPB(3) => NLW_renderer_character_rom_Mram_rom1_DOPB_3_UNCONNECTED,
      DOPB(2) => NLW_renderer_character_rom_Mram_rom1_DOPB_2_UNCONNECTED,
      DOPB(1) => NLW_renderer_character_rom_Mram_rom1_DOPB_1_UNCONNECTED,
      DOPB(0) => NLW_renderer_character_rom_Mram_rom1_DOPB_0_UNCONNECTED,
      WEA(3) => '0',
      WEA(2) => '0',
      WEA(1) => '0',
      WEA(0) => '0',
      WEB(3) => NLW_renderer_character_rom_Mram_rom1_WEB_3_UNCONNECTED,
      WEB(2) => NLW_renderer_character_rom_Mram_rom1_WEB_2_UNCONNECTED,
      WEB(1) => NLW_renderer_character_rom_Mram_rom1_WEB_1_UNCONNECTED,
      WEB(0) => NLW_renderer_character_rom_Mram_rom1_WEB_0_UNCONNECTED
    );
  INV_renderer_character_rom_Mram_rom2CLKA : X_INV
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => renderer_character_rom_Mram_rom2_INV_renderer_character_rom_Mram_rom2CLKA
    );
  renderer_character_rom_Mram_rom2 : X_RAMB16BWER
    generic map(
      DATA_WIDTH_A => 4,
      DATA_WIDTH_B => 0,
      DOA_REG => 0,
      DOB_REG => 0,
      EN_RSTRAM_A => TRUE,
      EN_RSTRAM_B => TRUE,
      RST_PRIORITY_A => "CE",
      RST_PRIORITY_B => "CE",
      RSTTYPE => "SYNC",
      WRITE_MODE_A => "WRITE_FIRST",
      WRITE_MODE_B => "WRITE_FIRST",
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_00 => X"0000137FFFF6000000007FFECFFDF70000007889B88A87000000000000000000",
      INIT_01 => X"000000133100000000003117FF7310000000311EEE33100000000137F7310000",
      INIT_02 => X"00007CCCC7310100FFFFFC9BB9CFFFFF0000036446300000FFFFFFECCEFFFFFF",
      INIT_03 => X"000011D3E3D11000000CEE66666767000000EF73333333000000117136666300",
      INIT_04 => X"00066066666666000000013711173100000000013F31000000008CEFFFFFEC80",
      INIT_05 => X"00007137111731000000FFFF000000000007C036CC636C700000111117DDD700",
      INIT_06 => X"00000036F630000000000010F010000000001371111111000000111111173100",
      INIT_07 => X"0000013377FF000000000FF77331000000000026F6200000000000FCCC000000",
      INIT_08 => X"000066F666F66000000000000002666000001101113331000000000000000000",
      INIT_09 => X"000000000006333000007CCCD736630000008C6310CC000000117C8007CCC711",
      INIT_0A => X"000000117110000000000063F360000000003100000013000000013333331000",
      INIT_0B => X"00008C63100000000000110000000000000000000F0000000031110000000000",
      INIT_0C => X"00007C000300C7000000FCC63100C7000000711111173100000036CCDDCC6300",
      INIT_0D => X"000033331000CF0000007CCCCFCC630000007C000FCCCF0000001000FC631000",
      INIT_0E => X"000031100011000000000110001100000000700007CCC70000007CCCC7CCC700",
      INIT_0F => X"00001101110CC700000063100013600000000007007000000000001363100000",
      INIT_10 => X"000036CCCCCC63000000F66667666F000000CCCCFCC6310000007CDDDDCC7000",
      INIT_11 => X"000036CCDCCC63000000F66667666F000000F66667666F000000F66666666F00",
      INIT_12 => X"0000E66677666E0000007CCC0000010000003111111113000000CCCCCFCCCC00",
      INIT_13 => X"00007CCCCCCCC7000000CCCCCDFFEC000000CCCCCDFFEC000000F66666666F00",
      INIT_14 => X"00007CC0036CC7000000E66667666F0000007DDCCCCCC7000000F66667666F00",
      INIT_15 => X"00006EFDDDCCCC000000136CCCCCCC0000007CCCCCCCCC000000311111157700",
      INIT_16 => X"00003333333333000000FCC63108CF0000003111136666000000CC673376CC00",
      INIT_17 => X"0F00000000000000000000000000C63100003000000003000000000137EC8000",
      INIT_18 => X"00007CCCCC7000000000766666766E0000007CCC707000000000000000000133",
      INIT_19 => X"07C07CCCCC7000000000F6666F66630000007CCCFC70000000007CCCC6300100",
      INIT_1A => X"0000E66776666E00036600000000000000003111113011000000E66667666E00",
      INIT_1B => X"00007CCCCC7000000000666666D000000000CDDDDFE000000000311111111300",
      INIT_1C => X"00007C036C7000000000F66667D0000001007CCCCC7000000F66766666D00000",
      INIT_1D => X"00006FDDDCC00000000013666660000000007CCCCCC000000000133333F33100",
      INIT_1E => X"00000111171110000000FC631CF000000F007CCCCCC000000000C63336C00000",
      INIT_1F => X"00000FCCC6310000000000000000D70000007111101117000000111110111100",
      INIT_20 => X"00007CCC7070631000007CCCFC70310000007CCCCCC00C000070036CCCCC6300",
      INIT_21 => X"000300366663000000007CCC7070363000007CCC7070136000007CCC70700C00",
      INIT_22 => X"000031111130060000007CCCFC70136000007CCCFC700C0000007CCCFC706310",
      INIT_23 => X"0000CCCFCC6303630000CCCFCC6310C000003111113013600000311111306310",
      INIT_24 => X"00007CCCCC7063100000CCCCCFCC630000006DD737C000000000F666766F0631",
      INIT_25 => X"00007CCCCCC0136000007CCCCCC0C73000007CCCCC70136000007CCCCC700C00",
      INIT_26 => X"000011366666311000007CCCCCCCC0C000007CCCCCCC70C007007CCCCCC00C00",
      INIT_27 => X"007D1111171111000000CCCCDCCFCCF000001117171366000000FE6666F66630",
      INIT_28 => X"00007CCCCCC0631000007CCCCC706310000031111130310000007CCC70706310",
      INIT_29 => X"000000000703663000000000070366300000CCCCDFFEC0D70000666666D0D700",
      INIT_2A => X"003108D631CCCCC0000000000F00000000000CCCCF00000000007CCC63303300",
      INIT_2B => X"000000D636D0000000000036D63000000000133311101100000039C631CCCCC0",
      INIT_2C => X"11111111111111117D7D7D7D7D7D7D7DA5A5A5A5A5A5A5A54141414141414141",
      INIT_2D => X"33333333F000000033333333F333333311111111F1F1111111111111F1111111",
      INIT_2E => X"33333333F0F00000333333333333333333333333F0F3333311111111F1F00000",
      INIT_2F => X"11111111F000000000000000F1F1111100000000F333333300000000F0F33333",
      INIT_30 => X"111111111111111111111111F000000000000000F11111110000000011111111",
      INIT_31 => X"3333333333333333111111111111111111111111F111111100000000F0000000",
      INIT_32 => X"33333333F0F0000000000000F0F3333333333333333000000000000033333333",
      INIT_33 => X"00000000F0F1111133333333F0F3333300000000F0F000003333333333333333",
      INIT_34 => X"000000003333333333333333F000000011111111F0F0000000000000F3333333",
      INIT_35 => X"33333333F3333333333333333000000011111111111000000000000011111111",
      INIT_36 => X"FFFFFFFFFFFFFFFF111111111000000000000000F111111111111111F1F11111",
      INIT_37 => X"000000000FFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFF0000000",
      INIT_38 => X"00006666666F00000000CCCCCCCCCF000000CCCCCDCCC70000007DDDDD700000",
      INIT_39 => X"0000111111D70000000C66766666000000007DDDDD7000000000FC63136CF000",
      INIT_3A => X"00003666630131000000E6666CCC6300000036CCFCC630000000713666317000",
      INIT_3B => X"0000CCCCCCCC700000001366676631000000C67FDD7000000000007DDD700000",
      INIT_3C => X"000070013631000000007031000130000000F0011711000000000F00F00F0000",
      INIT_3D => X"000000D70D700000000001107011000000007DDD111111111111111111111000",
      INIT_3E => X"00001366E0000000000000010000000000000001100000000000000000036630",
      INIT_3F => X"00000000000000000000077777770000000000000FC63D7000000000066666D0",
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      SRVAL_A => X"000000000",
      SRVAL_B => X"000000000",
      SIM_COLLISION_CHECK => "ALL",
      SIM_DEVICE => "SPARTAN6",
      INIT_FILE => "NONE",
      LOC => "RAMB16_X1Y20"
    )
    port map (
      CLKA => NlwBufferSignal_renderer_character_rom_Mram_rom2_CLKA,
      CLKB => NLW_renderer_character_rom_Mram_rom2_CLKB_UNCONNECTED,
      ENA => '1',
      ENB => NLW_renderer_character_rom_Mram_rom2_ENB_UNCONNECTED,
      REGCEA => '0',
      REGCEB => NLW_renderer_character_rom_Mram_rom2_REGCEB_UNCONNECTED,
      RSTA => '0',
      RSTB => NLW_renderer_character_rom_Mram_rom2_RSTB_UNCONNECTED,
      ADDRA(13) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(13),
      ADDRA(12) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(12),
      ADDRA(11) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(11),
      ADDRA(10) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(10),
      ADDRA(9) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(9),
      ADDRA(8) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(8),
      ADDRA(7) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(7),
      ADDRA(6) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(6),
      ADDRA(5) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(5),
      ADDRA(4) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(4),
      ADDRA(3) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(3),
      ADDRA(2) => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(2),
      ADDRA(1) => NLW_renderer_character_rom_Mram_rom2_ADDRA_1_UNCONNECTED,
      ADDRA(0) => NLW_renderer_character_rom_Mram_rom2_ADDRA_0_UNCONNECTED,
      ADDRB(13) => NLW_renderer_character_rom_Mram_rom2_ADDRB_13_UNCONNECTED,
      ADDRB(12) => NLW_renderer_character_rom_Mram_rom2_ADDRB_12_UNCONNECTED,
      ADDRB(11) => NLW_renderer_character_rom_Mram_rom2_ADDRB_11_UNCONNECTED,
      ADDRB(10) => NLW_renderer_character_rom_Mram_rom2_ADDRB_10_UNCONNECTED,
      ADDRB(9) => NLW_renderer_character_rom_Mram_rom2_ADDRB_9_UNCONNECTED,
      ADDRB(8) => NLW_renderer_character_rom_Mram_rom2_ADDRB_8_UNCONNECTED,
      ADDRB(7) => NLW_renderer_character_rom_Mram_rom2_ADDRB_7_UNCONNECTED,
      ADDRB(6) => NLW_renderer_character_rom_Mram_rom2_ADDRB_6_UNCONNECTED,
      ADDRB(5) => NLW_renderer_character_rom_Mram_rom2_ADDRB_5_UNCONNECTED,
      ADDRB(4) => NLW_renderer_character_rom_Mram_rom2_ADDRB_4_UNCONNECTED,
      ADDRB(3) => NLW_renderer_character_rom_Mram_rom2_ADDRB_3_UNCONNECTED,
      ADDRB(2) => NLW_renderer_character_rom_Mram_rom2_ADDRB_2_UNCONNECTED,
      ADDRB(1) => NLW_renderer_character_rom_Mram_rom2_ADDRB_1_UNCONNECTED,
      ADDRB(0) => NLW_renderer_character_rom_Mram_rom2_ADDRB_0_UNCONNECTED,
      DIA(31) => NLW_renderer_character_rom_Mram_rom2_DIA_31_UNCONNECTED,
      DIA(30) => NLW_renderer_character_rom_Mram_rom2_DIA_30_UNCONNECTED,
      DIA(29) => NLW_renderer_character_rom_Mram_rom2_DIA_29_UNCONNECTED,
      DIA(28) => NLW_renderer_character_rom_Mram_rom2_DIA_28_UNCONNECTED,
      DIA(27) => NLW_renderer_character_rom_Mram_rom2_DIA_27_UNCONNECTED,
      DIA(26) => NLW_renderer_character_rom_Mram_rom2_DIA_26_UNCONNECTED,
      DIA(25) => NLW_renderer_character_rom_Mram_rom2_DIA_25_UNCONNECTED,
      DIA(24) => NLW_renderer_character_rom_Mram_rom2_DIA_24_UNCONNECTED,
      DIA(23) => NLW_renderer_character_rom_Mram_rom2_DIA_23_UNCONNECTED,
      DIA(22) => NLW_renderer_character_rom_Mram_rom2_DIA_22_UNCONNECTED,
      DIA(21) => NLW_renderer_character_rom_Mram_rom2_DIA_21_UNCONNECTED,
      DIA(20) => NLW_renderer_character_rom_Mram_rom2_DIA_20_UNCONNECTED,
      DIA(19) => NLW_renderer_character_rom_Mram_rom2_DIA_19_UNCONNECTED,
      DIA(18) => NLW_renderer_character_rom_Mram_rom2_DIA_18_UNCONNECTED,
      DIA(17) => NLW_renderer_character_rom_Mram_rom2_DIA_17_UNCONNECTED,
      DIA(16) => NLW_renderer_character_rom_Mram_rom2_DIA_16_UNCONNECTED,
      DIA(15) => NLW_renderer_character_rom_Mram_rom2_DIA_15_UNCONNECTED,
      DIA(14) => NLW_renderer_character_rom_Mram_rom2_DIA_14_UNCONNECTED,
      DIA(13) => NLW_renderer_character_rom_Mram_rom2_DIA_13_UNCONNECTED,
      DIA(12) => NLW_renderer_character_rom_Mram_rom2_DIA_12_UNCONNECTED,
      DIA(11) => NLW_renderer_character_rom_Mram_rom2_DIA_11_UNCONNECTED,
      DIA(10) => NLW_renderer_character_rom_Mram_rom2_DIA_10_UNCONNECTED,
      DIA(9) => NLW_renderer_character_rom_Mram_rom2_DIA_9_UNCONNECTED,
      DIA(8) => NLW_renderer_character_rom_Mram_rom2_DIA_8_UNCONNECTED,
      DIA(7) => NLW_renderer_character_rom_Mram_rom2_DIA_7_UNCONNECTED,
      DIA(6) => NLW_renderer_character_rom_Mram_rom2_DIA_6_UNCONNECTED,
      DIA(5) => NLW_renderer_character_rom_Mram_rom2_DIA_5_UNCONNECTED,
      DIA(4) => NLW_renderer_character_rom_Mram_rom2_DIA_4_UNCONNECTED,
      DIA(3) => '0',
      DIA(2) => '0',
      DIA(1) => '0',
      DIA(0) => '0',
      DIB(31) => NLW_renderer_character_rom_Mram_rom2_DIB_31_UNCONNECTED,
      DIB(30) => NLW_renderer_character_rom_Mram_rom2_DIB_30_UNCONNECTED,
      DIB(29) => NLW_renderer_character_rom_Mram_rom2_DIB_29_UNCONNECTED,
      DIB(28) => NLW_renderer_character_rom_Mram_rom2_DIB_28_UNCONNECTED,
      DIB(27) => NLW_renderer_character_rom_Mram_rom2_DIB_27_UNCONNECTED,
      DIB(26) => NLW_renderer_character_rom_Mram_rom2_DIB_26_UNCONNECTED,
      DIB(25) => NLW_renderer_character_rom_Mram_rom2_DIB_25_UNCONNECTED,
      DIB(24) => NLW_renderer_character_rom_Mram_rom2_DIB_24_UNCONNECTED,
      DIB(23) => NLW_renderer_character_rom_Mram_rom2_DIB_23_UNCONNECTED,
      DIB(22) => NLW_renderer_character_rom_Mram_rom2_DIB_22_UNCONNECTED,
      DIB(21) => NLW_renderer_character_rom_Mram_rom2_DIB_21_UNCONNECTED,
      DIB(20) => NLW_renderer_character_rom_Mram_rom2_DIB_20_UNCONNECTED,
      DIB(19) => NLW_renderer_character_rom_Mram_rom2_DIB_19_UNCONNECTED,
      DIB(18) => NLW_renderer_character_rom_Mram_rom2_DIB_18_UNCONNECTED,
      DIB(17) => NLW_renderer_character_rom_Mram_rom2_DIB_17_UNCONNECTED,
      DIB(16) => NLW_renderer_character_rom_Mram_rom2_DIB_16_UNCONNECTED,
      DIB(15) => NLW_renderer_character_rom_Mram_rom2_DIB_15_UNCONNECTED,
      DIB(14) => NLW_renderer_character_rom_Mram_rom2_DIB_14_UNCONNECTED,
      DIB(13) => NLW_renderer_character_rom_Mram_rom2_DIB_13_UNCONNECTED,
      DIB(12) => NLW_renderer_character_rom_Mram_rom2_DIB_12_UNCONNECTED,
      DIB(11) => NLW_renderer_character_rom_Mram_rom2_DIB_11_UNCONNECTED,
      DIB(10) => NLW_renderer_character_rom_Mram_rom2_DIB_10_UNCONNECTED,
      DIB(9) => NLW_renderer_character_rom_Mram_rom2_DIB_9_UNCONNECTED,
      DIB(8) => NLW_renderer_character_rom_Mram_rom2_DIB_8_UNCONNECTED,
      DIB(7) => NLW_renderer_character_rom_Mram_rom2_DIB_7_UNCONNECTED,
      DIB(6) => NLW_renderer_character_rom_Mram_rom2_DIB_6_UNCONNECTED,
      DIB(5) => NLW_renderer_character_rom_Mram_rom2_DIB_5_UNCONNECTED,
      DIB(4) => NLW_renderer_character_rom_Mram_rom2_DIB_4_UNCONNECTED,
      DIB(3) => NLW_renderer_character_rom_Mram_rom2_DIB_3_UNCONNECTED,
      DIB(2) => NLW_renderer_character_rom_Mram_rom2_DIB_2_UNCONNECTED,
      DIB(1) => NLW_renderer_character_rom_Mram_rom2_DIB_1_UNCONNECTED,
      DIB(0) => NLW_renderer_character_rom_Mram_rom2_DIB_0_UNCONNECTED,
      DIPA(3) => NLW_renderer_character_rom_Mram_rom2_DIPA_3_UNCONNECTED,
      DIPA(2) => NLW_renderer_character_rom_Mram_rom2_DIPA_2_UNCONNECTED,
      DIPA(1) => NLW_renderer_character_rom_Mram_rom2_DIPA_1_UNCONNECTED,
      DIPA(0) => NLW_renderer_character_rom_Mram_rom2_DIPA_0_UNCONNECTED,
      DIPB(3) => NLW_renderer_character_rom_Mram_rom2_DIPB_3_UNCONNECTED,
      DIPB(2) => NLW_renderer_character_rom_Mram_rom2_DIPB_2_UNCONNECTED,
      DIPB(1) => NLW_renderer_character_rom_Mram_rom2_DIPB_1_UNCONNECTED,
      DIPB(0) => NLW_renderer_character_rom_Mram_rom2_DIPB_0_UNCONNECTED,
      DOA(31) => NLW_renderer_character_rom_Mram_rom2_DOA_31_UNCONNECTED,
      DOA(30) => NLW_renderer_character_rom_Mram_rom2_DOA_30_UNCONNECTED,
      DOA(29) => NLW_renderer_character_rom_Mram_rom2_DOA_29_UNCONNECTED,
      DOA(28) => NLW_renderer_character_rom_Mram_rom2_DOA_28_UNCONNECTED,
      DOA(27) => NLW_renderer_character_rom_Mram_rom2_DOA_27_UNCONNECTED,
      DOA(26) => NLW_renderer_character_rom_Mram_rom2_DOA_26_UNCONNECTED,
      DOA(25) => NLW_renderer_character_rom_Mram_rom2_DOA_25_UNCONNECTED,
      DOA(24) => NLW_renderer_character_rom_Mram_rom2_DOA_24_UNCONNECTED,
      DOA(23) => NLW_renderer_character_rom_Mram_rom2_DOA_23_UNCONNECTED,
      DOA(22) => NLW_renderer_character_rom_Mram_rom2_DOA_22_UNCONNECTED,
      DOA(21) => NLW_renderer_character_rom_Mram_rom2_DOA_21_UNCONNECTED,
      DOA(20) => NLW_renderer_character_rom_Mram_rom2_DOA_20_UNCONNECTED,
      DOA(19) => NLW_renderer_character_rom_Mram_rom2_DOA_19_UNCONNECTED,
      DOA(18) => NLW_renderer_character_rom_Mram_rom2_DOA_18_UNCONNECTED,
      DOA(17) => NLW_renderer_character_rom_Mram_rom2_DOA_17_UNCONNECTED,
      DOA(16) => NLW_renderer_character_rom_Mram_rom2_DOA_16_UNCONNECTED,
      DOA(15) => NLW_renderer_character_rom_Mram_rom2_DOA_15_UNCONNECTED,
      DOA(14) => NLW_renderer_character_rom_Mram_rom2_DOA_14_UNCONNECTED,
      DOA(13) => NLW_renderer_character_rom_Mram_rom2_DOA_13_UNCONNECTED,
      DOA(12) => NLW_renderer_character_rom_Mram_rom2_DOA_12_UNCONNECTED,
      DOA(11) => NLW_renderer_character_rom_Mram_rom2_DOA_11_UNCONNECTED,
      DOA(10) => NLW_renderer_character_rom_Mram_rom2_DOA_10_UNCONNECTED,
      DOA(9) => NLW_renderer_character_rom_Mram_rom2_DOA_9_UNCONNECTED,
      DOA(8) => NLW_renderer_character_rom_Mram_rom2_DOA_8_UNCONNECTED,
      DOA(7) => NLW_renderer_character_rom_Mram_rom2_DOA_7_UNCONNECTED,
      DOA(6) => NLW_renderer_character_rom_Mram_rom2_DOA_6_UNCONNECTED,
      DOA(5) => NLW_renderer_character_rom_Mram_rom2_DOA_5_UNCONNECTED,
      DOA(4) => NLW_renderer_character_rom_Mram_rom2_DOA_4_UNCONNECTED,
      DOA(3) => renderer_glyph_row(7),
      DOA(2) => renderer_glyph_row(6),
      DOA(1) => renderer_glyph_row(5),
      DOA(0) => renderer_glyph_row(4),
      DOB(31) => NLW_renderer_character_rom_Mram_rom2_DOB_31_UNCONNECTED,
      DOB(30) => NLW_renderer_character_rom_Mram_rom2_DOB_30_UNCONNECTED,
      DOB(29) => NLW_renderer_character_rom_Mram_rom2_DOB_29_UNCONNECTED,
      DOB(28) => NLW_renderer_character_rom_Mram_rom2_DOB_28_UNCONNECTED,
      DOB(27) => NLW_renderer_character_rom_Mram_rom2_DOB_27_UNCONNECTED,
      DOB(26) => NLW_renderer_character_rom_Mram_rom2_DOB_26_UNCONNECTED,
      DOB(25) => NLW_renderer_character_rom_Mram_rom2_DOB_25_UNCONNECTED,
      DOB(24) => NLW_renderer_character_rom_Mram_rom2_DOB_24_UNCONNECTED,
      DOB(23) => NLW_renderer_character_rom_Mram_rom2_DOB_23_UNCONNECTED,
      DOB(22) => NLW_renderer_character_rom_Mram_rom2_DOB_22_UNCONNECTED,
      DOB(21) => NLW_renderer_character_rom_Mram_rom2_DOB_21_UNCONNECTED,
      DOB(20) => NLW_renderer_character_rom_Mram_rom2_DOB_20_UNCONNECTED,
      DOB(19) => NLW_renderer_character_rom_Mram_rom2_DOB_19_UNCONNECTED,
      DOB(18) => NLW_renderer_character_rom_Mram_rom2_DOB_18_UNCONNECTED,
      DOB(17) => NLW_renderer_character_rom_Mram_rom2_DOB_17_UNCONNECTED,
      DOB(16) => NLW_renderer_character_rom_Mram_rom2_DOB_16_UNCONNECTED,
      DOB(15) => NLW_renderer_character_rom_Mram_rom2_DOB_15_UNCONNECTED,
      DOB(14) => NLW_renderer_character_rom_Mram_rom2_DOB_14_UNCONNECTED,
      DOB(13) => NLW_renderer_character_rom_Mram_rom2_DOB_13_UNCONNECTED,
      DOB(12) => NLW_renderer_character_rom_Mram_rom2_DOB_12_UNCONNECTED,
      DOB(11) => NLW_renderer_character_rom_Mram_rom2_DOB_11_UNCONNECTED,
      DOB(10) => NLW_renderer_character_rom_Mram_rom2_DOB_10_UNCONNECTED,
      DOB(9) => NLW_renderer_character_rom_Mram_rom2_DOB_9_UNCONNECTED,
      DOB(8) => NLW_renderer_character_rom_Mram_rom2_DOB_8_UNCONNECTED,
      DOB(7) => NLW_renderer_character_rom_Mram_rom2_DOB_7_UNCONNECTED,
      DOB(6) => NLW_renderer_character_rom_Mram_rom2_DOB_6_UNCONNECTED,
      DOB(5) => NLW_renderer_character_rom_Mram_rom2_DOB_5_UNCONNECTED,
      DOB(4) => NLW_renderer_character_rom_Mram_rom2_DOB_4_UNCONNECTED,
      DOB(3) => NLW_renderer_character_rom_Mram_rom2_DOB_3_UNCONNECTED,
      DOB(2) => NLW_renderer_character_rom_Mram_rom2_DOB_2_UNCONNECTED,
      DOB(1) => NLW_renderer_character_rom_Mram_rom2_DOB_1_UNCONNECTED,
      DOB(0) => NLW_renderer_character_rom_Mram_rom2_DOB_0_UNCONNECTED,
      DOPA(3) => NLW_renderer_character_rom_Mram_rom2_DOPA_3_UNCONNECTED,
      DOPA(2) => NLW_renderer_character_rom_Mram_rom2_DOPA_2_UNCONNECTED,
      DOPA(1) => NLW_renderer_character_rom_Mram_rom2_DOPA_1_UNCONNECTED,
      DOPA(0) => NLW_renderer_character_rom_Mram_rom2_DOPA_0_UNCONNECTED,
      DOPB(3) => NLW_renderer_character_rom_Mram_rom2_DOPB_3_UNCONNECTED,
      DOPB(2) => NLW_renderer_character_rom_Mram_rom2_DOPB_2_UNCONNECTED,
      DOPB(1) => NLW_renderer_character_rom_Mram_rom2_DOPB_1_UNCONNECTED,
      DOPB(0) => NLW_renderer_character_rom_Mram_rom2_DOPB_0_UNCONNECTED,
      WEA(3) => '0',
      WEA(2) => '0',
      WEA(1) => '0',
      WEA(0) => '0',
      WEB(3) => NLW_renderer_character_rom_Mram_rom2_WEB_3_UNCONNECTED,
      WEB(2) => NLW_renderer_character_rom_Mram_rom2_WEB_2_UNCONNECTED,
      WEB(1) => NLW_renderer_character_rom_Mram_rom2_WEB_1_UNCONNECTED,
      WEB(0) => NLW_renderer_character_rom_Mram_rom2_WEB_0_UNCONNECTED
    );
  count50_3 : X_FF
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_3_CLK,
      I => Result(3),
      O => count50(3),
      RST => GND,
      SET => GND
    );
  count50_3_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(3),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_3_rt_251
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_5_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_5_D5LUT_O_UNCONNECTED
    );
  ProtoComp25_CYINITGND : X_ZERO
    generic map(
      LOC => "SLICE_X34Y16"
    )
    port map (
      O => ProtoComp25_CYINITGND_0
    );
  count50_2 : X_FF
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_2_CLK,
      I => Result(2),
      O => count50(2),
      RST => GND,
      SET => GND
    );
  Mcount_count50_cy_3_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X34Y16"
    )
    port map (
      CI => '0',
      CYINIT => ProtoComp25_CYINITGND_0,
      CO(3) => Mcount_count50_cy_3_Q_2663,
      CO(2) => NLW_Mcount_count50_cy_3_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count50_cy_3_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count50_cy_3_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '1',
      O(3) => Result(3),
      O(2) => Result(2),
      O(1) => Result(1),
      O(0) => Result(0),
      S(3) => count50_3_rt_251,
      S(2) => count50_2_rt_263,
      S(1) => count50_1_rt_259,
      S(0) => Mcount_count50_lut(0)
    );
  count50_2_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(2),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_2_rt_263
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_4_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_4_C5LUT_O_UNCONNECTED
    );
  count50_1 : X_FF
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_1_CLK,
      I => Result(1),
      O => count50(1),
      RST => GND,
      SET => GND
    );
  count50_1_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(1),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_1_rt_259
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_3_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_3_B5LUT_O_UNCONNECTED
    );
  count50_0 : X_FF
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_0_CLK,
      I => Result(0),
      O => count50(0),
      RST => GND,
      SET => GND
    );
  Mcount_count50_lut_0_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => X"00FF00FF00FF00FF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count50(0),
      ADR4 => '1',
      ADR5 => '1',
      O => Mcount_count50_lut(0)
    );
  N0_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y16",
      INIT => X"FFFFFFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_N0_A5LUT_O_UNCONNECTED
    );
  count50_7 : X_FF
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_7_CLK,
      I => Result(7),
      O => count50(7),
      RST => GND,
      SET => GND
    );
  count50_7_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(7),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_7_rt_294
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_9_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_9_D5LUT_O_UNCONNECTED
    );
  count50_6 : X_FF
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_6_CLK,
      I => Result(6),
      O => count50(6),
      RST => GND,
      SET => GND
    );
  Mcount_count50_cy_7_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X34Y17"
    )
    port map (
      CI => Mcount_count50_cy_3_Q_2663,
      CYINIT => '0',
      CO(3) => Mcount_count50_cy_7_Q_2668,
      CO(2) => NLW_Mcount_count50_cy_7_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count50_cy_7_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count50_cy_7_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Result(7),
      O(2) => Result(6),
      O(1) => Result(5),
      O(0) => Result(4),
      S(3) => count50_7_rt_294,
      S(2) => count50_6_rt_282,
      S(1) => count50_5_rt_275,
      S(0) => count50_4_rt_274
    );
  count50_6_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(6),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_6_rt_282
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_8_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_8_C5LUT_O_UNCONNECTED
    );
  count50_5 : X_FF
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_5_CLK,
      I => Result(5),
      O => count50(5),
      RST => GND,
      SET => GND
    );
  count50_5_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(5),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_5_rt_275
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_7_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_7_B5LUT_O_UNCONNECTED
    );
  count50_4 : X_FF
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_4_CLK,
      I => Result(4),
      O => count50(4),
      RST => GND,
      SET => GND
    );
  count50_4_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count50(4),
      ADR4 => '1',
      ADR5 => '1',
      O => count50_4_rt_274
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_6_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y17",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_6_A5LUT_O_UNCONNECTED
    );
  count50_11 : X_FF
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_11_CLK,
      I => Result(11),
      O => count50(11),
      RST => GND,
      SET => GND
    );
  count50_11_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(11),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_11_rt_321
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_13_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_13_D5LUT_O_UNCONNECTED
    );
  count50_10 : X_FF
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_10_CLK,
      I => Result(10),
      O => count50(10),
      RST => GND,
      SET => GND
    );
  Mcount_count50_cy_11_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X34Y18"
    )
    port map (
      CI => Mcount_count50_cy_7_Q_2668,
      CYINIT => '0',
      CO(3) => Mcount_count50_cy_11_Q_2673,
      CO(2) => NLW_Mcount_count50_cy_11_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count50_cy_11_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count50_cy_11_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Result(11),
      O(2) => Result(10),
      O(1) => Result(9),
      O(0) => Result(8),
      S(3) => count50_11_rt_321,
      S(2) => count50_10_rt_309,
      S(1) => count50_9_rt_302,
      S(0) => count50_8_rt_301
    );
  count50_10_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(10),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_10_rt_309
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_12_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_12_C5LUT_O_UNCONNECTED
    );
  count50_9 : X_FF
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_9_CLK,
      I => Result(9),
      O => count50(9),
      RST => GND,
      SET => GND
    );
  count50_9_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(9),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_9_rt_302
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_11_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_11_B5LUT_O_UNCONNECTED
    );
  count50_8 : X_FF
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_8_CLK,
      I => Result(8),
      O => count50(8),
      RST => GND,
      SET => GND
    );
  count50_8_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count50(8),
      ADR4 => '1',
      ADR5 => '1',
      O => count50_8_rt_301
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_10_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y18",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_10_A5LUT_O_UNCONNECTED
    );
  count50_15 : X_FF
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_15_CLK,
      I => Result(15),
      O => count50(15),
      RST => GND,
      SET => GND
    );
  count50_15_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(15),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_15_rt_348
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_17_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_17_D5LUT_O_UNCONNECTED
    );
  count50_14 : X_FF
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_14_CLK,
      I => Result(14),
      O => count50(14),
      RST => GND,
      SET => GND
    );
  Mcount_count50_cy_15_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X34Y19"
    )
    port map (
      CI => Mcount_count50_cy_11_Q_2673,
      CYINIT => '0',
      CO(3) => Mcount_count50_cy_15_Q_2678,
      CO(2) => NLW_Mcount_count50_cy_15_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count50_cy_15_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count50_cy_15_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Result(15),
      O(2) => Result(14),
      O(1) => Result(13),
      O(0) => Result(12),
      S(3) => count50_15_rt_348,
      S(2) => count50_14_rt_336,
      S(1) => count50_13_rt_329,
      S(0) => count50_12_rt_328
    );
  count50_14_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(14),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_14_rt_336
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_16_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_16_C5LUT_O_UNCONNECTED
    );
  count50_13 : X_FF
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_13_CLK,
      I => Result(13),
      O => count50(13),
      RST => GND,
      SET => GND
    );
  count50_13_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(13),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_13_rt_329
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_15_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_15_B5LUT_O_UNCONNECTED
    );
  count50_12 : X_FF
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_12_CLK,
      I => Result(12),
      O => count50(12),
      RST => GND,
      SET => GND
    );
  count50_12_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count50(12),
      ADR4 => '1',
      ADR5 => '1',
      O => count50_12_rt_328
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_14_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y19",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_14_A5LUT_O_UNCONNECTED
    );
  count50_19 : X_FF
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_19_CLK,
      I => Result(19),
      O => count50(19),
      RST => GND,
      SET => GND
    );
  count50_19_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(19),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_19_rt_375
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_21_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_21_D5LUT_O_UNCONNECTED
    );
  count50_18 : X_FF
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_18_CLK,
      I => Result(18),
      O => count50(18),
      RST => GND,
      SET => GND
    );
  Mcount_count50_cy_19_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X34Y20"
    )
    port map (
      CI => Mcount_count50_cy_15_Q_2678,
      CYINIT => '0',
      CO(3) => Mcount_count50_cy_19_Q_2683,
      CO(2) => NLW_Mcount_count50_cy_19_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count50_cy_19_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count50_cy_19_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Result(19),
      O(2) => Result(18),
      O(1) => Result(17),
      O(0) => Result(16),
      S(3) => count50_19_rt_375,
      S(2) => count50_18_rt_363,
      S(1) => count50_17_rt_356,
      S(0) => count50_16_rt_355
    );
  count50_18_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(18),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_18_rt_363
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_20_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_20_C5LUT_O_UNCONNECTED
    );
  count50_17 : X_FF
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_17_CLK,
      I => Result(17),
      O => count50(17),
      RST => GND,
      SET => GND
    );
  count50_17_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(17),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_17_rt_356
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_19_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_19_B5LUT_O_UNCONNECTED
    );
  count50_16 : X_FF
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_16_CLK,
      I => Result(16),
      O => count50(16),
      RST => GND,
      SET => GND
    );
  count50_16_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count50(16),
      ADR4 => '1',
      ADR5 => '1',
      O => count50_16_rt_355
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_18_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y20",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_18_A5LUT_O_UNCONNECTED
    );
  count50_23 : X_FF
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_23_CLK,
      I => Result(23),
      O => count50(23),
      RST => GND,
      SET => GND
    );
  count50_23_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(23),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_23_rt_402
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_25_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_25_D5LUT_O_UNCONNECTED
    );
  count50_22 : X_FF
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_22_CLK,
      I => Result(22),
      O => count50(22),
      RST => GND,
      SET => GND
    );
  Mcount_count50_cy_23_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X34Y21"
    )
    port map (
      CI => Mcount_count50_cy_19_Q_2683,
      CYINIT => '0',
      CO(3) => Mcount_count50_cy_23_Q_2688,
      CO(2) => NLW_Mcount_count50_cy_23_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count50_cy_23_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count50_cy_23_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Result(23),
      O(2) => Result(22),
      O(1) => Result(21),
      O(0) => Result(20),
      S(3) => count50_23_rt_402,
      S(2) => count50_22_rt_390,
      S(1) => count50_21_rt_383,
      S(0) => count50_20_rt_382
    );
  count50_22_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(22),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_22_rt_390
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_24_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_24_C5LUT_O_UNCONNECTED
    );
  count50_21 : X_FF
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_21_CLK,
      I => Result(21),
      O => count50(21),
      RST => GND,
      SET => GND
    );
  count50_21_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(21),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_21_rt_383
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_23_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_23_B5LUT_O_UNCONNECTED
    );
  count50_20 : X_FF
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_20_CLK,
      I => Result(20),
      O => count50(20),
      RST => GND,
      SET => GND
    );
  count50_20_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count50(20),
      ADR4 => '1',
      ADR5 => '1',
      O => count50_20_rt_382
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_22_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y21",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_22_A5LUT_O_UNCONNECTED
    );
  Mcount_count50_xor_25_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X34Y22"
    )
    port map (
      CI => Mcount_count50_cy_23_Q_2688,
      CYINIT => '0',
      CO(3) => NLW_Mcount_count50_xor_25_CO_3_UNCONNECTED,
      CO(2) => NLW_Mcount_count50_xor_25_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count50_xor_25_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count50_xor_25_CO_0_UNCONNECTED,
      DI(3) => NLW_Mcount_count50_xor_25_DI_3_UNCONNECTED,
      DI(2) => NLW_Mcount_count50_xor_25_DI_2_UNCONNECTED,
      DI(1) => NLW_Mcount_count50_xor_25_DI_1_UNCONNECTED,
      DI(0) => '0',
      O(3) => NLW_Mcount_count50_xor_25_O_3_UNCONNECTED,
      O(2) => NLW_Mcount_count50_xor_25_O_2_UNCONNECTED,
      O(1) => Result(25),
      O(0) => Result(24),
      S(3) => NLW_Mcount_count50_xor_25_S_3_UNCONNECTED,
      S(2) => NLW_Mcount_count50_xor_25_S_2_UNCONNECTED,
      S(1) => count50_25_rt_414,
      S(0) => count50_24_rt_417
    );
  count50_25 : X_FF
    generic map(
      LOC => "SLICE_X34Y22",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_25_CLK,
      I => Result(25),
      O => count50(25),
      RST => GND,
      SET => GND
    );
  count50_25_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y22",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count50(25),
      ADR3 => '1',
      ADR5 => '1',
      O => count50_25_rt_414
    );
  count50_24 : X_FF
    generic map(
      LOC => "SLICE_X34Y22",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count50_24_CLK,
      I => Result(24),
      O => count50(24),
      RST => GND,
      SET => GND
    );
  count50_24_rt : X_LUT6
    generic map(
      LOC => "SLICE_X34Y22",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count50(24),
      ADR4 => '1',
      ADR5 => '1',
      O => count50_24_rt_417
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_26_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X34Y22",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_26_A5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_v_next_3 : X_SFF
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_3_CLK,
      I => Inst_DvidGen_Result(3),
      O => Inst_DvidGen_v_next(3),
      SRST => Inst_DvidGen_n0071,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_v_next_3_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_v_next(3),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_v_next_3_rt_423
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_60_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_60_D5LUT_O_UNCONNECTED
    );
  ProtoComp28_CYINITGND : X_ZERO
    generic map(
      LOC => "SLICE_X12Y45"
    )
    port map (
      O => ProtoComp28_CYINITGND_0
    );
  Inst_DvidGen_v_next_2 : X_SFF
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_2_CLK,
      I => Inst_DvidGen_Result(2),
      O => Inst_DvidGen_v_next(2),
      SRST => Inst_DvidGen_n0071,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_Mcount_v_next_cy_3_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X12Y45"
    )
    port map (
      CI => '0',
      CYINIT => ProtoComp28_CYINITGND_0,
      CO(3) => Inst_DvidGen_Mcount_v_next_cy_3_Q_2696,
      CO(2) => NLW_Inst_DvidGen_Mcount_v_next_cy_3_CO_2_UNCONNECTED,
      CO(1) => NLW_Inst_DvidGen_Mcount_v_next_cy_3_CO_1_UNCONNECTED,
      CO(0) => NLW_Inst_DvidGen_Mcount_v_next_cy_3_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '1',
      O(3) => Inst_DvidGen_Result(3),
      O(2) => Inst_DvidGen_Result(2),
      O(1) => Inst_DvidGen_Result(1),
      O(0) => Inst_DvidGen_Result(0),
      S(3) => Inst_DvidGen_v_next_3_rt_423,
      S(2) => Inst_DvidGen_v_next_2_rt_435,
      S(1) => Inst_DvidGen_v_next_1_rt_439,
      S(0) => Inst_DvidGen_Mcount_v_next_lut(0)
    );
  Inst_DvidGen_v_next_2_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_v_next(2),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_v_next_2_rt_435
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_61_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_61_C5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_v_next_1 : X_SFF
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_1_CLK,
      I => Inst_DvidGen_Result(1),
      O => Inst_DvidGen_v_next(1),
      SRST => Inst_DvidGen_n0071,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_v_next_1_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_v_next(1),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_v_next_1_rt_439
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_62_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_62_B5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_v_next_0 : X_SFF
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_0_CLK,
      I => Inst_DvidGen_Result(0),
      O => Inst_DvidGen_v_next(0),
      SRST => Inst_DvidGen_n0071,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_Mcount_v_next_lut_0_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => X"0000FFFF0000FFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_v_next(0),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_Mcount_v_next_lut(0)
    );
  N0_3_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y45",
      INIT => X"FFFFFFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_N0_3_A5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_v_next_5_Inst_DvidGen_v_next_5_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_Result(7),
      O => Inst_DvidGen_Result_7_0
    );
  Inst_DvidGen_v_next_5_Inst_DvidGen_v_next_5_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_Result(6),
      O => Inst_DvidGen_Result_6_0
    );
  Inst_DvidGen_v_next_5_Inst_DvidGen_v_next_5_AMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_Result(4),
      O => Inst_DvidGen_Result_4_0
    );
  Inst_DvidGen_v_next_7_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y46",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => '1',
      ADR3 => Inst_DvidGen_v_next(7),
      ADR5 => '1',
      O => Inst_DvidGen_v_next_7_rt_451
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_56_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y46",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_56_D5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_Mcount_v_next_cy_7_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X12Y46"
    )
    port map (
      CI => Inst_DvidGen_Mcount_v_next_cy_3_Q_2696,
      CYINIT => '0',
      CO(3) => Inst_DvidGen_Mcount_v_next_cy_7_Q_2702,
      CO(2) => NLW_Inst_DvidGen_Mcount_v_next_cy_7_CO_2_UNCONNECTED,
      CO(1) => NLW_Inst_DvidGen_Mcount_v_next_cy_7_CO_1_UNCONNECTED,
      CO(0) => NLW_Inst_DvidGen_Mcount_v_next_cy_7_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Inst_DvidGen_Result(7),
      O(2) => Inst_DvidGen_Result(6),
      O(1) => Inst_DvidGen_Result(5),
      O(0) => Inst_DvidGen_Result(4),
      S(3) => Inst_DvidGen_v_next_7_rt_451,
      S(2) => Inst_DvidGen_v_next_6_rt_462,
      S(1) => Inst_DvidGen_v_next_5_rt_466,
      S(0) => Inst_DvidGen_v_next_4_rt_469
    );
  Inst_DvidGen_v_next_6_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y46",
      INIT => X"F0F0F0F0F0F0F0F0"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR4 => '1',
      ADR3 => '1',
      ADR2 => Inst_DvidGen_v_next(6),
      ADR5 => '1',
      O => Inst_DvidGen_v_next_6_rt_462
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_57_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y46",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_57_C5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_v_next_5 : X_SFF
    generic map(
      LOC => "SLICE_X12Y46",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_5_CLK,
      I => Inst_DvidGen_Result(5),
      O => Inst_DvidGen_v_next(5),
      SRST => Inst_DvidGen_n0071,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_v_next_5_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y46",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_v_next(5),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_v_next_5_rt_466
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_58_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y46",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_58_B5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_v_next_4_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y46",
      INIT => X"AAAAAAAAAAAAAAAA"
    )
    port map (
      ADR4 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR0 => Inst_DvidGen_v_next(4),
      ADR5 => '1',
      O => Inst_DvidGen_v_next_4_rt_469
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_59_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y46",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_59_A5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_v_next_11_Inst_DvidGen_v_next_11_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_Result(9),
      O => Inst_DvidGen_Result_9_0
    );
  Inst_DvidGen_v_next_11 : X_SFF
    generic map(
      LOC => "SLICE_X12Y47",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_11_CLK,
      I => Inst_DvidGen_Result(11),
      O => Inst_DvidGen_v_next(11),
      SRST => Inst_DvidGen_n0071,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_v_next_11_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y47",
      INIT => X"FFFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR5 => Inst_DvidGen_v_next(11),
      ADR4 => '1',
      ADR3 => '1',
      O => Inst_DvidGen_v_next_11_rt_478
    );
  Inst_DvidGen_v_next_10 : X_SFF
    generic map(
      LOC => "SLICE_X12Y47",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_10_CLK,
      I => Inst_DvidGen_Result(10),
      O => Inst_DvidGen_v_next(10),
      SRST => Inst_DvidGen_n0071,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_Mcount_v_next_xor_11_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X12Y47"
    )
    port map (
      CI => Inst_DvidGen_Mcount_v_next_cy_7_Q_2702,
      CYINIT => '0',
      CO(3) => NLW_Inst_DvidGen_Mcount_v_next_xor_11_CO_3_UNCONNECTED,
      CO(2) => NLW_Inst_DvidGen_Mcount_v_next_xor_11_CO_2_UNCONNECTED,
      CO(1) => NLW_Inst_DvidGen_Mcount_v_next_xor_11_CO_1_UNCONNECTED,
      CO(0) => NLW_Inst_DvidGen_Mcount_v_next_xor_11_CO_0_UNCONNECTED,
      DI(3) => NLW_Inst_DvidGen_Mcount_v_next_xor_11_DI_3_UNCONNECTED,
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Inst_DvidGen_Result(11),
      O(2) => Inst_DvidGen_Result(10),
      O(1) => Inst_DvidGen_Result(9),
      O(0) => Inst_DvidGen_Result(8),
      S(3) => Inst_DvidGen_v_next_11_rt_478,
      S(2) => Inst_DvidGen_v_next_10_rt_488,
      S(1) => Inst_DvidGen_v_next_9_rt_491,
      S(0) => Inst_DvidGen_v_next_8_rt_495
    );
  Inst_DvidGen_v_next_10_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y47",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_v_next(10),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_v_next_10_rt_488
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_53_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y47",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_53_C5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_v_next_9_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y47",
      INIT => X"F0F0F0F0F0F0F0F0"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR4 => '1',
      ADR3 => '1',
      ADR2 => Inst_DvidGen_v_next(9),
      ADR5 => '1',
      O => Inst_DvidGen_v_next_9_rt_491
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_54_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y47",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_54_B5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_v_next_8 : X_SFF
    generic map(
      LOC => "SLICE_X12Y47",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_8_CLK,
      I => Inst_DvidGen_Result(8),
      O => Inst_DvidGen_v_next(8),
      SRST => Inst_DvidGen_n0071,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_v_next_8_rt : X_LUT6
    generic map(
      LOC => "SLICE_X12Y47",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_v_next(8),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_v_next_8_rt_495
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_55_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X12Y47",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_55_A5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_h_next_3 : X_SFF
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_next_3_CLK,
      I => Inst_DvidGen_Result_3_1,
      O => Inst_DvidGen_h_next(3),
      SRST => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_h_next_3_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_h_next(3),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_h_next_3_rt_503
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_71_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_71_D5LUT_O_UNCONNECTED
    );
  ProtoComp31_CYINITGND : X_ZERO
    generic map(
      LOC => "SLICE_X14Y45"
    )
    port map (
      O => ProtoComp31_CYINITGND_0
    );
  Inst_DvidGen_h_next_2 : X_SFF
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_next_2_CLK,
      I => Inst_DvidGen_Result_2_1,
      O => Inst_DvidGen_h_next(2),
      SRST => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_Mcount_h_next_cy_3_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X14Y45"
    )
    port map (
      CI => '0',
      CYINIT => ProtoComp31_CYINITGND_0,
      CO(3) => Inst_DvidGen_Mcount_h_next_cy_3_Q_2710,
      CO(2) => NLW_Inst_DvidGen_Mcount_h_next_cy_3_CO_2_UNCONNECTED,
      CO(1) => NLW_Inst_DvidGen_Mcount_h_next_cy_3_CO_1_UNCONNECTED,
      CO(0) => NLW_Inst_DvidGen_Mcount_h_next_cy_3_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '1',
      O(3) => Inst_DvidGen_Result_3_1,
      O(2) => Inst_DvidGen_Result_2_1,
      O(1) => Inst_DvidGen_Result_1_1,
      O(0) => NLW_Inst_DvidGen_Mcount_h_next_cy_3_O_0_UNCONNECTED,
      S(3) => Inst_DvidGen_h_next_3_rt_503,
      S(2) => Inst_DvidGen_h_next_2_rt_513,
      S(1) => Inst_DvidGen_h_next_1_rt_517,
      S(0) => count32_0_rt_520
    );
  Inst_DvidGen_h_next_2_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_h_next(2),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_h_next_2_rt_513
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_72_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_72_C5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_h_next_1 : X_SFF
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_next_1_CLK,
      I => Inst_DvidGen_Result_1_1,
      O => Inst_DvidGen_h_next(1),
      SRST => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_h_next_1_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_h_next(1),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_h_next_1_rt_517
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_73_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_73_B5LUT_O_UNCONNECTED
    );
  count32_0_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => X"CCCCCCCCCCCCCCCC"
    )
    port map (
      ADR0 => '1',
      ADR4 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR1 => count32(0),
      ADR5 => '1',
      O => count32_0_rt_520
    );
  N0_4_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X14Y45",
      INIT => X"FFFFFFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_N0_4_A5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_h_next_7 : X_SFF
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_next_7_CLK,
      I => Inst_DvidGen_Result_7_1,
      O => Inst_DvidGen_h_next(7),
      SRST => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_h_next_7_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => Inst_DvidGen_h_next(7),
      ADR4 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_h_next_7_rt_529
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_67_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_67_D5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_h_next_6 : X_SFF
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_next_6_CLK,
      I => Inst_DvidGen_Result_6_1,
      O => Inst_DvidGen_h_next(6),
      SRST => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_Mcount_h_next_cy_7_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X14Y46"
    )
    port map (
      CI => Inst_DvidGen_Mcount_h_next_cy_3_Q_2710,
      CYINIT => '0',
      CO(3) => Inst_DvidGen_Mcount_h_next_cy_7_Q_2712,
      CO(2) => NLW_Inst_DvidGen_Mcount_h_next_cy_7_CO_2_UNCONNECTED,
      CO(1) => NLW_Inst_DvidGen_Mcount_h_next_cy_7_CO_1_UNCONNECTED,
      CO(0) => NLW_Inst_DvidGen_Mcount_h_next_cy_7_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Inst_DvidGen_Result_7_1,
      O(2) => Inst_DvidGen_Result_6_1,
      O(1) => Inst_DvidGen_Result_5_1,
      O(0) => Inst_DvidGen_Result_4_1,
      S(3) => Inst_DvidGen_h_next_7_rt_529,
      S(2) => Inst_DvidGen_h_next_6_rt_540,
      S(1) => Inst_DvidGen_h_next_5_rt_544,
      S(0) => Inst_DvidGen_h_next_4_rt_548
    );
  Inst_DvidGen_h_next_6_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_h_next(6),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_h_next_6_rt_540
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_68_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_68_C5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_h_next_5 : X_SFF
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_next_5_CLK,
      I => Inst_DvidGen_Result_5_1,
      O => Inst_DvidGen_h_next(5),
      SRST => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_h_next_5_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_h_next(5),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_h_next_5_rt_544
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_69_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_69_B5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_h_next_4 : X_SFF
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_next_4_CLK,
      I => Inst_DvidGen_Result_4_1,
      O => Inst_DvidGen_h_next(4),
      SRST => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_h_next_4_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => Inst_DvidGen_h_next(4),
      ADR4 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_h_next_4_rt_548
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_70_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X14Y46",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_70_A5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_h_next_10 : X_SFF
    generic map(
      LOC => "SLICE_X14Y47",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_next_10_CLK,
      I => Inst_DvidGen_Result_10_1,
      O => Inst_DvidGen_h_next(10),
      SRST => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_Mcount_h_next_xor_10_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X14Y47"
    )
    port map (
      CI => Inst_DvidGen_Mcount_h_next_cy_7_Q_2712,
      CYINIT => '0',
      CO(3) => NLW_Inst_DvidGen_Mcount_h_next_xor_10_CO_3_UNCONNECTED,
      CO(2) => NLW_Inst_DvidGen_Mcount_h_next_xor_10_CO_2_UNCONNECTED,
      CO(1) => NLW_Inst_DvidGen_Mcount_h_next_xor_10_CO_1_UNCONNECTED,
      CO(0) => NLW_Inst_DvidGen_Mcount_h_next_xor_10_CO_0_UNCONNECTED,
      DI(3) => NLW_Inst_DvidGen_Mcount_h_next_xor_10_DI_3_UNCONNECTED,
      DI(2) => NLW_Inst_DvidGen_Mcount_h_next_xor_10_DI_2_UNCONNECTED,
      DI(1) => '0',
      DI(0) => '0',
      O(3) => NLW_Inst_DvidGen_Mcount_h_next_xor_10_O_3_UNCONNECTED,
      O(2) => Inst_DvidGen_Result_10_1,
      O(1) => Inst_DvidGen_Result_9_1,
      O(0) => Inst_DvidGen_Result_8_1,
      S(3) => NLW_Inst_DvidGen_Mcount_h_next_xor_10_S_3_UNCONNECTED,
      S(2) => Inst_DvidGen_h_next_10_rt_562,
      S(1) => Inst_DvidGen_h_next_9_rt_565,
      S(0) => Inst_DvidGen_h_next_8_rt_569
    );
  Inst_DvidGen_h_next_10_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y47",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_h_next(10),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_h_next_10_rt_562
    );
  Inst_DvidGen_h_next_9 : X_SFF
    generic map(
      LOC => "SLICE_X14Y47",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_next_9_CLK,
      I => Inst_DvidGen_Result_9_1,
      O => Inst_DvidGen_h_next(9),
      SRST => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_h_next_9_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y47",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_h_next(9),
      ADR3 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_h_next_9_rt_565
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_65_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X14Y47",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_65_B5LUT_O_UNCONNECTED
    );
  Inst_DvidGen_h_next_8 : X_SFF
    generic map(
      LOC => "SLICE_X14Y47",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_next_8_CLK,
      I => Inst_DvidGen_Result_8_1,
      O => Inst_DvidGen_h_next(8),
      SRST => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_h_next_8_rt : X_LUT6
    generic map(
      LOC => "SLICE_X14Y47",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => Inst_DvidGen_h_next(8),
      ADR4 => '1',
      ADR5 => '1',
      O => Inst_DvidGen_h_next_8_rt_569
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_66_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X14Y47",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_66_A5LUT_O_UNCONNECTED
    );
  count32_3 : X_FF
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_3_CLK,
      I => Result_3_1,
      O => count32(3),
      RST => GND,
      SET => GND
    );
  count32_3_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(3),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_3_rt_578
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_31_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_31_D5LUT_O_UNCONNECTED
    );
  ProtoComp25_CYINITGND_1 : X_ZERO
    generic map(
      LOC => "SLICE_X18Y30"
    )
    port map (
      O => count32_3_ProtoComp25_CYINITGND_0
    );
  count32_2 : X_FF
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_2_CLK,
      I => Result_2_1,
      O => count32(2),
      RST => GND,
      SET => GND
    );
  Mcount_count32_cy_3_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X18Y30"
    )
    port map (
      CI => '0',
      CYINIT => count32_3_ProtoComp25_CYINITGND_0,
      CO(3) => Mcount_count32_cy_3_Q_2715,
      CO(2) => NLW_Mcount_count32_cy_3_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count32_cy_3_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count32_cy_3_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '1',
      O(3) => Result_3_1,
      O(2) => Result_2_1,
      O(1) => Result_1_1,
      O(0) => Result_0_1,
      S(3) => count32_3_rt_578,
      S(2) => count32_2_rt_590,
      S(1) => count32_1_rt_586,
      S(0) => Mcount_count32_lut_0_1
    );
  count32_2_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(2),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_2_rt_590
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_30_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_30_C5LUT_O_UNCONNECTED
    );
  count32_1 : X_FF
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_1_CLK,
      I => Result_1_1,
      O => count32(1),
      RST => GND,
      SET => GND
    );
  count32_1_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(1),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_1_rt_586
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_29_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_29_B5LUT_O_UNCONNECTED
    );
  count32_0 : X_FF
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_0_CLK,
      I => Result_0_1,
      O => count32(0),
      RST => GND,
      SET => GND
    );
  Mcount_count32_lut_0_1_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => X"00FF00FF00FF00FF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count32(0),
      ADR4 => '1',
      ADR5 => '1',
      O => Mcount_count32_lut_0_1
    );
  N0_2_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y30",
      INIT => X"FFFFFFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_N0_2_A5LUT_O_UNCONNECTED
    );
  count32_7 : X_FF
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_7_CLK,
      I => Result_7_1,
      O => count32(7),
      RST => GND,
      SET => GND
    );
  count32_7_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(7),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_7_rt_621
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_35_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_35_D5LUT_O_UNCONNECTED
    );
  count32_6 : X_FF
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_6_CLK,
      I => Result_6_1,
      O => count32(6),
      RST => GND,
      SET => GND
    );
  Mcount_count32_cy_7_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X18Y31"
    )
    port map (
      CI => Mcount_count32_cy_3_Q_2715,
      CYINIT => '0',
      CO(3) => Mcount_count32_cy_7_Q_2720,
      CO(2) => NLW_Mcount_count32_cy_7_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count32_cy_7_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count32_cy_7_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Result_7_1,
      O(2) => Result_6_1,
      O(1) => Result_5_1,
      O(0) => Result_4_1,
      S(3) => count32_7_rt_621,
      S(2) => count32_6_rt_609,
      S(1) => count32_5_rt_602,
      S(0) => count32_4_rt_601
    );
  count32_6_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(6),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_6_rt_609
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_34_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_34_C5LUT_O_UNCONNECTED
    );
  count32_5 : X_FF
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_5_CLK,
      I => Result_5_1,
      O => count32(5),
      RST => GND,
      SET => GND
    );
  count32_5_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(5),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_5_rt_602
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_33_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_33_B5LUT_O_UNCONNECTED
    );
  count32_4 : X_FF
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_4_CLK,
      I => Result_4_1,
      O => count32(4),
      RST => GND,
      SET => GND
    );
  count32_4_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count32(4),
      ADR4 => '1',
      ADR5 => '1',
      O => count32_4_rt_601
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_32_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y31",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_32_A5LUT_O_UNCONNECTED
    );
  count32_11 : X_FF
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_11_CLK,
      I => Result_11_1,
      O => count32(11),
      RST => GND,
      SET => GND
    );
  count32_11_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(11),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_11_rt_648
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_39_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_39_D5LUT_O_UNCONNECTED
    );
  count32_10 : X_FF
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_10_CLK,
      I => Result_10_1,
      O => count32(10),
      RST => GND,
      SET => GND
    );
  Mcount_count32_cy_11_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X18Y32"
    )
    port map (
      CI => Mcount_count32_cy_7_Q_2720,
      CYINIT => '0',
      CO(3) => Mcount_count32_cy_11_Q_2725,
      CO(2) => NLW_Mcount_count32_cy_11_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count32_cy_11_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count32_cy_11_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Result_11_1,
      O(2) => Result_10_1,
      O(1) => Result_9_1,
      O(0) => Result_8_1,
      S(3) => count32_11_rt_648,
      S(2) => count32_10_rt_636,
      S(1) => count32_9_rt_629,
      S(0) => count32_8_rt_628
    );
  count32_10_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(10),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_10_rt_636
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_38_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_38_C5LUT_O_UNCONNECTED
    );
  count32_9 : X_FF
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_9_CLK,
      I => Result_9_1,
      O => count32(9),
      RST => GND,
      SET => GND
    );
  count32_9_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(9),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_9_rt_629
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_37_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_37_B5LUT_O_UNCONNECTED
    );
  count32_8 : X_FF
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_8_CLK,
      I => Result_8_1,
      O => count32(8),
      RST => GND,
      SET => GND
    );
  count32_8_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count32(8),
      ADR4 => '1',
      ADR5 => '1',
      O => count32_8_rt_628
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_36_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y32",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_36_A5LUT_O_UNCONNECTED
    );
  count32_15 : X_FF
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_15_CLK,
      I => Result_15_1,
      O => count32(15),
      RST => GND,
      SET => GND
    );
  count32_15_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(15),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_15_rt_675
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_43_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_43_D5LUT_O_UNCONNECTED
    );
  count32_14 : X_FF
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_14_CLK,
      I => Result_14_1,
      O => count32(14),
      RST => GND,
      SET => GND
    );
  Mcount_count32_cy_15_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X18Y33"
    )
    port map (
      CI => Mcount_count32_cy_11_Q_2725,
      CYINIT => '0',
      CO(3) => Mcount_count32_cy_15_Q_2730,
      CO(2) => NLW_Mcount_count32_cy_15_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count32_cy_15_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count32_cy_15_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Result_15_1,
      O(2) => Result_14_1,
      O(1) => Result_13_1,
      O(0) => Result_12_1,
      S(3) => count32_15_rt_675,
      S(2) => count32_14_rt_663,
      S(1) => count32_13_rt_656,
      S(0) => count32_12_rt_655
    );
  count32_14_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(14),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_14_rt_663
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_42_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_42_C5LUT_O_UNCONNECTED
    );
  count32_13 : X_FF
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_13_CLK,
      I => Result_13_1,
      O => count32(13),
      RST => GND,
      SET => GND
    );
  count32_13_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(13),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_13_rt_656
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_41_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_41_B5LUT_O_UNCONNECTED
    );
  count32_12 : X_FF
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_12_CLK,
      I => Result_12_1,
      O => count32(12),
      RST => GND,
      SET => GND
    );
  count32_12_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count32(12),
      ADR4 => '1',
      ADR5 => '1',
      O => count32_12_rt_655
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_40_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y33",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_40_A5LUT_O_UNCONNECTED
    );
  count32_19 : X_FF
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_19_CLK,
      I => Result_19_1,
      O => count32(19),
      RST => GND,
      SET => GND
    );
  count32_19_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(19),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_19_rt_702
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_47_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_47_D5LUT_O_UNCONNECTED
    );
  count32_18 : X_FF
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_18_CLK,
      I => Result_18_1,
      O => count32(18),
      RST => GND,
      SET => GND
    );
  Mcount_count32_cy_19_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X18Y34"
    )
    port map (
      CI => Mcount_count32_cy_15_Q_2730,
      CYINIT => '0',
      CO(3) => Mcount_count32_cy_19_Q_2735,
      CO(2) => NLW_Mcount_count32_cy_19_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count32_cy_19_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count32_cy_19_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Result_19_1,
      O(2) => Result_18_1,
      O(1) => Result_17_1,
      O(0) => Result_16_1,
      S(3) => count32_19_rt_702,
      S(2) => count32_18_rt_690,
      S(1) => count32_17_rt_683,
      S(0) => count32_16_rt_682
    );
  count32_18_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(18),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_18_rt_690
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_46_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_46_C5LUT_O_UNCONNECTED
    );
  count32_17 : X_FF
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_17_CLK,
      I => Result_17_1,
      O => count32(17),
      RST => GND,
      SET => GND
    );
  count32_17_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(17),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_17_rt_683
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_45_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_45_B5LUT_O_UNCONNECTED
    );
  count32_16 : X_FF
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_16_CLK,
      I => Result_16_1,
      O => count32(16),
      RST => GND,
      SET => GND
    );
  count32_16_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count32(16),
      ADR4 => '1',
      ADR5 => '1',
      O => count32_16_rt_682
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_44_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y34",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_44_A5LUT_O_UNCONNECTED
    );
  count32_23 : X_FF
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_23_CLK,
      I => Result_23_1,
      O => count32(23),
      RST => GND,
      SET => GND
    );
  count32_23_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(23),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_23_rt_729
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_51_D5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_51_D5LUT_O_UNCONNECTED
    );
  count32_22 : X_FF
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_22_CLK,
      I => Result_22_1,
      O => count32(22),
      RST => GND,
      SET => GND
    );
  Mcount_count32_cy_23_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X18Y35"
    )
    port map (
      CI => Mcount_count32_cy_19_Q_2735,
      CYINIT => '0',
      CO(3) => Mcount_count32_cy_23_Q_2740,
      CO(2) => NLW_Mcount_count32_cy_23_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count32_cy_23_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count32_cy_23_CO_0_UNCONNECTED,
      DI(3) => '0',
      DI(2) => '0',
      DI(1) => '0',
      DI(0) => '0',
      O(3) => Result_23_1,
      O(2) => Result_22_1,
      O(1) => Result_21_1,
      O(0) => Result_20_1,
      S(3) => count32_23_rt_729,
      S(2) => count32_22_rt_717,
      S(1) => count32_21_rt_710,
      S(0) => count32_20_rt_709
    );
  count32_22_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(22),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_22_rt_717
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_50_C5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_50_C5LUT_O_UNCONNECTED
    );
  count32_21 : X_FF
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_21_CLK,
      I => Result_21_1,
      O => count32(21),
      RST => GND,
      SET => GND
    );
  count32_21_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(21),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_21_rt_710
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_49_B5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_49_B5LUT_O_UNCONNECTED
    );
  count32_20 : X_FF
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_20_CLK,
      I => Result_20_1,
      O => count32(20),
      RST => GND,
      SET => GND
    );
  count32_20_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count32(20),
      ADR4 => '1',
      ADR5 => '1',
      O => count32_20_rt_709
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_48_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y35",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_48_A5LUT_O_UNCONNECTED
    );
  Mcount_count32_xor_25_Q : X_CARRY4
    generic map(
      LOC => "SLICE_X18Y36"
    )
    port map (
      CI => Mcount_count32_cy_23_Q_2740,
      CYINIT => '0',
      CO(3) => NLW_Mcount_count32_xor_25_CO_3_UNCONNECTED,
      CO(2) => NLW_Mcount_count32_xor_25_CO_2_UNCONNECTED,
      CO(1) => NLW_Mcount_count32_xor_25_CO_1_UNCONNECTED,
      CO(0) => NLW_Mcount_count32_xor_25_CO_0_UNCONNECTED,
      DI(3) => NLW_Mcount_count32_xor_25_DI_3_UNCONNECTED,
      DI(2) => NLW_Mcount_count32_xor_25_DI_2_UNCONNECTED,
      DI(1) => NLW_Mcount_count32_xor_25_DI_1_UNCONNECTED,
      DI(0) => '0',
      O(3) => NLW_Mcount_count32_xor_25_O_3_UNCONNECTED,
      O(2) => NLW_Mcount_count32_xor_25_O_2_UNCONNECTED,
      O(1) => Result_25_1,
      O(0) => Result_24_1,
      S(3) => NLW_Mcount_count32_xor_25_S_3_UNCONNECTED,
      S(2) => NLW_Mcount_count32_xor_25_S_2_UNCONNECTED,
      S(1) => count32_25_rt_741,
      S(0) => count32_24_rt_744
    );
  count32_25 : X_FF
    generic map(
      LOC => "SLICE_X18Y36",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_25_CLK,
      I => Result_25_1,
      O => count32(25),
      RST => GND,
      SET => GND
    );
  count32_25_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y36",
      INIT => X"FFFF0000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => count32(25),
      ADR3 => '1',
      ADR5 => '1',
      O => count32_25_rt_741
    );
  count32_24 : X_FF
    generic map(
      LOC => "SLICE_X18Y36",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_count32_24_CLK,
      I => Result_24_1,
      O => count32(24),
      RST => GND,
      SET => GND
    );
  count32_24_rt : X_LUT6
    generic map(
      LOC => "SLICE_X18Y36",
      INIT => X"FF00FF00FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => count32(24),
      ADR4 => '1',
      ADR5 => '1',
      O => count32_24_rt_744
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_52_A5LUT : X_LUT5
    generic map(
      LOC => "SLICE_X18Y36",
      INIT => X"00000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => '1',
      O => NLW_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd1_lut_0_52_A5LUT_O_UNCONNECTED
    );
  Switches_0_PULLUP : X_PU
    generic map(
      LOC => "PAD222"
    )
    port map (
      O => NlwRenamedSig_IO_Switches(0)
    );
  Switches_0_IBUF : X_BUF
    generic map(
      LOC => "PAD222",
      PATHPULSE => 115 ps
    )
    port map (
      O => Switches_0_IBUF_749,
      I => NlwRenamedSig_IO_Switches(0)
    );
  ProtoComp34_IMUX : X_BUF
    generic map(
      LOC => "PAD222",
      PATHPULSE => 115 ps
    )
    port map (
      I => Switches_0_IBUF_749,
      O => Switches_0_IBUF_0
    );
  Switches_1_PULLUP : X_PU
    generic map(
      LOC => "PAD221"
    )
    port map (
      O => NlwRenamedSig_IO_Switches(1)
    );
  Switches_1_IBUF : X_BUF
    generic map(
      LOC => "PAD221",
      PATHPULSE => 115 ps
    )
    port map (
      O => Switches_1_IBUF_752,
      I => NlwRenamedSig_IO_Switches(1)
    );
  ProtoComp34_IMUX_1 : X_BUF
    generic map(
      LOC => "PAD221",
      PATHPULSE => 115 ps
    )
    port map (
      I => Switches_1_IBUF_752,
      O => Switches_1_IBUF_0
    );
  Switches_2_PULLUP : X_PU
    generic map(
      LOC => "PAD239"
    )
    port map (
      O => NlwRenamedSig_IO_Switches(2)
    );
  Switches_2_IBUF : X_BUF
    generic map(
      LOC => "PAD239",
      PATHPULSE => 115 ps
    )
    port map (
      O => Switches_2_IBUF_755,
      I => NlwRenamedSig_IO_Switches(2)
    );
  ProtoComp34_IMUX_2 : X_BUF
    generic map(
      LOC => "PAD239",
      PATHPULSE => 115 ps
    )
    port map (
      I => Switches_2_IBUF_755,
      O => Switches_2_IBUF_0
    );
  Switches_3_PULLUP : X_PU
    generic map(
      LOC => "PAD240"
    )
    port map (
      O => NlwRenamedSig_IO_Switches(3)
    );
  Switches_3_IBUF : X_BUF
    generic map(
      LOC => "PAD240",
      PATHPULSE => 115 ps
    )
    port map (
      O => Switches_3_IBUF_758,
      I => NlwRenamedSig_IO_Switches(3)
    );
  ProtoComp34_IMUX_3 : X_BUF
    generic map(
      LOC => "PAD240",
      PATHPULSE => 115 ps
    )
    port map (
      I => Switches_3_IBUF_758,
      O => Switches_3_IBUF_0
    );
  Inst_DvidGen_OBUFDS_blue_OBUFDS : X_OBUFDS
    generic map(
      LOC => "PAD11"
    )
    port map (
      I => NlwBufferSignal_Inst_DvidGen_OBUFDS_blue_OBUFDS_I,
      O => TMDS_Out_P(0),
      OB => Inst_DvidGen_OBUFDS_blue_SLAVEBUF_DIFFOUT
    );
  Inst_DvidGen_OBUFDS_green_OBUFDS : X_OBUFDS
    generic map(
      LOC => "PAD7"
    )
    port map (
      I => NlwBufferSignal_Inst_DvidGen_OBUFDS_green_OBUFDS_I,
      O => TMDS_Out_P(1),
      OB => Inst_DvidGen_OBUFDS_green_SLAVEBUF_DIFFOUT
    );
  Inst_DvidGen_OBUFDS_red_OBUFDS : X_OBUFDS
    generic map(
      LOC => "PAD3"
    )
    port map (
      I => NlwBufferSignal_Inst_DvidGen_OBUFDS_red_OBUFDS_I,
      O => TMDS_Out_P(2),
      OB => Inst_DvidGen_OBUFDS_red_SLAVEBUF_DIFFOUT
    );
  Inst_DvidGen_OBUFDS_clock_OBUFDS : X_OBUFDS
    generic map(
      LOC => "PAD21"
    )
    port map (
      I => NlwBufferSignal_Inst_DvidGen_OBUFDS_clock_OBUFDS_I,
      O => TMDS_Out_P(3),
      OB => Inst_DvidGen_OBUFDS_clock_SLAVEBUF_DIFFOUT
    );
  Clk32_IBUFG : X_BUF
    generic map(
      LOC => "PAD234",
      PATHPULSE => 115 ps
    )
    port map (
      O => Clk32_IBUFG_781,
      I => Clk32
    );
  ProtoComp37_IMUX : X_BUF
    generic map(
      LOC => "PAD234",
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk32_IBUFG_781,
      O => Clk32_IBUFG_0
    );
  Clk50_BUFGP_IBUFG : X_BUF
    generic map(
      LOC => "PAD233",
      PATHPULSE => 115 ps
    )
    port map (
      O => Clk50_BUFGP_IBUFG_784,
      I => Clk50
    );
  ProtoComp37_IMUX_1 : X_BUF
    generic map(
      LOC => "PAD233",
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP_IBUFG_784,
      O => Clk50_BUFGP_IBUFG_0
    );
  LEDs_0_OBUF : X_OBUF
    generic map(
      LOC => "PAD136"
    )
    port map (
      I => NlwBufferSignal_LEDs_0_OBUF_I,
      O => LEDs(0)
    );
  LEDs_1_OBUF : X_OBUF
    generic map(
      LOC => "PAD137"
    )
    port map (
      I => NlwBufferSignal_LEDs_1_OBUF_I,
      O => LEDs(1)
    );
  LEDs_2_OBUF : X_OBUF
    generic map(
      LOC => "PAD153"
    )
    port map (
      I => NlwBufferSignal_LEDs_2_OBUF_I,
      O => LEDs(2)
    );
  LEDs_3_OBUF : X_OBUF
    generic map(
      LOC => "PAD138"
    )
    port map (
      I => NlwBufferSignal_LEDs_3_OBUF_I,
      O => LEDs(3)
    );
  LEDs_4_OBUF : X_OBUF
    generic map(
      LOC => "PAD156"
    )
    port map (
      I => NlwBufferSignal_LEDs_4_OBUF_I,
      O => LEDs(4)
    );
  LEDs_5_OBUF : X_OBUF
    generic map(
      LOC => "PAD154"
    )
    port map (
      I => NlwBufferSignal_LEDs_5_OBUF_I,
      O => LEDs(5)
    );
  LEDs_6_OBUF : X_OBUF
    generic map(
      LOC => "PAD155"
    )
    port map (
      I => NlwBufferSignal_LEDs_6_OBUF_I,
      O => LEDs(6)
    );
  LEDs_7_OBUF : X_OBUF
    generic map(
      LOC => "PAD157"
    )
    port map (
      I => NlwBufferSignal_LEDs_7_OBUF_I,
      O => LEDs(7)
    );
  Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_CLK0INV : X_BUF
    generic map(
      LOC => "OLOGIC_X3Y69",
      PATHPULSE => 115 ps
    )
    port map (
      I => ioclock_t,
      O => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_CLK0_INT
    );
  Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master : X_OSERDES2
    generic map(
      DATA_WIDTH => 5,
      TRAIN_PATTERN => 0,
      BYPASS_GCLK_FF => FALSE,
      DATA_RATE_OQ => "SDR",
      DATA_RATE_OT => "SDR",
      OUTPUT_MODE => "SINGLE_ENDED",
      SERDES_MODE => "MASTER",
      LOC => "OLOGIC_X3Y69"
    )
    port map (
      D2 => GND,
      D3 => GND,
      CLKDIV => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_CLKDIV,
      SHIFTIN1 => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_SHIFTIN1,
      T4 => GND,
      OCE => VCC,
      SHIFTIN4 => Inst_DvidGen_dvid_ser_output_serializer_b_cascade4,
      SHIFTIN3 => Inst_DvidGen_dvid_ser_output_serializer_b_cascade3,
      CLK0 => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_CLK0_INT,
      T1 => GND,
      IOCE => serdes_strobe_t,
      SHIFTIN2 => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_SHIFTIN2,
      D1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_D1,
      D4 => GND,
      TCE => VCC,
      T3 => GND,
      TRAIN => GND,
      CLK1 => NLW_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_CLK1_UNCONNECTED,
      RST => GND,
      T2 => GND,
      SHIFTOUT1 => Inst_DvidGen_dvid_ser_output_serializer_b_cascade1,
      TQ => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_TQ,
      SHIFTOUT3 => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_SHIFTOUT3,
      OQ => Inst_DvidGen_tmds_out_blue,
      SHIFTOUT2 => Inst_DvidGen_dvid_ser_output_serializer_b_cascade2,
      SHIFTOUT4 => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_SHIFTOUT4
    );
  Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_RSTINV : X_BUF
    generic map(
      LOC => "PLL_ADV_X0Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_RST_INT
    );
  Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKFBIN : X_BUF
    generic map(
      LOC => "PLL_ADV_X0Y1",
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_clocking_clk_s1_feedback,
      O => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKFBIN_INT
    );
  Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV : X_PLL_ADV
    generic map(
      COMPENSATION => "INTERNAL",
      BANDWIDTH => "OPTIMIZED",
      CLK_FEEDBACK => "CLKFBOUT",
      SIM_DEVICE => "SPARTAN6",
      CLKOUT2_DUTY_CYCLE => 0.500000,
      CLKOUT5_DUTY_CYCLE => 0.500000,
      CLKOUT3_DUTY_CYCLE => 0.500000,
      CLKFBOUT_PHASE => 0.000000,
      CLKOUT4_DUTY_CYCLE => 0.500000,
      CLKOUT1_DUTY_CYCLE => 0.500000,
      CLKOUT1_PHASE => 0.000000,
      CLKOUT2_PHASE => 0.000000,
      CLKOUT3_PHASE => 0.000000,
      CLKOUT4_PHASE => 0.000000,
      CLKOUT0_PHASE => 0.000000,
      CLKOUT5_PHASE => 0.000000,
      REF_JITTER => 0.100000,
      CLKOUT0_DUTY_CYCLE => 0.500000,
      CLKOUT4_DIVIDE => 1,
      CLKOUT0_DIVIDE => 20,
      CLKOUT1_DIVIDE => 1,
      CLKOUT3_DIVIDE => 1,
      DIVCLK_DIVIDE => 1,
      CLKFBOUT_MULT => 16,
      CLKOUT5_DIVIDE => 1,
      CLKOUT2_DIVIDE => 1,
      CLKIN1_PERIOD => 31.250000,
      LOC => "PLL_ADV_X0Y1",
      CLKIN2_PERIOD => 31.250000,
      VCOCLK_FREQ_MAX => 1080.000000,
      VCOCLK_FREQ_MIN => 400.000000,
      CLKIN_FREQ_MAX => 540.000000,
      CLKIN_FREQ_MIN => 19.000000,
      CLKPFD_FREQ_MAX => 500.000000,
      CLKPFD_FREQ_MIN => 19.000000
    )
    port map (
      CLKFBIN => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKFBIN_INT,
      DCLK => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DCLK,
      DEN => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DEN,
      CLKINSEL => GND,
      CLKIN2 => NlwBufferSignal_Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKIN2,
      RST => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_RST_INT,
      DWE => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DWE,
      REL => NLW_Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_REL_UNCONNECTED,
      CLKIN1 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKIN1,
      CLKOUT3 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUT3,
      CLKOUTDCM3 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM3,
      CLKFBOUT => Inst_clocking_clk_s1_feedback,
      CLKOUTDCM4 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM4,
      CLKOUT1 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUT1,
      CLKOUT5 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUT5,
      CLKOUTDCM2 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM2,
      DRDY => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DRDY,
      CLKOUTDCM1 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM1,
      CLKOUTDCM5 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM5,
      CLKFBDCM => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKFBDCM,
      CLKOUT0 => Inst_clocking_clk25p6m_unbuffered,
      CLKOUT4 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUT4,
      CLKOUT2 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUT2,
      CLKOUTDCM0 => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKOUTDCM0,
      LOCKED => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_LOCKED,
      DADDR(4) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DADDR4,
      DADDR(3) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DADDR3,
      DADDR(2) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DADDR2,
      DADDR(1) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DADDR1,
      DADDR(0) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DADDR0,
      DI(15) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI15,
      DI(14) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI14,
      DI(13) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI13,
      DI(12) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI12,
      DI(11) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI11,
      DI(10) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI10,
      DI(9) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI9,
      DI(8) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI8,
      DI(7) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI7,
      DI(6) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI6,
      DI(5) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI5,
      DI(4) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI4,
      DI(3) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI3,
      DI(2) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI2,
      DI(1) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI1,
      DI(0) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DI0,
      DO(15) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO15,
      DO(14) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO14,
      DO(13) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO13,
      DO(12) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO12,
      DO(11) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO11,
      DO(10) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO10,
      DO(9) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO9,
      DO(8) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO8,
      DO(7) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO7,
      DO(6) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO6,
      DO(5) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO5,
      DO(4) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO4,
      DO(3) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO3,
      DO(2) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO2,
      DO(1) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO1,
      DO(0) => Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_DO0
    );
  Inst_clocking_BUFG_clk25p6m : X_CKBUF
    generic map(
      LOC => "BUFGMUX_X2Y4",
      PATHPULSE => 115 ps
    )
    port map (
      I => NlwBufferSignal_Inst_clocking_BUFG_clk25p6m_IN,
      O => Inst_clocking_clk25p6m_buffered
    );
  Clk50_BUFGP_BUFG : X_CKBUF
    generic map(
      LOC => "BUFGMUX_X2Y11",
      PATHPULSE => 115 ps
    )
    port map (
      I => NlwBufferSignal_Clk50_BUFGP_BUFG_IN,
      O => Clk50_BUFGP
    );
  Inst_clocking_PLL_BASE_inst_PLL_ADV_RSTINV : X_BUF
    generic map(
      LOC => "PLL_ADV_X0Y0",
      PATHPULSE => 115 ps
    )
    port map (
      I => '0',
      O => Inst_clocking_PLL_BASE_inst_PLL_ADV_RST_INT
    );
  Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKFBIN : X_BUF
    generic map(
      LOC => "PLL_ADV_X0Y0",
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_clocking_clk_s2_feedback,
      O => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKFBIN_INT
    );
  Inst_clocking_PLL_BASE_inst_PLL_ADV : X_PLL_ADV
    generic map(
      COMPENSATION => "INTERNAL",
      BANDWIDTH => "OPTIMIZED",
      CLK_FEEDBACK => "CLKFBOUT",
      SIM_DEVICE => "SPARTAN6",
      CLKOUT2_DUTY_CYCLE => 0.500000,
      CLKOUT5_DUTY_CYCLE => 0.500000,
      CLKOUT3_DUTY_CYCLE => 0.500000,
      CLKFBOUT_PHASE => 0.000000,
      CLKOUT4_DUTY_CYCLE => 0.500000,
      CLKOUT1_DUTY_CYCLE => 0.500000,
      CLKOUT1_PHASE => 0.000000,
      CLKOUT2_PHASE => 0.000000,
      CLKOUT3_PHASE => 0.000000,
      CLKOUT4_PHASE => 0.000000,
      CLKOUT0_PHASE => 0.000000,
      CLKOUT5_PHASE => 0.000000,
      REF_JITTER => 0.100000,
      CLKOUT0_DUTY_CYCLE => 0.500000,
      CLKOUT4_DIVIDE => 1,
      CLKOUT0_DIVIDE => 1,
      CLKOUT1_DIVIDE => 5,
      CLKOUT3_DIVIDE => 1,
      DIVCLK_DIVIDE => 1,
      CLKFBOUT_MULT => 29,
      CLKOUT5_DIVIDE => 1,
      CLKOUT2_DIVIDE => 10,
      CLKIN1_PERIOD => 39.062500,
      LOC => "PLL_ADV_X0Y0",
      CLKIN2_PERIOD => 39.062500,
      VCOCLK_FREQ_MAX => 1080.000000,
      VCOCLK_FREQ_MIN => 400.000000,
      CLKIN_FREQ_MAX => 540.000000,
      CLKIN_FREQ_MIN => 19.000000,
      CLKPFD_FREQ_MAX => 500.000000,
      CLKPFD_FREQ_MIN => 19.000000
    )
    port map (
      CLKFBIN => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKFBIN_INT,
      DCLK => Inst_clocking_PLL_BASE_inst_PLL_ADV_DCLK,
      DEN => Inst_clocking_PLL_BASE_inst_PLL_ADV_DEN,
      CLKINSEL => GND,
      CLKIN2 => NlwBufferSignal_Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKIN2,
      RST => Inst_clocking_PLL_BASE_inst_PLL_ADV_RST_INT,
      DWE => Inst_clocking_PLL_BASE_inst_PLL_ADV_DWE,
      REL => NLW_Inst_clocking_PLL_BASE_inst_PLL_ADV_REL_UNCONNECTED,
      CLKIN1 => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKIN1,
      CLKOUT3 => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUT3,
      CLKOUTDCM3 => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM3,
      CLKFBOUT => Inst_clocking_clk_s2_feedback,
      CLKOUTDCM4 => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM4,
      CLKOUT1 => Inst_clocking_clock_x2_unbuffered,
      CLKOUT5 => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUT5,
      CLKOUTDCM2 => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM2,
      DRDY => Inst_clocking_PLL_BASE_inst_PLL_ADV_DRDY,
      CLKOUTDCM1 => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM1,
      CLKOUTDCM5 => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM5,
      CLKFBDCM => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKFBDCM,
      CLKOUT0 => Inst_clocking_clock_x10_unbuffered,
      CLKOUT4 => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUT4,
      CLKOUT2 => Inst_clocking_clock_x1_unbuffered,
      CLKOUTDCM0 => Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKOUTDCM0,
      LOCKED => Inst_clocking_pll_s2_locked,
      DADDR(4) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DADDR4,
      DADDR(3) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DADDR3,
      DADDR(2) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DADDR2,
      DADDR(1) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DADDR1,
      DADDR(0) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DADDR0,
      DI(15) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI15,
      DI(14) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI14,
      DI(13) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI13,
      DI(12) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI12,
      DI(11) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI11,
      DI(10) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI10,
      DI(9) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI9,
      DI(8) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI8,
      DI(7) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI7,
      DI(6) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI6,
      DI(5) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI5,
      DI(4) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI4,
      DI(3) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI3,
      DI(2) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI2,
      DI(1) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI1,
      DI(0) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DI0,
      DO(15) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO15,
      DO(14) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO14,
      DO(13) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO13,
      DO(12) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO12,
      DO(11) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO11,
      DO(10) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO10,
      DO(9) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO9,
      DO(8) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO8,
      DO(7) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO7,
      DO(6) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO6,
      DO(5) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO5,
      DO(4) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO4,
      DO(3) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO3,
      DO(2) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO2,
      DO(1) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO1,
      DO(0) => Inst_clocking_PLL_BASE_inst_PLL_ADV_DO0
    );
  Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_CLK0INV : X_BUF
    generic map(
      LOC => "OLOGIC_X3Y68",
      PATHPULSE => 115 ps
    )
    port map (
      I => ioclock_t,
      O => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_CLK0_INT
    );
  Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave : X_OSERDES2
    generic map(
      DATA_WIDTH => 5,
      TRAIN_PATTERN => 0,
      BYPASS_GCLK_FF => FALSE,
      DATA_RATE_OQ => "SDR",
      DATA_RATE_OT => "SDR",
      OUTPUT_MODE => "SINGLE_ENDED",
      SERDES_MODE => "SLAVE",
      LOC => "OLOGIC_X3Y68"
    )
    port map (
      D2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D2,
      D3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D3,
      CLKDIV => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_CLKDIV,
      SHIFTIN1 => Inst_DvidGen_dvid_ser_output_serializer_b_cascade1,
      T4 => GND,
      OCE => VCC,
      SHIFTIN4 => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_SHIFTIN4,
      SHIFTIN3 => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_SHIFTIN3,
      CLK0 => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_CLK0_INT,
      T1 => GND,
      IOCE => serdes_strobe_t,
      SHIFTIN2 => Inst_DvidGen_dvid_ser_output_serializer_b_cascade2,
      D1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D1,
      D4 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D4,
      TCE => VCC,
      T3 => GND,
      TRAIN => GND,
      CLK1 => NLW_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_CLK1_UNCONNECTED,
      RST => GND,
      T2 => GND,
      SHIFTOUT1 => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_SHIFTOUT1,
      TQ => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_TQ,
      SHIFTOUT3 => Inst_DvidGen_dvid_ser_output_serializer_b_cascade3,
      OQ => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_OQ,
      SHIFTOUT2 => Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_SHIFTOUT2,
      SHIFTOUT4 => Inst_DvidGen_dvid_ser_output_serializer_b_cascade4
    );
  Inst_clocking_BUFG_pclockx2 : X_CKBUF
    generic map(
      LOC => "BUFGMUX_X2Y2",
      PATHPULSE => 115 ps
    )
    port map (
      I => NlwBufferSignal_Inst_clocking_BUFG_pclockx2_IN,
      O => data_load_clock_t
    );
  Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_CLK0INV : X_BUF
    generic map(
      LOC => "OLOGIC_X13Y71",
      PATHPULSE => 115 ps
    )
    port map (
      I => ioclock_t,
      O => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_CLK0_INT
    );
  Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master : X_OSERDES2
    generic map(
      DATA_WIDTH => 5,
      TRAIN_PATTERN => 0,
      BYPASS_GCLK_FF => FALSE,
      DATA_RATE_OQ => "SDR",
      DATA_RATE_OT => "SDR",
      OUTPUT_MODE => "SINGLE_ENDED",
      SERDES_MODE => "MASTER",
      LOC => "OLOGIC_X13Y71"
    )
    port map (
      D2 => GND,
      D3 => GND,
      CLKDIV => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_CLKDIV,
      SHIFTIN1 => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_SHIFTIN1,
      T4 => GND,
      OCE => VCC,
      SHIFTIN4 => Inst_DvidGen_dvid_ser_output_serializer_c_cascade4,
      SHIFTIN3 => Inst_DvidGen_dvid_ser_output_serializer_c_cascade3,
      CLK0 => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_CLK0_INT,
      T1 => GND,
      IOCE => serdes_strobe_t,
      SHIFTIN2 => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_SHIFTIN2,
      D1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_D1,
      D4 => GND,
      TCE => VCC,
      T3 => GND,
      TRAIN => GND,
      CLK1 => NLW_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_CLK1_UNCONNECTED,
      RST => GND,
      T2 => GND,
      SHIFTOUT1 => Inst_DvidGen_dvid_ser_output_serializer_c_cascade1,
      TQ => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_TQ,
      SHIFTOUT3 => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_SHIFTOUT3,
      OQ => Inst_DvidGen_tmds_out_clock,
      SHIFTOUT2 => Inst_DvidGen_dvid_ser_output_serializer_c_cascade2,
      SHIFTOUT4 => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_SHIFTOUT4
    );
  Inst_clocking_BUFPLL_inst : X_BUFPLL
    generic map(
      DIVIDE => 5,
      ENABLE_SYNC => TRUE,
      LOC => "BUFPLL_X1Y5"
    )
    port map (
      PLLIN => NlwBufferSignal_Inst_clocking_BUFPLL_inst_PLLIN,
      GCLK => NlwBufferSignal_Inst_clocking_BUFPLL_inst_GCLK,
      LOCKED => NlwBufferSignal_Inst_clocking_BUFPLL_inst_LOCKED,
      IOCLK => ioclock_t,
      LOCK => Inst_clocking_BUFPLL_inst_LOCK,
      SERDESSTROBE => serdes_strobe_t
    );
  Inst_clocking_BUFG_clk32m : X_CKBUF
    generic map(
      LOC => "BUFGMUX_X3Y13",
      PATHPULSE => 115 ps
    )
    port map (
      I => NlwBufferSignal_Inst_clocking_BUFG_clk32m_IN,
      O => Inst_clocking_clk32m_buffered
    );
  Inst_clocking_BUFG_pclock : X_CKBUF
    generic map(
      LOC => "BUFGMUX_X2Y3",
      PATHPULSE => 115 ps
    )
    port map (
      I => NlwBufferSignal_Inst_clocking_BUFG_pclock_IN,
      O => pixel_clock_t
    );
  Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_CLK0INV : X_BUF
    generic map(
      LOC => "OLOGIC_X2Y69",
      PATHPULSE => 115 ps
    )
    port map (
      I => ioclock_t,
      O => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_CLK0_INT
    );
  Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master : X_OSERDES2
    generic map(
      DATA_WIDTH => 5,
      TRAIN_PATTERN => 0,
      BYPASS_GCLK_FF => FALSE,
      DATA_RATE_OQ => "SDR",
      DATA_RATE_OT => "SDR",
      OUTPUT_MODE => "SINGLE_ENDED",
      SERDES_MODE => "MASTER",
      LOC => "OLOGIC_X2Y69"
    )
    port map (
      D2 => GND,
      D3 => GND,
      CLKDIV => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_CLKDIV,
      SHIFTIN1 => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_SHIFTIN1,
      T4 => GND,
      OCE => VCC,
      SHIFTIN4 => Inst_DvidGen_dvid_ser_output_serializer_g_cascade4,
      SHIFTIN3 => Inst_DvidGen_dvid_ser_output_serializer_g_cascade3,
      CLK0 => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_CLK0_INT,
      T1 => GND,
      IOCE => serdes_strobe_t,
      SHIFTIN2 => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_SHIFTIN2,
      D1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_D1,
      D4 => GND,
      TCE => VCC,
      T3 => GND,
      TRAIN => GND,
      CLK1 => NLW_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_CLK1_UNCONNECTED,
      RST => GND,
      T2 => GND,
      SHIFTOUT1 => Inst_DvidGen_dvid_ser_output_serializer_g_cascade1,
      TQ => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_TQ,
      SHIFTOUT3 => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_SHIFTOUT3,
      OQ => Inst_DvidGen_tmds_out_green,
      SHIFTOUT2 => Inst_DvidGen_dvid_ser_output_serializer_g_cascade2,
      SHIFTOUT4 => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_SHIFTOUT4
    );
  Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_CLK0INV : X_BUF
    generic map(
      LOC => "OLOGIC_X13Y70",
      PATHPULSE => 115 ps
    )
    port map (
      I => ioclock_t,
      O => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_CLK0_INT
    );
  Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave : X_OSERDES2
    generic map(
      DATA_WIDTH => 5,
      TRAIN_PATTERN => 0,
      BYPASS_GCLK_FF => FALSE,
      DATA_RATE_OQ => "SDR",
      DATA_RATE_OT => "SDR",
      OUTPUT_MODE => "SINGLE_ENDED",
      SERDES_MODE => "SLAVE",
      LOC => "OLOGIC_X13Y70"
    )
    port map (
      D2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D2,
      D3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D3,
      CLKDIV => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_CLKDIV,
      SHIFTIN1 => Inst_DvidGen_dvid_ser_output_serializer_c_cascade1,
      T4 => GND,
      OCE => VCC,
      SHIFTIN4 => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_SHIFTIN4,
      SHIFTIN3 => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_SHIFTIN3,
      CLK0 => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_CLK0_INT,
      T1 => GND,
      IOCE => serdes_strobe_t,
      SHIFTIN2 => Inst_DvidGen_dvid_ser_output_serializer_c_cascade2,
      D1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D1,
      D4 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D4,
      TCE => VCC,
      T3 => GND,
      TRAIN => GND,
      CLK1 => NLW_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_CLK1_UNCONNECTED,
      RST => GND,
      T2 => GND,
      SHIFTOUT1 => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_SHIFTOUT1,
      TQ => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_TQ,
      SHIFTOUT3 => Inst_DvidGen_dvid_ser_output_serializer_c_cascade3,
      OQ => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_OQ,
      SHIFTOUT2 => Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_SHIFTOUT2,
      SHIFTOUT4 => Inst_DvidGen_dvid_ser_output_serializer_c_cascade4
    );
  Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_CLK0INV : X_BUF
    generic map(
      LOC => "OLOGIC_X1Y69",
      PATHPULSE => 115 ps
    )
    port map (
      I => ioclock_t,
      O => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_CLK0_INT
    );
  Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master : X_OSERDES2
    generic map(
      DATA_WIDTH => 5,
      TRAIN_PATTERN => 0,
      BYPASS_GCLK_FF => FALSE,
      DATA_RATE_OQ => "SDR",
      DATA_RATE_OT => "SDR",
      OUTPUT_MODE => "SINGLE_ENDED",
      SERDES_MODE => "MASTER",
      LOC => "OLOGIC_X1Y69"
    )
    port map (
      D2 => GND,
      D3 => GND,
      CLKDIV => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_CLKDIV,
      SHIFTIN1 => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_SHIFTIN1,
      T4 => GND,
      OCE => VCC,
      SHIFTIN4 => Inst_DvidGen_dvid_ser_output_serializer_r_cascade4,
      SHIFTIN3 => Inst_DvidGen_dvid_ser_output_serializer_r_cascade3,
      CLK0 => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_CLK0_INT,
      T1 => GND,
      IOCE => serdes_strobe_t,
      SHIFTIN2 => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_SHIFTIN2,
      D1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_D1,
      D4 => GND,
      TCE => VCC,
      T3 => GND,
      TRAIN => GND,
      CLK1 => NLW_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_CLK1_UNCONNECTED,
      RST => GND,
      T2 => GND,
      SHIFTOUT1 => Inst_DvidGen_dvid_ser_output_serializer_r_cascade1,
      TQ => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_TQ,
      SHIFTOUT3 => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_SHIFTOUT3,
      OQ => Inst_DvidGen_tmds_out_red,
      SHIFTOUT2 => Inst_DvidGen_dvid_ser_output_serializer_r_cascade2,
      SHIFTOUT4 => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_SHIFTOUT4
    );
  Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_CLK0INV : X_BUF
    generic map(
      LOC => "OLOGIC_X2Y68",
      PATHPULSE => 115 ps
    )
    port map (
      I => ioclock_t,
      O => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_CLK0_INT
    );
  Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave : X_OSERDES2
    generic map(
      DATA_WIDTH => 5,
      TRAIN_PATTERN => 0,
      BYPASS_GCLK_FF => FALSE,
      DATA_RATE_OQ => "SDR",
      DATA_RATE_OT => "SDR",
      OUTPUT_MODE => "SINGLE_ENDED",
      SERDES_MODE => "SLAVE",
      LOC => "OLOGIC_X2Y68"
    )
    port map (
      D2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D2,
      D3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D3,
      CLKDIV => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_CLKDIV,
      SHIFTIN1 => Inst_DvidGen_dvid_ser_output_serializer_g_cascade1,
      T4 => GND,
      OCE => VCC,
      SHIFTIN4 => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_SHIFTIN4,
      SHIFTIN3 => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_SHIFTIN3,
      CLK0 => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_CLK0_INT,
      T1 => GND,
      IOCE => serdes_strobe_t,
      SHIFTIN2 => Inst_DvidGen_dvid_ser_output_serializer_g_cascade2,
      D1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D1,
      D4 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D4,
      TCE => VCC,
      T3 => GND,
      TRAIN => GND,
      CLK1 => NLW_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_CLK1_UNCONNECTED,
      RST => GND,
      T2 => GND,
      SHIFTOUT1 => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_SHIFTOUT1,
      TQ => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_TQ,
      SHIFTOUT3 => Inst_DvidGen_dvid_ser_output_serializer_g_cascade3,
      OQ => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_OQ,
      SHIFTOUT2 => Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_SHIFTOUT2,
      SHIFTOUT4 => Inst_DvidGen_dvid_ser_output_serializer_g_cascade4
    );
  Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_CLK0INV : X_BUF
    generic map(
      LOC => "OLOGIC_X1Y68",
      PATHPULSE => 115 ps
    )
    port map (
      I => ioclock_t,
      O => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_CLK0_INT
    );
  Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave : X_OSERDES2
    generic map(
      DATA_WIDTH => 5,
      TRAIN_PATTERN => 0,
      BYPASS_GCLK_FF => FALSE,
      DATA_RATE_OQ => "SDR",
      DATA_RATE_OT => "SDR",
      OUTPUT_MODE => "SINGLE_ENDED",
      SERDES_MODE => "SLAVE",
      LOC => "OLOGIC_X1Y68"
    )
    port map (
      D2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D2,
      D3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D3,
      CLKDIV => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_CLKDIV,
      SHIFTIN1 => Inst_DvidGen_dvid_ser_output_serializer_r_cascade1,
      T4 => GND,
      OCE => VCC,
      SHIFTIN4 => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_SHIFTIN4,
      SHIFTIN3 => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_SHIFTIN3,
      CLK0 => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_CLK0_INT,
      T1 => GND,
      IOCE => serdes_strobe_t,
      SHIFTIN2 => Inst_DvidGen_dvid_ser_output_serializer_r_cascade2,
      D1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D1,
      D4 => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D4,
      TCE => VCC,
      T3 => GND,
      TRAIN => GND,
      CLK1 => NLW_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_CLK1_UNCONNECTED,
      RST => GND,
      T2 => GND,
      SHIFTOUT1 => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_SHIFTOUT1,
      TQ => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_TQ,
      SHIFTOUT3 => Inst_DvidGen_dvid_ser_output_serializer_r_cascade3,
      OQ => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_OQ,
      SHIFTOUT2 => Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_SHIFTOUT2,
      SHIFTOUT4 => Inst_DvidGen_dvid_ser_output_serializer_r_cascade4
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut_3_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X4Y53",
      INIT => X"E8FF810FE80081F0"
    )
    port map (
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21,
      ADR0 => N84,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(2),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_2,
      O => N47
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3 : X_SFF
    generic map(
      LOC => "SLICE_X4Y53",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Result(3),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(3),
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_xor_3_11 : X_LUT6
    generic map(
      LOC => "SLICE_X4Y53",
      INIT => X"505FA0AF5C53ACA3"
    )
    port map (
      ADR2 => N146,
      ADR4 => N132,
      ADR3 => N47,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(3),
      ADR5 => N49,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_cy(1),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Result(3)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_2 : X_SFF
    generic map(
      LOC => "SLICE_X4Y53",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_2_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Result(2),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(2),
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_xor_2_11 : X_LUT6
    generic map(
      LOC => "SLICE_X4Y53",
      INIT => X"728DD827D827728D"
    )
    port map (
      ADR0 => N146,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(2),
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_cy(1),
      ADR2 => N49,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Result(2)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_1 : X_SFF
    generic map(
      LOC => "SLICE_X4Y53",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_1_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Result(1),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(1),
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_xor_1_11 : X_LUT6
    generic map(
      LOC => "SLICE_X4Y53",
      INIT => X"55A9A65555565955"
    )
    port map (
      ADR0 => N138_0,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_06,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(0),
      ADR2 => N146,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Result(1)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut_2_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X4Y54",
      INIT => X"CA3553AC35CAAC53"
    )
    port map (
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(2),
      ADR1 => N113,
      ADR0 => N114,
      O => N49
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut_2_SW0_SW1 : X_LUT6
    generic map(
      LOC => "SLICE_X4Y54",
      INIT => X"005A5A0001A4A401"
    )
    port map (
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_lut(1),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_cy(0),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd6_cy(0),
      ADR1 => Inst_DvidGen_red_level_2_Q,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(3),
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(1),
      O => N114
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_31 : X_LUT6
    generic map(
      LOC => "SLICE_X4Y54",
      INIT => X"A5A5EDED00008484"
    )
    port map (
      ADR3 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(1),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111_0,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(2),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_2
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_21 : X_LUT6
    generic map(
      LOC => "SLICE_X4Y54",
      INIT => X"CECD8C4C3B372313"
    )
    port map (
      ADR0 => Inst_DvidGen_red_level_2_Q,
      ADR3 => Inst_DvidGen_red_level_7_Q,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111_0,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(1),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(0),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03_Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03_CMUX_Delay : 
X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd6_cy_0_pack_5,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd6_cy(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_GND_13_o_GND_13_o_OR_17_o : X_LUT6
    generic map(
      LOC => "SLICE_X4Y55",
      INIT => X"FAFAA0A0FAFAA0A0"
    )
    port map (
      ADR3 => '1',
      ADR1 => '1',
      ADR0 => Inst_DvidGen_red_level_6_Q,
      ADR4 => Inst_DvidGen_red_level_2_Q,
      ADR2 => Inst_DvidGen_red_level_5_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd6_cy_0_11 : X_LUT5
    generic map(
      LOC => "SLICE_X4Y55",
      INIT => X"FA0000A0"
    )
    port map (
      ADR1 => '1',
      ADR3 => Inst_DvidGen_red_level_7_Q,
      ADR0 => Inst_DvidGen_red_level_6_Q,
      ADR4 => Inst_DvidGen_red_level_2_Q,
      ADR2 => Inst_DvidGen_red_level_5_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd6_cy_0_pack_5
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut_2_SW0_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X4Y55",
      INIT => X"11BB277277221BB1"
    )
    port map (
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_lut(1),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_cy(0),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd6_cy(0),
      ADR2 => Inst_DvidGen_red_level_2_Q,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(3),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(1),
      O => N113
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_21 : X_LUT6
    generic map(
      LOC => "SLICE_X4Y55",
      INIT => X"C4DCDCC431737331"
    )
    port map (
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(0),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111_0,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(1),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03,
      ADR3 => Inst_DvidGen_red_level_2_Q,
      ADR4 => Inst_DvidGen_red_level_7_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_xor_3_11_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X5Y53",
      INIT => X"188E8007100E8007"
    )
    port map (
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_cy(1),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(2),
      ADR4 => Inst_DvidGen_red_level_2_Q,
      ADR1 => Inst_DvidGen_red_level_6_Q,
      ADR0 => Inst_DvidGen_red_level_5_Q,
      ADR5 => Inst_DvidGen_red_level_7_Q,
      O => N132
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_cy_1_11 : X_LUT6
    generic map(
      LOC => "SLICE_X5Y53",
      INIT => X"E0B02080E080E080"
    )
    port map (
      ADR2 => N146,
      ADR3 => N138_0,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(0),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_06,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(1),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_cy(1)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd6_xor_0_11 : X_LUT6
    generic map(
      LOC => "SLICE_X5Y53",
      INIT => X"33CC33CC33CC33CC"
    )
    port map (
      ADR0 => '1',
      ADR5 => '1',
      ADR2 => '1',
      ADR4 => '1',
      ADR3 => Inst_DvidGen_red_level_2_Q,
      ADR1 => Inst_DvidGen_red_level_7_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_06
    );
  Inst_DvidGen_red_level_5_Inst_DvidGen_red_level_5_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111_0
    );
  Inst_DvidGen_red_level_5_Inst_DvidGen_red_level_5_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => N63,
      O => N63_0
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_211 : X_LUT6
    generic map(
      LOC => "SLICE_X5Y54",
      INIT => X"D5D55555D5D55555"
    )
    port map (
      ADR3 => '1',
      ADR2 => Inst_DvidGen_red_level_5_Q,
      ADR1 => Inst_DvidGen_red_level_7_Q,
      ADR4 => Inst_DvidGen_red_level_6_Q,
      ADR0 => Inst_DvidGen_red_level_2_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_1111 : X_LUT5
    generic map(
      LOC => "SLICE_X5Y54",
      INIT => X"3D3DDADA"
    )
    port map (
      ADR3 => '1',
      ADR2 => Inst_DvidGen_red_level_5_Q,
      ADR1 => Inst_DvidGen_red_level_7_Q,
      ADR4 => Inst_DvidGen_red_level_6_Q,
      ADR0 => Inst_DvidGen_red_level_2_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111
    );
  renderer_rgb_21_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X5Y54",
      INIT => X"5F5F00005F5F0000"
    )
    port map (
      ADR3 => '1',
      ADR1 => '1',
      ADR4 => renderer_Mram_bgcolor23,
      ADR2 => renderer_Mram_bgcolor7,
      ADR0 => renderer_Mram_bgcolor15,
      ADR5 => '1',
      O => N57
    );
  renderer_rgb_14_2_SW0 : X_LUT5
    generic map(
      LOC => "SLICE_X5Y54",
      INIT => X"AAAA0000"
    )
    port map (
      ADR2 => '1',
      ADR1 => '1',
      ADR4 => renderer_Mram_bgcolor23,
      ADR3 => '1',
      ADR0 => renderer_Mram_bgcolor15,
      O => N63
    );
  Inst_DvidGen_red_level_5 : X_SFF
    generic map(
      LOC => "SLICE_X5Y54",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_red_level_5_CLK,
      I => red_val_3_Q,
      O => Inst_DvidGen_red_level_5_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_rgb_21_Q : X_LUT6
    generic map(
      LOC => "SLICE_X5Y54",
      INIT => X"AABB22AAF0F0F0F0"
    )
    port map (
      ADR1 => renderer_character_data(8),
      ADR3 => renderer_character_data(9),
      ADR0 => renderer_character_data(10),
      ADR4 => renderer_character_data(11),
      ADR2 => N57,
      ADR5 => renderer_use_foreground_color_0,
      O => red_val_3_Q
    );
  Inst_DvidGen_red_level_2 : X_SFF
    generic map(
      LOC => "SLICE_X5Y54",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_red_level_2_CLK,
      I => red_val_0_Q,
      O => Inst_DvidGen_red_level_2_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_rgb_22_11 : X_LUT6
    generic map(
      LOC => "SLICE_X5Y54",
      INIT => X"FF00000000000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR5 => renderer_character_data(10),
      ADR3 => renderer_character_data(11),
      ADR4 => renderer_use_foreground_color_0,
      O => red_val_0_Q
    );
  Inst_DvidGen_dvid_ser_ser_in_green_3_Inst_DvidGen_dvid_ser_ser_in_green_3_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_green(4),
      O => Inst_DvidGen_dvid_ser_ser_in_green_4_0
    );
  Inst_DvidGen_dvid_ser_ser_in_green_3_Inst_DvidGen_dvid_ser_ser_in_green_3_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_green(2),
      O => Inst_DvidGen_dvid_ser_ser_in_green_2_0
    );
  Inst_DvidGen_dvid_ser_ser_in_green_3_Inst_DvidGen_dvid_ser_ser_in_green_3_AMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_red(0),
      O => Inst_DvidGen_dvid_ser_ser_in_red_0_0
    );
  Inst_DvidGen_dvid_ser_ser_in_green_3 : X_FF
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_3_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_3_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_green(3),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_14_fifo_out_19_mux_3_OUT41 : X_LUT6
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => X"FFCC3300FFCC3300"
    )
    port map (
      ADR0 => '1',
      ADR2 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(13),
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(18),
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_3_Q
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_14_fifo_out_19_mux_3_OUT51 : X_LUT5
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => X"B8B8B8B8"
    )
    port map (
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(14),
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(19),
      ADR1 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR3 => '1',
      ADR4 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_4_Q
    );
  Inst_DvidGen_dvid_ser_ser_in_green_4 : X_FF
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_4_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_4_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_green(4),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_ser_in_green_1 : X_FF
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_1_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_1_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_green(1),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_14_fifo_out_19_mux_3_OUT21 : X_LUT6
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => X"AFA0AFA0AFA0AFA0"
    )
    port map (
      ADR4 => '1',
      ADR1 => '1',
      ADR2 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(11),
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(16),
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_1_Q
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_14_fifo_out_19_mux_3_OUT31 : X_LUT5
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => X"FCFC0C0C"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(12),
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(17),
      ADR2 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR3 => '1',
      ADR0 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_2_Q
    );
  Inst_DvidGen_dvid_ser_ser_in_green_2 : X_FF
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_2_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_2_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_green(2),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_ser_in_green_0 : X_FF
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_0_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_0_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_green(0),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_14_fifo_out_19_mux_3_OUT11 : X_LUT6
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => X"CFC0CFC0CFC0CFC0"
    )
    port map (
      ADR0 => '1',
      ADR4 => '1',
      ADR2 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(10),
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(15),
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_14_fifo_out_19_mux_3_OUT_0_Q
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_24_fifo_out_29_mux_2_OUT11 : X_LUT5
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => X"AFAFA0A0"
    )
    port map (
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(20),
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_DataOut_25_0,
      ADR2 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR3 => '1',
      ADR1 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_0_Q
    );
  Inst_DvidGen_dvid_ser_ser_in_red_0 : X_FF
    generic map(
      LOC => "SLICE_X5Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_0_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_0_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_red(0),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut_0_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut_0_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_lut_1_pack_9,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_lut(1)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut_0_1 : X_LUT6
    generic map(
      LOC => "SLICE_X6Y55",
      INIT => X"1EE1E11EE11E1EE1"
    )
    port map (
      ADR1 => N146,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(0),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR2 => Inst_DvidGen_red_level_2_Q,
      ADR5 => Inst_DvidGen_red_level_7_Q,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_cy_0_11 : X_LUT6
    generic map(
      LOC => "SLICE_X6Y55",
      INIT => X"C0C0FCFCC0C0FCFC"
    )
    port map (
      ADR0 => '1',
      ADR3 => '1',
      ADR2 => Inst_DvidGen_red_level_2_Q,
      ADR1 => Inst_DvidGen_red_level_6_Q,
      ADR4 => Inst_DvidGen_red_level_5_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_cy(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_lut_1_1 : X_LUT5
    generic map(
      LOC => "SLICE_X6Y55",
      INIT => X"0303C0C0"
    )
    port map (
      ADR0 => '1',
      ADR3 => '1',
      ADR2 => Inst_DvidGen_red_level_2_Q,
      ADR1 => Inst_DvidGen_red_level_6_Q,
      ADR4 => Inst_DvidGen_red_level_5_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_lut_1_pack_9
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_311 : X_LUT6
    generic map(
      LOC => "SLICE_X6Y55",
      INIT => X"CC6CCC669C399933"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(3),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_data_word_inv(7),
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_cy(0),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_lut(1),
      ADR5 => Inst_DvidGen_red_level_2_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut_3_SW0_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X6Y55",
      INIT => X"FF69FF69FF66FF66"
    )
    port map (
      ADR4 => '1',
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_data_word_inv(7),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_lut(1),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd5_cy(0),
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(1),
      O => N84
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_8_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_8_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_06_pack_10,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_06
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_8 : X_FF
    generic map(
      LOC => "SLICE_X6Y56",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_8_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_8_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_8_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT91 : X_LUT6
    generic map(
      LOC => "SLICE_X6Y56",
      INIT => X"CDDFCDDFCDDFCDDF"
    )
    port map (
      ADR4 => '1',
      ADR0 => Inst_DvidGen_green_level_6_Q,
      ADR3 => Inst_DvidGen_green_level_2_Q,
      ADR2 => Inst_DvidGen_green_level_5_Q,
      ADR1 => Inst_DvidGen_blank_2524,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_8_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd6_xor_0_11 : X_LUT5
    generic map(
      LOC => "SLICE_X6Y56",
      INIT => X"00FFFF00"
    )
    port map (
      ADR4 => Inst_DvidGen_green_level_7_Q,
      ADR1 => '1',
      ADR3 => Inst_DvidGen_green_level_2_Q,
      ADR2 => '1',
      ADR0 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_06_pack_10
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_cy_1_11 : X_LUT6
    generic map(
      LOC => "SLICE_X6Y56",
      INIT => X"CA00AC00FA00A000"
    )
    port map (
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      ADR4 => N136_0,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_03,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(0),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_06,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(1),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_cy(1)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_7 : X_FF
    generic map(
      LOC => "SLICE_X6Y56",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_7_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_7_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_7_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT8 : X_LUT6
    generic map(
      LOC => "SLICE_X6Y56",
      INIT => X"0014551455140014"
    )
    port map (
      ADR0 => Inst_DvidGen_blank_2524,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      ADR4 => Inst_DvidGen_green_level_2_Q,
      ADR5 => Inst_DvidGen_green_level_7_Q,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_data_word_inv(7),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_7_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_6 : X_FF
    generic map(
      LOC => "SLICE_X6Y56",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_6_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_6_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_6_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT71 : X_LUT6
    generic map(
      LOC => "SLICE_X6Y56",
      INIT => X"FFFF6633FFFFCC99"
    )
    port map (
      ADR2 => '1',
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_03,
      ADR1 => Inst_DvidGen_green_level_2_Q,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR4 => Inst_DvidGen_blank_2524,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_6_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_9 : X_FF
    generic map(
      LOC => "SLICE_X6Y60",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_9_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_9_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_9_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT101 : X_LUT6
    generic map(
      LOC => "SLICE_X6Y60",
      INIT => X"FFFFFFFFCF8B8B03"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      ADR3 => Inst_DvidGen_green_level_2_Q,
      ADR0 => Inst_DvidGen_green_level_5_Q,
      ADR4 => Inst_DvidGen_green_level_6_Q,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR5 => Inst_DvidGen_blank_2524,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_9_Q
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_11_Inst_DvidGen_dvid_ser_out_fifo_n0035_11_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_O,
      O => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_O_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_11_Inst_DvidGen_dvid_ser_out_fifo_n0035_11_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(10),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_10_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_11_Inst_DvidGen_dvid_ser_out_fifo_n0035_11_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(8),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_8_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_11_Inst_DvidGen_dvid_ser_out_fifo_n0035_11_AMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(6),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_6_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y61",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_CLK,
      I => '0',
      O => NLW_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_O_UNCONNECTED,
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y61",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_CLK,
      I => '0',
      O => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_O,
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y61",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(11),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y61",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(10),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y61",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(9),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y61",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(8),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y61",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(7),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y61",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(6),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_7 : X_FF
    generic map(
      LOC => "SLICE_X6Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_7_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_7_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(7),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_6 : X_FF
    generic map(
      LOC => "SLICE_X6Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_6_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_6_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(6),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_5 : X_FF
    generic map(
      LOC => "SLICE_X6Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_5_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_5_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(5),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_4 : X_FF
    generic map(
      LOC => "SLICE_X6Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_4_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_4_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(4),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_17_Inst_DvidGen_dvid_ser_out_fifo_n0035_17_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_O,
      O => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_O_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_17_Inst_DvidGen_dvid_ser_out_fifo_n0035_17_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(16),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_16_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_17_Inst_DvidGen_dvid_ser_out_fifo_n0035_17_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(14),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_14_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_17_Inst_DvidGen_dvid_ser_out_fifo_n0035_17_AMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(12),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_12_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y64",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_CLK,
      I => '0',
      O => NLW_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_O_UNCONNECTED,
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y64",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_CLK,
      I => '0',
      O => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_O,
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y64",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(17),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y64",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(16),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y64",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(15),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y64",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(14),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y64",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(13),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y64",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(12),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_29_Inst_DvidGen_dvid_ser_out_fifo_n0035_29_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_O,
      O => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_O_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_29_Inst_DvidGen_dvid_ser_out_fifo_n0035_29_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(28),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_28_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_29_Inst_DvidGen_dvid_ser_out_fifo_n0035_29_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(26),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_26_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_29_Inst_DvidGen_dvid_ser_out_fifo_n0035_29_AMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(24),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_24_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y65",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_CLK,
      I => '0',
      O => NLW_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_O_UNCONNECTED,
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y65",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_CLK,
      I => '0',
      O => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_O,
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y65",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(29),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y65",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(28),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y65",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(27),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y65",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(26),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y65",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(25),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y65",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(24),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_23_Inst_DvidGen_dvid_ser_out_fifo_n0035_23_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_O,
      O => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_O_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_23_Inst_DvidGen_dvid_ser_out_fifo_n0035_23_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(22),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_22_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_23_Inst_DvidGen_dvid_ser_out_fifo_n0035_23_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(20),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_20_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_23_Inst_DvidGen_dvid_ser_out_fifo_n0035_23_AMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(18),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_18_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y66",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_CLK,
      I => '0',
      O => NLW_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_O_UNCONNECTED,
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y66",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_CLK,
      I => '0',
      O => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_O,
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y66",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(23),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y66",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(22),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y66",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(21),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y66",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(20),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y66",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(19),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA : X_RAMD32
    generic map(
      LOC => "SLICE_X6Y66",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(18),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_23 : X_FF
    generic map(
      LOC => "SLICE_X6Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_23_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_23_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(23),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_22 : X_FF
    generic map(
      LOC => "SLICE_X6Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_22_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_22_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(22),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_21 : X_FF
    generic map(
      LOC => "SLICE_X6Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_21_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_21_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(21),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_20 : X_FF
    generic map(
      LOC => "SLICE_X6Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_20_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_20_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(20),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_29 : X_FF
    generic map(
      LOC => "SLICE_X6Y68",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_29_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_29_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(29),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_28 : X_FF
    generic map(
      LOC => "SLICE_X6Y68",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_28_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_28_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(28),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_red_level_7_Inst_DvidGen_red_level_7_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => N138,
      O => N138_0
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Mmux_data_word271 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y54",
      INIT => X"5599665555996655"
    )
    port map (
      ADR2 => '1',
      ADR3 => Inst_DvidGen_red_level_2_Q,
      ADR0 => Inst_DvidGen_red_level_7_Q,
      ADR1 => Inst_DvidGen_red_level_6_Q,
      ADR4 => Inst_DvidGen_red_level_5_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_data_word_inv(7)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut_1_SW2 : X_LUT5
    generic map(
      LOC => "SLICE_X7Y54",
      INIT => X"6978B4C3"
    )
    port map (
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(1),
      ADR3 => Inst_DvidGen_red_level_2_Q,
      ADR0 => Inst_DvidGen_red_level_7_Q,
      ADR1 => Inst_DvidGen_red_level_6_Q,
      ADR4 => Inst_DvidGen_red_level_5_Q,
      O => N138
    );
  Inst_DvidGen_red_level_7 : X_SFF
    generic map(
      LOC => "SLICE_X7Y54",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_red_level_7_CLK,
      I => red_val_7_Q,
      O => Inst_DvidGen_red_level_7_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_Mmux_rgb161 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y54",
      INIT => X"CCCCCFCCAAAAAAAA"
    )
    port map (
      ADR0 => renderer_Mram_bgcolor23,
      ADR4 => renderer_character_data(9),
      ADR2 => renderer_character_data(8),
      ADR1 => renderer_character_data(10),
      ADR3 => renderer_character_data(11),
      ADR5 => renderer_use_foreground_color_0,
      O => red_val_7_Q
    );
  renderer_rgb_22_2_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y54",
      INIT => X"FFFF000000000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => renderer_character_data(9),
      ADR5 => renderer_character_data(8),
      O => N101
    );
  Inst_DvidGen_red_level_6 : X_SFF
    generic map(
      LOC => "SLICE_X7Y54",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_red_level_6_CLK,
      I => red_val_4_Q,
      O => Inst_DvidGen_red_level_6_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_rgb_22_2 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y54",
      INIT => X"FFF0000088888888"
    )
    port map (
      ADR1 => renderer_Mram_bgcolor7,
      ADR4 => renderer_character_data(10),
      ADR2 => renderer_character_data(11),
      ADR0 => N63_0,
      ADR3 => N101,
      ADR5 => renderer_use_foreground_color_0,
      O => red_val_4_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_xored_5_Inst_DvidGen_dvid_ser_TMDS_encoder_red_xored_5_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_0_pack_2,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_xored_5_1 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y55",
      INIT => X"3C3C3C3C3C3C3C3C"
    )
    port map (
      ADR0 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR1 => Inst_DvidGen_red_level_6_Q,
      ADR2 => Inst_DvidGen_red_level_2_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_xored(5)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_xor_0_11 : X_LUT5
    generic map(
      LOC => "SLICE_X7Y55",
      INIT => X"17E8FF00"
    )
    port map (
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Maccum_dc_bias_lut(0),
      ADR0 => Inst_DvidGen_red_level_5_Q,
      ADR4 => N146,
      ADR1 => Inst_DvidGen_red_level_6_Q,
      ADR2 => Inst_DvidGen_red_level_2_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Result(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_0 : X_SFF
    generic map(
      LOC => "SLICE_X7Y55",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_0_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Result(0),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_0_pack_2,
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_GND_13_o_GND_13_o_OR_18_o4_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y55",
      INIT => X"000000000000000F"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(0),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(1),
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(2),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias(3),
      O => N146
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_5 : X_FF
    generic map(
      LOC => "SLICE_X7Y60",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_5_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_5_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_5_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT61 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y60",
      INIT => X"00000000393AC5C9"
    )
    port map (
      ADR5 => Inst_DvidGen_blank_2524,
      ADR4 => Inst_DvidGen_green_level_6_Q,
      ADR1 => Inst_DvidGen_green_level_2_Q,
      ADR3 => Inst_DvidGen_green_level_5_Q,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_5_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_4 : X_FF
    generic map(
      LOC => "SLICE_X7Y60",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_4_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_4_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_4_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT51 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y60",
      INIT => X"BBFFFFEEEBBEBEEB"
    )
    port map (
      ADR1 => Inst_DvidGen_green_level_2_Q,
      ADR3 => Inst_DvidGen_green_level_5_Q,
      ADR4 => Inst_DvidGen_green_level_6_Q,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      ADR0 => Inst_DvidGen_blank_2524,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_4_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_3 : X_FF
    generic map(
      LOC => "SLICE_X7Y60",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_3_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_3_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_3_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT41 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y60",
      INIT => X"0309030A0C050C09"
    )
    port map (
      ADR2 => Inst_DvidGen_blank_2524,
      ADR1 => Inst_DvidGen_green_level_5_Q,
      ADR5 => Inst_DvidGen_green_level_2_Q,
      ADR4 => Inst_DvidGen_green_level_6_Q,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_3_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_1 : X_FF
    generic map(
      LOC => "SLICE_X7Y60",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_1_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_1_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_1_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT21 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y60",
      INIT => X"0302020000010103"
    )
    port map (
      ADR1 => Inst_DvidGen_blank_2524,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR0 => Inst_DvidGen_green_level_2_Q,
      ADR4 => Inst_DvidGen_green_level_5_Q,
      ADR3 => Inst_DvidGen_green_level_6_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Ctrl_1_mux_36_OUT_1_Q
    );
  Inst_DvidGen_dvid_ser_ser_in_blue_3_Inst_DvidGen_dvid_ser_ser_in_blue_3_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_blue(4),
      O => Inst_DvidGen_dvid_ser_ser_in_blue_4_0
    );
  Inst_DvidGen_dvid_ser_ser_in_blue_3_Inst_DvidGen_dvid_ser_ser_in_blue_3_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_blue(2),
      O => Inst_DvidGen_dvid_ser_ser_in_blue_2_0
    );
  Inst_DvidGen_dvid_ser_not_ready_yet_inv1_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => X"0F0F0F0F0F0F0F0F"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR5 => '1',
      ADR3 => '1',
      ADR4 => '1',
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_empty_out_2848,
      O => Inst_DvidGen_dvid_ser_not_ready_yet_inv
    );
  Inst_DvidGen_dvid_ser_ser_in_blue_3 : X_FF
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_3_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_3_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_blue(3),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_4_fifo_out_9_mux_4_OUT41 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => X"CCCCF0F0CCCCF0F0"
    )
    port map (
      ADR0 => '1',
      ADR3 => '1',
      ADR4 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(3),
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(8),
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_3_Q
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_4_fifo_out_9_mux_4_OUT51 : X_LUT5
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => X"FF00AAAA"
    )
    port map (
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(4),
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(9),
      ADR4 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR1 => '1',
      ADR2 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_4_Q
    );
  Inst_DvidGen_dvid_ser_ser_in_blue_4 : X_FF
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_4_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_4_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_blue(4),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_ser_in_blue_1 : X_FF
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_1_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_1_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_blue(1),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_4_fifo_out_9_mux_4_OUT21 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => X"F0F0FF00F0F0FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR4 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(1),
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(6),
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_1_Q
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_4_fifo_out_9_mux_4_OUT31 : X_LUT5
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => X"AAAACCCC"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(2),
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(7),
      ADR4 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR3 => '1',
      ADR2 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_2_Q
    );
  Inst_DvidGen_dvid_ser_ser_in_blue_2 : X_FF
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_2_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_2_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_blue(2),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_ser_in_blue_0 : X_FF
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_0_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_0_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_blue(0),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_4_fifo_out_9_mux_4_OUT11 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y61",
      INIT => X"CCCCFFFFCCCC0000"
    )
    port map (
      ADR0 => '1',
      ADR3 => '1',
      ADR2 => '1',
      ADR4 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR5 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(0),
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(5),
      O => Inst_DvidGen_dvid_ser_fifo_out_4_fifo_out_9_mux_4_OUT_0_Q
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_11 : X_FF
    generic map(
      LOC => "SLICE_X7Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_11_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_11_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(11),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_10 : X_FF
    generic map(
      LOC => "SLICE_X7Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_10_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_10_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(10),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_9 : X_FF
    generic map(
      LOC => "SLICE_X7Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_9_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_9_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(9),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_8 : X_FF
    generic map(
      LOC => "SLICE_X7Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_8_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_8_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(8),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en1 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y63",
      INIT => X"00000000FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR5 => Inst_DvidGen_dvid_ser_out_fifo_empty_out_2848,
      O => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_5 : X_FF
    generic map(
      LOC => "SLICE_X7Y64",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_5_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_5_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_5_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT61 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y64",
      INIT => X"000000004B4EB1E1"
    )
    port map (
      ADR5 => Inst_DvidGen_blank_2524,
      ADR4 => Inst_DvidGen_red_level_6_Q,
      ADR2 => Inst_DvidGen_red_level_2_Q,
      ADR3 => Inst_DvidGen_red_level_5_Q,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR0 => N146,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_5_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_4 : X_FF
    generic map(
      LOC => "SLICE_X7Y64",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_4_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_4_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_4_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT51 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y64",
      INIT => X"FFFFFFFF7796EE69"
    )
    port map (
      ADR1 => Inst_DvidGen_red_level_2_Q,
      ADR4 => Inst_DvidGen_red_level_5_Q,
      ADR0 => Inst_DvidGen_red_level_6_Q,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR3 => N146,
      ADR5 => Inst_DvidGen_blank_2524,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_4_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_3 : X_FF
    generic map(
      LOC => "SLICE_X7Y64",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_3_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_3_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_3_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT41 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y64",
      INIT => X"0022331233120011"
    )
    port map (
      ADR1 => Inst_DvidGen_blank_2524,
      ADR4 => Inst_DvidGen_red_level_5_Q,
      ADR5 => Inst_DvidGen_red_level_2_Q,
      ADR2 => Inst_DvidGen_red_level_6_Q,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR3 => N146,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_3_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_1 : X_FF
    generic map(
      LOC => "SLICE_X7Y64",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_1_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_1_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_1_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT21 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y64",
      INIT => X"000E000100080007"
    )
    port map (
      ADR2 => Inst_DvidGen_blank_2524,
      ADR3 => N146,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR5 => Inst_DvidGen_red_level_2_Q,
      ADR0 => Inst_DvidGen_red_level_5_Q,
      ADR1 => Inst_DvidGen_red_level_6_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_1_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_9_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_9_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8_0
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT8_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y65",
      INIT => X"AA55AA55AA55AA55"
    )
    port map (
      ADR4 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR0 => Inst_DvidGen_red_level_7_Q,
      ADR3 => Inst_DvidGen_red_level_6_Q,
      ADR5 => '1',
      O => N40
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT91 : X_LUT5
    generic map(
      LOC => "SLICE_X7Y65",
      INIT => X"FFFF033F"
    )
    port map (
      ADR2 => Inst_DvidGen_red_level_2_Q,
      ADR1 => Inst_DvidGen_red_level_5_Q,
      ADR4 => Inst_DvidGen_blank_2524,
      ADR0 => '1',
      ADR3 => Inst_DvidGen_red_level_6_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_8_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8 : X_FF
    generic map(
      LOC => "SLICE_X7Y65",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_8_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_9 : X_FF
    generic map(
      LOC => "SLICE_X7Y65",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_9_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_9_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_9_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT101 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y65",
      INIT => X"FEEAAAAAFEEAFFFF"
    )
    port map (
      ADR4 => N146,
      ADR2 => Inst_DvidGen_red_level_2_Q,
      ADR3 => Inst_DvidGen_red_level_5_Q,
      ADR1 => Inst_DvidGen_red_level_6_Q,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR0 => Inst_DvidGen_blank_2524,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_9_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_7 : X_FF
    generic map(
      LOC => "SLICE_X7Y65",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_7_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_7_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_7_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT8 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y65",
      INIT => X"4411050544115050"
    )
    port map (
      ADR0 => Inst_DvidGen_blank_2524,
      ADR4 => N146,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_xored(5),
      ADR1 => N40,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_data_word_inv(7),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_7_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_6 : X_FF
    generic map(
      LOC => "SLICE_X7Y65",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_6_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_6_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_6_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_red_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT71 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y65",
      INIT => X"CCFCFFFCFFCFCCCF"
    )
    port map (
      ADR0 => '1',
      ADR3 => N146,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_ADDERTREE_INTERNAL_Madd_03,
      ADR5 => Inst_DvidGen_red_level_2_Q,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR1 => Inst_DvidGen_blank_2524,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_Ctrl_1_mux_36_OUT_6_Q
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_DataOut(27),
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut_27_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_DataOut(26),
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut_26_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_DataOut(25),
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut_25_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_AMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_DataOut(24),
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut_24_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_19 : X_FF
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(19),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_27_rt : X_LUT5
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => X"F0F0F0F0"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR4 => '1',
      ADR3 => '1',
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_n0035(27),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_27_rt_1597
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_27 : X_FF
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_27_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_27_rt_1597,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(27),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_18 : X_FF
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_18_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_18_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(18),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_26_rt : X_LUT5
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => X"FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_n0035_26_0,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_26_rt_1588
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_26 : X_FF
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_26_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_26_rt_1588,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(26),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_17 : X_FF
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_17_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_17_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(17),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_25_rt : X_LUT5
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => X"FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => '1',
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_n0035(25),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_25_rt_1592
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_25 : X_FF
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_25_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_25_rt_1592,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(25),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_16 : X_FF
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_16_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_16_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(16),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_24_rt : X_LUT5
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => X"FF00FF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR4 => '1',
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_n0035_24_0,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_24_rt_1607
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_24 : X_FF
    generic map(
      LOC => "SLICE_X7Y66",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_24_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_24_rt_1607,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(24),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_15 : X_FF
    generic map(
      LOC => "SLICE_X7Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_15_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_15_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(15),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_14 : X_FF
    generic map(
      LOC => "SLICE_X7Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_14_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_14_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(14),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_13 : X_FF
    generic map(
      LOC => "SLICE_X7Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_13_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_13_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(13),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_12 : X_FF
    generic map(
      LOC => "SLICE_X7Y67",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_12_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_12_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(12),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_ser_in_red_3_Inst_DvidGen_dvid_ser_ser_in_red_3_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_red(4),
      O => Inst_DvidGen_dvid_ser_ser_in_red_4_0
    );
  Inst_DvidGen_dvid_ser_ser_in_red_3_Inst_DvidGen_dvid_ser_ser_in_red_3_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_red(2),
      O => Inst_DvidGen_dvid_ser_ser_in_red_2_0
    );
  Inst_DvidGen_dvid_ser_ser_in_red_3 : X_FF
    generic map(
      LOC => "SLICE_X7Y68",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_3_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_3_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_red(3),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_24_fifo_out_29_mux_2_OUT41 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y68",
      INIT => X"F3C0F3C0F3C0F3C0"
    )
    port map (
      ADR0 => '1',
      ADR4 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(23),
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(28),
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_3_Q
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_24_fifo_out_29_mux_2_OUT51 : X_LUT5
    generic map(
      LOC => "SLICE_X7Y68",
      INIT => X"BBBB8888"
    )
    port map (
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_DataOut_24_0,
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(29),
      ADR1 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR3 => '1',
      ADR2 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_4_Q
    );
  Inst_DvidGen_dvid_ser_ser_in_red_4 : X_FF
    generic map(
      LOC => "SLICE_X7Y68",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_4_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_4_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_red(4),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_ser_in_red_1 : X_FF
    generic map(
      LOC => "SLICE_X7Y68",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_1_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_1_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_red(1),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_24_fifo_out_29_mux_2_OUT21 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y68",
      INIT => X"F0F0AAAAF0F0AAAA"
    )
    port map (
      ADR3 => '1',
      ADR1 => '1',
      ADR4 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(21),
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_DataOut_26_0,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_1_Q
    );
  Inst_DvidGen_dvid_ser_Mmux_fifo_out_24_fifo_out_29_mux_2_OUT31 : X_LUT5
    generic map(
      LOC => "SLICE_X7Y68",
      INIT => X"FF00CCCC"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_DataOut(22),
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_DataOut_27_0,
      ADR4 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR0 => '1',
      ADR2 => '1',
      O => Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_2_Q
    );
  Inst_DvidGen_dvid_ser_ser_in_red_2 : X_FF
    generic map(
      LOC => "SLICE_X7Y68",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_2_CLK,
      I => Inst_DvidGen_dvid_ser_fifo_out_24_fifo_out_29_mux_2_OUT_2_Q,
      O => Inst_DvidGen_dvid_ser_ser_in_red(2),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_rd_enable : X_FF
    generic map(
      LOC => "SLICE_X7Y68",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_not_ready_yet_inv,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_rd_enable_CLK,
      I => Inst_DvidGen_dvid_ser_rd_enable_INV_46_o,
      O => Inst_DvidGen_dvid_ser_rd_enable_2504,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_rd_enable_INV_46_o1_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X7Y68",
      INIT => X"00000000FFFFFFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR5 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      ADR4 => '1',
      ADR3 => '1',
      O => Inst_DvidGen_dvid_ser_rd_enable_INV_46_o
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_2_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_2_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => N134_pack_9,
      O => N134
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_lut_3_SW0_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y52",
      INIT => X"CFFEFDDECFFEFDDE"
    )
    port map (
      ADR3 => Inst_DvidGen_blue_level_6_Q,
      ADR2 => Inst_DvidGen_blue_level_5_Q,
      ADR4 => Inst_DvidGen_blue_level_7_Q,
      ADR0 => Inst_DvidGen_blue_level_2_Q,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(1),
      ADR5 => '1',
      O => N80
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_lut_1_SW2 : X_LUT5
    generic map(
      LOC => "SLICE_X8Y52",
      INIT => X"3CC9C669"
    )
    port map (
      ADR3 => Inst_DvidGen_blue_level_6_Q,
      ADR2 => Inst_DvidGen_blue_level_5_Q,
      ADR4 => Inst_DvidGen_blue_level_7_Q,
      ADR0 => Inst_DvidGen_blue_level_2_Q,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(1),
      O => N134_pack_9
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_2 : X_SFF
    generic map(
      LOC => "SLICE_X8Y52",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_2_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Result(2),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(2),
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_xor_2_11 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y52",
      INIT => X"69966996AAAA5555"
    )
    port map (
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21_0,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(2),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_cy(1),
      ADR4 => N19,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Result(2)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y52",
      INIT => X"0000000000110011"
    )
    port map (
      ADR4 => '1',
      ADR2 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(2),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(3),
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(1),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(0),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_1 : X_SFF
    generic map(
      LOC => "SLICE_X8Y52",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_1_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Result(1),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(1),
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_xor_1_11 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y52",
      INIT => X"5AA542BD00FF18E7"
    )
    port map (
      ADR3 => N134,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_06,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(0),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Result(1)
    );
  Inst_DvidGen_green_level_7_Inst_DvidGen_green_level_7_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_cy(0),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_cy_0_0
    );
  Inst_DvidGen_green_level_7_Inst_DvidGen_green_level_7_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => N105_pack_8,
      O => N105
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_lut_1_1 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y54",
      INIT => X"500A500A500A500A"
    )
    port map (
      ADR4 => '1',
      ADR1 => '1',
      ADR0 => Inst_DvidGen_blue_level_5_Q,
      ADR2 => Inst_DvidGen_blue_level_6_Q,
      ADR3 => Inst_DvidGen_blue_level_2_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_lut(1)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_cy_0_11 : X_LUT5
    generic map(
      LOC => "SLICE_X8Y54",
      INIT => X"F550F550"
    )
    port map (
      ADR4 => '1',
      ADR1 => '1',
      ADR0 => Inst_DvidGen_blue_level_5_Q,
      ADR2 => Inst_DvidGen_blue_level_6_Q,
      ADR3 => Inst_DvidGen_blue_level_2_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_cy(0)
    );
  Inst_DvidGen_green_level_7 : X_SFF
    generic map(
      LOC => "SLICE_X8Y54",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_green_level_7_CLK,
      I => green_val_7_Q,
      O => Inst_DvidGen_green_level_7_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_Mmux_rgb71 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y54",
      INIT => X"F0F4F0F4FFFF0000"
    )
    port map (
      ADR4 => renderer_Mram_bgcolor15,
      ADR0 => renderer_character_data(8),
      ADR3 => renderer_character_data(10),
      ADR2 => renderer_character_data(9),
      ADR1 => renderer_character_data(11),
      ADR5 => renderer_use_foreground_color_0,
      O => green_val_7_Q
    );
  Inst_DvidGen_blue_level_2 : X_SFF
    generic map(
      LOC => "SLICE_X8Y54",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_blue_level_2_CLK,
      I => blue_val_0_Q,
      O => Inst_DvidGen_blue_level_2_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_rgb_6_11 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y54",
      INIT => X"F0000000F0000000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR3 => renderer_character_data(8),
      ADR2 => renderer_character_data(11),
      ADR4 => renderer_use_foreground_color_0,
      ADR5 => '1',
      O => blue_val_0_Q
    );
  renderer_rgb_14_1_SW0 : X_LUT5
    generic map(
      LOC => "SLICE_X8Y54",
      INIT => X"CC00CC00"
    )
    port map (
      ADR0 => '1',
      ADR1 => renderer_character_data(10),
      ADR3 => renderer_character_data(8),
      ADR2 => '1',
      ADR4 => '1',
      O => N105_pack_8
    );
  Inst_DvidGen_green_level_6 : X_SFF
    generic map(
      LOC => "SLICE_X8Y54",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_green_level_6_CLK,
      I => green_val_4_Q,
      O => Inst_DvidGen_green_level_6_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_rgb_14_1 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y54",
      INIT => X"FF00CC00A0A0A0A0"
    )
    port map (
      ADR0 => renderer_Mram_bgcolor7,
      ADR3 => renderer_character_data(9),
      ADR4 => renderer_character_data(11),
      ADR2 => N63_0,
      ADR1 => N105,
      ADR5 => renderer_use_foreground_color_0,
      O => green_val_4_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_8 : X_FF
    generic map(
      LOC => "SLICE_X8Y55",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_8_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_8_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_8_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT91 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y55",
      INIT => X"0F0F0F0F005555FF"
    )
    port map (
      ADR1 => '1',
      ADR5 => Inst_DvidGen_blank_2524,
      ADR3 => Inst_DvidGen_blue_level_5_Q,
      ADR4 => Inst_DvidGen_blue_level_6_Q,
      ADR0 => Inst_DvidGen_blue_level_2_Q,
      ADR2 => Inst_DvidGen_hsync_2526,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_8_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT8_F : X_LUT6
    generic map(
      LOC => "SLICE_X8Y55",
      INIT => X"663363369CC9CC99"
    )
    port map (
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR5 => Inst_DvidGen_blue_level_2_Q,
      ADR1 => Inst_DvidGen_blue_level_7_Q,
      ADR2 => Inst_DvidGen_blue_level_6_Q,
      ADR4 => Inst_DvidGen_blue_level_5_Q,
      O => N150
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_7 : X_FF
    generic map(
      LOC => "SLICE_X8Y55",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_7_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_7_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_7_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT81 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y55",
      INIT => X"CCFFCC00CCFFCC00"
    )
    port map (
      ADR0 => '1',
      ADR5 => '1',
      ADR2 => '1',
      ADR3 => Inst_DvidGen_blank_2524,
      ADR4 => N150,
      ADR1 => Inst_DvidGen_hsync_2526,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_7_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1_pack_8,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_211 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y56",
      INIT => X"D4CC7133D4CC7133"
    )
    port map (
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(0),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_03,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_data_word_inv(7),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(1),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111_0,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_211 : X_LUT5
    generic map(
      LOC => "SLICE_X8Y56",
      INIT => X"CCD43371"
    )
    port map (
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(0),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_03,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_data_word_inv(7),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(1),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111_0,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1_pack_8
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_31 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y56",
      INIT => X"F2F22F2F20200202"
    )
    port map (
      ADR3 => '1',
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(1),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111_0,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(2),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_2
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut_3_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y56",
      INIT => X"E8E88181FF0033CC"
    )
    port map (
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21,
      ADR2 => N82,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(2),
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_2,
      O => N32
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3 : X_SFF
    generic map(
      LOC => "SLICE_X8Y56",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Result(3),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(3),
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_xor_3_11 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y56",
      INIT => X"0321CFEDCFED0321"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      ADR5 => N130,
      ADR2 => N32,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(3),
      ADR3 => N34,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_cy(1),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Result(3)
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_1_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_1_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_2_pack_6,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2)
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_1_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_1_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => N53_pack_4,
      O => N53
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_1 : X_SFF
    generic map(
      LOC => "SLICE_X8Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_1_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_GND_19_o_xor_1_OUT_1_Q,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_Mxor_binary_count_3_GND_19_o_xor_1_OUT_1_xo_0_1 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y61",
      INIT => X"33CC33CC33CC33CC"
    )
    port map (
      ADR0 => '1',
      ADR4 => '1',
      ADR2 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_GND_19_o_xor_1_OUT_1_Q
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_Mxor_binary_count_3_GND_19_o_xor_1_OUT_2_xo_0_1 : X_LUT5
    generic map(
      LOC => "SLICE_X8Y61",
      INIT => X"00FFFF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_Q,
      ADR2 => '1',
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_Q,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_GND_19_o_xor_1_OUT_2_Q
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_2 : X_SFF
    generic map(
      LOC => "SLICE_X8Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_2_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_GND_19_o_xor_1_OUT_2_Q,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_2_pack_6,
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_0 : X_SFF
    generic map(
      LOC => "SLICE_X8Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_0_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_Result(1),
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_Result_1_1 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y61",
      INIT => X"5A5A5A5A5A5A5A5A"
    )
    port map (
      ADR4 => '1',
      ADR1 => '1',
      ADR3 => '1',
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_out_fifo_Result(1)
    );
  Inst_DvidGen_dvid_ser_out_fifo_preset_full_SW0 : X_LUT5
    generic map(
      LOC => "SLICE_X8Y61",
      INIT => X"C0300C03"
    )
    port map (
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      ADR0 => '1',
      O => N53_pack_4
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_3 : X_SFF
    generic map(
      LOC => "SLICE_X8Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_3_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_3_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_preset_full : X_LUT6
    generic map(
      LOC => "SLICE_X8Y61",
      INIT => X"8400000000840000"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_going_full_2622,
      ADR4 => N53,
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      ADR5 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => Inst_DvidGen_dvid_ser_out_fifo_preset_full_2621
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_pack_3,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_Q
    );
  Inst_DvidGen_dvid_ser_out_fifo_write_ctrl_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y62",
      INIT => X"0000FFFF0000FFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR5 => '1',
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_full_out_2886,
      O => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2 : X_SFF
    generic map(
      LOC => "SLICE_X8Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_Result(2),
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_Q,
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_Mcount_binary_count_xor_2_11 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y62",
      INIT => X"33CCFF0033CCFF00"
    )
    port map (
      ADR0 => '1',
      ADR2 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0_Q,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_Q,
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_out_fifo_Result(2)
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_Mcount_binary_count_xor_3_11 : X_LUT5
    generic map(
      LOC => "SLICE_X8Y62",
      INIT => X"66AAAAAA"
    )
    port map (
      ADR2 => '1',
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_Q,
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0_Q,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_Q,
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => Inst_DvidGen_dvid_ser_out_fifo_Result(3)
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3 : X_SFF
    generic map(
      LOC => "SLICE_X8Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_Result(3),
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_pack_3,
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0 : X_SFF
    generic map(
      LOC => "SLICE_X8Y62",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_Result(0),
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0_Q,
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_Mcount_binary_count_xor_0_11_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X8Y62",
      INIT => X"00000000FFFFFFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR5 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0_Q,
      ADR4 => '1',
      ADR3 => '1',
      O => Inst_DvidGen_dvid_ser_out_fifo_Result(0)
    );
  Inst_DvidGen_dvid_ser_out_fifo_empty_out : X_FF
    generic map(
      LOC => "SLICE_X8Y63",
      INIT => '1'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_empty_out_CLK,
      I => '0',
      O => Inst_DvidGen_dvid_ser_out_fifo_empty_out_2848,
      SET => Inst_DvidGen_dvid_ser_out_fifo_preset_empty_2889,
      RST => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_xor_3_11_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y51",
      INIT => X"60C5085120450851"
    )
    port map (
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_cy(1),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(2),
      ADR1 => Inst_DvidGen_blue_level_2_Q,
      ADR2 => Inst_DvidGen_blue_level_6_Q,
      ADR4 => Inst_DvidGen_blue_level_5_Q,
      ADR5 => Inst_DvidGen_blue_level_7_Q,
      O => N128
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_cy_1_11 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y51",
      INIT => X"A2A88020AA888800"
    )
    port map (
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR1 => N134,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(0),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_06,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(1),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_cy(1)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd6_xor_0_11 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y51",
      INIT => X"00FFFF0000FFFF00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR5 => '1',
      ADR4 => Inst_DvidGen_blue_level_2_Q,
      ADR3 => Inst_DvidGen_blue_level_7_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_06
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_31 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y52",
      INIT => X"AE5D0804AE5D0804"
    )
    port map (
      ADR5 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(1),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(2),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21_0,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_2
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_21 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y52",
      INIT => X"C382EBC382C3C3EB"
    )
    port map (
      ADR3 => Inst_DvidGen_blue_level_2_Q,
      ADR5 => Inst_DvidGen_blue_level_7_Q,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(1),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(0),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_lut_3_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y52",
      INIT => X"FCA6AC06AC060C56"
    )
    port map (
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21_0,
      ADR4 => N80,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(2),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_2,
      O => N17
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3 : X_SFF
    generic map(
      LOC => "SLICE_X9Y52",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Result(3),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(3),
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_xor_3_11 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y52",
      INIT => X"10BA45EFBA10EF45"
    )
    port map (
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR3 => N128,
      ADR4 => N17,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(3),
      ADR1 => N19,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_cy(1),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Result(3)
    );
  Inst_DvidGen_blue_level_5_Inst_DvidGen_blue_level_5_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21_0
    );
  Inst_DvidGen_blue_level_5_Inst_DvidGen_blue_level_5_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => N61_pack_7,
      O => N61
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_1111 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y53",
      INIT => X"66BB77CC66BB77CC"
    )
    port map (
      ADR2 => '1',
      ADR3 => Inst_DvidGen_blue_level_5_Q,
      ADR0 => Inst_DvidGen_blue_level_7_Q,
      ADR4 => Inst_DvidGen_blue_level_2_Q,
      ADR1 => Inst_DvidGen_blue_level_6_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_211 : X_LUT5
    generic map(
      LOC => "SLICE_X9Y53",
      INIT => X"8800FFFF"
    )
    port map (
      ADR2 => '1',
      ADR3 => Inst_DvidGen_blue_level_5_Q,
      ADR0 => Inst_DvidGen_blue_level_7_Q,
      ADR4 => Inst_DvidGen_blue_level_2_Q,
      ADR1 => Inst_DvidGen_blue_level_6_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21
    );
  renderer_rgb_5_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y53",
      INIT => X"50F050F050F050F0"
    )
    port map (
      ADR4 => '1',
      ADR1 => '1',
      ADR2 => renderer_Mram_bgcolor7,
      ADR3 => renderer_Mram_bgcolor23,
      ADR0 => renderer_Mram_bgcolor15,
      ADR5 => '1',
      O => N59
    );
  renderer_rgb_13_SW0 : X_LUT5
    generic map(
      LOC => "SLICE_X9Y53",
      INIT => X"0AAA0AAA"
    )
    port map (
      ADR4 => '1',
      ADR1 => '1',
      ADR2 => renderer_Mram_bgcolor7,
      ADR3 => renderer_Mram_bgcolor23,
      ADR0 => renderer_Mram_bgcolor15,
      O => N61_pack_7
    );
  Inst_DvidGen_blue_level_5 : X_SFF
    generic map(
      LOC => "SLICE_X9Y53",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_blue_level_5_CLK,
      I => blue_val_3_Q,
      O => Inst_DvidGen_blue_level_5_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_rgb_5_Q : X_LUT6
    generic map(
      LOC => "SLICE_X9Y53",
      INIT => X"CDCD4C4CFF00FF00"
    )
    port map (
      ADR0 => renderer_character_data(10),
      ADR2 => renderer_character_data(9),
      ADR1 => renderer_character_data(8),
      ADR4 => renderer_character_data(11),
      ADR3 => N59,
      ADR5 => renderer_use_foreground_color_0,
      O => blue_val_3_Q
    );
  Inst_DvidGen_green_level_5 : X_SFF
    generic map(
      LOC => "SLICE_X9Y53",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_green_level_5_CLK,
      I => green_val_3_Q,
      O => Inst_DvidGen_green_level_5_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_rgb_13_Q : X_LUT6
    generic map(
      LOC => "SLICE_X9Y53",
      INIT => X"F0F550F0CCCCCCCC"
    )
    port map (
      ADR0 => renderer_character_data(10),
      ADR3 => renderer_character_data(8),
      ADR2 => renderer_character_data(9),
      ADR4 => renderer_character_data(11),
      ADR1 => N61,
      ADR5 => renderer_use_foreground_color_0,
      O => green_val_3_Q
    );
  Inst_DvidGen_blue_level_7_Inst_DvidGen_blue_level_7_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111_0
    );
  Inst_DvidGen_blue_level_7_Inst_DvidGen_blue_level_7_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => N103_pack_9,
      O => N103
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Mmux_data_word271 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y54",
      INIT => X"05A0FA5F05A0FA5F"
    )
    port map (
      ADR1 => '1',
      ADR3 => Inst_DvidGen_green_level_2_Q,
      ADR4 => Inst_DvidGen_green_level_7_Q,
      ADR2 => Inst_DvidGen_green_level_6_Q,
      ADR0 => Inst_DvidGen_green_level_5_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_data_word_inv(7)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_1111 : X_LUT5
    generic map(
      LOC => "SLICE_X9Y54",
      INIT => X"5F5AA5FA"
    )
    port map (
      ADR1 => '1',
      ADR3 => Inst_DvidGen_green_level_2_Q,
      ADR4 => Inst_DvidGen_green_level_7_Q,
      ADR2 => Inst_DvidGen_green_level_6_Q,
      ADR0 => Inst_DvidGen_green_level_5_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111
    );
  Inst_DvidGen_blue_level_7 : X_SFF
    generic map(
      LOC => "SLICE_X9Y54",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_blue_level_7_CLK,
      I => blue_val_7_Q,
      O => Inst_DvidGen_blue_level_7_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_Mmux_rgb221 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y54",
      INIT => X"F0F0F0FCAAAAAAAA"
    )
    port map (
      ADR0 => renderer_Mram_bgcolor7,
      ADR4 => renderer_character_data(9),
      ADR3 => renderer_character_data(10),
      ADR2 => renderer_character_data(8),
      ADR1 => renderer_character_data(11),
      ADR5 => renderer_use_foreground_color_0,
      O => blue_val_7_Q
    );
  Inst_DvidGen_green_level_2 : X_SFF
    generic map(
      LOC => "SLICE_X9Y54",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_green_level_2_CLK,
      I => green_val_0_Q,
      O => Inst_DvidGen_green_level_2_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_rgb_14_31 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y54",
      INIT => X"A0A00000A0A00000"
    )
    port map (
      ADR3 => '1',
      ADR1 => '1',
      ADR0 => renderer_character_data(9),
      ADR2 => renderer_character_data(11),
      ADR4 => renderer_use_foreground_color_0,
      ADR5 => '1',
      O => green_val_0_Q
    );
  renderer_rgb_6_2_SW0 : X_LUT5
    generic map(
      LOC => "SLICE_X9Y54",
      INIT => X"AA00AA00"
    )
    port map (
      ADR2 => '1',
      ADR3 => renderer_character_data(10),
      ADR0 => renderer_character_data(9),
      ADR1 => '1',
      ADR4 => '1',
      O => N103_pack_9
    );
  Inst_DvidGen_blue_level_6 : X_SFF
    generic map(
      LOC => "SLICE_X9Y54",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_blue_level_6_CLK,
      I => blue_val_4_Q,
      O => Inst_DvidGen_blue_level_6_Q,
      SRST => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  renderer_rgb_6_2 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y54",
      INIT => X"FF00AA00C0C0C0C0"
    )
    port map (
      ADR1 => renderer_Mram_bgcolor7,
      ADR3 => renderer_character_data(8),
      ADR4 => renderer_character_data(11),
      ADR2 => N63_0,
      ADR0 => N103,
      ADR5 => renderer_use_foreground_color_0,
      O => blue_val_4_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_xor_3_11_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y55",
      INIT => X"088FA005500A000F"
    )
    port map (
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_cy(1),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(2),
      ADR4 => Inst_DvidGen_green_level_2_Q,
      ADR0 => Inst_DvidGen_green_level_6_Q,
      ADR5 => Inst_DvidGen_green_level_5_Q,
      ADR1 => Inst_DvidGen_green_level_7_Q,
      O => N130
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_2 : X_SFF
    generic map(
      LOC => "SLICE_X9Y56",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_2_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Result(2),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(2),
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_xor_2_11 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y56",
      INIT => X"7B4884B7B784487B"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_03,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(2),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_cy(1),
      ADR3 => N34,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Result(2)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_1 : X_SFF
    generic map(
      LOC => "SLICE_X9Y56",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_1_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Result(1),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(1),
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_xor_1_11 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y56",
      INIT => X"0A06A090F5F95F6F"
    )
    port map (
      ADR5 => N136_0,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_03,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_06,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(0),
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Result(1)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y56",
      INIT => X"0000000000000505"
    )
    port map (
      ADR3 => '1',
      ADR1 => '1',
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(2),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(3),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(1),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(0),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_0 : X_SFF
    generic map(
      LOC => "SLICE_X9Y56",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_0_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Result(0),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(0),
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_xor_0_11 : X_LUT6
    generic map(
      LOC => "SLICE_X9Y56",
      INIT => X"055FFFFFFAA00000"
    )
    port map (
      ADR1 => '1',
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut(0),
      ADR3 => Inst_DvidGen_green_level_6_Q,
      ADR0 => Inst_DvidGen_green_level_2_Q,
      ADR2 => Inst_DvidGen_green_level_5_Q,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Result(0)
    );
  Inst_DvidGen_dvid_ser_out_fifo_full_out : X_FF
    generic map(
      LOC => "SLICE_X9Y61",
      INIT => '1'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_full_out_CLK,
      I => '0',
      O => Inst_DvidGen_dvid_ser_out_fifo_full_out_2886,
      SET => Inst_DvidGen_dvid_ser_out_fifo_preset_full_2621,
      RST => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_preset_empty : X_LUT6
    generic map(
      LOC => "SLICE_X9Y62",
      INIT => X"8400008400000000"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_going_empty_2849,
      ADR5 => N53,
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => Inst_DvidGen_dvid_ser_out_fifo_preset_empty_2889
    );
  Inst_DvidGen_v_next_9 : X_FF
    generic map(
      LOC => "SLICE_X10Y46",
      INIT => '1'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_9_CLK,
      I => Inst_DvidGen_v_next_9_glue_rst_1967,
      O => Inst_DvidGen_v_next(9),
      SET => GND,
      RST => GND
    );
  Inst_DvidGen_v_next_9_glue_rst : X_LUT6
    generic map(
      LOC => "SLICE_X10Y46",
      INIT => X"3FFFFFFF00000000"
    )
    port map (
      ADR0 => '1',
      ADR5 => Inst_DvidGen_Result_9_0,
      ADR4 => Inst_DvidGen_v_next(2),
      ADR2 => Inst_DvidGen_v_next(0),
      ADR1 => Inst_DvidGen_n00712_2856,
      ADR3 => Inst_DvidGen_n00711_2857,
      O => Inst_DvidGen_v_next_9_glue_rst_1967
    );
  Inst_DvidGen_v_next_7 : X_FF
    generic map(
      LOC => "SLICE_X10Y46",
      INIT => '1'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_7_CLK,
      I => Inst_DvidGen_v_next_7_glue_rst_1979,
      O => Inst_DvidGen_v_next(7),
      SET => GND,
      RST => GND
    );
  Inst_DvidGen_v_next_7_glue_rst : X_LUT6
    generic map(
      LOC => "SLICE_X10Y46",
      INIT => X"0AAAAAAAAAAAAAAA"
    )
    port map (
      ADR1 => '1',
      ADR0 => Inst_DvidGen_Result_7_0,
      ADR3 => Inst_DvidGen_v_next(2),
      ADR5 => Inst_DvidGen_v_next(0),
      ADR4 => Inst_DvidGen_n00712_2856,
      ADR2 => Inst_DvidGen_n00711_2857,
      O => Inst_DvidGen_v_next_7_glue_rst_1979
    );
  Inst_DvidGen_v_next_6 : X_FF
    generic map(
      LOC => "SLICE_X10Y46",
      INIT => '1'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_6_CLK,
      I => Inst_DvidGen_v_next_6_glue_rst_1981,
      O => Inst_DvidGen_v_next(6),
      SET => GND,
      RST => GND
    );
  Inst_DvidGen_v_next_6_glue_rst : X_LUT6
    generic map(
      LOC => "SLICE_X10Y46",
      INIT => X"70F070F0F0F0F0F0"
    )
    port map (
      ADR4 => '1',
      ADR2 => Inst_DvidGen_Result_6_0,
      ADR3 => Inst_DvidGen_v_next(2),
      ADR0 => Inst_DvidGen_v_next(0),
      ADR1 => Inst_DvidGen_n00712_2856,
      ADR5 => Inst_DvidGen_n00711_2857,
      O => Inst_DvidGen_v_next_6_glue_rst_1981
    );
  Inst_DvidGen_v_next_4 : X_FF
    generic map(
      LOC => "SLICE_X10Y46",
      INIT => '1'
    )
    port map (
      CE => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      CLK => NlwBufferSignal_Inst_DvidGen_v_next_4_CLK,
      I => Inst_DvidGen_v_next_4_glue_rst_1993,
      O => Inst_DvidGen_v_next(4),
      SET => GND,
      RST => GND
    );
  Inst_DvidGen_v_next_4_glue_rst : X_LUT6
    generic map(
      LOC => "SLICE_X10Y46",
      INIT => X"2A2AAAAAAAAAAAAA"
    )
    port map (
      ADR3 => '1',
      ADR0 => Inst_DvidGen_Result_4_0,
      ADR4 => Inst_DvidGen_v_next(2),
      ADR2 => Inst_DvidGen_v_next(0),
      ADR5 => Inst_DvidGen_n00712_2856,
      ADR1 => Inst_DvidGen_n00711_2857,
      O => Inst_DvidGen_v_next_4_glue_rst_1993
    );
  Inst_DvidGen_v_count_11_GND_9_o_LessThan_12_o12 : X_LUT6
    generic map(
      LOC => "SLICE_X10Y47",
      INIT => X"0101011155555555"
    )
    port map (
      ADR0 => Inst_DvidGen_v_count(5),
      ADR1 => Inst_DvidGen_v_count(3),
      ADR2 => Inst_DvidGen_v_count(2),
      ADR3 => Inst_DvidGen_v_count(1),
      ADR4 => Inst_DvidGen_v_count(0),
      ADR5 => Inst_DvidGen_v_count(4),
      O => Inst_DvidGen_v_count_11_GND_9_o_LessThan_12_o11_2910
    );
  Inst_DvidGen_v_count_11_GND_9_o_LessThan_12_o13 : X_LUT6
    generic map(
      LOC => "SLICE_X10Y47",
      INIT => X"33130000FFFF0000"
    )
    port map (
      ADR4 => Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o,
      ADR1 => Inst_DvidGen_v_count(8),
      ADR2 => Inst_DvidGen_v_count(7),
      ADR0 => Inst_DvidGen_v_count(6),
      ADR3 => Inst_DvidGen_v_count_11_GND_9_o_LessThan_12_o11_2910,
      ADR5 => Inst_DvidGen_v_count(9),
      O => Inst_DvidGen_v_count_11_GND_9_o_LessThan_12_o
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_lut_2_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X10Y52",
      INIT => X"956A9A65A65956A9"
    )
    port map (
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21_0,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(2),
      ADR2 => N107,
      ADR5 => N108,
      O => N19
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_lut_2_SW0_SW1 : X_LUT6
    generic map(
      LOC => "SLICE_X10Y52",
      INIT => X"1414282841428281"
    )
    port map (
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_lut(1),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_cy_0_0,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd6_cy(0),
      ADR3 => Inst_DvidGen_blue_level_2_Q,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(3),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(1),
      O => N108
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT51 : X_MUX2
    generic map(
      LOC => "SLICE_X10Y55"
    )
    port map (
      IA => N152,
      IB => N153,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_4_Q,
      SEL => Inst_DvidGen_blank_2524
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT51_F : X_LUT6
    generic map(
      LOC => "SLICE_X10Y55",
      INIT => X"5FFA5FFAA5A55A5A"
    )
    port map (
      ADR1 => '1',
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR2 => Inst_DvidGen_blue_level_5_Q,
      ADR0 => Inst_DvidGen_blue_level_6_Q,
      ADR3 => Inst_DvidGen_blue_level_2_Q,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(3),
      O => N152
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_4 : X_FF
    generic map(
      LOC => "SLICE_X10Y55",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_4_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_4_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_4_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT51_G_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X10Y55",
      INIT => X"00FF00FF00FF00FF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR5 => '1',
      ADR4 => '1',
      ADR3 => Inst_DvidGen_hsync_2526,
      O => N153
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_6 : X_FF
    generic map(
      LOC => "SLICE_X10Y55",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_6_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_6_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_6_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT7 : X_LUT6
    generic map(
      LOC => "SLICE_X10Y55",
      INIT => X"12221121DEEEDDED"
    )
    port map (
      ADR1 => Inst_DvidGen_blank_2524,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03,
      ADR0 => Inst_DvidGen_blue_level_2_Q,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR5 => Inst_DvidGen_hsync_2526,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_6_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_5 : X_FF
    generic map(
      LOC => "SLICE_X10Y55",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_5_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_5_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_5_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT61 : X_LUT6
    generic map(
      LOC => "SLICE_X10Y55",
      INIT => X"F5B1F5E4A0E4A0B1"
    )
    port map (
      ADR0 => Inst_DvidGen_blank_2524,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_xored(5),
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR2 => Inst_DvidGen_hsync_2526,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_5_Q
    );
  N34_N34_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd6_cy_0_pack_9,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd6_cy(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut_2_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X10Y56",
      INIT => X"A695569A596AA965"
    )
    port map (
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Msub_GND_13_o_GND_13_o_sub_31_OUT_3_0_cy_0_1,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(2),
      ADR4 => N110,
      ADR1 => N111,
      O => N34
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut_2_SW0_SW1 : X_LUT6
    generic map(
      LOC => "SLICE_X10Y56",
      INIT => X"1212484821248481"
    )
    port map (
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_lut(1),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_cy(0),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd6_cy(0),
      ADR3 => Inst_DvidGen_green_level_2_Q,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(3),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(1),
      O => N111
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_17_o : X_LUT6
    generic map(
      LOC => "SLICE_X10Y56",
      INIT => X"FCFCC0C0FCFCC0C0"
    )
    port map (
      ADR0 => '1',
      ADR3 => '1',
      ADR2 => Inst_DvidGen_green_level_6_Q,
      ADR4 => Inst_DvidGen_green_level_2_Q,
      ADR1 => Inst_DvidGen_green_level_5_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_03
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd6_cy_0_11 : X_LUT5
    generic map(
      LOC => "SLICE_X10Y56",
      INIT => X"FC0000C0"
    )
    port map (
      ADR0 => '1',
      ADR3 => Inst_DvidGen_green_level_7_Q,
      ADR2 => Inst_DvidGen_green_level_6_Q,
      ADR4 => Inst_DvidGen_green_level_2_Q,
      ADR1 => Inst_DvidGen_green_level_5_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd6_cy_0_pack_9
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut_2_SW0_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X10Y56",
      INIT => X"53353A53533A3AA3"
    )
    port map (
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_lut(1),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_cy(0),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd6_cy(0),
      ADR5 => Inst_DvidGen_green_level_2_Q,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(3),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(1),
      O => N110
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_5_Inst_DvidGen_dvid_ser_out_fifo_n0035_5_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_O,
      O => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_O_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_5_Inst_DvidGen_dvid_ser_out_fifo_n0035_5_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(4),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_4_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_5_Inst_DvidGen_dvid_ser_out_fifo_n0035_5_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(2),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_2_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_n0035_5_Inst_DvidGen_dvid_ser_out_fifo_n0035_5_AMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(0),
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035_0_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X10Y60",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_CLK,
      I => '0',
      O => NLW_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_O_UNCONNECTED,
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD : X_RAMD32
    generic map(
      LOC => "SLICE_X10Y60",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_CLK,
      I => '0',
      O => Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_O,
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X10Y60",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(5),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC : X_RAMD32
    generic map(
      LOC => "SLICE_X10Y60",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(4),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X10Y60",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(3),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB : X_RAMD32
    generic map(
      LOC => "SLICE_X10Y60",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(2),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1 : X_RAMD32
    generic map(
      LOC => "SLICE_X10Y60",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(1),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA : X_RAMD32
    generic map(
      LOC => "SLICE_X10Y60",
      INIT => X"00000000"
    )
    port map (
      RADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR0,
      RADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR1,
      RADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR2,
      RADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR3,
      RADR4 => '0',
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_n0035(0),
      WADR0 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR0,
      WADR1 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR1,
      WADR2 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR2,
      WADR3 => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR3,
      WADR4 => '0',
      WE => Inst_DvidGen_dvid_ser_out_fifo_next_write_address_en
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_3 : X_FF
    generic map(
      LOC => "SLICE_X10Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_3_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_3_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(3),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_2 : X_FF
    generic map(
      LOC => "SLICE_X10Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_2_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_2_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(2),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_1 : X_FF
    generic map(
      LOC => "SLICE_X10Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_1_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(1),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_DataOut_0 : X_FF
    generic map(
      LOC => "SLICE_X10Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_0_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_0_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_DataOut(0),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_going_full : X_FF
    generic map(
      LOC => "SLICE_X10Y62",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_going_full_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_going_full_rstpot_2132,
      O => Inst_DvidGen_dvid_ser_out_fifo_going_full_2622,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_going_full_rstpot : X_LUT6
    generic map(
      LOC => "SLICE_X10Y62",
      INIT => X"33B7B73300A5A500"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_going_empty_2849,
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      ADR5 => Inst_DvidGen_dvid_ser_out_fifo_going_full_2622,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => Inst_DvidGen_dvid_ser_out_fifo_going_full_rstpot_2132
    );
  Inst_DvidGen_n00712 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y46",
      INIT => X"8000000080000000"
    )
    port map (
      ADR5 => '1',
      ADR3 => Inst_DvidGen_v_next(5),
      ADR1 => Inst_DvidGen_v_next(3),
      ADR2 => Inst_DvidGen_v_next(9),
      ADR0 => Inst_DvidGen_v_next(7),
      ADR4 => Inst_DvidGen_v_next(6),
      O => Inst_DvidGen_n00712_2856
    );
  Inst_DvidGen_v_count_7 : X_FF
    generic map(
      LOC => "SLICE_X11Y47",
      INIT => '1'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_7_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_7_IN,
      O => Inst_DvidGen_v_count(7),
      SET => GND,
      RST => GND
    );
  Inst_DvidGen_v_count_6 : X_FF
    generic map(
      LOC => "SLICE_X11Y47",
      INIT => '1'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_6_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_6_IN,
      O => Inst_DvidGen_v_count(6),
      SET => GND,
      RST => GND
    );
  Inst_DvidGen_v_count_5 : X_FF
    generic map(
      LOC => "SLICE_X11Y47",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_5_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_5_IN,
      O => Inst_DvidGen_v_count(5),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_v_count_4 : X_FF
    generic map(
      LOC => "SLICE_X11Y47",
      INIT => '1'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_4_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_4_IN,
      O => Inst_DvidGen_v_count(4),
      SET => GND,
      RST => GND
    );
  Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o1 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y48",
      INIT => X"EEEC0000CCCC0000"
    )
    port map (
      ADR4 => Inst_DvidGen_v_count(9),
      ADR0 => Inst_DvidGen_v_count(6),
      ADR5 => Inst_DvidGen_v_count(7),
      ADR2 => Inst_DvidGen_v_count(4),
      ADR3 => Inst_DvidGen_v_count(5),
      ADR1 => Inst_DvidGen_v_count(8),
      O => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o1_2916
    );
  Inst_DvidGen_blank : X_FF
    generic map(
      LOC => "SLICE_X11Y48",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_blank_CLK,
      I => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o,
      O => Inst_DvidGen_blank_2524,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o2 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y48",
      INIT => X"FFFFFFFFFFFFFAF8"
    )
    port map (
      ADR0 => Inst_DvidGen_h_count(10),
      ADR1 => Inst_DvidGen_h_count(8),
      ADR3 => Inst_DvidGen_h_count(9),
      ADR2 => Inst_DvidGen_v_count(11),
      ADR4 => Inst_DvidGen_v_count(10),
      ADR5 => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o1_2916,
      O => Inst_DvidGen_GND_9_o_GND_9_o_OR_1_o
    );
  Inst_DvidGen_v_count_11_GND_9_o_LessThan_12_o11 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y48",
      INIT => X"000000000F0F0F0F"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR4 => '1',
      ADR3 => '1',
      ADR2 => Inst_DvidGen_v_count(10),
      ADR5 => Inst_DvidGen_v_count(11),
      O => Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o
    );
  Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o3 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y49",
      INIT => X"30F0307030F030F0"
    )
    port map (
      ADR2 => Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o,
      ADR3 => Inst_DvidGen_v_count(8),
      ADR5 => Inst_DvidGen_v_count(7),
      ADR0 => Inst_DvidGen_v_count(6),
      ADR4 => Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o1,
      ADR1 => Inst_DvidGen_v_count(9),
      O => Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o_0
    );
  Inst_DvidGen_vsync : X_FF
    generic map(
      LOC => "SLICE_X11Y49",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_vsync_CLK,
      I => Inst_DvidGen_vsync_rstpot_2182,
      O => Inst_DvidGen_vsync_2528,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_vsync_rstpot : X_LUT6
    generic map(
      LOC => "SLICE_X11Y49",
      INIT => X"00000000F0F0F0F0"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR4 => '1',
      ADR3 => '1',
      ADR2 => Inst_DvidGen_v_count_11_GND_9_o_LessThan_12_o,
      ADR5 => Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o_0,
      O => Inst_DvidGen_vsync_rstpot_2182
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03_CMUX_Delay : 
X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd6_cy_0_pack_5,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd6_cy(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_17_o : X_LUT6
    generic map(
      LOC => "SLICE_X11Y52",
      INIT => X"FFAAAA00FFAAAA00"
    )
    port map (
      ADR2 => '1',
      ADR1 => '1',
      ADR3 => Inst_DvidGen_blue_level_6_Q,
      ADR4 => Inst_DvidGen_blue_level_2_Q,
      ADR0 => Inst_DvidGen_blue_level_5_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd6_cy_0_11 : X_LUT5
    generic map(
      LOC => "SLICE_X11Y52",
      INIT => X"CC882200"
    )
    port map (
      ADR2 => '1',
      ADR1 => Inst_DvidGen_blue_level_7_Q,
      ADR3 => Inst_DvidGen_blue_level_6_Q,
      ADR4 => Inst_DvidGen_blue_level_2_Q,
      ADR0 => Inst_DvidGen_blue_level_5_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd6_cy_0_pack_5
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_lut_2_SW0_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y52",
      INIT => X"3535535C535CC5C5"
    )
    port map (
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_lut(1),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd5_cy_0_0,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd6_cy(0),
      ADR3 => Inst_DvidGen_blue_level_2_Q,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(3),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(1),
      O => N107
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_21 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y52",
      INIT => X"F1F21F2F70B0070B"
    )
    port map (
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(0),
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_111,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(1),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03,
      ADR3 => Inst_DvidGen_blue_level_2_Q,
      ADR0 => Inst_DvidGen_blue_level_7_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_cy_0_1
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_9_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_9_DMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => N148_pack_12,
      O => N148
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_311 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y55",
      INIT => X"CC33CC33CC33CC33"
    )
    port map (
      ADR0 => '1',
      ADR4 => '1',
      ADR2 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(3),
      ADR3 => Inst_DvidGen_blue_level_2_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT41_SW0 : X_LUT5
    generic map(
      LOC => "SLICE_X11Y55",
      INIT => X"C333CCC3"
    )
    port map (
      ADR0 => '1',
      ADR2 => Inst_DvidGen_blue_level_5_Q,
      ADR4 => Inst_DvidGen_blue_level_6_Q,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(3),
      ADR3 => Inst_DvidGen_blue_level_2_Q,
      O => N148_pack_12
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_9 : X_FF
    generic map(
      LOC => "SLICE_X11Y55",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_9_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_9_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_9_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT101 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y55",
      INIT => X"B7B7848484B784B7"
    )
    port map (
      ADR1 => Inst_DvidGen_blank_2524,
      ADR0 => Inst_DvidGen_hsync_2526,
      ADR2 => Inst_DvidGen_vsync_2528,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_9_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_3 : X_FF
    generic map(
      LOC => "SLICE_X11Y55",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_3_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_3_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_3_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT41 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y55",
      INIT => X"F0F055CCF0F0AA33"
    )
    port map (
      ADR4 => Inst_DvidGen_blank_2524,
      ADR5 => Inst_DvidGen_blue_level_2_Q,
      ADR0 => Inst_DvidGen_blue_level_5_Q,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR1 => N148,
      ADR2 => Inst_DvidGen_hsync_2526,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_3_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_1 : X_FF
    generic map(
      LOC => "SLICE_X11Y55",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_1_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_1_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_1_Q,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Mmux_dc_bias_3_Ctrl_1_mux_36_OUT21 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y55",
      INIT => X"8B88888B888B8B88"
    )
    port map (
      ADR1 => Inst_DvidGen_blank_2524,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03,
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(3),
      ADR4 => Inst_DvidGen_blue_level_2_Q,
      ADR0 => Inst_DvidGen_hsync_2526,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_Ctrl_1_mux_36_OUT_1_Q
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut_0_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut_0_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_cy_0_pack_8,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_cy(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut_0_11 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y56",
      INIT => X"A5A59696A5A59696"
    )
    port map (
      ADR3 => '1',
      ADR5 => '1',
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(0),
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_data_word_inv(7),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_GND_13_o_GND_13_o_OR_18_o1_2613,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_lut_1_1 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y56",
      INIT => X"0F0000F00F0000F0"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => Inst_DvidGen_green_level_5_Q,
      ADR4 => Inst_DvidGen_green_level_6_Q,
      ADR3 => Inst_DvidGen_green_level_2_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_lut(1)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_cy_0_11 : X_LUT5
    generic map(
      LOC => "SLICE_X11Y56",
      INIT => X"FF0F0F00"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => Inst_DvidGen_green_level_5_Q,
      ADR4 => Inst_DvidGen_green_level_6_Q,
      ADR3 => Inst_DvidGen_green_level_2_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_cy_0_pack_8
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_311 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y56",
      INIT => X"CCC6CCC366C333C3"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(3),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_03,
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_data_word_inv(7),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_cy(0),
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_lut(1),
      ADR2 => Inst_DvidGen_green_level_2_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_31
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut_3_SW0_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X11Y56",
      INIT => X"FFFF3399FFFFCC66"
    )
    port map (
      ADR2 => '1',
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd_03,
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_data_word_inv(7),
      ADR5 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_lut(1),
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_ADDERTREE_INTERNAL_Madd5_cy(0),
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(1),
      O => N82
    );
  Inst_DvidGen_dvid_ser_out_fifo_going_empty : X_FF
    generic map(
      LOC => "SLICE_X11Y62",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_going_empty_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_going_empty_rstpot_2264,
      O => Inst_DvidGen_dvid_ser_out_fifo_going_empty_2849,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_going_empty_rstpot : X_LUT6
    generic map(
      LOC => "SLICE_X11Y62",
      INIT => X"73503705B3A03B0A"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_going_full_2622,
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_going_empty_2849,
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      ADR5 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => Inst_DvidGen_dvid_ser_out_fifo_going_empty_rstpot_2264
    );
  Inst_DvidGen_v_count_11 : X_FF
    generic map(
      LOC => "SLICE_X12Y48",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_11_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_11_IN,
      O => Inst_DvidGen_v_count(11),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_v_count_10 : X_FF
    generic map(
      LOC => "SLICE_X12Y48",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_10_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_10_IN,
      O => Inst_DvidGen_v_count(10),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_v_count_9 : X_FF
    generic map(
      LOC => "SLICE_X12Y48",
      INIT => '1'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_9_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_9_IN,
      O => Inst_DvidGen_v_count(9),
      SET => GND,
      RST => GND
    );
  Inst_DvidGen_v_count_8 : X_FF
    generic map(
      LOC => "SLICE_X12Y48",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_8_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_8_IN,
      O => Inst_DvidGen_v_count(8),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_xored_5_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_xored_5_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_0_pack_4,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_xored_5_1 : X_LUT6
    generic map(
      LOC => "SLICE_X12Y52",
      INIT => X"0FF00FF00FF00FF0"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR4 => '1',
      ADR3 => Inst_DvidGen_blue_level_6_Q,
      ADR2 => Inst_DvidGen_blue_level_2_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_xored(5)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_xor_0_11 : X_LUT5
    generic map(
      LOC => "SLICE_X12Y52",
      INIT => X"566AAAAA"
    )
    port map (
      ADR0 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_lut(0),
      ADR1 => Inst_DvidGen_blue_level_5_Q,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR3 => Inst_DvidGen_blue_level_6_Q,
      ADR2 => Inst_DvidGen_blue_level_2_Q,
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Result(0)
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_0 : X_SFF
    generic map(
      LOC => "SLICE_X12Y52",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_0_CLK,
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Result(0),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_0_pack_4,
      SRST => Inst_DvidGen_blank_2524,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_lut_0_1 : X_LUT6
    generic map(
      LOC => "SLICE_X12Y52",
      INIT => X"5AA56996A55A6996"
    )
    port map (
      ADR3 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_ADDERTREE_INTERNAL_Madd_03,
      ADR5 => Inst_DvidGen_blue_level_2_Q,
      ADR4 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_GND_13_o_GND_13_o_OR_18_o1_2525,
      ADR2 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(0),
      ADR0 => Inst_DvidGen_blue_level_7_Q,
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias(3),
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Maccum_dc_bias_lut(0)
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(2),
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3 : X_SFF
    generic map(
      LOC => "SLICE_X12Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3_CLK,
      I => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3_IN,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_1 : X_SFF
    generic map(
      LOC => "SLICE_X12Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_1_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_GND_19_o_xor_1_OUT_1_Q,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_Mxor_binary_count_3_GND_19_o_xor_1_OUT_1_xo_0_1 : X_LUT6
    generic map(
      LOC => "SLICE_X12Y61",
      INIT => X"6666666666666666"
    )
    port map (
      ADR4 => '1',
      ADR3 => '1',
      ADR2 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_GND_19_o_xor_1_OUT_1_Q
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_Mxor_binary_count_3_GND_19_o_xor_1_OUT_2_xo_0_1 : X_LUT5
    generic map(
      LOC => "SLICE_X12Y61",
      INIT => X"5A5A5A5A"
    )
    port map (
      ADR4 => '1',
      ADR1 => '1',
      ADR2 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_Q,
      ADR3 => '1',
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_Q,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_GND_19_o_xor_1_OUT_2_Q
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2 : X_SFF
    generic map(
      LOC => "SLICE_X12Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_GND_19_o_xor_1_OUT_2_Q,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(2),
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_0 : X_SFF
    generic map(
      LOC => "SLICE_X12Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_0_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_Result_1_1_2301,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_Result_1_11 : X_LUT6
    generic map(
      LOC => "SLICE_X12Y61",
      INIT => X"33333333CCCCCCCC"
    )
    port map (
      ADR0 => '1',
      ADR3 => '1',
      ADR2 => '1',
      ADR5 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      ADR4 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0_Q,
      O => Inst_DvidGen_dvid_ser_out_fifo_Result_1_1_2301
    );
  Inst_DvidGen_h_count_7 : X_FF
    generic map(
      LOC => "SLICE_X13Y46",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_count_7_CLK,
      I => NlwBufferSignal_Inst_DvidGen_h_count_7_IN,
      O => Inst_DvidGen_h_count(7),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_n00711 : X_LUT6
    generic map(
      LOC => "SLICE_X13Y46",
      INIT => X"0000000100000001"
    )
    port map (
      ADR5 => '1',
      ADR1 => Inst_DvidGen_v_next(4),
      ADR3 => Inst_DvidGen_v_next(1),
      ADR0 => Inst_DvidGen_v_next(8),
      ADR4 => Inst_DvidGen_v_next(10),
      ADR2 => Inst_DvidGen_v_next(11),
      O => Inst_DvidGen_n00711_2857
    );
  Inst_DvidGen_h_count_6 : X_FF
    generic map(
      LOC => "SLICE_X13Y46",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_count_6_CLK,
      I => NlwBufferSignal_Inst_DvidGen_h_count_6_IN,
      O => Inst_DvidGen_h_count(6),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_n00713 : X_LUT6
    generic map(
      LOC => "SLICE_X13Y46",
      INIT => X"8080000000000000"
    )
    port map (
      ADR3 => '1',
      ADR1 => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o,
      ADR4 => Inst_DvidGen_v_next(2),
      ADR2 => Inst_DvidGen_v_next(0),
      ADR0 => Inst_DvidGen_n00712_2856,
      ADR5 => Inst_DvidGen_n00711_2857,
      O => Inst_DvidGen_n0071
    );
  Inst_DvidGen_h_count_5 : X_FF
    generic map(
      LOC => "SLICE_X13Y46",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_count_5_CLK,
      I => NlwBufferSignal_Inst_DvidGen_h_count_5_IN,
      O => Inst_DvidGen_h_count(5),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_h_next_11_GND_9_o_equal_16_o_11_SW0 : X_LUT6
    generic map(
      LOC => "SLICE_X13Y46",
      INIT => X"FFFFFFFFBFFFFFFF"
    )
    port map (
      ADR3 => Inst_DvidGen_h_next(3),
      ADR5 => Inst_DvidGen_h_next(8),
      ADR4 => Inst_DvidGen_h_next(2),
      ADR2 => Inst_DvidGen_h_next(1),
      ADR1 => Inst_DvidGen_h_next(10),
      ADR0 => Inst_DvidGen_h_next(4),
      O => N4
    );
  Inst_DvidGen_h_count_4 : X_FF
    generic map(
      LOC => "SLICE_X13Y46",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_count_4_CLK,
      I => NlwBufferSignal_Inst_DvidGen_h_count_4_IN,
      O => Inst_DvidGen_h_count(4),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_h_next_11_GND_9_o_equal_16_o_11_Q : X_LUT6
    generic map(
      LOC => "SLICE_X13Y46",
      INIT => X"0000000000002000"
    )
    port map (
      ADR4 => count32(0),
      ADR0 => Inst_DvidGen_h_next(9),
      ADR5 => Inst_DvidGen_h_next(7),
      ADR2 => Inst_DvidGen_h_next(6),
      ADR3 => Inst_DvidGen_h_next(5),
      ADR1 => N4,
      O => Inst_DvidGen_h_next_11_GND_9_o_equal_16_o
    );
  Inst_DvidGen_v_count_3 : X_FF
    generic map(
      LOC => "SLICE_X13Y47",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_3_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_3_IN,
      O => Inst_DvidGen_v_count(3),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_GND_9_o_h_count_11_LessThan_9_o1 : X_LUT6
    generic map(
      LOC => "SLICE_X13Y47",
      INIT => X"11FF11FF11FF15FF"
    )
    port map (
      ADR0 => Inst_DvidGen_h_count(7),
      ADR1 => Inst_DvidGen_h_count(6),
      ADR5 => count32(3),
      ADR2 => Inst_DvidGen_h_count(4),
      ADR4 => Inst_DvidGen_h_count(5),
      ADR3 => Inst_DvidGen_h_count(8),
      O => Inst_DvidGen_GND_9_o_h_count_11_LessThan_9_o
    );
  Inst_DvidGen_v_count_2 : X_FF
    generic map(
      LOC => "SLICE_X13Y47",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_2_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_2_IN,
      O => Inst_DvidGen_v_count(2),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_v_count_1 : X_FF
    generic map(
      LOC => "SLICE_X13Y47",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_1_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_1_IN,
      O => Inst_DvidGen_v_count(1),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_v_count_0 : X_FF
    generic map(
      LOC => "SLICE_X13Y47",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_v_count_0_CLK,
      I => NlwBufferSignal_Inst_DvidGen_v_count_0_IN,
      O => Inst_DvidGen_v_count(0),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o2 : X_LUT6
    generic map(
      LOC => "SLICE_X13Y47",
      INIT => X"00010F0F00030F0F"
    )
    port map (
      ADR2 => Inst_DvidGen_v_count(5),
      ADR1 => Inst_DvidGen_v_count(3),
      ADR3 => Inst_DvidGen_v_count(2),
      ADR5 => Inst_DvidGen_v_count(0),
      ADR0 => Inst_DvidGen_v_count(1),
      ADR4 => Inst_DvidGen_v_count(4),
      O => Inst_DvidGen_GND_9_o_v_count_11_LessThan_11_o1
    );
  Inst_DvidGen_hsync_Inst_DvidGen_hsync_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_count_10_pack_4,
      O => Inst_DvidGen_h_count(10)
    );
  Inst_DvidGen_h_count_11_GND_9_o_LessThan_10_o11 : X_LUT6
    generic map(
      LOC => "SLICE_X13Y48",
      INIT => X"00550055005700FF"
    )
    port map (
      ADR3 => Inst_DvidGen_h_count(9),
      ADR5 => Inst_DvidGen_h_count(7),
      ADR4 => Inst_DvidGen_h_count(6),
      ADR1 => Inst_DvidGen_h_count(5),
      ADR2 => Inst_DvidGen_h_count(4),
      ADR0 => Inst_DvidGen_h_count(8),
      O => Inst_DvidGen_h_count_11_GND_9_o_LessThan_10_o1
    );
  Inst_DvidGen_hsync : X_FF
    generic map(
      LOC => "SLICE_X13Y48",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_hsync_CLK,
      I => Inst_DvidGen_hsync_rstpot_2381,
      O => Inst_DvidGen_hsync_2526,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_hsync_rstpot : X_LUT6
    generic map(
      LOC => "SLICE_X13Y48",
      INIT => X"8C008C008C008C00"
    )
    port map (
      ADR4 => '1',
      ADR1 => Inst_DvidGen_h_count(10),
      ADR2 => Inst_DvidGen_GND_9_o_h_count_11_LessThan_9_o,
      ADR0 => Inst_DvidGen_h_count(9),
      ADR3 => Inst_DvidGen_h_count_11_GND_9_o_LessThan_10_o1,
      ADR5 => '1',
      O => Inst_DvidGen_hsync_rstpot_2381
    );
  Inst_DvidGen_hsync_Inst_DvidGen_h_next_10_rt : X_LUT5
    generic map(
      LOC => "SLICE_X13Y48",
      INIT => X"FFFF0000"
    )
    port map (
      ADR4 => Inst_DvidGen_h_next(10),
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => '1',
      ADR0 => '1',
      O => Inst_DvidGen_hsync_Inst_DvidGen_h_next_10_rt_2382
    );
  Inst_DvidGen_h_count_10 : X_FF
    generic map(
      LOC => "SLICE_X13Y48",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_count_10_CLK,
      I => Inst_DvidGen_hsync_Inst_DvidGen_h_next_10_rt_2382,
      O => Inst_DvidGen_h_count_10_pack_4,
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_h_count_9 : X_FF
    generic map(
      LOC => "SLICE_X13Y48",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_count_9_CLK,
      I => NlwBufferSignal_Inst_DvidGen_h_count_9_IN,
      O => Inst_DvidGen_h_count(9),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_h_count_8 : X_FF
    generic map(
      LOC => "SLICE_X13Y48",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_h_count_8_CLK,
      I => NlwBufferSignal_Inst_DvidGen_h_count_8_IN,
      O => Inst_DvidGen_h_count(8),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21_AMUX_Delay : 
X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => N136,
      O => N136_0
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_211 : X_LUT6
    generic map(
      LOC => "SLICE_X13Y56",
      INIT => X"F5555555F5555555"
    )
    port map (
      ADR1 => '1',
      ADR2 => Inst_DvidGen_green_level_5_Q,
      ADR4 => Inst_DvidGen_green_level_7_Q,
      ADR3 => Inst_DvidGen_green_level_6_Q,
      ADR0 => Inst_DvidGen_green_level_2_Q,
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Madd_GND_13_o_data_word_disparity_3_add_32_OUT_lut_0_21
    );
  Inst_DvidGen_dvid_ser_TMDS_encoder_green_Maccum_dc_bias_lut_1_SW2 : X_LUT5
    generic map(
      LOC => "SLICE_X13Y56",
      INIT => X"3CC9C669"
    )
    port map (
      ADR1 => Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias(1),
      ADR2 => Inst_DvidGen_green_level_5_Q,
      ADR4 => Inst_DvidGen_green_level_7_Q,
      ADR3 => Inst_DvidGen_green_level_6_Q,
      ADR0 => Inst_DvidGen_green_level_2_Q,
      O => N136
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_BMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_pack_3,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_Q
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2 : X_SFF
    generic map(
      LOC => "SLICE_X13Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_Result_2_1,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_Q,
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_Mcount_binary_count_xor_2_11 : X_LUT6
    generic map(
      LOC => "SLICE_X13Y61",
      INIT => X"55AAFF0055AAFF00"
    )
    port map (
      ADR2 => '1',
      ADR1 => '1',
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0_Q,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_Q,
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      ADR5 => '1',
      O => Inst_DvidGen_dvid_ser_out_fifo_Result_2_1
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_Mcount_binary_count_xor_3_11 : X_LUT5
    generic map(
      LOC => "SLICE_X13Y61",
      INIT => X"66CCCCCC"
    )
    port map (
      ADR2 => '1',
      ADR1 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_Q,
      ADR0 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0_Q,
      ADR3 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_Q,
      ADR4 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => Inst_DvidGen_dvid_ser_out_fifo_Result_3_1
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3 : X_SFF
    generic map(
      LOC => "SLICE_X13Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_Result_3_1,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_pack_3,
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0 : X_SFF
    generic map(
      LOC => "SLICE_X13Y61",
      INIT => '0'
    )
    port map (
      CE => Inst_DvidGen_dvid_ser_out_fifo_next_read_address_en,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0_CLK,
      I => Inst_DvidGen_dvid_ser_out_fifo_Result_0_1,
      O => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0_Q,
      SRST => GND,
      SET => GND,
      RST => GND,
      SSET => GND
    );
  Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_Mcount_binary_count_xor_0_11_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X13Y61",
      INIT => X"00000000FFFFFFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR5 => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0_Q,
      ADR4 => '1',
      ADR3 => '1',
      O => Inst_DvidGen_dvid_ser_out_fifo_Result_0_1
    );
  renderer_hpos_latched_3_renderer_hpos_latched_3_CMUX_Delay : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_use_foreground_color,
      O => renderer_use_foreground_color_0
    );
  renderer_Mmux_use_foreground_color_2_f7 : X_MUX2
    generic map(
      LOC => "SLICE_X16Y36"
    )
    port map (
      IA => renderer_Mmux_use_foreground_color_4_2417,
      IB => renderer_Mmux_use_foreground_color_3_2426,
      O => renderer_use_foreground_color,
      SEL => renderer_hpos_latched_3_inv
    );
  renderer_Mmux_use_foreground_color_4 : X_LUT6
    generic map(
      LOC => "SLICE_X16Y36",
      INIT => X"F7B3E6A2D591C480"
    )
    port map (
      ADR0 => count32(2),
      ADR1 => count32(1),
      ADR5 => renderer_glyph_row(1),
      ADR2 => renderer_glyph_row(0),
      ADR3 => renderer_glyph_row(2),
      ADR4 => renderer_glyph_row(3),
      O => renderer_Mmux_use_foreground_color_4_2417
    );
  renderer_Mmux_use_foreground_color_3 : X_LUT6
    generic map(
      LOC => "SLICE_X16Y36",
      INIT => X"DDFA88FADD508850"
    )
    port map (
      ADR0 => count32(2),
      ADR3 => count32(1),
      ADR5 => renderer_glyph_row(5),
      ADR1 => renderer_glyph_row(4),
      ADR4 => renderer_glyph_row(6),
      ADR2 => renderer_glyph_row(7),
      O => renderer_Mmux_use_foreground_color_3_2426
    );
  renderer_hpos_latched_3 : X_FF
    generic map(
      LOC => "SLICE_X16Y36",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_renderer_hpos_latched_3_CLK,
      I => NlwBufferSignal_renderer_hpos_latched_3_IN,
      O => renderer_hpos_latched(3),
      RST => GND,
      SET => GND
    );
  renderer_hpos_latched_3_inv1_INV_0 : X_LUT6
    generic map(
      LOC => "SLICE_X16Y36",
      INIT => X"00000000FFFFFFFF"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR5 => renderer_hpos_latched(3),
      ADR4 => '1',
      ADR3 => '1',
      O => renderer_hpos_latched_3_inv
    );
  Inst_DvidGen_dvid_ser_ser_in_clock_4 : X_FF
    generic map(
      LOC => "SLICE_X25Y68",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_clock_4_CLK,
      I => Inst_DvidGen_dvid_ser_ser_in_clock_4_rstpot_2439,
      O => Inst_DvidGen_dvid_ser_ser_in_clock(4),
      RST => GND,
      SET => GND
    );
  Inst_DvidGen_dvid_ser_ser_in_clock_4_rstpot : X_LUT6
    generic map(
      LOC => "SLICE_X25Y68",
      INIT => X"FF00FF00FFFF0000"
    )
    port map (
      ADR0 => '1',
      ADR1 => '1',
      ADR2 => '1',
      ADR3 => Inst_DvidGen_dvid_ser_ser_in_clock(4),
      ADR5 => Inst_DvidGen_dvid_ser_out_fifo_empty_out_2848,
      ADR4 => Inst_DvidGen_dvid_ser_rd_enable_2504,
      O => Inst_DvidGen_dvid_ser_ser_in_clock_4_rstpot_2439
    );
  LEDs_7 : X_FF
    generic map(
      LOC => "SLICE_X28Y15",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_LEDs_7_CLK,
      I => NlwBufferSignal_LEDs_7_IN,
      O => LEDs_7_2765,
      RST => GND,
      SET => GND
    );
  LEDs_6 : X_FF
    generic map(
      LOC => "SLICE_X28Y15",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_LEDs_6_CLK,
      I => NlwBufferSignal_LEDs_6_IN,
      O => LEDs_6_2764,
      RST => GND,
      SET => GND
    );
  LEDs_5 : X_FF
    generic map(
      LOC => "SLICE_X28Y15",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_LEDs_5_CLK,
      I => NlwBufferSignal_LEDs_5_IN,
      O => LEDs_5_2763,
      RST => GND,
      SET => GND
    );
  LEDs_4 : X_FF
    generic map(
      LOC => "SLICE_X28Y15",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_LEDs_4_CLK,
      I => NlwBufferSignal_LEDs_4_IN,
      O => LEDs_4_2762,
      RST => GND,
      SET => GND
    );
  LEDs_3 : X_FF
    generic map(
      LOC => "SLICE_X35Y12",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_LEDs_3_CLK,
      I => NlwBufferSignal_LEDs_3_IN,
      O => LEDs_3_2761,
      RST => GND,
      SET => GND
    );
  LEDs_2 : X_FF
    generic map(
      LOC => "SLICE_X35Y12",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_LEDs_2_CLK,
      I => NlwBufferSignal_LEDs_2_IN,
      O => LEDs_2_2760,
      RST => GND,
      SET => GND
    );
  LEDs_1 : X_FF
    generic map(
      LOC => "SLICE_X35Y12",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_LEDs_1_CLK,
      I => NlwBufferSignal_LEDs_1_IN,
      O => LEDs_1_2759,
      RST => GND,
      SET => GND
    );
  LEDs_0 : X_FF
    generic map(
      LOC => "SLICE_X35Y12",
      INIT => '0'
    )
    port map (
      CE => VCC,
      CLK => NlwBufferSignal_LEDs_0_CLK,
      I => NlwBufferSignal_LEDs_0_IN,
      O => LEDs_0_2758,
      RST => GND,
      SET => GND
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_10_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(6),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(10)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_11_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(7),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(11)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_12_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(8),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(12)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_13_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(9),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(13)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_2_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(4),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(2)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_3_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(5),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(3)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_4_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(6),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(4)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_5_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(7),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(5)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_6_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(8),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(6)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_7_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(9),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(7)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_8_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(10),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(8)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_ADDRB_9_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(5),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_ADDRB(9)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM1_CLKB : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM1_CLKB
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_10_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(6),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(10)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_11_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(7),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(11)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_12_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(8),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(12)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_13_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(9),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(13)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_2_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(4),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(2)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_3_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(5),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(3)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_4_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(6),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(4)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_5_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(7),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(5)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_6_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(8),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(6)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_7_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(9),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(7)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_8_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(10),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(8)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_ADDRB_9_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(5),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_ADDRB(9)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM2_CLKB : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM2_CLKB
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_10_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(6),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(10)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_11_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(7),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(11)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_12_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(8),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(12)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_13_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(9),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(13)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_2_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(4),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(2)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_3_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(5),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(3)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_4_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(6),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(4)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_5_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(7),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(5)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_6_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(8),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(6)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_7_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(9),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(7)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_8_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(10),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(8)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_ADDRB_9_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(5),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_ADDRB(9)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM3_CLKB : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM3_CLKB
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_10_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(6),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(10)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_11_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(7),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(11)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_12_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(8),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(12)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_13_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(9),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(13)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_2_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(4),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(2)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_3_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(5),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(3)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_4_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(6),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(4)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_5_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(7),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(5)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_6_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(8),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(6)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_7_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(9),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(7)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_8_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(10),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(8)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_ADDRB_9_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(5),
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_ADDRB(9)
    );
  NlwBufferBlock_renderer_text_buffer_Mram_RAM4_CLKB : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_renderer_text_buffer_Mram_RAM4_CLKB
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_10_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(4),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(10)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_11_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(5),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(11)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_12_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(6),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(12)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_13_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(7),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(13)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_2_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_count(1),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(2)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_3_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_count(2),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(3)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_4_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_count(3),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(4)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_5_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_count(4),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(5)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_6_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(0),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(6)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_7_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(1),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(7)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_8_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(2),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(8)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_ADDRA_9_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(3),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_ADDRA(9)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom1_CLKA : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_rom_Mram_rom1_INV_renderer_character_rom_Mram_rom1CLKA,
      O => NlwBufferSignal_renderer_character_rom_Mram_rom1_CLKA
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_10_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(4),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(10)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_11_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(5),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(11)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_12_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(6),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(12)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_13_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(7),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(13)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_2_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_count(1),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(2)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_3_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_count(2),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(3)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_4_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_count(3),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(4)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_5_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_count(4),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(5)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_6_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(0),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(6)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_7_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(1),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(7)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_8_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(2),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(8)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_ADDRA_9_Q : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_data(3),
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_ADDRA(9)
    );
  NlwBufferBlock_renderer_character_rom_Mram_rom2_CLKA : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => renderer_character_rom_Mram_rom2_INV_renderer_character_rom_Mram_rom2CLKA,
      O => NlwBufferSignal_renderer_character_rom_Mram_rom2_CLKA
    );
  NlwBufferBlock_count50_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_3_CLK
    );
  NlwBufferBlock_count50_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_2_CLK
    );
  NlwBufferBlock_count50_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_1_CLK
    );
  NlwBufferBlock_count50_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_0_CLK
    );
  NlwBufferBlock_count50_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_7_CLK
    );
  NlwBufferBlock_count50_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_6_CLK
    );
  NlwBufferBlock_count50_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_5_CLK
    );
  NlwBufferBlock_count50_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_4_CLK
    );
  NlwBufferBlock_count50_11_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_11_CLK
    );
  NlwBufferBlock_count50_10_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_10_CLK
    );
  NlwBufferBlock_count50_9_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_9_CLK
    );
  NlwBufferBlock_count50_8_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_8_CLK
    );
  NlwBufferBlock_count50_15_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_15_CLK
    );
  NlwBufferBlock_count50_14_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_14_CLK
    );
  NlwBufferBlock_count50_13_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_13_CLK
    );
  NlwBufferBlock_count50_12_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_12_CLK
    );
  NlwBufferBlock_count50_19_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_19_CLK
    );
  NlwBufferBlock_count50_18_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_18_CLK
    );
  NlwBufferBlock_count50_17_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_17_CLK
    );
  NlwBufferBlock_count50_16_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_16_CLK
    );
  NlwBufferBlock_count50_23_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_23_CLK
    );
  NlwBufferBlock_count50_22_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_22_CLK
    );
  NlwBufferBlock_count50_21_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_21_CLK
    );
  NlwBufferBlock_count50_20_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_20_CLK
    );
  NlwBufferBlock_count50_25_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_25_CLK
    );
  NlwBufferBlock_count50_24_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_count50_24_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_11_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_11_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_10_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_10_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_8_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_8_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_next_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_next_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_next_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_next_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_next_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_next_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_next_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_next_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_next_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_next_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_next_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_next_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_next_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_next_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_next_10_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_next_10_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_next_9_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_next_9_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_next_8_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_next_8_CLK
    );
  NlwBufferBlock_count32_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_3_CLK
    );
  NlwBufferBlock_count32_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_2_CLK
    );
  NlwBufferBlock_count32_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_1_CLK
    );
  NlwBufferBlock_count32_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_0_CLK
    );
  NlwBufferBlock_count32_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_7_CLK
    );
  NlwBufferBlock_count32_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_6_CLK
    );
  NlwBufferBlock_count32_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_5_CLK
    );
  NlwBufferBlock_count32_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_4_CLK
    );
  NlwBufferBlock_count32_11_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_11_CLK
    );
  NlwBufferBlock_count32_10_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_10_CLK
    );
  NlwBufferBlock_count32_9_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_9_CLK
    );
  NlwBufferBlock_count32_8_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_8_CLK
    );
  NlwBufferBlock_count32_15_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_15_CLK
    );
  NlwBufferBlock_count32_14_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_14_CLK
    );
  NlwBufferBlock_count32_13_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_13_CLK
    );
  NlwBufferBlock_count32_12_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_12_CLK
    );
  NlwBufferBlock_count32_19_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_19_CLK
    );
  NlwBufferBlock_count32_18_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_18_CLK
    );
  NlwBufferBlock_count32_17_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_17_CLK
    );
  NlwBufferBlock_count32_16_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_16_CLK
    );
  NlwBufferBlock_count32_23_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_23_CLK
    );
  NlwBufferBlock_count32_22_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_22_CLK
    );
  NlwBufferBlock_count32_21_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_21_CLK
    );
  NlwBufferBlock_count32_20_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_20_CLK
    );
  NlwBufferBlock_count32_25_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_25_CLK
    );
  NlwBufferBlock_count32_24_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_count32_24_CLK
    );
  NlwBufferBlock_Inst_DvidGen_OBUFDS_blue_OBUFDS_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_tmds_out_blue,
      O => NlwBufferSignal_Inst_DvidGen_OBUFDS_blue_OBUFDS_I
    );
  NlwBufferBlock_Inst_DvidGen_OBUFDS_green_OBUFDS_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_tmds_out_green,
      O => NlwBufferSignal_Inst_DvidGen_OBUFDS_green_OBUFDS_I
    );
  NlwBufferBlock_Inst_DvidGen_OBUFDS_red_OBUFDS_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_tmds_out_red,
      O => NlwBufferSignal_Inst_DvidGen_OBUFDS_red_OBUFDS_I
    );
  NlwBufferBlock_Inst_DvidGen_OBUFDS_clock_OBUFDS_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_tmds_out_clock,
      O => NlwBufferSignal_Inst_DvidGen_OBUFDS_clock_OBUFDS_I
    );
  NlwBufferBlock_LEDs_0_OBUF_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => LEDs_0_2758,
      O => NlwBufferSignal_LEDs_0_OBUF_I
    );
  NlwBufferBlock_LEDs_1_OBUF_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => LEDs_1_2759,
      O => NlwBufferSignal_LEDs_1_OBUF_I
    );
  NlwBufferBlock_LEDs_2_OBUF_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => LEDs_2_2760,
      O => NlwBufferSignal_LEDs_2_OBUF_I
    );
  NlwBufferBlock_LEDs_3_OBUF_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => LEDs_3_2761,
      O => NlwBufferSignal_LEDs_3_OBUF_I
    );
  NlwBufferBlock_LEDs_4_OBUF_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => LEDs_4_2762,
      O => NlwBufferSignal_LEDs_4_OBUF_I
    );
  NlwBufferBlock_LEDs_5_OBUF_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => LEDs_5_2763,
      O => NlwBufferSignal_LEDs_5_OBUF_I
    );
  NlwBufferBlock_LEDs_6_OBUF_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => LEDs_6_2764,
      O => NlwBufferSignal_LEDs_6_OBUF_I
    );
  NlwBufferBlock_LEDs_7_OBUF_I : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => LEDs_7_2765,
      O => NlwBufferSignal_LEDs_7_OBUF_I
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_CLKDIV : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_CLKDIV
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_D1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_blue_4_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_master_D1
    );
  NlwBufferBlock_Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKIN2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_clocking_clk32m_buffered,
      O => NlwBufferSignal_Inst_clocking_PLL_BASE_32m_to_25p6m_PLL_ADV_CLKIN2
    );
  NlwBufferBlock_Inst_clocking_BUFG_clk25p6m_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_clocking_clk25p6m_unbuffered,
      O => NlwBufferSignal_Inst_clocking_BUFG_clk25p6m_IN
    );
  NlwBufferBlock_Clk50_BUFGP_BUFG_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP_IBUFG_0,
      O => NlwBufferSignal_Clk50_BUFGP_BUFG_IN
    );
  NlwBufferBlock_Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKIN2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_clocking_clk25p6m_buffered,
      O => NlwBufferSignal_Inst_clocking_PLL_BASE_inst_PLL_ADV_CLKIN2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_blue(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_blue_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_CLKDIV : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_CLKDIV
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_blue(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D4 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_blue(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_b_OSERDES2_slave_D4
    );
  NlwBufferBlock_Inst_clocking_BUFG_pclockx2_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_clocking_clock_x2_unbuffered,
      O => NlwBufferSignal_Inst_clocking_BUFG_pclockx2_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_CLKDIV : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_CLKDIV
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_D1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_clock(4),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_master_D1
    );
  NlwBufferBlock_Inst_clocking_BUFPLL_inst_PLLIN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_clocking_clock_x10_unbuffered,
      O => NlwBufferSignal_Inst_clocking_BUFPLL_inst_PLLIN
    );
  NlwBufferBlock_Inst_clocking_BUFPLL_inst_GCLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_clocking_BUFPLL_inst_GCLK
    );
  NlwBufferBlock_Inst_clocking_BUFPLL_inst_LOCKED : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_clocking_pll_s2_locked,
      O => NlwBufferSignal_Inst_clocking_BUFPLL_inst_LOCKED
    );
  NlwBufferBlock_Inst_clocking_BUFG_clk32m_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk32_IBUFG_0,
      O => NlwBufferSignal_Inst_clocking_BUFG_clk32m_IN
    );
  NlwBufferBlock_Inst_clocking_BUFG_pclock_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_clocking_clock_x1_unbuffered,
      O => NlwBufferSignal_Inst_clocking_BUFG_pclock_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_CLKDIV : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_CLKDIV
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_D1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_green_4_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_master_D1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_clock(4),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_clock(4),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_CLKDIV : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_CLKDIV
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_clock(4),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D4 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_clock(4),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_c_OSERDES2_slave_D4
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_CLKDIV : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_CLKDIV
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_D1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_red_4_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_master_D1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_green(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_green_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_CLKDIV : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_CLKDIV
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_green(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D4 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_green(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_g_OSERDES2_slave_D4
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_red(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_red_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_CLKDIV : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_CLKDIV
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_red_0_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D4 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_ser_in_red(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_output_serializer_r_OSERDES2_slave_D4
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_red_level_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_red_level_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_red_level_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_red_level_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_green_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_green_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_green_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_green_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_green_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_green_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_red_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_8_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_8_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_9_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_9_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMD_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_1_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_1_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMC_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_9_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_8_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMB_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_7_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_6_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem2_RAMA_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_7_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(7),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_7_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_6_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_6_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_6_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_5_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(5),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_5_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_4_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_4_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_4_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMD_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_7_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_6_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMC_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_5_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_4_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMB_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_3_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_6_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem3_RAMA_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMD_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_9_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMC_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_7_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_6_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMB_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_5_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_4_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem5_RAMA_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMD_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_3_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_6_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMC_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_1_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_1_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMB_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_9_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_8_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem4_RAMA_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_23_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_23_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_23_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(23),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_23_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_22_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_22_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_22_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_22_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_22_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_21_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_21_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_21_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(21),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_21_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_20_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_20_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_20_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_20_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_20_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_29_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_29_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_29_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(29),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_29_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_28_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_28_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_28_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_28_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_28_IN
    );
  NlwBufferBlock_Inst_DvidGen_red_level_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_red_level_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_red_level_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_red_level_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_dc_bias_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_Encoded_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_blue_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_blue_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_blue_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_blue_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_blue_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_blue_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_11_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_11_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_11_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(11),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_11_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_10_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_10_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_10_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_10_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_10_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_9_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_9_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_9_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(9),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_9_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_8_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_8_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_8_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_8_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_8_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_8_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_9_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_9_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_red_Encoded_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(19),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_19_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_27_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_27_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_18_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_18_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_18_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_18_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_18_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_26_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_26_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_17_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_17_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_17_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(17),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_17_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_25_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_25_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_16_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_16_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_16_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_16_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_16_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_24_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_24_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_15_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_15_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_15_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(15),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_15_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_14_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_14_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_14_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_14_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_14_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_13_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_13_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_13_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(13),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_13_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_12_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_12_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_12_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_12_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_12_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_red_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_red_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_red_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_red_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_red_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_rd_enable_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_rd_enable_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_green_level_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_green_level_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_blue_level_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_blue_level_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_green_level_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_green_level_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_8_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_8_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_3_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount_3_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_binary_count_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_empty_out_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_empty_out_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_blue_level_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_blue_level_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_green_level_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_green_level_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_blue_level_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_blue_level_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_green_level_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_green_level_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_blue_level_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_blue_level_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_green_dc_bias_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_full_out_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_full_out_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_9_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_9_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_next_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_next_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMD_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_5_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_4_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMC_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_3_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_6_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMB_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_1_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_D1_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_RADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_1_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR0 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(0),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR0
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR1 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR1
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR2 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(2),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR2
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR3 : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pWr_GrayCount(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_Mram_mem1_RAMA_WADR3
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_3_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(3),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_3_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_2_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_2_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_2_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035(1),
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_1_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_DataOut_0_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_n0035_0_0,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_DataOut_0_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_going_full_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_going_full_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_7_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(7),
      O => NlwBufferSignal_Inst_DvidGen_v_count_7_IN
    );
  NlwBufferBlock_Inst_DvidGen_v_count_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_6_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(6),
      O => NlwBufferSignal_Inst_DvidGen_v_count_6_IN
    );
  NlwBufferBlock_Inst_DvidGen_v_count_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_5_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(5),
      O => NlwBufferSignal_Inst_DvidGen_v_count_5_IN
    );
  NlwBufferBlock_Inst_DvidGen_v_count_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_4_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(4),
      O => NlwBufferSignal_Inst_DvidGen_v_count_4_IN
    );
  NlwBufferBlock_Inst_DvidGen_blank_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_blank_CLK
    );
  NlwBufferBlock_Inst_DvidGen_vsync_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_vsync_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_9_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_9_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_Encoded_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_going_empty_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_going_empty_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_11_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_11_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_11_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(11),
      O => NlwBufferSignal_Inst_DvidGen_v_count_11_IN
    );
  NlwBufferBlock_Inst_DvidGen_v_count_10_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_10_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_10_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(10),
      O => NlwBufferSignal_Inst_DvidGen_v_count_10_IN
    );
  NlwBufferBlock_Inst_DvidGen_v_count_9_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_9_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_9_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(9),
      O => NlwBufferSignal_Inst_DvidGen_v_count_9_IN
    );
  NlwBufferBlock_Inst_DvidGen_v_count_8_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_8_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_8_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(8),
      O => NlwBufferSignal_Inst_DvidGen_v_count_8_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_TMDS_encoder_blue_dc_bias_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_Q,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_3_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_GrayCount_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_count_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_count_7_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_count_7_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(7),
      O => NlwBufferSignal_Inst_DvidGen_h_count_7_IN
    );
  NlwBufferBlock_Inst_DvidGen_h_count_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_count_6_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_count_6_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(6),
      O => NlwBufferSignal_Inst_DvidGen_h_count_6_IN
    );
  NlwBufferBlock_Inst_DvidGen_h_count_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_count_5_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_count_5_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(5),
      O => NlwBufferSignal_Inst_DvidGen_h_count_5_IN
    );
  NlwBufferBlock_Inst_DvidGen_h_count_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_count_4_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_count_4_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(4),
      O => NlwBufferSignal_Inst_DvidGen_h_count_4_IN
    );
  NlwBufferBlock_Inst_DvidGen_v_count_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_3_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(3),
      O => NlwBufferSignal_Inst_DvidGen_v_count_3_IN
    );
  NlwBufferBlock_Inst_DvidGen_v_count_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_2_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(2),
      O => NlwBufferSignal_Inst_DvidGen_v_count_2_IN
    );
  NlwBufferBlock_Inst_DvidGen_v_count_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_1_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(1),
      O => NlwBufferSignal_Inst_DvidGen_v_count_1_IN
    );
  NlwBufferBlock_Inst_DvidGen_v_count_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_v_count_0_CLK
    );
  NlwBufferBlock_Inst_DvidGen_v_count_0_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_v_next(0),
      O => NlwBufferSignal_Inst_DvidGen_v_count_0_IN
    );
  NlwBufferBlock_Inst_DvidGen_hsync_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_hsync_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_count_10_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_count_10_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_count_9_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_count_9_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_count_9_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(9),
      O => NlwBufferSignal_Inst_DvidGen_h_count_9_IN
    );
  NlwBufferBlock_Inst_DvidGen_h_count_8_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_h_count_8_CLK
    );
  NlwBufferBlock_Inst_DvidGen_h_count_8_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(8),
      O => NlwBufferSignal_Inst_DvidGen_h_count_8_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_2_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_3_CLK
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_out_fifo_GrayCounter_pRd_binary_count_0_CLK
    );
  NlwBufferBlock_renderer_hpos_latched_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_renderer_hpos_latched_3_CLK
    );
  NlwBufferBlock_renderer_hpos_latched_3_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Inst_DvidGen_h_next(3),
      O => NlwBufferSignal_renderer_hpos_latched_3_IN
    );
  NlwBufferBlock_Inst_DvidGen_dvid_ser_ser_in_clock_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => data_load_clock_t,
      O => NlwBufferSignal_Inst_DvidGen_dvid_ser_ser_in_clock_4_CLK
    );
  NlwBufferBlock_LEDs_7_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_LEDs_7_CLK
    );
  NlwBufferBlock_LEDs_7_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => count32(25),
      O => NlwBufferSignal_LEDs_7_IN
    );
  NlwBufferBlock_LEDs_6_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_LEDs_6_CLK
    );
  NlwBufferBlock_LEDs_6_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => count32(24),
      O => NlwBufferSignal_LEDs_6_IN
    );
  NlwBufferBlock_LEDs_5_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_LEDs_5_CLK
    );
  NlwBufferBlock_LEDs_5_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => count32(23),
      O => NlwBufferSignal_LEDs_5_IN
    );
  NlwBufferBlock_LEDs_4_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => pixel_clock_t,
      O => NlwBufferSignal_LEDs_4_CLK
    );
  NlwBufferBlock_LEDs_4_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => count32(22),
      O => NlwBufferSignal_LEDs_4_IN
    );
  NlwBufferBlock_LEDs_3_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_LEDs_3_CLK
    );
  NlwBufferBlock_LEDs_3_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => count50(25),
      O => NlwBufferSignal_LEDs_3_IN
    );
  NlwBufferBlock_LEDs_2_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_LEDs_2_CLK
    );
  NlwBufferBlock_LEDs_2_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => count50(24),
      O => NlwBufferSignal_LEDs_2_IN
    );
  NlwBufferBlock_LEDs_1_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_LEDs_1_CLK
    );
  NlwBufferBlock_LEDs_1_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => count50(23),
      O => NlwBufferSignal_LEDs_1_IN
    );
  NlwBufferBlock_LEDs_0_CLK : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => Clk50_BUFGP,
      O => NlwBufferSignal_LEDs_0_CLK
    );
  NlwBufferBlock_LEDs_0_IN : X_BUF
    generic map(
      PATHPULSE => 115 ps
    )
    port map (
      I => count50(22),
      O => NlwBufferSignal_LEDs_0_IN
    );
  NlwBlock_reclone_top_VCC : X_ONE
    port map (
      O => VCC
    );
  NlwBlock_reclone_top_GND : X_ZERO
    port map (
      O => GND
    );
  NlwBlockROC : X_ROC
    generic map (ROC_WIDTH => 100 ns)
    port map (O => GSR);
  NlwBlockTOC : X_TOC
    port map (O => GTS);

end Structure;

