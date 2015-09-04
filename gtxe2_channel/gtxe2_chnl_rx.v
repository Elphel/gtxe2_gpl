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
// TODO resync all output signals
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

parameter   DEC_MCOMMA_DETECT = "TRUE";
parameter   DEC_PCOMMA_DETECT = "TRUE";

parameter   [9:0]   ALIGN_MCOMMA_VALUE  = 10'b1010000011;
parameter           ALIGN_MCOMMA_DET    = "TRUE";
parameter   [9:0]   ALIGN_PCOMMA_VALUE  = 10'b0101111100;
parameter           ALIGN_PCOMMA_DET    = "TRUE";
parameter   [9:0]   ALIGN_COMMA_ENABLE  = 10'b1111111111;
parameter           ALIGN_COMMA_DOUBLE  = "FALSE";

function integer calc_idw;
    input   dummy;
    begin
        calc_idw = RX_INT_DATAWIDTH == 1 ? 40 : 20;
    end
endfunction

function integer calc_ifdw;
    input   dummy;
    begin
       calc_ifdw = RX_DATA_WIDTH == 16 ? 20 :
                   RX_DATA_WIDTH == 32 ? 40 :
                   RX_DATA_WIDTH == 64 ? 80 : RX_DATA_WIDTH;
    end
endfunction

// can be 20 or 40, if it shall be 16 or 32, extra bits wont be used
localparam  internal_data_width     = calc_idw(1);
localparam  interface_data_width    = calc_ifdw(1);
localparam  internal_isk_width      = internal_data_width / 10;
localparam  interface_isk_width     = interface_data_width / 10;
// used in case of TX8B10BEN = 0
localparam  data_width_odd          = RX_DATA_WIDTH == 16 | RX_DATA_WIDTH == 32 | RX_DATA_WIDTH == 64;


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
wire    [internal_data_width - 1:0] parallel_data; // in trimmed case highest bites shall be 'x'
gtxe2_chnl_rx_des #(
    .width      (internal_data_width)
)
des(
    .reset      (reset),
    .trim       (data_width_odd & ~RX8B10BEN),
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

localparam  iface_databus_width = interface_data_width * 8 / 10;
localparam  intern_databus_width = internal_data_width * 8 / 10;

wire [intern_databus_width - 1:0] internal_data;
wire [internal_isk_width  - 1:0]  internal_isk;
wire [internal_isk_width  - 1:0]  internal_chariscomma;
wire [internal_isk_width  - 1:0]  internal_notintable;
wire [internal_isk_width  - 1:0]  internal_disperr;
// 10x8 decoder
gtxe2_chnl_rx_10x8dec #(
    .iwidth             (internal_data_width),
    .iskwidth           (internal_isk_width),
    .owidth             (intern_databus_width),
    .DEC_MCOMMA_DETECT  (DEC_MCOMMA_DETECT),
    .DEC_PCOMMA_DETECT  (DEC_PCOMMA_DETECT)
)
decoder_10x8(
    .clk            (RXUSRCLK),
    .rst            (reset),
    .indata         (aligned_data),
    .RX8B10BEN      (RX8B10BEN),
    .data_width_odd (data_width_odd),

    .rxchariscomma  (internal_chariscomma),
    .rxcharisk      (internal_isk),
    .rxdisperr      (internal_disperr),
    .rxnotintable   (internal_notintable),

    .outdata        (internal_data)
);

// fit data width

localparam outdiv = interface_data_width / internal_data_width;
// if something is written into dataiface_data_in _except_ internal_data and internal_isk => count all extra bits in this parameter
localparam internal_data_extra = 4;
localparam interface_data_extra = outdiv * internal_data_extra;

wire [interface_data_width - 1 + interface_data_extra:0]  dataiface_data_out;
wire [internal_data_width - 1 + internal_data_extra:0]   dataiface_data_in;

assign  dataiface_data_in  = {internal_notintable, internal_chariscomma, internal_disperr, internal_isk, internal_data};

genvar ii;
generate
for (ii = 1; ii < (outdiv + 1); ii = ii + 1)
begin: asdadfdsf
    assign  RXDATA[ii*intern_databus_width - 1 -: intern_databus_width]    = dataiface_data_out[(ii-1)*(internal_data_width + internal_data_extra) + intern_databus_width - 1 -: intern_databus_width];
    assign  RXCHARISK[ii*internal_isk_width - 1 -: internal_isk_width]     = dataiface_data_out[(ii-1)*(internal_data_width + internal_data_extra) + intern_databus_width - 1 + internal_isk_width -: internal_isk_width];
    assign  RXDISPERR[ii*internal_isk_width - 1 -: internal_isk_width]     = dataiface_data_out[(ii-1)*(internal_data_width + internal_data_extra) + intern_databus_width - 1 + internal_isk_width*2 -: internal_isk_width];
    assign  RXCHARISCOMMA[ii*internal_isk_width - 1 -: internal_isk_width] = dataiface_data_out[(ii-1)*(internal_data_width + internal_data_extra) + intern_databus_width - 1 + internal_isk_width*3 -: internal_isk_width];
    assign  RXNOTINTABLE[ii*internal_isk_width - 1 -: internal_isk_width]  = dataiface_data_out[(ii-1)*(internal_data_width + internal_data_extra) + intern_databus_width - 1 + internal_isk_width*4 -: internal_isk_width];
end
endgenerate
assign  RXDATA[63:iface_databus_width]       = {64 - iface_databus_width{1'bx}};
assign  RXDISPERR[7:interface_isk_width]     = {7 - interface_isk_width{1'bx}};
assign  RXCHARISK[7:interface_isk_width]     = {7 - interface_isk_width{1'bx}};
assign  RXCHARISCOMMA[7:interface_isk_width] = {7 - interface_isk_width{1'bx}};
assign  RXNOTINTABLE[7:interface_isk_width]  = {7 - interface_isk_width{1'bx}};

gtxe2_chnl_rx_dataiface #(
    .internal_data_width    (internal_data_width + internal_data_extra),
    .interface_data_width   (interface_data_width + interface_data_extra),
    .internal_isk_width     (internal_isk_width),
    .interface_isk_width    (interface_isk_width)
)
dataiface
(
    .usrclk     (RXUSRCLK),
    .usrclk2    (RXUSRCLK2),
    .reset      (reset),
    .indata     (dataiface_data_in),
    .inisk      (internal_isk), // not used actually
    .outdata    (dataiface_data_out),
    .outisk     (),
    .realign    (RXBYTEREALIGN === 1'bx ? 1'b0 : RXBYTEREALIGN)
);

endmodule
