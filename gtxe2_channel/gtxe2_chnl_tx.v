/*******************************************************************************
 * Module: gtxe2_chnl_tx
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: transmitter top-level, includes polarity-inversion, bit-reordering
 *              and elecidle logic
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_tx.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_tx.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
`include "gtxe2_chnl_tx_ser.v"
`include "gtxe2_chnl_tx_8x10enc.v"
`include "gtxe2_chnl_tx_oob.v"
module gtxe2_chnl_tx(
    input   wire            reset,
    output  wire            TXP,
    output  wire            TXN,

    input   wire    [63:0]  TXDATA,
    input   wire            TXUSRCLK,
    input   wire            TXUSRCLK2,

// 8/10 encoder
    input   wire    [7:0]   TX8B10BBYPASS,
    input   wire            TX8B10BEN,
    input   wire    [7:0]   TXCHARDISPMODE,
    input   wire    [7:0]   TXCHARDISPVAL,
    input   wire    [7:0]   TXCHARISK,

// TX Buffer
    output  wire    [1:0]   TXBUFSTATUS,

// TX Polarity
    input   wire            TXPOLARITY,

// TX Fabric Clock Control
    input   wire    [2:0]   TXRATE,
    output  wire            TXRATEDONE,

// TX OOB
    input   wire            TXCOMINIT,
    input   wire            TXCOMWAKE,
    output  wire            TXCOMFINISH,

// TX Driver Control
    input   wire            TXELECIDLE,

// internal
    input   wire            serial_clk
);
parameter   TX_DATA_WIDTH       = 20;
parameter   TX_INT_DATAWIDTH    = 0;
parameter   PTX8B10BEN           = 1;

parameter   [3:0]   SATA_BURST_SEQ_LEN = 4'b1111;
parameter           SATA_CPLL_CFG = "VCO_3000MHZ";

function integer calc_idw;
    input   TX8B10BEN;
//    input   TX_INT_DATAWIDTH;
//    input   TX_DATA_WIDTH;
    begin
    if (TX8B10BEN == 1)
        calc_idw = TX_INT_DATAWIDTH == 1 ? 40 : 20;
    else
    begin
        if (TX_INT_DATAWIDTH == 1)
            calc_idw    = TX_DATA_WIDTH == 32 ? 32
                        : TX_DATA_WIDTH == 40 ? 40
                        : TX_DATA_WIDTH == 64 ? 32 : 40;
        else
            calc_idw    = TX_DATA_WIDTH == 16 ? 16  
                        : TX_DATA_WIDTH == 20 ? 20 
                        : TX_DATA_WIDTH == 32 ? 16 : 20;
    end
    end
endfunction

localparam  internal_data_width = calc_idw(PTX8B10BEN);//, TX_INT_DATAWIDTH, TX_DATA_WIDTH);

// TX PMA

// serializer
wire    serial_data;
wire    line_idle;
wire    line_idle_pcs; // line_idle in pcs clock domain
wire    [internal_data_width - 1:0] ser_input;
wire    oob_active;

assign  TXP = ~line_idle ? serial_data : 1'bx;
assign  TXN = ~line_idle ? ~serial_data : 1'bx;


assign  line_idle_pcs = TXELECIDLE & ~oob_active | reset;

// Serializer
wire    [internal_data_width - 1:0] parallel_data;
wire    [internal_data_width - 1:0] inv_parallel_data;

gtxe2_chnl_tx_ser #(
    .width      (internal_data_width)
)
ser(
    .reset      (reset),
    .inclk      (TXUSRCLK),
    .outclk     (serial_clk),
    .indata     (inv_parallel_data),
    .idle_in    (line_idle_pcs),
    .outdata    (serial_data),
    .idle_out   (line_idle)
);

// TX PCS

// invert data (get words as [abdceifghj] after 8/10, each word shall be transmitter in a reverse bit order)
genvar ii;
genvar jj;
generate
    for (ii = 0; ii < internal_data_width; ii = ii + 10)
    begin: select_each_word
        for (jj = 0; jj < 10; jj = jj + 1)
        begin: reverse_bits
            assign inv_parallel_data[ii + jj] = polarized_data[ii + 9 - jj];
        end
    end
endgenerate

// Polarity:
wire    [internal_data_width - 1:0] polarized_data;

assign  ser_input = polarized_data;
generate
for (ii = 0; ii < internal_data_width; ii = ii + 1)
begin: invert_dataword
    assign polarized_data[ii] = TXPOLARITY == 1'b1 ? ~parallel_data[ii] : parallel_data[ii];
end
endgenerate


// SATA OOB
reg                                 disparity;
wire    [internal_data_width - 1:0] oob_data;
wire                                oob_val;

assign  oob_active = oob_val;
gtxe2_chnl_tx_oob #(
    .width  (internal_data_width)
)
tx_oob(
    .TXCOMINIT      (TXCOMINIT),
    .TXCOMWAKE      (TXCOMWAKE),
    .TXCOMFINISH    (TXCOMFINISH),

    .clk            (TXUSRCLK),
    .reset          (reset),
    .disparity      (disparity),
    .outdata        (oob_data),
    .outval         (oob_val)
);

// Disparity control
wire    next_disparity;
always @ (posedge TXUSRCLK)
    disparity <= reset | line_idle_pcs? 1'b0 : oob_val ? ~disparity : next_disparity;

// 8/10 endoding
wire    [internal_data_width - 1:0] encoded_data;
gtxe2_chnl_tx_8x10enc #(
    .iwidth     (16),//TX_DATA_WIDTH),
    .owidth     (internal_data_width)
)
encoder_8x10(
    .TX8B10BBYPASS      (TX8B10BBYPASS),
    .TX8B10BEN          (TX8B10BEN),
    .TXCHARDISPMODE     (TXCHARDISPMODE),
    .TXCHARDISPVAL      (TXCHARDISPVAL),
    .TXCHARISK          (TXCHARISK),
    .disparity          (disparity),
    .data_in            (TXDATA[15:0]),
    .data_out           (encoded_data),
    .next_disparity     (next_disparity)
);

// OOB-OrdinaryData Arbiter
assign  parallel_data = oob_val ? oob_data : encoded_data;


endmodule
