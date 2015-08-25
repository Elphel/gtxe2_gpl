/*******************************************************************************
 * Module: gtxe2_chnl_rx
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: reciever top-level. Also includes polarity-inversion logic
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_rx.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_rx.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
 /**
  * For now contains only deserializer, oob, 10x8 decoder, aligner and polarity invertor blocks
  **/
`include "gtxe2_chnl_rx_des.v"
`include "gtxe2_chnl_rx_oob.v"
`include "gtxe2_chnl_rx_10x8dec.v"
`include "gtxe2_chnl_rx_align.v"
`include "gtxe2_chnl_rx_dataiface.v"
module gtxe2_chnl_rx(
    input   wire            reset,
    input   wire            RXP,
    input   wire            RXN,
    
    input   wire            RXUSRCLK,
    input   wire            RXUSRCLK2,

    output  wire    [63:0]  RXDATA,

// oob
    input   wire    [1:0]   RXELECIDLEMODE,
    output  wire            RXELECIDLE,

    output  wire            RXCOMINITDET,
    output  wire            RXCOMWAKEDET,

// polarity
    input   wire            RXPOLARITY,

// aligner
    output  wire            RXBYTEISALIGNED,
    output  wire            RXBYTEREALIGN,
    output  wire            RXCOMMADET,

    input   wire            RXCOMMADETEN,
    input   wire            RXPCOMMAALIGNEN,
    input   wire            RXMCOMMAALIGNEN,

// 10/8 decoder
    input   wire            RX8B10BEN,

    output  wire    [7:0]   RXCHARISCOMMA,
    output  wire    [7:0]   RXCHARISK,
    output  wire    [7:0]   RXDISPERR,
    output  wire    [7:0]   RXNOTINTABLE,

// internal
    input   wire            serial_clk

);

parameter   integer RX_DATA_WIDTH       = 20;
parameter   integer RX_INT_DATAWIDTH    = 0;
parameter   integer PRX8B10BEN           = 1;

parameter   DEC_MCOMMA_DETECT = "TRUE";
parameter   DEC_PCOMMA_DETECT = "TRUE";

parameter   [9:0]   ALIGN_MCOMMA_VALUE  = 10'b1010000011;
parameter           ALIGN_MCOMMA_DET    = "TRUE";
parameter   [9:0]   ALIGN_PCOMMA_VALUE  = 10'b0101111100;
parameter           ALIGN_PCOMMA_DET    = "TRUE";
parameter   [9:0]   ALIGN_COMMA_ENABLE  = 10'b1111111111;
parameter           ALIGN_COMMA_DOUBLE  = "FALSE";

function integer calc_idw;
    input   RX8B10BEN;
    input   RX_INT_DATAWIDTH;
    input   RX_DATA_WIDTH;
    begin
        if (RX8B10BEN == 1)
            calc_idw = RX_INT_DATAWIDTH == 1 ? 40 : 20;
        else
        begin
            if (RX_INT_DATAWIDTH == 1)
                calc_idw    = RX_DATA_WIDTH == 32 ? 32
                            : RX_DATA_WIDTH == 40 ? 40
                            : RX_DATA_WIDTH == 64 ? 32 : 40;
            else
                calc_idw    = RX_DATA_WIDTH == 16 ? 16  
                            : RX_DATA_WIDTH == 20 ? 20 
                            : RX_DATA_WIDTH == 32 ? 16 : 20;
        end
    end
endfunction

localparam  internal_data_width = calc_idw(PRX8B10BEN, RX_INT_DATAWIDTH, RX_DATA_WIDTH);

// OOB
gtxe2_chnl_rx_oob #(
    .width          (internal_data_width)
)
rx_oob(
    .reset          (reset),
    .clk            (serial_clk),
    .usrclk2        (RXUSRCLK2),
    .RXN            (RXN),
    .RXP            (RXP),

    .RXELECIDLEMODE (RXELECIDLEMODE),
    .RXELECIDLE     (RXELECIDLE),

    .RXCOMINITDET   (RXCOMINITDET),
    .RXCOMWAKEDET   (RXCOMWAKEDET)
);

// Polarity
// no need to invert data after a deserializer, no need to resync or make a buffer trigger for simulation
wire    indata_ser;
assign  indata_ser = RXPOLARITY ^ RXP;

// due to non-syntasisable usage, CDR is missing

// deserializer
wire    [internal_data_width - 1:0] parallel_data;
gtxe2_chnl_rx_des #(
    .width      (internal_data_width)
)
des(
    .reset      (reset),
    .inclk      (serial_clk),
    .outclk     (RXUSRCLK),
    .indata     (indata_ser),
    .outdata    (parallel_data)
);

// aligner
wire    [internal_data_width - 1:0] aligned_data;
gtxe2_chnl_rx_align #(
    .width                  (internal_data_width),
    .ALIGN_MCOMMA_VALUE     (ALIGN_MCOMMA_VALUE),
    .ALIGN_MCOMMA_DET       (ALIGN_MCOMMA_DET),
    .ALIGN_PCOMMA_VALUE     (ALIGN_PCOMMA_VALUE),
    .ALIGN_PCOMMA_DET       (ALIGN_PCOMMA_DET),
    .ALIGN_COMMA_ENABLE     (ALIGN_COMMA_ENABLE),
    .ALIGN_COMMA_DOUBLE     (ALIGN_COMMA_DOUBLE)
)
aligner(
    .clk                (RXUSRCLK),
    .rst                (reset),
    .indata             (parallel_data),
    .outdata            (aligned_data),

    .rxelecidle         (RXELECIDLE),

    .RXBYTEISALIGNED    (RXBYTEISALIGNED),
    .RXBYTEREALIGN      (RXBYTEREALIGN),
    .RXCOMMADET         (RXCOMMADET),

    .RXCOMMADETEN       (RXCOMMADETEN),
    .RXPCOMMAALIGNEN    (RXPCOMMAALIGNEN),
    .RXMCOMMAALIGNEN    (RXMCOMMAALIGNEN)
);

wire [data_width - 1:0] internal_data;
wire [isk_width  - 1:0] internal_isk;
// 10x8 decoder
gtxe2_chnl_rx_10x8dec #(
    .iwidth             (internal_data_width),
    .owidth             (RX_DATA_WIDTH),
    .DEC_MCOMMA_DETECT  (DEC_MCOMMA_DETECT),
    .DEC_PCOMMA_DETECT  (DEC_PCOMMA_DETECT)
)
decoder_10x8(
    .clk            (RXUSRCLK),
    .rst            (reset),
    .indata         (aligned_data),
    .RX8B10BEN      (RX8B10BEN),

    .RXCHARISCOMMA  (RXCHARISCOMMA),
    .RXCHARISK      (internal_isk),
    .RXDISPERR      (RXDISPERR),
    .RXNOTINTABLE   (RXNOTINTABLE),

    .outdata        (),
    .RXDATA         (internal_data)
);

// fit data width
// TODO make parameters awesome
localparam data_width = 16;
localparam if_data_width = 32;
localparam isk_width = 2;
localparam if_isk_width = 4;


gtxe2_chnl_rx_dataiface #(
    .internal_data_width    (data_width),
    .interface_data_width   (if_data_width),
    .internal_isk_width     (isk_width),
    .interface_isk_width    (if_isk_width)
)
dataiface
(
    .usrclk     (RXUSRCLK),
    .usrclk2    (RXUSRCLK2),
    .reset      (reset),
    .indata     (internal_data),
    .inisk      (internal_isk),
    .outdata    (RXDATA[if_data_width - 1:0]),
    .outisk     (RXCHARISK[if_isk_width - 1:0]),
    .realign    (RXBYTEREALIGN === 1'bx ? 1'b0 : RXBYTEREALIGN)
);

assign  RXDATA[63:if_data_width]    = 0;
assign  RXCHARISK[7:if_isk_width]   = 0;

endmodule
