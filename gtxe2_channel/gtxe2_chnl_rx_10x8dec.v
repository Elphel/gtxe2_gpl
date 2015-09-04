/*******************************************************************************
 * Module: gtxe2_chnl_rx_10x8dec
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: 10x8 decoder implementation, has reduced parameterization abilities
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_rx_10x8dec.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_rx_10x8dec.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
// always enabled, wasnt tested with width parameters, disctinct from 20
module gtxe2_chnl_rx_10x8dec #(
    parameter iwidth = 20,
    parameter iskwidth = 2,
    parameter owidth = 20,

    parameter DEC_MCOMMA_DETECT = "TRUE",
    parameter DEC_PCOMMA_DETECT = "TRUE"
)
(
    input   wire                        clk,
    input   wire                        rst,
    input   wire    [iwidth - 1:0]      indata,
    input   wire                        RX8B10BEN,
    input   wire                        data_width_odd,

    output  wire    [iskwidth - 1:0]    rxchariscomma,
    output  wire    [iskwidth - 1:0]    rxcharisk,
    output  wire    [iskwidth - 1:0]    rxdisperr,
    output  wire    [iskwidth - 1:0]    rxnotintable,

    output  wire    [owidth - 1:0]      outdata
);
wire    [iskwidth - 1:0]    rxcharisk_dec;
wire    [iskwidth - 1:0]    rxdisperr_dec;
wire    [owidth - 1:0]      outdata_dec;

localparam word_count = iwidth / 10;
localparam add_2out_bits = owidth == 20 | owidth == 40 | owidth == 80 ? "TRUE" : "FALSE";

wire    [iwidth - 2 * word_count - 1:0] pure_data;
wire    [iwidth - 1:0]                  data;
wire    [word_count - 1:0]              disp; //consecutive disparity calculations;
wire    [word_count - 1:0]              disp_word; // 0 - negative, 1 - positive
wire    [word_count - 1:0]              no_disp_word; // ignore disp_word, '1's and '0's have equal count
wire    [word_count - 1:0]              disp_err;

reg     disp_init; // disparity after last clock's portion of data
always @ (posedge clk)
    disp_init <= rst ? 1'b0 : disp[word_count - 1];

genvar ii;
generate
for (ii = 0; ii < word_count; ii = ii + 1)
begin: asdf
    //data = {1'(is in table) + 3'(decoded 4/3) + 1'(is in table) + 5'(decoded 6/5)}

    //6/5 decoding
    assign  data[ii*10+5:ii*10] = rxcharisk_dec[ii] ? (
                                  indata[ii*10 + 9:ii*10] == 10'b0010111100 | indata[ii*10 + 9:ii*10] == 10'b1101000011 ? 6'b011100 :
                                  indata[ii*10 + 9:ii*10] == 10'b1001111100 | indata[ii*10 + 9:ii*10] == 10'b0110000011 ? 6'b011100 :
                                  indata[ii*10 + 9:ii*10] == 10'b1010111100 | indata[ii*10 + 9:ii*10] == 10'b0101000011 ? 6'b011100 :
                                  indata[ii*10 + 9:ii*10] == 10'b1100111100 | indata[ii*10 + 9:ii*10] == 10'b0011000011 ? 6'b011100 :
                                  indata[ii*10 + 9:ii*10] == 10'b0100111100 | indata[ii*10 + 9:ii*10] == 10'b1011000011 ? 6'b011100 :
                                  indata[ii*10 + 9:ii*10] == 10'b0101111100 | indata[ii*10 + 9:ii*10] == 10'b1010000011 ? 6'b011100 :
                                  indata[ii*10 + 9:ii*10] == 10'b0110111100 | indata[ii*10 + 9:ii*10] == 10'b1001000011 ? 6'b011100 :
                                  indata[ii*10 + 9:ii*10] == 10'b0001111100 | indata[ii*10 + 9:ii*10] == 10'b1110000011 ? 6'b011100 :
                                  indata[ii*10 + 9:ii*10] == 10'b0001010111 | indata[ii*10 + 9:ii*10] == 10'b1110101000 ? 6'b010111 :
                                  indata[ii*10 + 9:ii*10] == 10'b0001011011 | indata[ii*10 + 9:ii*10] == 10'b1110100100 ? 6'b011011 :
                                  indata[ii*10 + 9:ii*10] == 10'b0001011101 | indata[ii*10 + 9:ii*10] == 10'b1110100010 ? 6'b011101 :
                                  indata[ii*10 + 9:ii*10] == 10'b0001011110 | indata[ii*10 + 9:ii*10] == 10'b1110100001 ? 6'b011110 :
                                                                                                                          6'b100000)
                                  :
                                 (indata[ii*10 + 5:ii*10] == 6'b111001 | indata[ii*10 + 5:ii*10] == 6'b000110 ? 6'b000000 :// Data VVV
                                  indata[ii*10 + 5:ii*10] == 6'b101110 | indata[ii*10 + 5:ii*10] == 6'b010001 ? 6'b000001 :
                                  indata[ii*10 + 5:ii*10] == 6'b101101 | indata[ii*10 + 5:ii*10] == 6'b010010 ? 6'b000010 :
                                  indata[ii*10 + 5:ii*10] == 6'b100011 | indata[ii*10 + 5:ii*10] == 6'b100011 ? 6'b000011 :
                                  indata[ii*10 + 5:ii*10] == 6'b101011 | indata[ii*10 + 5:ii*10] == 6'b010100 ? 6'b000100 :
                                  indata[ii*10 + 5:ii*10] == 6'b100101 | indata[ii*10 + 5:ii*10] == 6'b100101 ? 6'b000101 :
                                  indata[ii*10 + 5:ii*10] == 6'b100110 | indata[ii*10 + 5:ii*10] == 6'b100110 ? 6'b000110 :
                                  indata[ii*10 + 5:ii*10] == 6'b000111 | indata[ii*10 + 5:ii*10] == 6'b111000 ? 6'b000111 :
                                  indata[ii*10 + 5:ii*10] == 6'b100111 | indata[ii*10 + 5:ii*10] == 6'b011000 ? 6'b001000 :
                                  indata[ii*10 + 5:ii*10] == 6'b101001 | indata[ii*10 + 5:ii*10] == 6'b101001 ? 6'b001001 :
                                  indata[ii*10 + 5:ii*10] == 6'b101010 | indata[ii*10 + 5:ii*10] == 6'b101010 ? 6'b001010 :
                                  indata[ii*10 + 5:ii*10] == 6'b001011 | indata[ii*10 + 5:ii*10] == 6'b001011 ? 6'b001011 :
                                  indata[ii*10 + 5:ii*10] == 6'b101100 | indata[ii*10 + 5:ii*10] == 6'b101100 ? 6'b001100 :
                                  indata[ii*10 + 5:ii*10] == 6'b001101 | indata[ii*10 + 5:ii*10] == 6'b001101 ? 6'b001101 :
                                  indata[ii*10 + 5:ii*10] == 6'b001110 | indata[ii*10 + 5:ii*10] == 6'b001110 ? 6'b001110 :
                                  indata[ii*10 + 5:ii*10] == 6'b111010 | indata[ii*10 + 5:ii*10] == 6'b000101 ? 6'b001111 :
                                  indata[ii*10 + 5:ii*10] == 6'b110110 | indata[ii*10 + 5:ii*10] == 6'b001001 ? 6'b010000 :
                                  indata[ii*10 + 5:ii*10] == 6'b110001 | indata[ii*10 + 5:ii*10] == 6'b110001 ? 6'b010001 :
                                  indata[ii*10 + 5:ii*10] == 6'b110010 | indata[ii*10 + 5:ii*10] == 6'b110010 ? 6'b010010 :
                                  indata[ii*10 + 5:ii*10] == 6'b010011 | indata[ii*10 + 5:ii*10] == 6'b010011 ? 6'b010011 :
                                  indata[ii*10 + 5:ii*10] == 6'b110100 | indata[ii*10 + 5:ii*10] == 6'b110100 ? 6'b010100 :
                                  indata[ii*10 + 5:ii*10] == 6'b010101 | indata[ii*10 + 5:ii*10] == 6'b010101 ? 6'b010101 :
                                  indata[ii*10 + 5:ii*10] == 6'b010110 | indata[ii*10 + 5:ii*10] == 6'b010110 ? 6'b010110 :
                                  indata[ii*10 + 5:ii*10] == 6'b010111 | indata[ii*10 + 5:ii*10] == 6'b101000 ? 6'b010111 :
                                  indata[ii*10 + 5:ii*10] == 6'b110011 | indata[ii*10 + 5:ii*10] == 6'b001100 ? 6'b011000 :
                                  indata[ii*10 + 5:ii*10] == 6'b011001 | indata[ii*10 + 5:ii*10] == 6'b011001 ? 6'b011001 :
                                  indata[ii*10 + 5:ii*10] == 6'b011010 | indata[ii*10 + 5:ii*10] == 6'b011010 ? 6'b011010 :
                                  indata[ii*10 + 5:ii*10] == 6'b011011 | indata[ii*10 + 5:ii*10] == 6'b100100 ? 6'b011011 :
                                  indata[ii*10 + 5:ii*10] == 6'b011100 | indata[ii*10 + 5:ii*10] == 6'b011100 ? 6'b011100 :
                                  indata[ii*10 + 5:ii*10] == 6'b011101 | indata[ii*10 + 5:ii*10] == 6'b100010 ? 6'b011101 :
                                  indata[ii*10 + 5:ii*10] == 6'b011110 | indata[ii*10 + 5:ii*10] == 6'b100001 ? 6'b011110 :
                                  indata[ii*10 + 5:ii*10] == 6'b110101 | indata[ii*10 + 5:ii*10] == 6'b001010 ? 6'b011111 :
                                  indata[ii*10 + 5:ii*10] == 6'b111100 | indata[ii*10 + 5:ii*10] == 6'b000011 ? 6'b011100 :// Controls VVV
/*                                indata[ii*10 + 5:ii*10] == 6'b111100 | indata[ii*10 + 5:ii*10] == 6'b000011 ? 6'b011100 :
                                  indata[ii*10 + 5:ii*10] == 6'b111100 | indata[ii*10 + 5:ii*10] == 6'b000011 ? 6'b011100 :
                                  indata[ii*10 + 5:ii*10] == 6'b111100 | indata[ii*10 + 5:ii*10] == 6'b000011 ? 6'b011100 :
                                  indata[ii*10 + 5:ii*10] == 6'b111100 | indata[ii*10 + 5:ii*10] == 6'b000011 ? 6'b011100 :
                                  indata[ii*10 + 5:ii*10] == 6'b111100 | indata[ii*10 + 5:ii*10] == 6'b000011 ? 6'b011100 :
                                  indata[ii*10 + 5:ii*10] == 6'b111100 | indata[ii*10 + 5:ii*10] == 6'b000011 ? 6'b011100 :
                                  indata[ii*10 + 5:ii*10] == 6'b111100 | indata[ii*10 + 5:ii*10] == 6'b000011 ? 6'b011100 :
                                  indata[ii*10 + 5:ii*10] == 6'b010111 | indata[ii*10 + 5:ii*10] == 6'b101000 ? 6'b010111 :
                                  indata[ii*10 + 5:ii*10] == 6'b011011 | indata[ii*10 + 5:ii*10] == 6'b100100 ? 6'b011011 :
                                  indata[ii*10 + 5:ii*10] == 6'b011101 | indata[ii*10 + 5:ii*10] == 6'b100010 ? 6'b011101 :
                                  indata[ii*10 + 5:ii*10] == 6'b011110 | indata[ii*10 + 5:ii*10] == 6'b100001 ? 6'b011110 :*/
                                                                                                                6'b100000); // not in a table
    //4/3 decoding                                                                                                 
    assign  data[ii*10+ 9:ii*10+ 6] = rxcharisk_dec[ii] ? (
                                      indata[ii*10 + 9:ii*10] == 10'b0010111100 | indata[ii*10 + 9:ii*10] == 10'b1101000011 ? 4'b0000 :
                                      indata[ii*10 + 9:ii*10] == 10'b1001111100 | indata[ii*10 + 9:ii*10] == 10'b0110000011 ? 4'b0001 :
                                      indata[ii*10 + 9:ii*10] == 10'b1010111100 | indata[ii*10 + 9:ii*10] == 10'b0101000011 ? 4'b0010 :
                                      indata[ii*10 + 9:ii*10] == 10'b1100111100 | indata[ii*10 + 9:ii*10] == 10'b0011000011 ? 4'b0011 :
                                      indata[ii*10 + 9:ii*10] == 10'b0100111100 | indata[ii*10 + 9:ii*10] == 10'b1011000011 ? 4'b0100 :
                                      indata[ii*10 + 9:ii*10] == 10'b0101111100 | indata[ii*10 + 9:ii*10] == 10'b1010000011 ? 4'b0101 :
                                      indata[ii*10 + 9:ii*10] == 10'b0110111100 | indata[ii*10 + 9:ii*10] == 10'b1001000011 ? 4'b0110 :
                                      indata[ii*10 + 9:ii*10] == 10'b0001111100 | indata[ii*10 + 9:ii*10] == 10'b1110000011 ? 4'b0111 :
                                      indata[ii*10 + 9:ii*10] == 10'b0001010111 | indata[ii*10 + 9:ii*10] == 10'b1110101000 ? 4'b0111 :
                                      indata[ii*10 + 9:ii*10] == 10'b0001011011 | indata[ii*10 + 9:ii*10] == 10'b1110100100 ? 4'b0111 :
                                      indata[ii*10 + 9:ii*10] == 10'b0001011101 | indata[ii*10 + 9:ii*10] == 10'b1110100010 ? 4'b0111 :
                                      indata[ii*10 + 9:ii*10] == 10'b0001011110 | indata[ii*10 + 9:ii*10] == 10'b1110100001 ? 4'b0111 :
                                                                                                                              4'b1000)
                                      :
                                     (indata[ii*10 + 9:ii*10 + 6] == 4'b1101 | indata[ii*10 + 9:ii*10 + 6] == 4'b0010 ? 4'b0000 : // Data VVV
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b1001 | indata[ii*10 + 9:ii*10 + 6] == 4'b1001 ? 4'b0001 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b1010 | indata[ii*10 + 9:ii*10 + 6] == 4'b1010 ? 4'b0010 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b0011 | indata[ii*10 + 9:ii*10 + 6] == 4'b1100 ? 4'b0011 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b1011 | indata[ii*10 + 9:ii*10 + 6] == 4'b0100 ? 4'b0100 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b0101 | indata[ii*10 + 9:ii*10 + 6] == 4'b0101 ? 4'b0101 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b0110 | indata[ii*10 + 9:ii*10 + 6] == 4'b0110 ? 4'b0110 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b0111 | indata[ii*10 + 9:ii*10 + 6] == 4'b1110 ? 4'b0111 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b0001 | indata[ii*10 + 9:ii*10 + 6] == 4'b1000 ? 4'b0111 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b0010 | indata[ii*10 + 9:ii*10 + 6] == 4'b1101 ? 4'b0000 : // Control VVV
/*                                    indata[ii*10 + 9:ii*10 + 6] == 4'b1001 | indata[ii*10 + 9:ii*10 + 6] == 4'b0110 ? 4'b0001 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b1010 | indata[ii*10 + 9:ii*10 + 6] == 4'b0101 ? 4'b0010 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b1100 | indata[ii*10 + 9:ii*10 + 6] == 4'b0011 ? 4'b0011 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b0100 | indata[ii*10 + 9:ii*10 + 6] == 4'b1011 ? 4'b0100 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b0101 | indata[ii*10 + 9:ii*10 + 6] == 4'b1010 ? 4'b0101 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b0110 | indata[ii*10 + 9:ii*10 + 6] == 4'b1001 ? 4'b0110 :
                                      indata[ii*10 + 9:ii*10 + 6] == 4'b0001 | indata[ii*10 + 9:ii*10 + 6] == 4'b1110 ? 4'b0111 :*/
                                                                                                                        4'b1000); // not in a table
    assign  disp_word[ii]   = (4'd0 + indata[ii*10] + indata[ii*10 + 1] + indata[ii*10 + 2] + indata[ii*10 + 3] + indata[ii*10 + 4] 
                                    + indata[ii*10 + 5] + indata[ii*10 + 6] + indata[ii*10 + 7] + indata[ii*10 + 8] + indata[ii*10 + 9]) > 5;
    assign  no_disp_word[ii]= (4'd0 + indata[ii*10] + indata[ii*10 + 1] + indata[ii*10 + 2] + indata[ii*10 + 3] + indata[ii*10 + 4] 
                                    + indata[ii*10 + 5] + indata[ii*10 + 6] + indata[ii*10 + 7] + indata[ii*10 + 8] + indata[ii*10 + 9]) == 5;

    assign  pure_data[ii*8 + 7:ii*8] = {data[ii*10 + 8:ii*10 + 6], data[ii*10 + 4:ii*10]};

    assign  outdata_dec[ii*8 + 7:ii*8]  = pure_data[ii*8 + 7:ii*8];

    assign  outdata[ii*8 + 7:ii*8]  = RX8B10BEN ? outdata_dec[ii*8 + 7:ii*8]   : ~data_width_odd ? indata[ii*10 + 7:ii*10]  : indata[ii*8 + 7:ii*8];
    assign  rxcharisk[ii]           = RX8B10BEN ? rxcharisk_dec[ii] : ~data_width_odd ? indata[ii*10 + 8]        : 1'bx;
    assign  rxdisperr[ii]           = RX8B10BEN ? rxdisperr_dec[ii] : ~data_width_odd ? indata[ii*10 + 9]        : 1'bx; 
/*    if (RX8B10BEN) begin
    end
    else 
    if (data_width_odd) begin
        assign  outdata[ii*8 + 7:ii*8]  = indata[ii*8 + 7:ii*8];
        assign  rxcharisk[ii]           = 1'bx;
        assign  rxdisperr[ii]           = 1'bx; 
    end
    else begin
        assign  outdata[ii*8 + 7:ii*8]  = indata[ii*10 + 7:ii*10];
        assign  rxcharisk[ii]           = indata[ii*10 + 8];
        assign  rxdisperr[ii]           = indata[ii*10 + 9];
    end*/
end
endgenerate

assign  disp_err = ~no_disp_word & (~disp_word ^ {disp[word_count - 2:0], disp_init});
assign  disp     = ~no_disp_word & disp_word | no_disp_word & {disp[word_count - 2:0], disp_init};


generate 
for (ii = 0; ii < word_count; ii = ii + 1)
begin:dfsga
    assign  rxnotintable[ii]    = ii >= word_count ? 1'b0 : data[ii*10 + 9] | data[ii*10 + 5];

    assign  rxdisperr_dec[ii]   = ii >= word_count ?  1'b0 : disp_err[ii];
    assign  rxcharisk_dec[ii]   = ii >= word_count ?  1'b0 :
                                                      indata[ii*10 + 9:ii*10] == 10'b0010111100 | indata[ii*10 + 9:ii*10] == 10'b1101000011 |
                                                      indata[ii*10 + 9:ii*10] == 10'b1001111100 | indata[ii*10 + 9:ii*10] == 10'b0110000011 |
                                                      indata[ii*10 + 9:ii*10] == 10'b1010111100 | indata[ii*10 + 9:ii*10] == 10'b0101000011 |
                                                      indata[ii*10 + 9:ii*10] == 10'b1100111100 | indata[ii*10 + 9:ii*10] == 10'b0011000011 |
                                                      indata[ii*10 + 9:ii*10] == 10'b0100111100 | indata[ii*10 + 9:ii*10] == 10'b1011000011 |
                                                      indata[ii*10 + 9:ii*10] == 10'b0101111100 | indata[ii*10 + 9:ii*10] == 10'b1010000011 |
                                                      indata[ii*10 + 9:ii*10] == 10'b0110111100 | indata[ii*10 + 9:ii*10] == 10'b1001000011 |
                                                      indata[ii*10 + 9:ii*10] == 10'b0001111100 | indata[ii*10 + 9:ii*10] == 10'b1110000011 |
                                                      indata[ii*10 + 9:ii*10] == 10'b0001010111 | indata[ii*10 + 9:ii*10] == 10'b1110101000 |
                                                      indata[ii*10 + 9:ii*10] == 10'b0001011011 | indata[ii*10 + 9:ii*10] == 10'b1110100100 |
                                                      indata[ii*10 + 9:ii*10] == 10'b0001011101 | indata[ii*10 + 9:ii*10] == 10'b1110100010 |
                                                      indata[ii*10 + 9:ii*10] == 10'b0001011110 | indata[ii*10 + 9:ii*10] == 10'b1110100001;

    assign  rxchariscomma[ii] = ii >= word_count ?  1'b0 :
                                                   (indata[ii*10 + 9:ii*10] == 10'b1001111100 | 
                                                    indata[ii*10 + 9:ii*10] == 10'b0101111100 | 
                                                    indata[ii*10 + 9:ii*10] == 10'b0001111100) & DEC_PCOMMA_DETECT |
                                                   (indata[ii*10 + 9:ii*10] == 10'b0110000011 |
                                                    indata[ii*10 + 9:ii*10] == 10'b1010000011 |
                                                    indata[ii*10 + 9:ii*10] == 10'b1110000011) & DEC_MCOMMA_DETECT;
end
endgenerate


endmodule
