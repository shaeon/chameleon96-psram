# ============================================================================
# loanio_sta.sdc -- PSRAM self-test build (144 MHz), CHIP 2 VARIANT.
#
# SCOPE, AND WHAT THIS FILE DELIBERATELY DOES NOT DO
# ----------------------------------------------------
# The PSRAM QSPI bus leaves the FPGA on loan I/O pads (J30): SIO0..3 =
# LOANIO29/27/53/30, CLK = LOANIO28, CE# = LOANIO23.
# (Chip 1's pads 17/19/33/34/54/48 are released in this build.)
#
# Those pads go through a LOAN primitive that exposes NO timing arcs to the
# fabric registers: there is no clock pin, no data-in arc, and no data-out arc
# on the `rnib` / `sio_in` side. That has two consequences, both of which are
# properties of the loan architecture and not something an SDC file can fix:
#
#   * create_generated_clock at the PSRAM sclk pad is rejected (no clock arc
#     to attach it to). The PSRAM pad clock therefore cannot exist as a real
#     clock in TimeQuest at all.
#   * set_input_delay / set_output_delay on the pad ports cannot be trusted to
#     produce a real constraint: with no arc to the capturing register, the
#     delay is either ignored or silently applied to nothing.
#
# The Qsys-generated HPS SDC false-paths the loan pads, which is the honest
# behaviour. This file therefore does NOT try to re-create the PSRAM interface
# timing through the pads. Writing a green-looking set_input_delay here would
# be worse than nothing: it would report a constraint that no physical path
# actually obeys, and would hide the real board-level question.
#
# What IS constrained here is the part TimeQuest can see and verify: the
# fabric-internal relationships on the 144 MHz domain.
#
# CLOCKS
# ------
#   refclk        h2f_user0 / clock_bridge_0_out_clk_1_clk = 100 MHz
#   pll96 outclk_0 = 144 MHz, 0 ps -> fabric clock AND the PSRAM sclk
#                                    (routed to LOANIO28)
#   pll96 outclk_1 = 144 MHz, -2951 ps -> GENERATED BUT NOT USED
#
# NOTE (corrected): an earlier revision of this file claimed the PSRAM sclk
# came from the phase-shifted outclk_1 and that the capture needed to lead the
# launch by ~2.9 ns to clear the APS6404L's tACLK. That was not what the
# design did. In the proven chip-1 build -- and in this chip-2 build -- the
# PSRAM sclk is outclk_0, the SAME net as the fabric clock: a single clock,
# no phase shift, data launched and captured on successive posedges of that
# one clock. pll96 still generates outclk_1, but nothing consumes it.
#
# This file's header used to describe a two-clock scheme that only ever
# existed in tb144.sv (the simulation testbench) and in a stale comment in
# psram_qspi_test.sv. The hardware build never used it, and the chip-1
# self-test passes single-clocked at 144 MHz. The comment is corrected here so
# that the next reader is not misled into "fixing" a non-problem.
#
# derive_pll_clocks creates BOTH PLL outputs as real clocks WITH their phase
# relationship intact. Only outclk_0 reaches fabric logic and the PSRAM pad;
# outclk_1 reaches nothing.
#
# The nibble DATA still never crosses between the two PLL domains: it is
# sampled by the fabric clock directly from the pad, and the pad itself is not
# timed (see header). The PSRAM eye remains a board measurement.
# ============================================================================

# Both PLL outputs as real, phase-related clocks (outclk_0, outclk_1).
derive_pll_clocks

# Loan pads are not timed: no clock arc, no data arcs. See header.
# The real PSRAM read/write eye must be measured on the board, with a scope on
# sclk and one SIO lane.
