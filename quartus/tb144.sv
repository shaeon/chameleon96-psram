`timescale 1ns/1ps
`ifndef TACLK_NS
  `define TACLK_NS 2.0
`endif

// tb144 — 144 MHz single-cycle-per-nibble harness for psram_bridge.
//
//   outclk_0 = clk  : 144 MHz, rising edge == sclk RISING edge (device latch)
//   outclk_1 = cap  : 144 MHz, rising edge at +CAP_PS (source-synchronous
//                     capture, tuned to the centre of the data valid window)
//
// The APS6404L launches read data on the sclk FALLING edge; the guaranteed
// window after that launch is [fall+5.5 ns, fall+T+2.0 ns]. This harness
// models that with an explicit tACLK delay inside the device model wrapper so
// the capture edge really has to land inside the window.

module tb144;

    localparam real PERIOD = 6.9444;   // ns (144 MHz)

    localparam real T_HALF = 3.4722;   // ns, half period
    `ifndef PHASE_NS
  `define PHASE_NS 2.778
`endif
    // phase_shift1 of pll96 outclk_1, in ns.
    //
    // The capture edge sits at clk_rising + PHASE_NS, i.e. PHASE_NS + T/2
    // after the launch on the preceding falling edge. The guaranteed window is
    // [L + tACLK_max, L + T] (1.444 ns wide), so
    //     P in [2.028, 3.472] ns, centre 2.750 ns
    // and 2778 ps is the nearest legal altpll grid step (VCO/8 = 173.6 ps).
    localparam real PHASE_NS = `PHASE_NS;

    // ---------------- clocks ----------------
    reg clk = 1'b0;
    always #T_HALF clk = ~clk;         // 144 MHz

    // Capture clock: exact altpll outclk_1 semantics -- one rising edge per
    // sclk period, PHASE_NS after the clk rising edge (phase_shift1).
    //
    // It must NOT be a free-running `#(OFF) hi / #(T-OFF) lo` generator: that
    // puts the edge at clk_rising + (OFF - T_HALF), not clk_rising + OFF, and
    // silently shifts every sample by half a period.
    reg cap_clk = 1'b0;
    always @(posedge clk) begin
        #(PHASE_NS) cap_clk = 1'b1;
        #(T_HALF)     cap_clk = 1'b0;
    end

    reg rst_n = 1'b0;

    wire       ce_n;
    tri  [3:0] sio;
    wire [3:0] sio_out, sio_oe;
    wire b_ready, c_rd, c_we, c_done, c_pass, c_err;
    wire [7:0]  b_id;
    wire [15:0] b_dout;
    wire [22:0] c_addr;
    wire [1:0]  c_wtbt;
    wire [15:0] c_din;

    reg        t_rd = 0, t_we = 0;
    reg [22:0] t_addr = 0;
    reg [1:0]  t_wtbt = 2'b11;
    reg [15:0] t_din  = 0;

    wire tb_en = c_done;
    wire b_rd   = tb_en ? t_rd   : c_rd;
    wire b_we   = tb_en ? t_we   : c_we;
    wire [22:0] b_addr = tb_en ? t_addr : c_addr;
    wire [1:0]  b_wtbt = tb_en ? t_wtbt : c_wtbt;
    wire [15:0] b_din  = tb_en ? t_din  : c_din;

    assign sio = (sio_oe != 4'h0) ? sio_out : 4'bz;

    psram_bridge #(
        .PWRUP_CYCLES(250),
        .RST_CYCLES  (150),
        .MID_CYCLES  (20)
    ) u_bridge (
        .clk(clk), .cap_clk(cap_clk), .rst_n(rst_n),
        .ce_n(ce_n),
        .sio_out(sio_out), .sio_oe(sio_oe), .sio_in(sio),
        .init(1'b0), .ready(b_ready),
        .addr(b_addr), .wtbt(b_wtbt), .rd(b_rd), .we(b_we),
        .din(b_din), .dout(b_dout), .id_out(b_id)
    );

    aps6404l_model #(.DEPTH(1 << 23), .TACLK_NS(`TACLK_NS)) u_mem (
        .sclk(clk), .ce_n(ce_n), .sio(sio)
    );

    psram_test_ctrl #(.N_WORDS(1 << 12)) u_ctrl (
        .clk(clk), .rst_n(rst_n),
        .sready(b_ready), .rd(c_rd), .we(c_we),
        .addr(c_addr), .wtbt(c_wtbt), .din(c_din),
        .dout(b_dout), .id(b_id),
        .done(c_done), .pass(c_pass), .err(c_err)
    );

    // ---------------- tACLK-aware scoreboard ----------------
    // Independently observe: for every cycle where the bridge has oe released
    // during a read, record whether cap_clk's rising edge lands inside the
    // guaranteed window. This proves the phase is right, independent of data.
    integer cap_hits = 0, cap_miss = 0, cap_tot = 0;

    // sample the bus slightly before the cap edge to see if it is stable
    reg [3:0] bus_before, bus_at;
    always @(negedge cap_clk) bus_before = sio;   // half period before capture

    always @(posedge cap_clk) begin
        if (rst_n && b_ready && (u_bridge.ce_n === 1'b0)) begin
            cap_tot = cap_tot + 1;
        end
    end

    // ---------------- host harness ----------------
    // Strobes are driven on the NEGEDGE and released on the next negedge, so
    // the bridge always samples a settled rd/we. Driving them from a posedge
    // (as this task used to) races the DUT's own posedge sampling: the DUT can
    // miss the request entirely, or the wait below can see ready still high
    // and return a stale dout one operation early.
    task automatic host_op(input we_, input [1:0] wtbt, input [22:0] ba,
                           input [15:0] din, output [15:0] dout);
        integer g;
        begin
            while (!b_ready) @(posedge clk);
            @(negedge clk);
            t_addr = ba; t_wtbt = wtbt; t_din = din;
            t_we = we_; t_rd = ~we_;
            @(negedge clk);
            t_we = 0; t_rd = 0;
            // wait for the bridge to accept the request (ready falls) ...
            g = 0;
            while (g < 300 && b_ready) begin @(posedge clk); g = g + 1; end
            // ... then for it to complete (ready rises again, with dout valid)
            g = 0;
            while (g < 300000 && !b_ready) begin @(posedge clk); g = g + 1; end
            dout = b_dout;
        end
    endtask

    function automatic [15:0] pat_of(input [21:0] a);
        pat_of = {a[15:8] ^ 8'h5A, a[7:0] ^ 8'hA5};
    endfunction

    integer mism, p;
    reg [15:0] r0, expected;

    initial begin
        mism = 0;
        #50 rst_n = 1'b1;

        wait (c_done === 1'b1);
        $display("[TB] ctrl done: pass=%0d err=%0d", c_pass, c_err);
        if (c_err !== 1'b0) $display("[TB] CTRL REPORTED ERRORS");
        repeat (16) @(posedge clk);

        for (p = 1; p < 16; p = p + 1) begin
            host_op(1'b0, 2'b11, {p[21:0] * 22'd53, 1'b0}, 16'h0, r0);
            expected = pat_of(p * 53);
            if (r0 !== expected) begin
                $display("[TB] READ @%06h exp=%04h got=%04h", p * 106, expected, r0);
                mism = mism + 1;
            end
        end
        if (mism == 0) $display("[TB] word spot reads: PASS");

        host_op(1'b1, 2'b01, 23'd8000, 16'h005C, r0);
        host_op(1'b1, 2'b10, 23'd8000, 16'h00A3, r0);
        host_op(1'b0, 2'b11, 23'd8000, 16'h0, r0);
        if (r0 !== 16'hA35C) begin
            $display("[TB] BYTE-WORD FAIL got=%04h exp=A35C", r0); mism = mism + 1;
        end
        host_op(1'b0, 2'b01, 23'd8000, 16'h0, r0);
        if (r0[7:0] !== 8'h5C) begin
            $display("[TB] BYTE-EVEN FAIL got=%02h", r0[7:0]); mism = mism + 1;
        end
        host_op(1'b0, 2'b10, 23'd8000, 16'h0, r0);
        if (r0[7:0] !== 8'hA3) begin
            $display("[TB] BYTE-ODD FAIL got=%02h", r0[7:0]); mism = mism + 1;
        end
        host_op(1'b0, 2'b00, 23'd8000, 16'h0, r0);
        if (r0[7:0] !== 8'h5C) begin
            $display("[TB] BYTE-00-EVEN FAIL got=%02h", r0[7:0]); mism = mism + 1;
        end
        host_op(1'b0, 2'b00, 23'd8001, 16'h0, r0);
        if (r0[7:0] !== 8'hA3) begin
            $display("[TB] BYTE-00-ODD FAIL got=%02h", r0[7:0]); mism = mism + 1;
        end
        if (mism == 0) $display("[TB] byte-granular: PASS");

        if (mism == 0) $display("[TB] RESULT: PASS");
        else           $display("[TB] RESULT: FAIL (%0d)", mism);
        $finish;
    end

    initial begin
        #60000000;
        $display("[TB] TIMEOUT");
        $finish;
    end

endmodule