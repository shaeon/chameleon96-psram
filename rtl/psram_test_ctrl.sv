`timescale 1ns/1ps

// psram_test_ctrl — synthesizable PSRAM self-test driving psram_bridge's
// psram64-style host port (23-bit byte address, wtbt byte select, single-cycle
// rd/we strobes, ready handshake).
//
// Test phases (run once after the bridge signals ready):
//   1. FILL  : write a word-address-derived pattern to every word.
//   2. CHECK : read every word back and compare, counting mismatches.
//   3. ROW   : address-bus cell tests at base / top / power-of-two
//              addresses: write P, verify, write ~P, verify each.
//   4. BYTES : byte-granular ops at byte corners (0,2,4,N-4,N-2) and a stride
//              window (2*ST_BASE .. +2*N_STRIDE): even/odd byte writes
//              (wtbt 01/10) then a full-word read (wtbt 11) and single-byte
//              reads (wtbt 01/10/00) verifying lane placement.
//
// The ctrl runs at 200 MHz (PLL C0); the PSRAM sclk is a separate PLL output.
// One host operation per frame: assert a 1-cycle rd/we strobe while the
// bridge is ready, wait for busy (sready low) and completion (sready high),
// then verify/advance.
//
// The expected pattern is a plain address-derived function of `cur` (byte-swap
// of the low 16 address bits XOR 0x5A/0xA5), identical to pat_of in the TB.
// FILL/CHECK still wait 3 settling cycles (S_B1..S_B3) after each address
// advance so that expa == cur and exp == pat_of(cur) at every issue / compare.
// (An LCG seed pair was used before; it cost two 32x32 multiplies in the 200 MHz
// fabric domain and was the divclk Fmax limiter. Address-derived is sufficient
// for bring-up and keeps the 200 MHz domain closing.)

module psram_test_ctrl #(
    parameter integer N_WORDS = 1 << 22,     // word count (byte depth / 2)
    parameter integer MAX_ERR = 1000,
    parameter integer LOOP_FOREVER = 0,      // 1 = restart forever (SignalTap)
    parameter integer GAP_CYCLES  = 2_000_000, // ~14 ms @144 MHz between runs
    parameter integer ST_BASE = 22'h900,     // BYTES stride window base (word)
    parameter integer N_STRIDE = 32          // stride addresses per phase run
) (
    input  wire        clk,
    input  wire        rst_n,

    // ---- bridge host port (psram64 style) ----
    input  wire        sready,
    output reg         rd,
    output reg         we,
    output reg  [22:0] addr,       // byte address
    output reg  [1:0]  wtbt,       // 00 byte@addr[0] / 01 even / 10 odd / 11 word
    output reg  [15:0] din,
    input  wire [15:0] dout,
    input  wire [7:0]  id,

    // ---- status ----
    output reg done,
    output reg pass,
    output reg err,

    // ---- diagnostics (hardware bring-up: LEDs alone cannot say WHERE it broke) ----
    output wire [31:0] dbg_errs,    // total mismatches seen so far
    output wire [1:0]  dbg_ph,      // phase: 0 FILL, 1 CHK, 2 ROW, 3 BYT
    output wire [3:0]  dbg_st,      // controller FSM state
    output wire        dbg_started, // 1 once bridge ready was seen and test began
    output wire [31:0] dbg_runs,    // completed test iterations
    output wire        dbg_running, // 1 while an iteration is in flight
    // First-mismatch snapshot. A plain SignalTap capture lands on an arbitrary
    // moment, which is useless for locating a fault: `err` is sticky and never
    // aborts, so the run always marches on to the last address. These latch the
    // FIRST failure instead, which is where the diagnosis actually starts.
    output reg  [22:0] fe_addr,    // byte address of first mismatch
    output reg  [15:0] fe_exp,     // value expected there
    output reg  [15:0] fe_got,     // value actually read
    output reg  [1:0]  fe_ph,      // phase it happened in
    output reg  [2:0]  fe_bb,      // BYTES sub-op (0..6), valid when fe_ph==BYT
    output reg         fe_valid    // 1 once a mismatch has been seen
);

`ifndef SYNTHESIS
    task automatic notify_mismatch(input [22:0] ad, input [15:0] xp,
                                   input [15:0] gt, input string tag);
        $display("MISMATCH [%0s] @%06h exp=%04h got=%04h", tag, ad, xp, gt);
    endtask
`else
    task automatic notify_mismatch(input [22:0] ad, input [15:0] xp,
                                   input [15:0] gt, input string tag);
    endtask
`endif

    // Latch the FIRST failure only. `err` is sticky and does not abort, so the
    // run always reaches the final address; a capture taken at the end tells
    // you nothing about where things first went wrong. First-write-wins.
    task automatic note_fail(input [22:0] ad, input [15:0] xp,
                             input [15:0] gt);
        if (!fe_valid) begin
            fe_addr  <= ad;
            fe_exp   <= xp;
            fe_got   <= gt;
            fe_ph    <= ph;
            fe_bb    <= bb;
            fe_valid <= 1'b1;
        end
    endtask

    // selected ROW-phase word address from walking-one index
    function automatic [21:0] row_addr(input [5:0] i);
        begin
            if      (i == 22) row_addr = 22'd0;            // base
            else if (i == 23) row_addr = N_WORDS[21:0] - 1;// top
            else              row_addr = (22'd1 << i);     // walking ones
        end
    endfunction

    // selected BYTES-phase even byte address from its index
    function automatic [22:0] byte_ba(input [6:0] ix);
        reg [21:0] w;
        begin
            case (ix)
                5'd0: w = 22'd0;
                5'd1: w = 22'd1;
                5'd2: w = 22'd2;
                5'd3: w = N_WORDS[21:0] - 22'd2;
                5'd4: w = N_WORDS[21:0] - 22'd1;
                default: w = ST_BASE[21:0] + (ix - 7'd5);
            endcase
            byte_ba = {1'b0, w, 1'b0};
        end
    endfunction

    localparam [3:0] S_WAIT=4'd0, S_ISS=4'd1, S_HI0=4'd2, S_LO0=4'd3, S_CMP=4'd4,
                     S_B1=4'd5, S_B2=4'd6, S_B3=4'd7, S_END=4'd8, S_DONE=4'd9;
    localparam [1:0] PH_FILL=2'd0, PH_CHK=2'd1, PH_ROW=2'd2, PH_BYT=2'd3;
    localparam [6:0] N_BA = 7'd5 + N_STRIDE;   // byte addresses per phase run

    reg [3:0] st = S_WAIT;
    reg [1:0] ph = PH_FILL;
    reg [31:0] errs /* synthesis keep */ = 32'd0;
    reg        started /* synthesis keep */ = 1'b0;

    // ---- free-running iteration support (SignalTap use) ----
    // With LOOP_FOREVER the test restarts forever so there is always activity to
    // trigger on. `runs` counts completed iterations and `running` marks an
    // iteration in flight, giving a clean trigger edge without needing to know
    // how far the FSM has got.
    reg [31:0] runs = 32'd0;
    reg [31:0] gapc = 32'd0;
    reg        running = 1'b0;

    assign dbg_errs    = errs;
    assign dbg_ph      = ph;
    assign dbg_st      = st;
    assign dbg_started = started;
    assign dbg_runs    = runs;
    assign dbg_running = running;
    reg [21:0] cur = 22'd0;
    reg [5:0]  row_i = 6'd0;
    reg [1:0]  rsub = 2'd0;
    reg [6:0]  bidx = 7'd0;
    reg [2:0]  bb   = 3'd0;

    // ---- expected pattern (address-derived, same function as TB pat_of) ----
    reg [21:0] expa;                  // issued word address (== cur, aliased)
    reg [15:0] exp;                   // final pattern for expa
    reg [15:0] exp_row;               // issued ROW-phase expected read value
    reg        mis /* synthesis keep */;                   // registered compare verdict (pipelined count)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            expa <= 22'd0; exp <= 16'd0;
        end else begin
            expa <= cur;
            exp  <= {cur[15:8] ^ 8'h5A, cur[7:0] ^ 8'hA5};
        end
    end

    // expected byte values in the BYTES phase
    wire [22:0] cba = byte_ba(bidx);
    wire [7:0] bx = 8'hA5 ^ cba[7:0];
    wire [7:0] by = 8'h5A ^ cba[7:0];

    // Registered copies captured at issue time (bidx stays stable across the
    // whole 7-op bb sequence). S_CMP then compares against these instead of the
    // full byte_ba adder/case chain, keeping the 200 MHz divclk domain short.
    reg [22:0] cba_r;
    reg [7:0]  bx_r, by_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            st   <= S_WAIT; ph <= PH_FILL;
            rd   <= 1'b0; we <= 1'b0;
            addr <= 23'd0; wtbt <= 2'b11; din <= 16'h0;
            errs <= 32'd0; done <= 1'b0; pass <= 1'b0; err <= 1'b0;
            cur  <= 22'd0; row_i <= 6'd0; rsub <= 2'd0; bidx <= 7'd0; bb <= 3'd0;
            cba_r <= 23'd0; bx_r <= 8'h0; by_r <= 8'h0; exp_row <= 16'h0; mis <= 1'b0;
            fe_valid <= 1'b0; fe_addr <= 23'd0; fe_exp <= 16'd0; fe_got <= 16'd0;
            fe_ph <= 2'd0; fe_bb <= 3'd0;
            started <= 1'b0;
        end else begin
            rd <= 1'b0;
            we <= 1'b0;
            mis <= 1'b0;                          // default: no pending verdict
            if (mis && errs < MAX_ERR)            // consume verdict from prior S_CMP
                errs <= errs + 32'd1;
            case (st)
                S_WAIT: if (sready) begin
                            cur <= 22'd0; ph <= PH_FILL;
                            st <= S_B1;          // settle the pattern for cur=0
                            // Latches "the bridge ever asserted ready". Stays 1
                            // even if the test later returns to S_WAIT, so a 0
                            // here proves the bridge never came up at all.
                            started <= 1'b1;
                            running <= 1'b1;
                        end

                // ---- issue one host op (strobe + address/wtbt/data) ----
                S_ISS: begin
                    case (ph)
                        PH_FILL: begin
                            addr <= {expa, 1'b0}; wtbt <= 2'b11; din <= exp; we <= 1'b1;
                        end
                        PH_CHK: begin
                            addr <= {expa, 1'b0}; wtbt <= 2'b11; rd <= 1'b1;
                        end
                        PH_ROW: begin
                            addr <= {row_addr(row_i), 1'b0}; wtbt <= 2'b11;
                            if (rsub[0]) rd <= 1'b1;
                            else begin
                                din <= (rsub[1]) ? ~16'hA55A : 16'hA55A;
                                we  <= 1'b1;
                            end
                            exp_row <= (rsub[1]) ? ~16'hA55A : 16'hA55A;
                        end
                        PH_BYT: begin
                            cba_r <= byte_ba(bidx);
                            bx_r  <= bx;
                            by_r  <= by;
                            case (bb)
                                3'd0: begin
                                    addr <= byte_ba(bidx); wtbt <= 2'b01;
                                    din  <= {8'h00, bx}; we <= 1'b1;
                                end
                                3'd1: begin
                                    addr <= byte_ba(bidx); wtbt <= 2'b10;
                                    din  <= {8'h00, by}; we <= 1'b1;
                                end
                                3'd2: begin
                                    addr <= byte_ba(bidx); wtbt <= 2'b11; rd <= 1'b1;
                                end
                                3'd3: begin
                                    addr <= byte_ba(bidx); wtbt <= 2'b01; rd <= 1'b1;
                                end
                                3'd4: begin
                                    addr <= byte_ba(bidx); wtbt <= 2'b10; rd <= 1'b1;
                                end
                                3'd5: begin
                                    addr <= byte_ba(bidx); wtbt <= 2'b00; rd <= 1'b1;
                                end
                                default: begin
                                    addr <= byte_ba(bidx) + 23'd1; wtbt <= 2'b00; rd <= 1'b1;
                                end
                            endcase
                        end
                    endcase
                    st <= S_HI0;
                end

                // ---- wait until the bridge accepted (busy) then completes ----
                S_HI0: if (!sready) st <= S_LO0;
                S_LO0: if ( sready) st <= S_CMP;

                // ---- verify (reads) and advance ----
                S_CMP: begin
                    case (ph)
                        PH_FILL: begin
                            if (cur == N_WORDS[21:0] - 22'd1) begin
                                cur <= 22'd0; ph <= PH_CHK;
                                st <= S_B1;                  // settle for cur=0
                            end else begin
                                cur <= cur + 22'd1; st <= S_B1;
                            end
                        end
                        PH_CHK: begin
                            if (dout != exp) begin
                                mis <= 1'b1;
                                err <= 1'b1;
                                notify_mismatch({expa, 1'b0}, exp, dout, "check");
                                note_fail({expa, 1'b0}, exp, dout);
                            end
                            if (cur == N_WORDS[21:0] - 22'd1) begin
                                cur <= 22'd0; row_i <= 6'd0; rsub <= 2'd0;
                                ph  <= PH_ROW;
                                st  <= S_ISS;
                            end else begin
                                cur <= cur + 22'd1; st <= S_B1;
                            end
                        end
                        PH_ROW: begin
                            if (rsub[0] && dout != exp_row) begin
                                mis <= 1'b1;
                                err <= 1'b1;
                                notify_mismatch({row_addr(row_i), 1'b0},
                                                exp_row,
                                                dout, "row");
                                note_fail({row_addr(row_i), 1'b0}, exp_row, dout);
                            end
                            if (rsub == 2'd3) begin
                                rsub <= 2'd0;
                                if (row_i == 6'd23) begin
                                    bidx <= 7'd0; bb <= 3'd0; ph <= PH_BYT;
                                    st   <= S_ISS;
                                end else begin
                                    row_i <= row_i + 6'd1; st <= S_ISS;
                                end
                            end else begin
                                rsub <= rsub + 2'd1; st <= S_ISS;
                            end
                        end
                        PH_BYT: begin
                            case (bb)
                                3'd0, 3'd1: ;        // writes: no verify
                                3'd2: if (dout != {by_r, bx_r}) begin
                                        mis <= 1'b1;
                                        err <= 1'b1;
                                        notify_mismatch(cba_r, {by_r, bx_r}, dout, "byte-word");
                                        note_fail(cba_r, {by_r, bx_r}, dout);
                                      end
                                3'd3: if (dout[7:0] != bx_r) begin
                                        mis <= 1'b1;
                                        err <= 1'b1;
                                        notify_mismatch(cba_r, bx_r, dout[7:0], "byte-even");
                                        note_fail(cba_r, bx_r, dout[7:0]);
                                      end
                                3'd4: if (dout[7:0] != by_r) begin
                                        mis <= 1'b1;
                                        err <= 1'b1;
                                        notify_mismatch(cba_r, by_r, dout[7:0], "byte-odd");
                                        note_fail(cba_r, by_r, dout[7:0]);
                                      end
                                3'd5: if (dout[7:0] != bx_r) begin
                                        mis <= 1'b1;
                                        err <= 1'b1;
                                        notify_mismatch(cba_r, bx_r, dout[7:0], "byte-00");
                                        note_fail(cba_r, bx_r, dout[7:0]);
                                      end
                                default: if (dout[7:0] != by_r) begin
                                        mis <= 1'b1;
                                        err <= 1'b1;
                                        notify_mismatch(cba_r + 23'd1, by_r, dout[7:0], "byte-01");
                                        note_fail(cba_r + 23'd1, by_r, dout[7:0]);
                                      end
                            endcase
                            if (bb == 3'd6) begin
                                bb <= 3'd0;
                                if (bidx == N_BA - 7'd1) begin
                                    // Terminal transition: every phase has run.
                                    // Going back to S_WAIT instead (as this line
                                    // once did) restarts PH_FILL forever, so
                                    // done/pass/err never assert and anything
                                    // waiting on done hangs.
                                    st   <= S_END;
                                end else begin
                                    bidx <= bidx + 7'd1; st <= S_ISS;
                                end
                            end else begin
                                bb <= bb + 3'd1; st <= S_ISS;
                            end
                        end
                    endcase
                end

                S_B1: st <= S_B2;
                S_B2: st <= S_B3;
                S_B3: st <= S_ISS;
                S_END: begin done <= 1'b1; pass <= (err == 1'b0); st <= S_DONE; end

                // With LOOP_FOREVER, restart instead of latching the result, so
                // there is always bus activity to trigger SignalTap on. The
                // iteration is separated from the next by GAP_CYCLES of idle so
                // `dbg_running` gives a clean, unambiguous trigger edge and a
                // capture can be taken from any point in the run.
                S_DONE: begin
                    if (LOOP_FOREVER == 0) begin
                        st <= S_DONE;          // terminal, as before
                    end else if (done) begin
                        // Hold the result for the gap, then re-arm.
                        if (gapc == GAP_CYCLES[31:0] - 1) begin
                            gapc   <= 32'd0;
                            done   <= 1'b0;
                            pass   <= 1'b0;
                            err    <= 1'b0;
                            running<= 1'b0;
                            runs   <= runs + 32'd1;
                            cur <= 22'd0; row_i <= 6'd0; rsub <= 2'd0;
                            bidx <= 7'd0; bb <= 3'd0;
                            ph <= PH_FILL;
                            st <= S_WAIT;
                        end else begin
                            gapc <= gapc + 32'd1;
                        end
                    end else begin
                        st <= S_DONE;
                    end
                end

                default: st <= S_DONE;
            endcase
        end
    end

`ifndef SYNTHESIS
    reg sdone_printed = 1'b0;
    always @(posedge clk) begin
        if (st == S_DONE && !sdone_printed) begin
            sdone_printed <= 1'b1;
            if (pass) $display("TEST PASS (errs=0, id=0x%02h)", id);
            else      $display("TEST FAIL: %0d errors (id=0x%02h)", errs, id);
        end
        if (st != S_DONE) sdone_printed <= 1'b0;
    end
`endif

endmodule