/*******************************************************************************
 * Module: gtxe2_comm_qpll_inmux
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: non-synthesizable clock multiplexer
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_comm_qpll_inmux.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_comm_qpll_inmux.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
module gtxe2_comm_qpll_inmux(
    input   wire    [2:0]   QPLLREFCLKSEL,
    input   wire            GTREFCLK0,
    input   wire            GTREFCLK1,
    input   wire            GTNORTHREFCLK0,
    input   wire            GTNORTHREFCLK1,
    input   wire            GTSOUTHREFCLK0,
    input   wire            GTSOUTHREFCLK1,
    input   wire            GTGREFCLK,
    output  wire            QPLL_MUX_CLK_OUT
);

// clock multiplexer - pre-syntesis simulation only
assign QPLL_MUX_CLK_OUT = QPLLREFCLKSEL == 3'b000 ?     1'b0 // reserved
                        : QPLLREFCLKSEL == 3'b001 ?     GTREFCLK0
                        : QPLLREFCLKSEL == 3'b010 ?     GTREFCLK1
                        : QPLLREFCLKSEL == 3'b011 ?     GTNORTHREFCLK0
                        : QPLLREFCLKSEL == 3'b100 ?     GTNORTHREFCLK1
                        : QPLLREFCLKSEL == 3'b101 ?     GTSOUTHREFCLK0
                        : QPLLREFCLKSEL == 3'b110 ?     GTSOUTHREFCLK1
                        : /*CPLLREFCLKSEL == 3'b111 ?*/ GTGREFCLK;

endmodule

