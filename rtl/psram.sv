`timescale 1ns/1ps

module psram #(
    parameter integer PWRUP_CYCLES = 30000,   // ~208 us @144 MHz
    parameter integer RST_CYCLES   = 4000,    // tRST guard
    parameter integer MID_CYCLES   = 100      // inter-op gap
) (
    input clk,
    input reset,
    input init,

    output reg ce_n,
    output reg [3:0] sio_out,
    output reg [3:0] sio_oe,
    input [3:0] sio_in,
    
    input [22:0] addr,
    input [1:0]  wtbt,
    input rd,
    input we,
    input [15:0] din,
    output reg [15:0] dout,
    output ready
);

    localparam [1:0]
        SPI_BYTE = 2'd0,
        WR2 = 2'd2,
        RD2 = 2'd3;

    localparam [2:0]
        ST_PWRUP = 3'd0,
        ST_RSTEN = 3'd1,
        ST_RST_WAIT = 3'd2,
        ST_RST = 3'd3,
        ST_QPIEN = 3'd4,
        ST_RDY = 3'd5;

    reg [2:0] st = ST_PWRUP;
    reg [31:0] waitc = 0;

    reg pwrup_ok = 1'b0;
    reg mid_ok = 1'b0;
    
    always @(posedge clk) begin
        pwrup_ok <= (waitc == PWRUP_CYCLES);
        mid_ok   <= (waitc == MID_CYCLES);
    end

    reg [1:0] fop = SPI_BYTE;
    reg [6:0] fpcnt = 7'd0;
    integer flen_m1;
    reg framer = 1'b0;
    reg fend = 1'b0;
    reg fword = 1'b0;

    reg [7:0] s_cmd = 8'h00;
    reg [23:0] raddr = 24'h0;
    reg [7:0] wd0 = 8'h00;
    reg [7:0] wd1 = 8'h00;

    reg old_rd = 1'b0;
    reg old_we = 1'b0;
    reg old_init = 1'b0;

    function automatic [3:0] addr_nib(input [23:0] v, input integer n);
        addr_nib = v[(23 - 4*n) -: 4];
    endfunction

    // nibble presented for period p+1 (one period ahead of the latch)
    function automatic [3:0] drive_val(input [1:0] op, input [6:0] p);
        begin
            case (op)
                SPI_BYTE: drive_val = {3'b000, s_cmd[7 - p[2:0]]};
                WR2: begin
                    case (p[3:0])
                        4'h0:    drive_val = 4'h0;
                        4'h1:    drive_val = 4'h2;
                        4'h2,4'h3,4'h4,4'h5,4'h6,4'h7:
                                 drive_val = addr_nib(raddr, p-2);
                        4'h8:    drive_val = wd0[7:4];
                        4'h9:    drive_val = wd0[3:0];
                        4'ha:    drive_val = wd1[7:4];
                        default: drive_val = wd1[3:0];
                    endcase
                end
                RD2: begin
                    case (p[3:0])
                        4'h0:    drive_val = 4'he;
                        4'h1:    drive_val = 4'hb;
                        4'h2,4'h3,4'h4,4'h5,4'h6,4'h7:
                                 drive_val = addr_nib(raddr, p-2);
                        default: drive_val = 4'h0;
                    endcase
                end
                default: drive_val = 4'h0;
            endcase
        end
    endfunction

    // First period whose returned data we capture.
    function automatic [6:0] cap_first(input [1:0] op);
        case (op)
            RD2: cap_first = 7'd15;
            default: cap_first = 7'd0;
        endcase
    endfunction

    // How many nibbles the frame returns.
    function automatic [6:0] cap_count(input [1:0] op);
        case (op)
            RD2:  cap_count = fword ? 7'd4 : 7'd2;
            default: cap_count = 7'd0;
        endcase
    endfunction

    function automatic bit is_rd(input [1:0] op);
        is_rd = (op == RD2);
    endfunction

    // release the bus one period before the first read nibble is returned
    function automatic bit pre_capture(input [1:0] op, input [6:0] p);
        begin
            pre_capture = 1'b0;
            case (op)
                RD2:  if (p == 7'd14) pre_capture = 1'b1;  // for cap_first==15
                default: ;
            endcase
        end
    endfunction

    reg cap_en_s = 1'b0;

    always @(posedge clk or posedge reset) begin
        if (reset) cap_en_s <= 1'b0;
        else cap_en_s <= framer && is_rd(fop) &&
            (fpcnt >= cap_first(fop)) &&
            (fpcnt < cap_first(fop) + cap_count(fop));
    end

    // ------------------------------------------------------- TX / engine core
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ce_n <= 1'b1;
            sio_oe <= 4'h0;
            framer <= 1'b0;
            fend <= 1'b0;
            old_rd <= 1'b0;
            old_we <= 1'b0;
            old_init <= 1'b0;
            fword <= 1'b0;
            fpcnt <= 7'd0;
            sio_out <= 4'h0;
        end else begin
            old_rd <= rd;
            old_we <= we;
            old_init <= init;

            if (framer) begin
                // ---- present the NEXT period's nibble (one period ahead) ----
                sio_out <= drive_val(fop, fpcnt + 7'd1);
                sio_oe  <= (pre_capture(fop, fpcnt + 7'd1) ||
                            (is_rd(fop) && (fpcnt + 7'd1) >= cap_first(fop)))
                           ? 4'h0 : 4'hf;
                // ---- advance ----
                if (fpcnt == flen_m1) begin
                    framer <= 1'b0;
                    ce_n   <= 1'b1;
                    sio_oe <= 4'h0;
                    fend   <= 1'b1;
                end else begin
                    fpcnt <= fpcnt + 7'd1;
                end
            end

            // ---- frame completion: one period after framer drops ----
            // fend is the init FSM's "frame done" pulse and the read-result
            // assembly edge. The capture window closes well before frame end,
            // so rnib is already final and a single drain cycle is enough.
            if (fend) begin
                fend <= 1'b0;
                if (is_rd(fop)) begin
                    // device sends MSB nibble first: n0=b0hi n1=b0lo n2=b1hi n3=b1lo
                    if (fword) dout <= {rnib[2], rnib[3], rnib[0], rnib[1]};
                    else       dout <= {8'h0, rnib[0], rnib[1]};
                end
            end

            // ---- master state machine ----
            case (st)
                ST_PWRUP: begin
                    if (pwrup_ok) begin
                        waitc <= 0; st <= ST_RSTEN;
                        frame_go(SPI_BYTE, 8, 8'h66, 24'h0, 8'h0, 8'h0);
                    end else waitc <= waitc + 32'd1;
                end
                ST_RSTEN: if (fend) begin waitc <= 0; st <= ST_RST_WAIT; end
                ST_RST_WAIT: begin
                    if (mid_ok) begin
                        waitc <= 0; st <= ST_RST;
                        frame_go(SPI_BYTE, 8, 8'h99, 24'h0, 8'h0, 8'h0);
                    end else waitc <= waitc + 32'd1;
                end
                ST_RST: if (fend) begin waitc <= 0; st <= ST_QPIEN; end
                ST_QPIEN: begin
                    if (mid_ok) begin
                        waitc <= 0; st <= ST_RDY;
                        frame_go(SPI_BYTE, 8, 8'h35, 24'h0, 8'h0, 8'h0);
                    end else waitc <= waitc + 32'd1;
                end
                ST_RDY: begin
                    // ready must not rise until the result is assembled: fend
                    // is still set for the assembly period, so gating on
                    // framer/fend alone lets a host sample dout too early.
                    if (~framer && ~fend) begin
                        if (rd && ~old_rd) begin
                            fword <= (wtbt == 2'b11);
                            if (wtbt == 2'b11)
                                frame_go(RD2, 20, 8'heb,
                                         {1'b0,addr[22:1],1'b0}, 8'h0, 8'h0);
                            else
                                frame_go(RD2, 18, 8'heb,
                                         {1'b0,addr[22:1],
                                          (wtbt==2'b00)?addr[0]:
                                          (wtbt==2'b10)?1'b1:1'b0}, 8'h0,8'h0);
                        end else if (we && ~old_we) begin
                            if (wtbt == 2'b11)
                                frame_go(WR2, 12, 8'h02, {1'b0,addr[22:1],1'b0},
                                         din[7:0], din[15:8]);
                            else
                                frame_go(WR2, 10, 8'h02,
                                         {1'b0,addr[22:1],
                                          (wtbt==2'b00)?addr[0]:
                                          (wtbt==2'b10)?1'b1:1'b0},
                                         din[7:0], din[7:0]);
                        end
                    end
                end
                default:;
            endcase

            if (old_init && ~init && ~framer && st == ST_RDY) begin
                st <= ST_PWRUP; waitc <= 0; ce_n <= 1'b1;
            end
        end
    end
    assign ready = st == ST_RDY && framer == 1'b0 && fend == 1'b0;
    
    task automatic frame_go(input [1:0] op, input integer len,
                            input [7:0] cmd, input [23:0] ba,
                            input [7:0] d0, input [7:0] d1);
        begin
            fop <= op;
            flen_m1 = len - 1;
            s_cmd = cmd;
            raddr = ba;
            wd0 = d0;
            wd1 = d1;
            framer  <= 1'b1;
            ce_n    <= 1'b0;
            fpcnt   <= 7'd0;
            sio_out <= drive_val(op, 7'd0);
            sio_oe  <= (is_rd(op) && 7'd0 >= cap_first(op)) ? 4'h0 : 4'hf;
        end
    endtask

    reg [3:0]  rnib [0:3];
    reg [1:0]  nidx = 2'd0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rnib[0] <= 4'h0;
            rnib[1] <= 4'h0;
            rnib[2] <= 4'h0;
            rnib[3] <= 4'h0;
            nidx    <= 2'd0;
        end else begin
            if (cap_en_s) begin
                rnib[nidx] <= sio_in[3:0];
                nidx <= nidx + 2'd1;
            end else begin
                nidx <= 2'd0;   // idle -> ready for the next read frame
            end
        end
    end

endmodule