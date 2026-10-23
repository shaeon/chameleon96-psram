`timescale 1ns/1ps

// tb_psram_qspi — sim harness: bridge + behavioral model + test ctrl.
// 1) ctrl runs FILL/CHECK/ROW/BYTES over a small window.
// 2) after ctrl reports done, this harness drives directed host ops:
//    word spot reads (address-derived pattern) and byte-granular single-byte reads/writes
//    exercising wtbt 11/01/10/00.
//
// ONE clock, matching the board architecture: the bridge runs at 144 MHz
// (clk = outclk_0 = the PSRAM sclk), `assign sclk = clk`, and that sclk
// OUTPUT is what clocks the device model -- same net, zero phase offset.
// cap_clk is vestigial (capture moved to posedge clk) and tied to clk.
//
// TACLK_NS = 2.0: with a single zero-phase clock the capture posedge sits
// T/2 = 3.472 ns after the device's launch (negedge), so the model's read
// launch must fit inside that half period (datasheet tACLK = 2.0..5.5 ns;
// the wider top corner is straddled by the phase-shifted board build, see
// the model header corner matrix). 2.0 gives 1.472 ns setup at capture and
// also releases the model's pad at ce_fall + 2.0 ns, well before its first
// command sample at ce_fall + 6.944 ns.
//
// Host strobes are driven on the NEGEDGE so the bridge always samples a
// settled rd/we; driving them from a posedge races the DUT's own posedge
// sampling.

module tb_psram_qspi;

    reg clk = 1'b0;
    always #3.472 clk = ~clk;               // 144 MHz (period 6.944 ns)

    reg rst_n = 1'b0;

    // ---------------- inter-module nets/regs (declared up front) --------
    wire       ce_n;
    tri  [3:0] sio;
    wire [3:0] sio_out, sio_oe;
    wire       b_sclk;                       // bridge sclk output (= clk) -> model

    wire b_ready;
    wire [7:0]  b_id;
    wire [15:0] b_dout;
    reg        t_rd = 1'b0, t_we = 1'b0;
    reg [22:0] t_addr = 23'd0;
    reg [1:0]  t_wtbt = 2'b11;
    reg [15:0] t_din  = 16'h0;

    wire       c_rd, c_we;
    wire [22:0] c_addr;
    wire [1:0]  c_wtbt;
    wire [15:0] c_din;
    wire       c_done, c_pass, c_err;

    wire tb_en = c_done;
    assign sio = (sio_oe != 4'h0) ? sio_out : 4'bzzzz;

    wire b_rd   = tb_en ? t_rd   : c_rd;
    wire b_we   = tb_en ? t_we   : c_we;
    wire [22:0] b_addr = tb_en ? t_addr : c_addr;
    wire [1:0]  b_wtbt = tb_en ? t_wtbt : c_wtbt;
    wire [15:0] b_din  = tb_en ? t_din  : c_din;

    psram_bridge #(
        .PWRUP_CYCLES(250),                // shorten for sim
        .RST_CYCLES  (150),
        .MID_CYCLES  (20)
    ) u_bridge (
        .clk(clk),
        .cap_clk(clk),                      // vestigial port, unused internally
        .rst_n(rst_n),
        .sclk(b_sclk),                      // assign sclk = clk
        .ce_n(ce_n),
        .sio_out(sio_out), .sio_oe(sio_oe), .sio_in(sio),
        .init(1'b0), .ready(b_ready),
        .addr(b_addr), .wtbt(b_wtbt), .rd(b_rd), .we(b_we),
        .din(b_din), .dout(b_dout), .id_out(b_id)
    );

    aps6404l_model #(
        .DEPTH(1 << 23),                    // 8 MB covers the ROW-address walk
        .TACLK_NS(2.0)                      // launch must fit in T/2 (see header)
    ) u_mem (
        .sclk(b_sclk), .ce_n(ce_n), .sio(sio)
    );

    psram_test_ctrl #(
        .N_WORDS(1 << 12)                  // sim: 4096 words
    ) u_ctrl (
        .clk(clk), .rst_n(rst_n),
        .sready(b_ready), .rd(c_rd), .we(c_we),
        .addr(c_addr), .wtbt(c_wtbt), .din(c_din),
        .dout(b_dout), .id(b_id),
        .done(c_done), .pass(c_pass), .err(c_err)
    );

    // same pattern function as ctrl so spot reads can be verified
    function automatic [15:0] pat_of(input [21:0] a);
        begin
            pat_of = {a[15:8] ^ 8'h5A, a[7:0] ^ 8'hA5};
        end
    endfunction

    // one host op: wait ready, pulse rd/we for one cycle, wait busy+done
    task automatic host_op(input we_, input [1:0] wtbt, input [22:0] ba,
                           input [15:0] din, output [15:0] dout);
        integer g;
        begin
            while (!b_ready) @(posedge clk);
            @(negedge clk);
            t_addr = ba; t_wtbt = wtbt; t_din = din;
            t_we   = we_;
            t_rd   = !we_;
            @(negedge clk);
            t_we   = 1'b0;
            t_rd   = 1'b0;
            g = 0;
            while (g < 300 && b_ready) begin @(posedge clk); g = g + 1; end
            g = 0;
            while (g < 300000 && !b_ready) begin @(posedge clk); g = g + 1; end
            dout = b_dout;
        end
    endtask

    integer mism, p;
    reg [15:0] r0, expected;

    initial begin
        mism = 0;
        #20 rst_n = 1'b1;

        wait (c_done === 1'b1);
        $display("[TB] ctrl done: pass=%0d err=%0d", c_pass, c_err);
        if (c_err !== 1'b0) $display("[TB] CTRL REPORTED ERRORS");
        repeat (16) @(posedge clk);        // quiet gap

        // spot reads (skip base: ROW phase left ~P there)
        for (p = 1; p < 16; p = p + 1) begin
            host_op(1'b0, 2'b11, {p[21:0] * 22'd53, 1'b0}, 16'h0, r0);
            expected = pat_of(p * 53);
            if (r0 !== expected) begin
                $display("[TB] READ @%06h exp=%04h got=%04h", p * 106, expected, r0);
                mism = mism + 1;
            end
        end
        if (mism == 0) $display("[TB] word spot reads: PASS");

        // byte-granular test at word 4000 (byte 8000), untouched by ctrl ROW/BYTES
        host_op(1'b1, 2'b01, 23'd8000, 16'h005C, r0);   // write even byte  5C
        host_op(1'b1, 2'b10, 23'd8000, 16'h00A3, r0);   // write odd  byte  A3
        host_op(1'b0, 2'b11, 23'd8000, 16'h0000, r0);   // word read
        if (r0 !== 16'hA35C) begin
            $display("[TB] BYTE-WORD FAIL got=%04h exp=A35C", r0);
            mism = mism + 1;
        end
        host_op(1'b0, 2'b01, 23'd8000, 16'h0000, r0);   // read even byte
        if (r0[7:0] !== 8'h5C) begin
            $display("[TB] BYTE-EVEN FAIL got=%02h exp=5C", r0[7:0]);
            mism = mism + 1;
        end
        host_op(1'b0, 2'b10, 23'd8000, 16'h0000, r0);   // read odd byte
        if (r0[7:0] !== 8'hA3) begin
            $display("[TB] BYTE-ODD FAIL got=%02h exp=A3", r0[7:0]);
            mism = mism + 1;
        end
        host_op(1'b0, 2'b00, 23'd8000, 16'h0000, r0);   // wtbt 00 @ a[0]=0
        if (r0[7:0] !== 8'h5C) begin
            $display("[TB] BYTE-00-EVEN FAIL got=%02h exp=5C", r0[7:0]);
            mism = mism + 1;
        end
        host_op(1'b0, 2'b00, 23'd8001, 16'h0000, r0);   // wtbt 00 @ a[0]=1
        if (r0[7:0] !== 8'hA3) begin
            $display("[TB] BYTE-00-ODD FAIL got=%02h exp=A3", r0[7:0]);
            mism = mism + 1;
        end
        if (mism == 0) $display("[TB] byte-granular: PASS");

        if (mism == 0) $display("[TB] RESULT: PASS");
        else           $display("[TB] RESULT: FAIL (%0d)", mism);
        $finish;
    end

    initial begin
        #60000000;                          // 60 ms timeout
        $display("[TB] TIMEOUT");
        $finish;
    end

    initial begin
        $dumpfile("vcd/psram_qspi.vcd");
        $dumpvars(0, tb_psram_qspi);
    end

endmodule
