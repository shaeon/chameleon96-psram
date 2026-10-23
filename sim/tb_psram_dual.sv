`timescale 1ns/1ps

// tb_psram_dual -- dos cadenas PSRAM completas corriendo A LA VEZ.
//
// Cada lane = psram (controlador) + psram_test_ctrl (autotest) + modelo
// aps6404l. Los dos lanes comparten el reloj (igual que en la placa: el
// mismo outclk_0 sale por los dos pines CLK) pero tienen buses SIO y CE#
// independientes, que es exactamente la topologia del addon.
//
// Parametros de barrido (se pasan por -P o por `define):
//   HALF_NS  : medio periodo del sclk. 3.472 = 144 MHz.
//   TACLK    : tACLK del modelo (2.0 .. 5.5 ns segun datasheet).
//
// Lo que este banco SI demuestra: que las dos cadenas funcionan
// simultaneamente sin interferirse a nivel logico, y donde esta el limite
// teorico de frecuencia para el esquema de captura actual.
// Lo que NO demuestra: la ventana real de la placa (eso es medida).

`ifndef HALF_NS
  `define HALF_NS 3.472
`endif
`ifndef TACLK
  `define TACLK 2.0
`endif
`ifndef NWORDS_LOG2
  `define NWORDS_LOG2 12
`endif

module tb_psram_dual;

    reg clk = 1'b0;
    always #(`HALF_NS) clk = ~clk;

    reg rst_n = 1'b0;
    wire reset = ~rst_n;

    // ------------------------------------------------------------------
    // LANE 1
    // ------------------------------------------------------------------
    wire        ce_n_1;
    tri  [3:0]  sio_1;
    wire [3:0]  sio_out_1, sio_oe_1;
    wire        ready_1;
    wire [15:0] dout_1;
    wire        rd_1, we_1;
    wire [22:0] addr_1;
    wire [1:0]  wtbt_1;
    wire [15:0] din_1;
    wire        done_1, pass_1, err_1;
    wire [31:0] errs_1;
    wire [1:0]  ph_1;
    wire [22:0] fe_addr_1;
    wire [15:0] fe_exp_1, fe_got_1;
    wire        fe_valid_1;

    assign sio_1 = (sio_oe_1 != 4'h0) ? sio_out_1 : 4'bzzzz;

    psram #(.PWRUP_CYCLES(250), .RST_CYCLES(150), .MID_CYCLES(20)) u_ps1 (
        .clk(clk), .reset(reset), .init(1'b0),
        .ce_n(ce_n_1), .sio_out(sio_out_1), .sio_oe(sio_oe_1), .sio_in(sio_1),
        .addr(addr_1), .wtbt(wtbt_1), .rd(rd_1), .we(we_1),
        .din(din_1), .dout(dout_1), .ready(ready_1)
    );

    aps6404l_model #(.DEPTH(1 << 23), .TACLK_NS(`TACLK)) u_mem1 (
        .sclk(clk), .ce_n(ce_n_1), .sio(sio_1)
    );

    psram_test_ctrl #(.N_WORDS(1 << `NWORDS_LOG2)) u_ct1 (
        .clk(clk), .rst_n(rst_n),
        .sready(ready_1), .rd(rd_1), .we(we_1),
        .addr(addr_1), .wtbt(wtbt_1), .din(din_1),
        .dout(dout_1), .id(8'h00),
        .done(done_1), .pass(pass_1), .err(err_1),
        .dbg_errs(errs_1), .dbg_ph(ph_1), .dbg_st(), .dbg_started(),
        .dbg_runs(), .dbg_running(),
        .fe_addr(fe_addr_1), .fe_exp(fe_exp_1), .fe_got(fe_got_1),
        .fe_ph(), .fe_bb(), .fe_valid(fe_valid_1)
    );

    // ------------------------------------------------------------------
    // LANE 2
    // ------------------------------------------------------------------
    wire        ce_n_2;
    tri  [3:0]  sio_2;
    wire [3:0]  sio_out_2, sio_oe_2;
    wire        ready_2;
    wire [15:0] dout_2;
    wire        rd_2, we_2;
    wire [22:0] addr_2;
    wire [1:0]  wtbt_2;
    wire [15:0] din_2;
    wire        done_2, pass_2, err_2;
    wire [31:0] errs_2;
    wire [1:0]  ph_2;
    wire [22:0] fe_addr_2;
    wire [15:0] fe_exp_2, fe_got_2;
    wire        fe_valid_2;

    assign sio_2 = (sio_oe_2 != 4'h0) ? sio_out_2 : 4'bzzzz;

    psram #(.PWRUP_CYCLES(250), .RST_CYCLES(150), .MID_CYCLES(20)) u_ps2 (
        .clk(clk), .reset(reset), .init(1'b0),
        .ce_n(ce_n_2), .sio_out(sio_out_2), .sio_oe(sio_oe_2), .sio_in(sio_2),
        .addr(addr_2), .wtbt(wtbt_2), .rd(rd_2), .we(we_2),
        .din(din_2), .dout(dout_2), .ready(ready_2)
    );

    aps6404l_model #(.DEPTH(1 << 23), .TACLK_NS(`TACLK)) u_mem2 (
        .sclk(clk), .ce_n(ce_n_2), .sio(sio_2)
    );

    psram_test_ctrl #(.N_WORDS(1 << `NWORDS_LOG2)) u_ct2 (
        .clk(clk), .rst_n(rst_n),
        .sready(ready_2), .rd(rd_2), .we(we_2),
        .addr(addr_2), .wtbt(wtbt_2), .din(din_2),
        .dout(dout_2), .id(8'h00),
        .done(done_2), .pass(pass_2), .err(err_2),
        .dbg_errs(errs_2), .dbg_ph(ph_2), .dbg_st(), .dbg_started(),
        .dbg_runs(), .dbg_running(),
        .fe_addr(fe_addr_2), .fe_exp(fe_exp_2), .fe_got(fe_got_2),
        .fe_ph(), .fe_bb(), .fe_valid(fe_valid_2)
    );

    // ------------------------------------------------------------------
    // Secuencia
    // ------------------------------------------------------------------
    real freq_mhz;
    integer timeout;

    initial begin
        freq_mhz = 1000.0 / (2.0 * `HALF_NS);
        $display("=== DUAL PSRAM  f=%0.1f MHz (T/2=%0.3f ns)  tACLK=%0.1f ns  N=%0d words ===",
                 freq_mhz, `HALF_NS, `TACLK, 1 << `NWORDS_LOG2);

        repeat (20) @(posedge clk);
        rst_n = 1'b1;

        timeout = 0;
        while (!(done_1 && done_2) && timeout < 60_000_000) begin
            @(posedge clk);
            timeout = timeout + 1;
        end

        if (!(done_1 && done_2)) begin
            $display("RESULT: TIMEOUT  done1=%0d done2=%0d", done_1, done_2);
            $display("VERDICT: FAIL");
            $finish;
        end

        $display("LANE1: pass=%0d err=%0d errs=%0d", pass_1, err_1, errs_1);
        if (fe_valid_1)
            $display("  LANE1 primer fallo @%06h exp=%04h got=%04h",
                     fe_addr_1, fe_exp_1, fe_got_1);
        $display("LANE2: pass=%0d err=%0d errs=%0d", pass_2, err_2, errs_2);
        if (fe_valid_2)
            $display("  LANE2 primer fallo @%06h exp=%04h got=%04h",
                     fe_addr_2, fe_exp_2, fe_got_2);

        if (pass_1 && pass_2 && !err_1 && !err_2)
            $display("VERDICT: PASS");
        else
            $display("VERDICT: FAIL");

        $finish;
    end

endmodule
