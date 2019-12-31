
set(USER_CONSTRAINTS_FILE ${CMAKE_CURRENT_LIST_DIR}/reclone-rise.ucf)
set(TARGET_PART "xc6slx16-2-ftg256")

# ISE tool options
set(XST_OPTS "\
-opt_mode Speed
-opt_level 1
-power NO
-iuc NO
-keep_hierarchy No
-netlist_hierarchy As_Optimized
-rtlview Yes
-glob_opt AllClockNets
-read_cores YES
-write_timing_constraints NO
-cross_clock_analysis NO
-hierarchy_separator /
-bus_delimiter <>
-case Maintain
-slice_utilization_ratio 100
-bram_utilization_ratio 100
-dsp_utilization_ratio 100
-lc Auto
-reduce_control_sets Auto
-fsm_extract YES -fsm_encoding Auto
-safe_implementation No
-fsm_style LUT
-ram_extract Yes
-ram_style Auto
-rom_extract Yes
-shreg_extract YES
-rom_style Auto
-auto_bram_packing NO
-resource_sharing YES
-async_to_sync NO
-shreg_min_size 2
-use_dsp48 Auto
-iobuf YES
-max_fanout 100000
-bufg 16
-register_duplication YES
-register_balancing No
-optimize_primitives NO
-use_clock_enable Auto
-use_sync_set Auto
-use_sync_reset Auto
-iob Auto
-equivalent_register_removal YES
-slice_utilization_ratio_maxmargin 5
")
set(NGDBUILD_OPTS "-dd _ngo -nt timestamp")
set(MAP_OPTS "-logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt off -ir off -pr off -lc off -power off")
set(PAR_OPTS "-ol high -mt off")
set(BITGEN_OPTS "\
-g Binary:no
-g Compress
-g CRC:Enable
-g Reset_on_err:No
-g ConfigRate:2
-g ProgPin:PullUp
-g TckPin:PullUp
-g TdiPin:PullUp
-g TdoPin:PullUp
-g TmsPin:PullUp
-g UnusedPin:PullDown
-g UserID:0xFFFFFFFF
-g ExtMasterCclk_en:No
-g SPI_buswidth:1
-g TIMER_CFG:0xFFFF
-g multipin_wakeup:No
-g StartUpClk:CClk
-g DONE_cycle:4
-g GTS_cycle:5
-g GWE_cycle:6
-g LCK_cycle:NoWait
-g Security:None
-g DonePipe:Yes
-g DriveDone:Yes
-g en_sw_gsr:No
-g drive_awake:No
-g sw_clk:Startupclk
-g sw_gwe_cycle:5
-g sw_gts_cycle:4
")