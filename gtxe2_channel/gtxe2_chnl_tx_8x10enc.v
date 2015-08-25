/*******************************************************************************
 * Module: gtxe2_chnl_tx_8x10enc
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: 8x10 encoder
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_tx_8x10enc.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_tx_8x10enc.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
// for some reason overall trasmitted disparity is tracked at the top level
module gtxe2_chnl_tx_8x10enc #(
    parameter iwidth = 16,
    parameter owidth = 20
)
(
    input   wire    [7:0]           TX8B10BBYPASS,
    input   wire                    TX8B10BEN,
    input   wire    [7:0]           TXCHARDISPMODE,
    input   wire    [7:0]           TXCHARDISPVAL,
    input   wire    [7:0]           TXCHARISK,
    input   wire                    disparity,
    input   wire    [iwidth - 1:0]  data_in,
    output  wire    [owidth - 1:0]  data_out,
    output  wire                    next_disparity
);

// only full 8/10 encoding and width=20 case is implemented

localparam  word_count = owidth / 10;

wire    [word_count - 1:0]  word_disparity;
wire    [word_count - 1:0]  interm_disparity;
wire    [5:0]               six     [word_count - 1:0];
wire    [3:0]               four    [word_count - 1:0];
wire    [9:0]               oword   [word_count - 1:0];
wire    [iwidth - 1:0]      iword   [word_count - 1:0];
wire    [word_count - 1:0]  is_control;

// typical approach: 8x10 = 5x6 + 3x4
// word disparity[i] = calculated disparity for the i-th 8-bit word
// interm_disparity[i] - disparity after 5x6 encoding for the i-th word 
genvar ii;
generate
for (ii = 0; ii < 2; ii = ii + 1)
begin: encode_by_word
    assign  is_control[ii]      = TXCHARISK[ii];
    assign  iword[ii]           = data_in[ii*8 + 7:ii*8];
    assign  interm_disparity[ii]= ^six[ii] ? word_disparity[ii] : ~word_disparity[ii];
    assign  word_disparity[ii]  = (ii == 0)  ? disparity :
                                               (^oword[ii - 1] ? word_disparity[ii - 1] : ~word_disparity[ii - 1]); // if there're 5 '1's - do no change the disparity, 6 or 4 - change
    assign  six[ii] = iword[ii][4:0] == 5'b00000 ? (~word_disparity[ii] ? 6'b100111 : 6'b011000)
                    : iword[ii][4:0] == 5'b00001 ? (~word_disparity[ii] ? 6'b011101 : 6'b100010)
                    : iword[ii][4:0] == 5'b00010 ? (~word_disparity[ii] ? 6'b101101 : 6'b010010)
                    : iword[ii][4:0] == 5'b00011 ? (~word_disparity[ii] ? 6'b110001 : 6'b110001)
                    : iword[ii][4:0] == 5'b00100 ? (~word_disparity[ii] ? 6'b110101 : 6'b001010)
                    : iword[ii][4:0] == 5'b00101 ? (~word_disparity[ii] ? 6'b101001 : 6'b101001)
                    : iword[ii][4:0] == 5'b00110 ? (~word_disparity[ii] ? 6'b011001 : 6'b011001)
                    : iword[ii][4:0] == 5'b00111 ? (~word_disparity[ii] ? 6'b111000 : 6'b000111)
                    : iword[ii][4:0] == 5'b01000 ? (~word_disparity[ii] ? 6'b111001 : 6'b000110)
                    : iword[ii][4:0] == 5'b01001 ? (~word_disparity[ii] ? 6'b100101 : 6'b100101)
                    : iword[ii][4:0] == 5'b01010 ? (~word_disparity[ii] ? 6'b010101 : 6'b010101)
                    : iword[ii][4:0] == 5'b01011 ? (~word_disparity[ii] ? 6'b110100 : 6'b110100)
                    : iword[ii][4:0] == 5'b01100 ? (~word_disparity[ii] ? 6'b001101 : 6'b001101)
                    : iword[ii][4:0] == 5'b01101 ? (~word_disparity[ii] ? 6'b101100 : 6'b101100)
                    : iword[ii][4:0] == 5'b01110 ? (~word_disparity[ii] ? 6'b011100 : 6'b011100)
                    : iword[ii][4:0] == 5'b01111 ? (~word_disparity[ii] ? 6'b010111 : 6'b101000)
                    : iword[ii][4:0] == 5'b10000 ? (~word_disparity[ii] ? 6'b011011 : 6'b100100)
                    : iword[ii][4:0] == 5'b10001 ? (~word_disparity[ii] ? 6'b100011 : 6'b100011)
                    : iword[ii][4:0] == 5'b10010 ? (~word_disparity[ii] ? 6'b010011 : 6'b010011)
                    : iword[ii][4:0] == 5'b10011 ? (~word_disparity[ii] ? 6'b110010 : 6'b110010)
                    : iword[ii][4:0] == 5'b10100 ? (~word_disparity[ii] ? 6'b001011 : 6'b001011)
                    : iword[ii][4:0] == 5'b10101 ? (~word_disparity[ii] ? 6'b101010 : 6'b101010)
                    : iword[ii][4:0] == 5'b10110 ? (~word_disparity[ii] ? 6'b011010 : 6'b011010)
                    : iword[ii][4:0] == 5'b10111 ? (~word_disparity[ii] ? 6'b111010 : 6'b000101)
                    : iword[ii][4:0] == 5'b11000 ? (~word_disparity[ii] ? 6'b110011 : 6'b001100)
                    : iword[ii][4:0] == 5'b11001 ? (~word_disparity[ii] ? 6'b100110 : 6'b100110)
                    : iword[ii][4:0] == 5'b11010 ? (~word_disparity[ii] ? 6'b010110 : 6'b010110)
                    : iword[ii][4:0] == 5'b11011 ? (~word_disparity[ii] ? 6'b110110 : 6'b001001)
                    : iword[ii][4:0] == 5'b11100 ? (~word_disparity[ii] ? 6'b001110 : 6'b001110)
                    : iword[ii][4:0] == 5'b11101 ? (~word_disparity[ii] ? 6'b101110 : 6'b010001)
                    : iword[ii][4:0] == 5'b11110 ? (~word_disparity[ii] ? 6'b011110 : 6'b100001)
                    :/*iword[ii][4:0] == 5'b11111*/(~word_disparity[ii] ? 6'b101011 : 6'b010100);
    assign  four[ii] = iword[ii][7:5] == 3'd0 ? (~interm_disparity[ii] ? 4'b1011 : 4'b0100)
                     : iword[ii][7:5] == 3'd1 ? (~interm_disparity[ii] ? 4'b1001 : 4'b1001)
                     : iword[ii][7:5] == 3'd2 ? (~interm_disparity[ii] ? 4'b0101 : 4'b0101)
                     : iword[ii][7:5] == 3'd3 ? (~interm_disparity[ii] ? 4'b1100 : 4'b0011)
                     : iword[ii][7:5] == 3'd4 ? (~interm_disparity[ii] ? 4'b1101 : 4'b0010)
                     : iword[ii][7:5] == 3'd5 ? (~interm_disparity[ii] ? 4'b1010 : 4'b1010)
                     : iword[ii][7:5] == 3'd6 ? (~interm_disparity[ii] ? 4'b0110 : 4'b0110)
                     :/*iword[ii][7:5] == 3'd7*/(~interm_disparity[ii] ? (six[ii][1:0] == 2'b11 ? 4'b0111 : 4'b1110) 
                                                                       : (six[ii][1:0] == 2'b00 ? 4'b1000 : 4'b0001));
    assign  oword[ii] = ~is_control[ii] ? {six[ii], four[ii]} 
                                        : iword[ii][7:0] == 8'b00011100 ? (~word_disparity[ii] ? 10'b0011110100 : 10'b1100001011)
                                        : iword[ii][7:0] == 8'b00111100 ? (~word_disparity[ii] ? 10'b0011111001 : 10'b1100000110)
                                        : iword[ii][7:0] == 8'b01011100 ? (~word_disparity[ii] ? 10'b0011110101 : 10'b1100001010)
                                        : iword[ii][7:0] == 8'b01111100 ? (~word_disparity[ii] ? 10'b0011110011 : 10'b1100001100)
                                        : iword[ii][7:0] == 8'b10011100 ? (~word_disparity[ii] ? 10'b0011110010 : 10'b1100001101)
                                        : iword[ii][7:0] == 8'b10111100 ? (~word_disparity[ii] ? 10'b0011111010 : 10'b1100000101)
                                        : iword[ii][7:0] == 8'b11011100 ? (~word_disparity[ii] ? 10'b0011110110 : 10'b1100001001)
                                        : iword[ii][7:0] == 8'b11111100 ? (~word_disparity[ii] ? 10'b0011111000 : 10'b1100000111)
                                        : iword[ii][7:0] == 8'b11110111 ? (~word_disparity[ii] ? 10'b1110101000 : 10'b0001010111)
                                        : iword[ii][7:0] == 8'b11111011 ? (~word_disparity[ii] ? 10'b1101101000 : 10'b0010010111)
                                        : iword[ii][7:0] == 8'b11111101 ? (~word_disparity[ii] ? 10'b1011101000 : 10'b0100010111)
                                        :/*iword[ii][7:0] == 8'b11111110*/(~word_disparity[ii] ? 10'b0111101000 : 10'b1000010111);

    assign  data_out[ii*10 + 9:ii * 10] = oword[ii];
end
endgenerate
assign  next_disparity = ^oword[word_count - 1] ? word_disparity[word_count - 1] : ~word_disparity[word_count - 1];

endmodule
