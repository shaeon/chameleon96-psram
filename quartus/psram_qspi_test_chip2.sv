`default_nettype none

// QSPI PSRAM self-test top level -- CHIP 2 (U2) VARIANT.
//
// This is a clone of psram_qspi_test with ONE functional change: the six
// PSRAM loan-I/O indices are retargeted from chip 1 (U1) to chip 2 (U2).
// Everything else -- HPS Qsys component, handoff, PLL, psram controller,
// psram_test_ctrl, LED reporting -- is identical to the proven chip-1 build,
// so the only variable between the two RBFs is which physical PSRAM the
// fabric talks to.
//
// Boots the HPS (SDMMC/UART0/DDR3 + HPS IO), drives the APS6404L PSRAM on
// the J30 loan I/O pins through the psram controller, runs psram_test_ctrl
// (FILL / CHECK / ROW / BYTES self-test), and reports pass/fail on the four
// user LEDs. No HDMI/LCD logic.
//
// Clocking: h2f_user0 100 MHz feeds pll96; outclk_0 = 144 MHz fabric + PSRAM
// sclk (routed to LOANIO28). SINGLE clock, no phase shift -- the shifted
// outclk_1 that pll96 also generates is left unused, exactly as in the
// proven chip-1 build.
//
// PSRAM QSPI addon pin map, CHIP 2 (U2, bottom side of the addon):
//   SIO0 = LOANIO29, SIO1 = LOANIO27, SIO2 = LOANIO53, SIO3 = LOANIO30
//   CLK  = LOANIO28, CE#  = LOANIO23
//   R8 (10k) pulls CE# up to +1V8; C2 = 100 nF VCC decoupling.
//   Chip 1 (U1) pins 17/19/33/34/54/48 are released (Hi-Z) by this build.
//   LEDs: D5=14 (done), D6=22 (err), D7=25 (phase), D8=32 (heartbeat).

module psram_qspi_test_chip2(
    // MMC
    inout HPS_3V3_SDMMC_CMD,
    inout HPS_3V3_SDMMC_D0,
    inout HPS_3V3_SDMMC_D1,
    output HPS_3V3_SDMMC_CLK,
    inout HPS_3V3_SDMMC_D2,
    inout HPS_3V3_SDMMC_D3,

    // UART0
    input HPS_1V8_UART0_RX,
    output HPS_1V8_UART0_TX,

    // I2C0
    inout HPS_1V8_I2C0_SCL,
    inout HPS_1V8_I2C0_SDA,

    // I2C1
    inout HPS_1V8_I2C1_SCL,
    inout HPS_1V8_I2C1_SDA,

    // I2C3
    inout HPS_1V8_I2C3_SCL,
    inout HPS_1V8_I2C3_SDA,

    // SPI Master 0
    output HPS_1V8_SPIM0_CLK,
    output HPS_1V8_SPIM0_MOSI,
    input HPS_1V8_SPIM0_MISO,
    output HPS_1V8_SPIM0_SS0,

    // SPI Master 1
    output HPS_1V8_SPIM1_CLK,
    output HPS_1V8_SPIM1_MOSI,
    input HPS_1V8_SPIM1_MISO,
    output HPS_1V8_SPIM1_SS0,

    // USB
    inout HPS_3V3_USB1_D0,
    inout HPS_3V3_USB1_D1,
    inout HPS_3V3_USB1_D2,
    inout HPS_3V3_USB1_D3,
    inout HPS_3V3_USB1_D4,
    inout HPS_3V3_USB1_D5,
    inout HPS_3V3_USB1_D6,
    inout HPS_3V3_USB1_D7,
    input HPS_3V3_USB1_CLK,
    output HPS_3V3_USB1_STP,
    input HPS_3V3_USB1_DIR,
    input HPS_3V3_USB1_NXT,

    // LOAN IO and GPIO
    inout HPS_3V3_GPIO_GPIO00,
    inout HPS_3V3_GPIO_GPIO09,
    inout HPS_1V8_LOANIO14,  // LED D5
    inout HPS_1V8_LOANIO17,  // chip1 SIO2 (released)
    inout HPS_1V8_LOANIO19,  // chip1 SIO1 (released)
    inout HPS_1V8_LOANIO22,  // LED D6
    inout HPS_1V8_LOANIO23,  // chip2 PSRAM CE#
    inout HPS_1V8_LOANIO25,  // LED D7
    inout HPS_1V8_LOANIO27,  // chip2 PSRAM SIO1
    inout HPS_1V8_LOANIO28,  // chip2 PSRAM CLK
    inout HPS_1V8_LOANIO29,  // chip2 PSRAM SIO0
    inout HPS_1V8_LOANIO30,  // chip2 PSRAM SIO3
    inout HPS_1V8_LOANIO32,  // LED D8
    inout HPS_1V8_LOANIO33,  // chip1 SIO0 (released)
    inout HPS_1V8_LOANIO34,  // chip1 SIO3 (released)
    inout HPS_3V3_GPIO_GPIO44,
    inout HPS_1V8_LOANIO48,  // chip1 CE# (released)
    inout HPS_1V8_LOANIO53,  // chip2 PSRAM SIO2
    inout HPS_1V8_LOANIO54,  // chip1 CLK (released)

    // DDR3
    output [14:0] HPS_SDRAM_MA,
    output [2:0] HPS_SDRAM_BA,
    output HPS_SDRAM_CLK_P,
    output HPS_SDRAM_CLK_N,
    output HPS_SDRAM_nMCKE,
    output HPS_SDRAM_nMCS,
    output HPS_SDRAM_nRAS,
    output HPS_SDRAM_nCAS,
    output HPS_SDRAM_nMWE,
    output HPS_SDRAM_nRESET,
    inout [15:0] HPS_SDRAM_DQ,
    inout [1:0] HPS_SDRAM_DQS_P,
    inout [1:0] HPS_SDRAM_DQS_N,
    output HPS_SDRAM_MODT,
    output [1:0] HPS_SDRAM_MDM,
    input HPS_SDRAM_RZQ
);

wire clk_100m;      // h2f_user0, 100 MHz (10 ns create_clock, HPS SDC)
wire clk_50m;       // h2f_user1, 50 MHz (unused here)
wire hps_reset;     // reset bridge, active high

wire pll_locked;

wire clk_144m;

pll96 u_pll (
    .refclk(clk_100m),
    .rst(hps_reset),
    .outclk_0(clk_144m),
    .locked(pll_locked)
);

wire rst_n_raw;
assign rst_n_raw = ~hps_reset & pll_locked;

// Reset synchronizer, now in the 144 MHz sclk domain. Two FFs deassert rst_n
// ~2 cycles after rst_n_raw goes high; no async clear is used, so there are no
// recovery/removal paths into the fabric (FINDINGS 25c lesson 3).
reg rst_s1 = 1'b0, rst_s2 = 1'b0;
always @(posedge clk_144m) begin
    rst_s1 <= rst_n_raw;
    rst_s2 <= rst_s1;
end
wire rst_n = rst_s2;

// ----------------------------------------------------------------------
// Loan I/O (66-bit fabric side of the loan mux)
// ----------------------------------------------------------------------
wire [66:0] loan_io_in;
wire [66:0] loan_io_out;
wire [66:0] loan_io_oe;

// psram_bridge <-> loan pins (CLK driven by PLL outclk_0, not the bridge)
wire        ps_ce_n;
wire [3:0]  ps_sio_out;
wire [3:0]  ps_sio_oe;
wire [3:0]  ps_sio_in;

// SIO pin map (sio[n] -> loan bit): 0:29, 1:27, 2:53, 3:30
assign loan_io_out[29] = ps_sio_out[0];
assign loan_io_out[27] = ps_sio_out[1];
assign loan_io_out[53] = ps_sio_out[2];
assign loan_io_out[30] = ps_sio_out[3];

assign loan_io_oe[29] = ps_sio_oe[0];
assign loan_io_oe[27] = ps_sio_oe[1];
assign loan_io_oe[53] = ps_sio_oe[2];
assign loan_io_oe[30] = ps_sio_oe[3];

assign ps_sio_in[0] = loan_io_in[29];
assign ps_sio_in[1] = loan_io_in[27];
assign ps_sio_in[2] = loan_io_in[53];
assign ps_sio_in[3] = loan_io_in[30];

// Control pins: CLK (28) = PLL outclk_0, CE# (23) driven by the bridge.
// PSRAM sclk pin. Driven from the same pll output the FSM runs on -- see the
// PLL note above. Single clock, no phase shift: this is what the proven
// chip-1 build did, and it works.
assign loan_io_out[28] = clk_144m;
assign loan_io_oe[28]  = 1'b1;
assign loan_io_out[23] = ps_ce_n;
assign loan_io_oe[23]  = 1'b1;

// ----------------------------------------------------------------------
// Chip 1 (U1) pins are NOT driven by this build.
// ----------------------------------------------------------------------
// The chip-2 twin leaves the chip-1 loan pins released (output enable low ->
// pad is Hi-Z). Chip 1's CE# has a 10k pull-up to +1V8 on the addon (R7), so
// chip 1 stays deselected for the whole run and cannot disturb the chip-2
// measurement. Chip 1's CLK is stopped too, so chip 1 is fully idle.
//
// Note on the remaining loan bits: every loan bit that neither build drives
// is left undriven ('z') in BOTH builds, exactly as in the proven chip-1
// rig. Only the six chip-1 pins that the rig used to drive are given an
// explicit release here, because they would otherwise become undriven in
// this build. Keeping the rest 'z' is deliberate: it keeps this build
// identical to the proven one in every respect except the six pin indices.
assign loan_io_out[17] = 1'b0;   // chip1 SIO2
assign loan_io_oe[17]  = 1'b0;
assign loan_io_out[19] = 1'b0;   // chip1 SIO1
assign loan_io_oe[19]  = 1'b0;
assign loan_io_out[33] = 1'b0;   // chip1 SIO0
assign loan_io_oe[33]  = 1'b0;
assign loan_io_out[34] = 1'b0;   // chip1 SIO3
assign loan_io_oe[34]  = 1'b0;
assign loan_io_out[54] = 1'b0;   // chip1 CLK
assign loan_io_oe[54]  = 1'b0;
assign loan_io_out[48] = 1'b0;   // chip1 CE#
assign loan_io_oe[48]  = 1'b0;

// ----------------------------------------------------------------------
// LEDs (D5=14, D6=22, D7=25, D8=32)
//
// These four pins were previously driven with a bare `~pass/~done/~err/1`.
// That reporting scheme was ambiguous on real hardware: the board's LED
// polarity is not pinned down anywhere in this repo, and because all four
// outputs sit at 1'b1 during reset, the observed "3 lit, 1 dark" pattern
// could mean a pass, a fail, or a dead design depending on which way round
// the polarity is. D8 in particular was hardwired dark and carried no
// information.
//
// They now run a power-up self-test that makes both unknowns observable,
// then hold a steady 4-bit code of the controller FSM state.
// ----------------------------------------------------------------------

// Self-test: 6 steps of ~200 ms at 144 MHz, stepped by a free-running counter.
localparam integer LED_STEP = 28_800_000;   // 200 ms @ 144 MHz
reg [27:0] led_t = 28'd0;
reg [2:0]  led_step = 3'd7;                // 7 = "still in self-test/not yet running"
reg        selftest_done = 1'b0;
always @(posedge clk_144m) begin
    if (!rst_n) begin
        led_t <= 28'd0; led_step <= 3'd7; selftest_done <= 1'b0;
    end else if (!selftest_done) begin
        if (led_t == LED_STEP[27:0] - 1) begin
            led_t <= 28'd0;
            led_step <= led_step + 3'd1;   // 0,1,2,3,4,5 then 6 => exit
            if (led_step == 3'd5) selftest_done <= 1'b1;
        end else begin
            led_t <= led_t + 28'd1;
        end
    end
end

// Self-test pattern, one-hot over {D8,D7,D6,D5}:
wire [3:0] led_selftest =
      (led_step == 3'd0) ? 4'b0000  // all driven 1
    : (led_step == 3'd1) ? 4'b1111  // all driven 0
    : (led_step == 3'd2) ? 4'b0001  // only D5 low
    : (led_step == 3'd3) ? 4'b0010  // only D6 low
    : (led_step == 3'd4) ? 4'b0100  // only D7 low
    :                        4'b1000; // only D8 low

// Steady state: a *latched, slow* snapshot.
//
// An earlier version drove dbg_st (the raw FSM state) straight onto the LEDs.
// That was a mistake: dbg_st spends most of its time in 1-cycle transit
// states like S_B2, so the display flickered continuously and any reading was
// essentially random. Only slowly-changing status is fit to be read by eye.
//
// Layout, D5 = bit0 .. D8 = bit3:
//   bit0  done       1 once the test has finished
//   bit1  errs!=0    1 if any mismatch was ever counted (sticky)
//   bit3:2 phase     0 FILL, 1 CHK, 2 ROW, 3 BYT
//
// This is latched once per second so it is readable, and it settles to the
// terminal phase (3 = BYT) with done=1 on a clean run.
localparam integer LED_LATCH = 144_000_000;  // 1 s @ 144 MHz
localparam integer LED_HB   = 144_000;      // 1 ms heartbeat @ 144 MHz
reg [27:0] latch_t = 28'd0;
reg [17:0] hb_t    = 18'd0;
reg [3:0]  led_code = 4'd7;                 // 0b0111 = "self-test finished, no data yet"
reg        led_frozen = 1'b0;               // stop changing once the test ends
always @(posedge clk_144m) begin
    if (!rst_n) begin
        latch_t <= 28'd0; hb_t <= 18'd0;
        led_code <= 4'd7;
        led_frozen <= 1'b0;
    end else begin
        // Free-running 1 ms heartbeat. Never gated, never frozen: if this
        // counter is not advancing the fabric is not running at all, and D8
        // flickering says so. This is what distinguishes "hung" from "done".
        if (hb_t == LED_HB[17:0] - 1) hb_t <= 18'd0;
        else                         hb_t <= hb_t + 18'd1;

        if (selftest_done) begin
            // Update on the 1 s tick, but snap to the terminal answer the moment
            // done rises and then hold it, so the result is there the instant the
            // test ends rather than up to a second later.
            if (c_done || led_frozen) begin
                led_code <= {dbg_ph[1], dbg_ph[0], (dbg_errs != 32'd0), c_done};
                led_frozen <= 1'b1;
            end else if (latch_t == LED_LATCH[27:0] - 1) begin
                latch_t <= 28'd0;
                led_code <= {dbg_ph[1], dbg_ph[0], (dbg_errs != 32'd0), c_done};
            end else begin
                latch_t <= latch_t + 28'd1;
            end
        end
    end
end

// D8 is the heartbeat, D5..D7 carry the latched status, so the status reading
// and the liveness proof do not fight over the same bits.
wire       led_hb     = hb_t[17];          // 1 kHz visible blink
wire [3:0] led_drive   = selftest_done ? {led_hb, led_code[2], led_code[1], led_code[0]}
                                       : led_selftest;

// NOTE on polarity: the previous code used `~pass` etc., i.e. it assumed an
// active-low LED. The self-test above deliberately drives all four pins high
// then all four low, so the board's actual polarity reveals itself on power-up
// without anyone needing to guess.
assign loan_io_out[14] = led_drive[0];   // D5
assign loan_io_oe[14]  = 1'b1;
assign loan_io_out[22] = led_drive[1];   // D6
assign loan_io_oe[22]  = 1'b1;
assign loan_io_out[25] = led_drive[2];   // D7
assign loan_io_oe[25]  = 1'b1;
assign loan_io_out[32] = led_drive[3];   // D8
assign loan_io_oe[32]  = 1'b1;

// ----------------------------------------------------------------------
// PSRAM bridge (psram64-style host port) + self-test controller
// ----------------------------------------------------------------------
wire        b_ready;
wire [15:0] b_dout;
wire [7:0]  b_id;

wire [22:0] c_addr;
wire [1:0]  c_wtbt;
wire        c_rd, c_we;
wire [15:0] c_din;
wire        c_done, c_pass, c_err;

// Diagnostics: brought out so the LED code can report WHERE the test stopped.
wire [31:0] dbg_errs;
wire [1:0]  dbg_ph;
wire [3:0]  dbg_st;
wire        dbg_started;
wire [31:0] dbg_runs;
wire        dbg_running;

// First-mismatch snapshot: this is what to point SignalTap at. Trigger on
// fe_valid rising and read fe_addr/fe_exp/fe_got -- that is the first place
// the link went wrong, not wherever a free-running capture happens to land.
wire [22:0] fe_addr;
wire [15:0] fe_exp, fe_got;
wire [1:0]  fe_ph;
wire [2:0]  fe_bb;
wire        fe_valid;

psram psram(
    .clk    (clk_144m),
    .reset  (~rst_n),
    .init   (~pll_locked),

    .ce_n   (ps_ce_n),
    .sio_out(ps_sio_out),
    .sio_oe (ps_sio_oe),
    .sio_in (ps_sio_in),
    .ready  (b_ready),
    .addr   (c_addr),
    .wtbt   (c_wtbt),
    .rd     (c_rd),
    .we     (c_we),
    .din    (c_din),
    .dout   (b_dout)
);

psram_test_ctrl #(
    .N_WORDS(1 << 22),                 // full 8 MB test
    // Run forever so there is always bus activity to trigger on. Change back
    // to 0 for a single-shot run once the link is known good.
    .LOOP_FOREVER(1'b1),
    .GAP_CYCLES (14_400_000)            // ~100 ms idle between iterations
) u_ctrl (
    .clk    (clk_144m),
    .rst_n  (rst_n),
    .sready (b_ready),
    .rd     (c_rd),
    .we     (c_we),
    .addr   (c_addr),
    .wtbt   (c_wtbt),
    .din    (c_din),
    .dout   (b_dout),
    .id     (b_id),
    .done   (c_done),
    .pass   (c_pass),
    .err    (c_err),
    .dbg_errs   (dbg_errs),
    .dbg_ph     (dbg_ph),
    .dbg_st     (dbg_st),
    .dbg_started(dbg_started),
    .dbg_runs   (dbg_runs),
    .dbg_running(dbg_running),
    .fe_addr    (fe_addr),
    .fe_exp     (fe_exp),
    .fe_got     (fe_got),
    .fe_ph      (fe_ph),
    .fe_bb      (fe_bb),
    .fe_valid   (fe_valid)
);

// ----------------------------------------------------------------------
// HPS (Qsys) wrapper - instance named u0 (qsf GLOBAL_SIGNAL paths rely on it)
// ----------------------------------------------------------------------
hps u0 (
    .clock_bridge_0_out_clk_1_clk(clk_100m),
    .hps_0_h2f_user1_clock_clk(clk_50m),
    .reset_bridge_0_out_reset_1_reset(hps_reset),

    .hps_io_hps_io_sdio_inst_CMD(HPS_3V3_SDMMC_CMD),
    .hps_io_hps_io_sdio_inst_D0(HPS_3V3_SDMMC_D0),
    .hps_io_hps_io_sdio_inst_D1(HPS_3V3_SDMMC_D1),
    .hps_io_hps_io_sdio_inst_CLK(HPS_3V3_SDMMC_CLK),
    .hps_io_hps_io_sdio_inst_D2(HPS_3V3_SDMMC_D2),
    .hps_io_hps_io_sdio_inst_D3(HPS_3V3_SDMMC_D3),

    .hps_io_hps_io_usb1_inst_D0(HPS_3V3_USB1_D0),
    .hps_io_hps_io_usb1_inst_D1(HPS_3V3_USB1_D1),
    .hps_io_hps_io_usb1_inst_D2(HPS_3V3_USB1_D2),
    .hps_io_hps_io_usb1_inst_D3(HPS_3V3_USB1_D3),
    .hps_io_hps_io_usb1_inst_D4(HPS_3V3_USB1_D4),
    .hps_io_hps_io_usb1_inst_D5(HPS_3V3_USB1_D5),
    .hps_io_hps_io_usb1_inst_D6(HPS_3V3_USB1_D6),
    .hps_io_hps_io_usb1_inst_D7(HPS_3V3_USB1_D7),
    .hps_io_hps_io_usb1_inst_CLK(HPS_3V3_USB1_CLK),
    .hps_io_hps_io_usb1_inst_STP(HPS_3V3_USB1_STP),
    .hps_io_hps_io_usb1_inst_DIR(HPS_3V3_USB1_DIR),
    .hps_io_hps_io_usb1_inst_NXT(HPS_3V3_USB1_NXT),

    .hps_io_hps_io_spim0_inst_CLK(HPS_1V8_SPIM0_CLK),
    .hps_io_hps_io_spim0_inst_MOSI(HPS_1V8_SPIM0_MOSI),
    .hps_io_hps_io_spim0_inst_MISO(HPS_1V8_SPIM0_MISO),
    .hps_io_hps_io_spim0_inst_SS0(HPS_1V8_SPIM0_SS0),

    .hps_io_hps_io_spim1_inst_CLK(HPS_1V8_SPIM1_CLK),
    .hps_io_hps_io_spim1_inst_MOSI(HPS_1V8_SPIM1_MOSI),
    .hps_io_hps_io_spim1_inst_MISO(HPS_1V8_SPIM1_MISO),
    .hps_io_hps_io_spim1_inst_SS0(HPS_1V8_SPIM1_SS0),

    .hps_io_hps_io_uart0_inst_RX(HPS_1V8_UART0_RX),
    .hps_io_hps_io_uart0_inst_TX(HPS_1V8_UART0_TX),

    .hps_io_hps_io_i2c0_inst_SDA(HPS_1V8_I2C0_SDA),
    .hps_io_hps_io_i2c0_inst_SCL(HPS_1V8_I2C0_SCL),
    .hps_io_hps_io_i2c1_inst_SDA(HPS_1V8_I2C1_SDA),
    .hps_io_hps_io_i2c1_inst_SCL(HPS_1V8_I2C1_SCL),
    .hps_io_hps_io_i2c3_inst_SDA(HPS_1V8_I2C3_SDA),
    .hps_io_hps_io_i2c3_inst_SCL(HPS_1V8_I2C3_SCL),

    .hps_io_hps_io_gpio_inst_GPIO00(HPS_3V3_GPIO_GPIO00),
    .hps_io_hps_io_gpio_inst_GPIO09(HPS_3V3_GPIO_GPIO09),
    .hps_io_hps_io_gpio_inst_GPIO44(HPS_3V3_GPIO_GPIO44),
    .hps_io_hps_io_gpio_inst_LOANIO14(HPS_1V8_LOANIO14),
    .hps_io_hps_io_gpio_inst_LOANIO17(HPS_1V8_LOANIO17),
    .hps_io_hps_io_gpio_inst_LOANIO19(HPS_1V8_LOANIO19),
    .hps_io_hps_io_gpio_inst_LOANIO22(HPS_1V8_LOANIO22),
    .hps_io_hps_io_gpio_inst_LOANIO23(HPS_1V8_LOANIO23),
    .hps_io_hps_io_gpio_inst_LOANIO25(HPS_1V8_LOANIO25),
    .hps_io_hps_io_gpio_inst_LOANIO27(HPS_1V8_LOANIO27),
    .hps_io_hps_io_gpio_inst_LOANIO28(HPS_1V8_LOANIO28),
    .hps_io_hps_io_gpio_inst_LOANIO29(HPS_1V8_LOANIO29),
    .hps_io_hps_io_gpio_inst_LOANIO30(HPS_1V8_LOANIO30),
    .hps_io_hps_io_gpio_inst_LOANIO32(HPS_1V8_LOANIO32),
    .hps_io_hps_io_gpio_inst_LOANIO33(HPS_1V8_LOANIO33),
    .hps_io_hps_io_gpio_inst_LOANIO34(HPS_1V8_LOANIO34),
    .hps_io_hps_io_gpio_inst_LOANIO48(HPS_1V8_LOANIO48),
    .hps_io_hps_io_gpio_inst_LOANIO53(HPS_1V8_LOANIO53),
    .hps_io_hps_io_gpio_inst_LOANIO54(HPS_1V8_LOANIO54),

    .hps_0_h2f_loan_io_in(loan_io_in),
    .hps_0_h2f_loan_io_out(loan_io_out),
    .hps_0_h2f_loan_io_oe(loan_io_oe),

    .memory_mem_a(HPS_SDRAM_MA),
    .memory_mem_ba(HPS_SDRAM_BA),
    .memory_mem_ck(HPS_SDRAM_CLK_P),
    .memory_mem_ck_n(HPS_SDRAM_CLK_N),
    .memory_mem_cke(HPS_SDRAM_nMCKE),
    .memory_mem_cs_n(HPS_SDRAM_nMCS),
    .memory_mem_ras_n(HPS_SDRAM_nRAS),
    .memory_mem_cas_n(HPS_SDRAM_nCAS),
    .memory_mem_we_n(HPS_SDRAM_nMWE),
    .memory_mem_reset_n(HPS_SDRAM_nRESET),
    .memory_mem_dq(HPS_SDRAM_DQ),
    .memory_mem_dqs(HPS_SDRAM_DQS_P),
    .memory_mem_dqs_n(HPS_SDRAM_DQS_N),
    .memory_mem_odt(HPS_SDRAM_MODT),
    .memory_mem_dm(HPS_SDRAM_MDM),
    .memory_oct_rzqin(HPS_SDRAM_RZQ)
);

endmodule