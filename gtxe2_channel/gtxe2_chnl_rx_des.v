/*******************************************************************************
 * Module: gtxe2_chnl_rx_des
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: 1xwidth deserializer
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_rx_des.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_rx_des.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
`include "resync_fifo_nonsynt.v"
module gtxe2_chnl_rx_des #(
    parameter [31:0] width = 20
)
(
    input   wire                    reset,
    input   wire                    inclk,
    input   wire                    outclk,
    input   wire                    indata,
    output  wire    [width - 1:0]   outdata
);

reg     [31:0]          bitcounter;
reg     [width - 1:0]   inbuffer;
wire                    empty_rd;
wire                    full_wr;
wire                    val_wr;
wire                    val_rd;

always @ (posedge inclk)
    bitcounter  <= reset | bitcounter == (width - 1) ? 32'h0 : bitcounter + 1'b1;

genvar ii;
generate
for (ii = 0; ii < width; ii = ii + 1)
begin: splicing
    always @ (posedge inclk)
        inbuffer[ii] <= reset ? 1'b0 : (bitcounter == ii) ? indata : inbuffer[ii];
end
endgenerate

assign  val_rd  = ~empty_rd & ~almost_empty_rd;
assign  val_wr  = ~full_wr & bitcounter == (width - 1);

always @ (posedge inclk)
    if (full_wr)
    begin
        $display("FIFO in %m is full, that is not an appropriate behaviour");
        $finish;
    end

resync_fifo_nonsynt #(
    .width      (width),
    .log_depth  (3)
)
fifo(
    .rst_rd     (reset),
    .rst_wr     (reset),
    .clk_wr     (inclk),
    .val_wr     (val_wr),
    .data_wr    ({indata, inbuffer[width - 2:0]}),
    .clk_rd     (outclk),
    .val_rd     (val_rd),
    .data_rd    (outdata),

    .empty_rd   (empty_rd),
    .full_wr    (full_wr),

    .almost_empty_rd (almost_empty_rd)
);


endmodule
