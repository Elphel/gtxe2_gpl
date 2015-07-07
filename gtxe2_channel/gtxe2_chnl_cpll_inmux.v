/*******************************************************************************
 * Module: gtxe2_chnl_cpll_inmux
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: non-sinthesizable clock multiplexer, used in clocking scheme
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_cpll_inmux.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_cpll_inmux.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
// cpll reference clock mux
module gtxe2_chnl_cpll_inmux(
    input   wire    [2:0]   CPLLREFCLKSEL,
    input   wire            GTREFCLK0,
    input   wire            GTREFCLK1,
    input   wire            GTNORTHREFCLK0,
    input   wire            GTNORTHREFCLK1,
    input   wire            GTSOUTHREFCLK0,
    input   wire            GTSOUTHREFCLK1,
    input   wire            GTGREFCLK,
    output  wire            CPLL_MUX_CLK_OUT
);

// clock multiplexer - pre-syntesis simulation only
assign CPLL_MUX_CLK_OUT = CPLLREFCLKSEL == 3'b000 ?     1'b0 // reserved
                        : CPLLREFCLKSEL == 3'b001 ?     GTREFCLK0
                        : CPLLREFCLKSEL == 3'b010 ?     GTREFCLK1
                        : CPLLREFCLKSEL == 3'b011 ?     GTNORTHREFCLK0
                        : CPLLREFCLKSEL == 3'b100 ?     GTNORTHREFCLK1
                        : CPLLREFCLKSEL == 3'b101 ?     GTSOUTHREFCLK0
                        : CPLLREFCLKSEL == 3'b110 ?     GTSOUTHREFCLK1
                        : /*CPLLREFCLKSEL == 3'b111 ?*/ GTGREFCLK;

endmodule
