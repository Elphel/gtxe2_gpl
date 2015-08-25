/*******************************************************************************
 * Module: gtxe2_chnl_rx_dataiface
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: output data @ usrclk2 <- inner data @ usrclk, widths changes respectively
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_rx_dataiface.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_rx_dataiface.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
/*
 * According to the doc, p110
 * If RX_INT_DATAWIDTH, the inner width = 32 bits, otherwise 16.
 */

module gtxe2_chnl_rx_dataiface #(
    parameter   internal_data_width = 16,
    parameter   interface_data_width = 32,
    parameter   internal_isk_width = 2,
    parameter   interface_isk_width = 4
)
(
    input   wire    usrclk,
    input   wire    usrclk2,
    input   wire    reset,
    output  wire    [interface_data_width - 1:0]    outdata,
    output  wire    [interface_isk_width - 1:0]     outisk,
    input   wire    [internal_data_width - 1:0]     indata,
    input   wire    [internal_isk_width - 1:0]      inisk,
    input   wire                                    realign
);

localparam div = interface_data_width / internal_data_width;
localparam internal_total_width = internal_data_width + internal_isk_width;
localparam interface_total_width = interface_data_width + interface_isk_width;

reg     [interface_data_width - 1:0]   inbuffer_data;
reg     [interface_isk_width - 1:0]    inbuffer_isk;
reg     [31:0]          wordcounter;
wire                    empty_rd;
wire                    full_wr;
wire                    val_wr;
wire                    val_rd;

always @ (posedge usrclk)
    wordcounter  <= reset ? 32'h0 : realign & ~(div == 0) ? 31'b1 : wordcounter == (div - 1) ? 32'h0 : wordcounter + 1'b1;

genvar ii;
generate
for (ii = 0; ii < div; ii = ii + 1)
begin: splicing
    always @ (posedge usrclk)
        inbuffer_data[(ii + 1) * internal_data_width - 1 -: internal_data_width] <= reset ? {interface_data_width{1'b0}} : ((wordcounter == ii) | realign & (0 == ii)) ? indata : inbuffer_data[(ii + 1) * internal_data_width - 1 -: internal_data_width];
end
endgenerate
generate
for (ii = 0; ii < div; ii = ii + 1)
begin: splicing2
    always @ (posedge usrclk)
        inbuffer_isk[(ii + 1) * internal_isk_width - 1 -: internal_isk_width] <= reset ? {interface_isk_width{1'b0}} : ((wordcounter == ii) | realign & (0 == ii)) ? inisk : inbuffer_isk[(ii + 1) * internal_isk_width - 1 -: internal_isk_width];
end
endgenerate

assign  val_rd  = ~empty_rd & ~almost_empty_rd;
assign  val_wr  = ~full_wr & wordcounter == (div - 1);

always @ (posedge usrclk)
    if (full_wr)
    begin
        $display("FIFO in %m is full, that is not an appropriate behaviour");
        $finish;
    end

wire    [interface_total_width - 1:0] resync;
assign  outdata = resync[interface_data_width - 1:0];
assign  outisk  = resync[interface_data_width + interface_isk_width - 1:interface_data_width];

resync_fifo_nonsynt #(
    .width      (interface_total_width),
    .log_depth  (3)
)
fifo(
    .rst_rd     (reset),
    .rst_wr     (reset),
    .clk_wr     (usrclk2),
    .val_wr     (val_wr),
    .data_wr    ({inisk, inbuffer_isk[interface_isk_width - internal_isk_width - 1 : 0], indata, inbuffer_data[interface_data_width - internal_data_width - 1 : 0]}),
    .clk_rd     (usrclk2),
    .val_rd     (val_rd),
    .data_rd    (resync),

    .empty_rd   (empty_rd),
    .full_wr    (full_wr),

    .almost_empty_rd (almost_empty_rd)
);

endmodule
