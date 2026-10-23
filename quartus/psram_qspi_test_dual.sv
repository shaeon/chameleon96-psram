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

module psram_qspi_test_dual(
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
    inout HPS_1V8_LOANIO17,  // chip1 SIO2
    inout HPS_1V8_LOANIO19,  // chip1 SIO1
    inout HPS_1V8_LOANIO22,  // LED D6
    inout HPS_1V8_LOANIO23,  // chip2 PSRAM CE#
    inout HPS_1V8_LOANIO25,  // LED D7
    inout HPS_1V8_LOANIO27,  // chip2 PSRAM SIO1
    inout HPS_1V8_LOANIO28,  // chip2 PSRAM CLK
    inout HPS_1V8_LOANIO29,  // chip2 PSRAM SIO0
    inout HPS_1V8_LOANIO30,  // chip2 PSRAM SIO3
    inout HPS_1V8_LOANIO32,  // LED D8
    inout HPS_1V8_LOANIO33,  // chip1 SIO0
    inout HPS_1V8_LOANIO34,  // chip1 SIO3
    inout HPS_3V3_GPIO_GPIO44,
    inout HPS_1V8_LOANIO48,  // chip1 CE#
    inout HPS_1V8_LOANIO53,  // chip2 PSRAM SIO2
    inout HPS_1V8_LOANIO54,  // chip1 CLK

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
wire clk_psram;     // pll96 outclk_0 -> fabric + los DOS pines CLK

pll96 u_pll (
    .refclk(clk_100m),
    .rst(hps_reset),
    .outclk_0(clk_psram),
    .locked(pll_locked)
);

wire rst_n_raw;
assign rst_n_raw = ~hps_reset & pll_locked;

reg rst_s1 = 1'b0, rst_s2 = 1'b0;
always @(posedge clk_psram) begin
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

// ----------------------------------------------------------------------
// LANE 1 = chip 1 (U1):  SIO0=33 SIO1=19 SIO2=17 SIO3=34  CLK=54  CE#=48
// LANE 2 = chip 2 (U2):  SIO0=29 SIO1=27 SIO2=53 SIO3=30  CLK=28  CE#=23
//
// Los dos lanes son electricamente independientes (buses y CE# propios) y
// comparten unicamente el reloj, que es como esta cableado el addon: un
// unico outclk_0 sale por los dos pines CLK. Arrancan a la vez y corren a
// la vez, que es justo el caso que interesa medir: consumo simultaneo,
// diafonia entre los dos buses y ruido en la alimentacion comun.
// ----------------------------------------------------------------------
wire        ce_n_1, ce_n_2;
wire [3:0]  sio_out_1, sio_oe_1, sio_in_1;
wire [3:0]  sio_out_2, sio_oe_2, sio_in_2;

// --- lane 1 pads ---
assign loan_io_out[33] = sio_out_1[0];
assign loan_io_out[19] = sio_out_1[1];
assign loan_io_out[17] = sio_out_1[2];
assign loan_io_out[34] = sio_out_1[3];
assign loan_io_oe[33]  = sio_oe_1[0];
assign loan_io_oe[19]  = sio_oe_1[1];
assign loan_io_oe[17]  = sio_oe_1[2];
assign loan_io_oe[34]  = sio_oe_1[3];
assign sio_in_1[0] = loan_io_in[33];
assign sio_in_1[1] = loan_io_in[19];
assign sio_in_1[2] = loan_io_in[17];
assign sio_in_1[3] = loan_io_in[34];
assign loan_io_out[54] = clk_psram;
assign loan_io_oe[54]  = 1'b1;
assign loan_io_out[48] = ce_n_1;
assign loan_io_oe[48]  = 1'b1;

// --- lane 2 pads ---
assign loan_io_out[29] = sio_out_2[0];
assign loan_io_out[27] = sio_out_2[1];
assign loan_io_out[53] = sio_out_2[2];
assign loan_io_out[30] = sio_out_2[3];
assign loan_io_oe[29]  = sio_oe_2[0];
assign loan_io_oe[27]  = sio_oe_2[1];
assign loan_io_oe[53]  = sio_oe_2[2];
assign loan_io_oe[30]  = sio_oe_2[3];
assign sio_in_2[0] = loan_io_in[29];
assign sio_in_2[1] = loan_io_in[27];
assign sio_in_2[2] = loan_io_in[53];
assign sio_in_2[3] = loan_io_in[30];
assign loan_io_out[28] = clk_psram;
assign loan_io_oe[28]  = 1'b1;
assign loan_io_out[23] = ce_n_2;
assign loan_io_oe[23]  = 1'b1;

// ----------------------------------------------------------------------
// LANE 1
// ----------------------------------------------------------------------
wire        b_ready_1;
wire [15:0] b_dout_1;
wire [22:0] c_addr_1;
wire [1:0]  c_wtbt_1;
wire        c_rd_1, c_we_1;
wire [15:0] c_din_1;
wire        c_done_1, c_pass_1, c_err_1;
wire [31:0] dbg_errs_1, dbg_runs_1;
wire [1:0]  dbg_ph_1;
wire [3:0]  dbg_st_1;
wire        dbg_started_1, dbg_running_1;
wire [22:0] fe_addr_1;
wire [15:0] fe_exp_1, fe_got_1;
wire [1:0]  fe_ph_1;
wire [2:0]  fe_bb_1;
wire        fe_valid_1;

psram psram1(
    .clk(clk_psram), .reset(~rst_n), .init(~pll_locked),
    .ce_n(ce_n_1), .sio_out(sio_out_1), .sio_oe(sio_oe_1), .sio_in(sio_in_1),
    .ready(b_ready_1), .addr(c_addr_1), .wtbt(c_wtbt_1),
    .rd(c_rd_1), .we(c_we_1), .din(c_din_1), .dout(b_dout_1)
);

psram_test_ctrl #(
    .N_WORDS(1 << 22),
    .LOOP_FOREVER(1'b1),
    .GAP_CYCLES (14_400_000)
) u_ctrl1 (
    .clk(clk_psram), .rst_n(rst_n),
    .sready(b_ready_1), .rd(c_rd_1), .we(c_we_1),
    .addr(c_addr_1), .wtbt(c_wtbt_1), .din(c_din_1),
    .dout(b_dout_1), .id(8'h00),
    .done(c_done_1), .pass(c_pass_1), .err(c_err_1),
    .dbg_errs(dbg_errs_1), .dbg_ph(dbg_ph_1), .dbg_st(dbg_st_1),
    .dbg_started(dbg_started_1), .dbg_runs(dbg_runs_1),
    .dbg_running(dbg_running_1),
    .fe_addr(fe_addr_1), .fe_exp(fe_exp_1), .fe_got(fe_got_1),
    .fe_ph(fe_ph_1), .fe_bb(fe_bb_1), .fe_valid(fe_valid_1)
);

// ----------------------------------------------------------------------
// LANE 2
// ----------------------------------------------------------------------
wire        b_ready_2;
wire [15:0] b_dout_2;
wire [22:0] c_addr_2;
wire [1:0]  c_wtbt_2;
wire        c_rd_2, c_we_2;
wire [15:0] c_din_2;
wire        c_done_2, c_pass_2, c_err_2;
wire [31:0] dbg_errs_2, dbg_runs_2;
wire [1:0]  dbg_ph_2;
wire [3:0]  dbg_st_2;
wire        dbg_started_2, dbg_running_2;
wire [22:0] fe_addr_2;
wire [15:0] fe_exp_2, fe_got_2;
wire [1:0]  fe_ph_2;
wire [2:0]  fe_bb_2;
wire        fe_valid_2;

psram psram2(
    .clk(clk_psram), .reset(~rst_n), .init(~pll_locked),
    .ce_n(ce_n_2), .sio_out(sio_out_2), .sio_oe(sio_oe_2), .sio_in(sio_in_2),
    .ready(b_ready_2), .addr(c_addr_2), .wtbt(c_wtbt_2),
    .rd(c_rd_2), .we(c_we_2), .din(c_din_2), .dout(b_dout_2)
);

psram_test_ctrl #(
    .N_WORDS(1 << 22),
    .LOOP_FOREVER(1'b1),
    .GAP_CYCLES (14_400_000)
) u_ctrl2 (
    .clk(clk_psram), .rst_n(rst_n),
    .sready(b_ready_2), .rd(c_rd_2), .we(c_we_2),
    .addr(c_addr_2), .wtbt(c_wtbt_2), .din(c_din_2),
    .dout(b_dout_2), .id(8'h00),
    .done(c_done_2), .pass(c_pass_2), .err(c_err_2),
    .dbg_errs(dbg_errs_2), .dbg_ph(dbg_ph_2), .dbg_st(dbg_st_2),
    .dbg_started(dbg_started_2), .dbg_runs(dbg_runs_2),
    .dbg_running(dbg_running_2),
    .fe_addr(fe_addr_2), .fe_exp(fe_exp_2), .fe_got(fe_got_2),
    .fe_ph(fe_ph_2), .fe_bb(fe_bb_2), .fe_valid(fe_valid_2)
);

// ----------------------------------------------------------------------
// LEDs (D5=14, D6=22, D7=25, D8=32)
//
// Con dos chips el codigo de fase ya no cabe ni sirve: lo que hace falta
// saber de un vistazo es QUE chip falla. Reparto:
//
//   D5  arrancado   : los dos controladores han visto ready y estan corriendo
//   D6  error chip1 : sticky, se enciende en cuanto chip 1 cuenta un fallo
//   D7  error chip2 : sticky, idem chip 2
//   D8  heartbeat   : parpadeo libre; si se para, la fabrica esta colgada
//
// Autotest de encendido identico al build anterior: enciende y apaga los
// cuatro para revelar la polaridad real de la placa sin tener que suponerla.
// ----------------------------------------------------------------------
localparam integer LED_STEP = 28_800_000;   // 200 ms @ 144 MHz
reg [27:0] led_t = 28'd0;
reg [2:0]  led_step = 3'd7;
reg        selftest_done = 1'b0;
always @(posedge clk_psram) begin
    if (!rst_n) begin
        led_t <= 28'd0; led_step <= 3'd7; selftest_done <= 1'b0;
    end else if (!selftest_done) begin
        if (led_t == LED_STEP[27:0] - 1) begin
            led_t <= 28'd0;
            led_step <= led_step + 3'd1;
            if (led_step == 3'd5) selftest_done <= 1'b1;
        end else begin
            led_t <= led_t + 28'd1;
        end
    end
end

wire [3:0] led_selftest =
      (led_step == 3'd0) ? 4'b0000
    : (led_step == 3'd1) ? 4'b1111
    : (led_step == 3'd2) ? 4'b0001
    : (led_step == 3'd3) ? 4'b0010
    : (led_step == 3'd4) ? 4'b0100
    :                      4'b1000;

localparam integer LED_HB = 144_000;        // 1 ms @ 144 MHz
reg [17:0] hb_t = 18'd0;
reg        err_sticky_1 = 1'b0, err_sticky_2 = 1'b0;
always @(posedge clk_psram) begin
    if (!rst_n) begin
        hb_t <= 18'd0; err_sticky_1 <= 1'b0; err_sticky_2 <= 1'b0;
    end else begin
        if (hb_t == LED_HB[17:0] - 1) hb_t <= 18'd0;
        else                          hb_t <= hb_t + 18'd1;
        if (dbg_errs_1 != 32'd0) err_sticky_1 <= 1'b1;
        if (dbg_errs_2 != 32'd0) err_sticky_2 <= 1'b1;
    end
end

wire       led_hb = hb_t[17];
wire       led_run = dbg_started_1 & dbg_started_2;
wire [3:0] led_drive = selftest_done
                     ? {led_hb, err_sticky_2, err_sticky_1, led_run}
                     : led_selftest;

assign loan_io_out[14] = led_drive[0];   // D5
assign loan_io_oe[14]  = 1'b1;
assign loan_io_out[22] = led_drive[1];   // D6
assign loan_io_oe[22]  = 1'b1;
assign loan_io_out[25] = led_drive[2];   // D7
assign loan_io_oe[25]  = 1'b1;
assign loan_io_out[32] = led_drive[3];   // D8
assign loan_io_oe[32]  = 1'b1;

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