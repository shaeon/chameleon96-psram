# sta_divclk.tcl -- report the divclk (200 MHz fabric) domain only.
# The psram_clk virtual clock + loan-path pad delays carry a known pessimistic
# output-delay artifact (FINDINGS 23f) and are out of scope here.

package require ::quartus::sta

project_open psram_qspi_test_chip2
create_timing_netlist
read_sdc
update_timing_netlist

puts "\n=== Clocks ==="
foreach_in_collection clk [get_clocks] {
    puts "  Clock: [get_object_info -name $clk]"
}

puts "\n=== divclk->divclk (200 MHz fabric) setup ==="
report_timing -to_clock [get_clocks [list *generic_pll1*PLL_OUTPUT_COUNTER*]] -from_clock [get_clocks [list *generic_pll1*PLL_OUTPUT_COUNTER*]] \
    -setup -npaths 8 -detail full_path

puts "\n=== divclk->divclk (200 MHz fabric) hold ==="
report_timing -to_clock [get_clocks [list *generic_pll1*PLL_OUTPUT_COUNTER*]] -from_clock [get_clocks [list *generic_pll1*PLL_OUTPUT_COUNTER*]] \
    -hold -npaths 8 -detail full_path

project_close