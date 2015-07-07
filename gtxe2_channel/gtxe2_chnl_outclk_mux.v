/*******************************************************************************
 * Module: gtxe2_chnl_cpll_outmux
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: non-sinthesizable clock multiplexer, used in clocking scheme
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_cpll_outmux.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_cpll_outmux.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
module gtxe2_chnl_outclk_mux(
    input   wire            TXPLLREFCLK_DIV1,
    input   wire            TXPLLREFCLK_DIV2,
    input   wire            TXOUTCLKPMA,
    input   wire            TXOUTCLKPCS,
    input   wire    [2:0]   TXOUTCLKSEL,
    input   wire            TXDLYBYPASS,
    output  wire            TXOUTCLK
);

assign  TXOUTCLK    = TXOUTCLKSEL == 3'b001 ? TXOUTCLKPCS                       
                    : TXOUTCLKSEL == 3'b010 ? TXOUTCLKPMA                      
                    : TXOUTCLKSEL == 3'b011 ? TXPLLREFCLK_DIV1                           
                    : TXOUTCLKSEL == 3'b100 ? TXPLLREFCLK_DIV2
                    : /* 3'b000 */            1'b1; 
endmodule
