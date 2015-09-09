/*******************************************************************************
 * Module: gtxe2_chnl_rx_align
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: reciever's comma-aligner implementation
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_rx_align.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_rx_align.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
module gtxe2_chnl_rx_align #(
    parameter width = 20,
    parameter   [9:0]   ALIGN_MCOMMA_VALUE  = 10'b1010000011,
    parameter           ALIGN_MCOMMA_DET    = "TRUE",
    parameter   [9:0]   ALIGN_PCOMMA_VALUE  = 10'b0101111100,
    parameter           ALIGN_PCOMMA_DET    = "TRUE",
    parameter   [9:0]   ALIGN_COMMA_ENABLE  = 10'b1111111111,
    parameter           ALIGN_COMMA_DOUBLE  = "FALSE",
    parameter           ALIGN_COMMA_WORD    = 1
)
(
    input   wire                    clk,
    input   wire                    rst,
    input   wire    [width - 1:0]   indata,
    output  wire    [width - 1:0]   outdata,

    input   wire                    rxelecidle,

    output  wire                    RXBYTEISALIGNED,
    output  wire                    RXBYTEREALIGN,
    output  wire                    RXCOMMADET,

    input   wire                    RXCOMMADETEN,
    input   wire                    RXPCOMMAALIGNEN,
    input   wire                    RXMCOMMAALIGNEN
);

localparam  comma_width = ALIGN_COMMA_DOUBLE == "FALSE" ? 10 : 20;
localparam  window_size = width;//comma_width + width;

// prepare a buffer to be scanned on comma matches
reg     [width - 1:0]       indata_r;
wire    [width*2 - 1:0]     data;

// looking for matches in all related bit history - in 'data'
assign  data    = {indata, indata_r};//{indata_r, indata};
always @ (posedge clk)
    indata_r <= indata;

// finding matches
wire    [comma_width - 1:0] comma_window [window_size - 1:0];
//initial
//  for (idx = 0; idx < window_size; idx = idx + 1) $dumpvars(0, comma_width[idx]);
wire    [window_size - 1:0] comma_match; // shows all matches
wire    [window_size - 1:0] comma_pos; // shows the first match
wire    [window_size - 1:0] pcomma_match;
wire    [window_size - 1:0] mcomma_match;

genvar ii;
generate
for (ii = 0; ii < window_size; ii = ii + 1)
begin: filter
    assign  comma_window[ii]    = data[comma_width + ii - 1:ii];
    assign  pcomma_match[ii]    = (comma_window[ii] & ALIGN_COMMA_ENABLE) == (ALIGN_PCOMMA_VALUE & ALIGN_COMMA_ENABLE);
    assign  mcomma_match[ii]    = (comma_window[ii] & ALIGN_COMMA_ENABLE) == (ALIGN_MCOMMA_VALUE & ALIGN_COMMA_ENABLE);
    assign  comma_match[ii]     = pcomma_match[ii] & RXPCOMMAALIGNEN | mcomma_match[ii] & RXMCOMMAALIGNEN;
end
endgenerate

// so, comma_match indicates bits, from whose comma/doublecomma (or commas) occurs in the window buffer
// all we need from now is to get one of these bits, [x], and say [x+width-1:x] is an aligned data

// doing it in a hard way
generate
for (ii = 1; ii < window_size; ii = ii + 1)
begin: filter_comma_pos
    assign  comma_pos[ii] = comma_match[ii] & ~|comma_match[ii - 1:0];
end
endgenerate
assign  comma_pos[0] = comma_match[0];
// so, comma_pos's '1' indicates the first comma occurence. there is only one '1' in the vector

function integer clogb2;
    input [31:0] value;
    begin
        value = value - 1;
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
            value = value >> 1;
        end
    end
endfunction

function integer powerof2;
    input [31:0] value;
    begin
        value = 1 << value;
    end
endfunction

localparam pwidth = clogb2(width * 2 -1);

// decoding (finding an index, representing '1' in comma_pos)
wire    [pwidth - 1:0]      pointer;
reg     [pwidth - 1:0]      pointer_latched;
wire                        pointer_set;
wire    [window_size - 1:0] pbits [pwidth - 1:0];
genvar jj;
generate
for (ii = 0; ii < pwidth; ii = ii + 1)
begin: for_each_pointers_bit
    for (jj = 0; jj < window_size; jj = jj + 1)
    begin: calculate_encoder_mask
        assign pbits[ii][jj] = jj[ii];
    end
    assign pointer[ii] = |(pbits[ii] & comma_pos);
end
endgenerate

//here we are: pointer = index of a beginning of the required output data
reg     is_aligned;

assign  outdata     = ~RXCOMMADETEN ? indata : pointer_set ? data[pointer + width - 1 -:width] : data[pointer_latched + width - 1 -:width];
assign  pointer_set = |comma_pos;
assign  RXCOMMADET  = RXCOMMADETEN & pointer_set & (|pcomma_match & ALIGN_PCOMMA_DET == "TRUE" | |mcomma_match & ALIGN_MCOMMA_DET == "TRUE");
assign  RXBYTEISALIGNED = RXCOMMADETEN & is_aligned;
assign  RXBYTEREALIGN = RXCOMMADETEN & is_aligned & pointer_set;

always @ (posedge clk)
begin
    is_aligned      <= rst | pointer_set === 1'bx | rxelecidle ? 1'b0 : ~is_aligned & pointer_set | is_aligned;
    pointer_latched <= rst ? {pwidth{1'b0}} : pointer_set ? pointer : pointer_latched;
end

endmodule
