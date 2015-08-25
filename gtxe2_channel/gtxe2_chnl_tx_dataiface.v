/*******************************************************************************
 * Module: gtxe2_chnl_tx_dataiface
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: input data @ usrclk2 -> inner data @ usrclk, widths changes respectively
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_tx_dataiface.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_tx_dataiface.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
/*
 * According to the doc, p110
 * If TX_INT_DATAWIDTH, the inner width = 32 bits, otherwise 16.
 */

module gtxe2_chnl_tx_dataiface #(
    parameter   internal_data_width = 16,
    parameter   interface_data_width = 32,
    parameter   internal_isk_width = 2,
    parameter   interface_isk_width = 4
)
(
    input   wire    usrclk,
    input   wire    usrclk2,
    input   wire    reset,
    output  wire    [internal_data_width - 1:0]     outdata,
    output  wire    [internal_isk_width - 1:0]      outisk,
    input   wire    [interface_data_width - 1:0]    indata,
    input   wire    [interface_isk_width - 1:0]     inisk
);

localparam div = interface_data_width / internal_data_width;

wire    [interface_data_width + interface_isk_width - 1:0] data_resynced;

reg     [31:0]          wordcounter;
wire                    almost_empty_rd;
wire                    empty_rd;
wire                    full_wr;
wire                    val_rd;

always @ (posedge usrclk)
    wordcounter <= reset | wordcounter == (div - 1) ? 32'h0 : wordcounter + 1'b1;
 

assign  outdata = data_resynced[(wordcounter + 1) * internal_data_width - 1 -: internal_data_width];
assign  outisk  = data_resynced[(wordcounter + 1) * internal_isk_width + internal_data_width * div - 1 -: internal_isk_width];
assign  val_rd  = ~almost_empty_rd & ~empty_rd & wordcounter == (div - 1);

resync_fifo_nonsynt #(
    .width      (interface_data_width + interface_isk_width),
    .log_depth  (3)
)
fifo(
    .rst_rd     (reset),
    .rst_wr     (reset),
    .clk_wr     (usrclk2),
    .val_wr     (1'b1),
    .data_wr    ({inisk, indata}),
    .clk_rd     (usrclk),
    .val_rd     (val_rd),
    .data_rd    ({data_resynced}),

    .empty_rd   (empty_rd),
    .full_wr    (full_wr),

    .almost_empty_rd   (almost_empty_rd)
);

endmodule
