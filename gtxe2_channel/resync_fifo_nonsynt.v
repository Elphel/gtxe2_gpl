/*******************************************************************************
 * Module: resync_fifo_nonsynt
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: non-synthesizable resyncronization fifo
 *
 * Copyright (c) 2015 Elphel, Inc.
 * resync_fifo_nonsynt.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * resync_fifo_nonsynt.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
// simplified resynchronisation fifo, could cause metastability
// because of that shall not be syntesisable
// TODO add shift registers and gray code to fix that
`ifndef RESYNC_FIFO_NOSYNT_V
`define RESYNC_FIFO_NOSYNT_V
module resync_fifo_nonsynt #(
    parameter [31:0] width = 20,
    //parameter [31:0] depth = 7
    parameter [31:0] log_depth = 3
)
(
    input   wire                        rst_rd,
    input   wire                        rst_wr,
    input   wire                        clk_wr,
    input   wire                        val_wr,
    input   wire    [width - 1:0]       data_wr,
    input   wire                        clk_rd,
    input   wire                        val_rd,
    output  wire    [width - 1:0]       data_rd,

    output  wire                        empty_rd,
    output  wire                        almost_empty_rd,
    output  wire                        full_wr
);
/*
function integer clogb2;
    input [31:0] value;
    begin
        value = value - 1;
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
            value = value >> 1;
        end
    end
endfunction

localparam  log_depth = clogb2(depth);
*/
localparam  depth = 1 << log_depth;

reg     [width -1:0]        fifo [depth - 1:0];
// wr_clk domain
reg     [log_depth - 1:0]   cnt_wr;
// rd_clk domain
reg     [log_depth - 1:0]   cnt_rd;

assign  data_rd           = fifo[cnt_rd];
assign  empty_rd          = cnt_wr == cnt_rd;
assign  full_wr           = (cnt_wr + 1'b1) == cnt_rd;
assign  almost_empty_rd   = (cnt_rd + 1'b1) == cnt_wr;

always @ (posedge clk_wr)
    fifo[cnt_wr] <= val_wr ? data_wr : fifo[cnt_wr];

always @ (posedge clk_wr)
    cnt_wr      <= rst_wr ? 0 : val_wr ? cnt_wr + 1'b1 : cnt_wr;

always @ (posedge clk_rd)
    cnt_rd      <= rst_rd ? 0 : val_rd ? cnt_rd + 1'b1 : cnt_rd;

endmodule
`endif
