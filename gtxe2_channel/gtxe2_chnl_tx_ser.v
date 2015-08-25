/*******************************************************************************
 * Module: gtxe2_chnl_tx_ser
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: widthx1 serializer
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_tx_ser.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_tx_ser.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
`include "resync_fifo_nonsynt.v"
module gtxe2_chnl_tx_ser #(
    parameter [31:0] width = 20
)
(
    input   wire                    reset,
    input   wire                    inclk,
    input   wire                    outclk,
    input   wire    [width - 1:0]   indata,
    input   wire                    idle_in,
    output  wire                    outdata,
    output  wire                    idle_out
);

reg     [31:0]          bitcounter;
wire    [width - 1:0]   data_resynced;
wire                    almost_empty_rd;
wire                    empty_rd;
wire                    full_wr;
wire                    val_rd;

always @ (posedge outclk)
    bitcounter  <= reset | bitcounter == (width - 1) ? 32'h0 : bitcounter + 1'b1;
 
assign  outdata = data_resynced[bitcounter];
assign  val_rd  = ~almost_empty_rd & ~empty_rd & bitcounter == (width - 1);

resync_fifo_nonsynt #(
    .width      (width + 1), // +1 is for a flag of an idle line (both TXP and TXN = 0)
    .log_depth  (3)
)
fifo(
    .rst_rd     (reset),
    .rst_wr     (reset),
    .clk_wr     (inclk),
    .val_wr     (1'b1),
    .data_wr    ({idle_in, indata}),
    .clk_rd     (outclk),
    .val_rd     (val_rd),
    .data_rd    ({idle_out, data_resynced}),

    .empty_rd   (empty_rd),
    .full_wr    (full_wr),

    .almost_empty_rd   (almost_empty_rd)
);


endmodule
