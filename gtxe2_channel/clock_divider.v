/*******************************************************************************
 * Module: clock_divider
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: Non-sinthesizable clock divider
 *
 * Copyright (c) 2015 Elphel, Inc.
 * clock_divider.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * clock_divider.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
 /**
  * Divides input clock either by input 'div' or by parameter 'divide_by' if divide_by_param
  * was set to 1
  **/
`ifndef CLOCK_DIVIDER_V
`define CLOCK_DIVIDER_V
// non synthesisable!
module clock_divider(
    input   wire    clk_in,
    output  reg     clk_out,

    input   wire    [31:0]  div
);
parameter divide_by = 1;
parameter divide_by_param = 1;

reg     [31:0]  cnt = 0;

reg [31:0]  div_r;
initial
begin
    cnt = 0;
    clk_out = 1'b1;
    forever
    begin
        if (divide_by_param == 0)
        begin
            if (div > 32'h0) 
                div_r = div;
            else    
                div_r = 1;
            repeat (div_r)
                @ (clk_in);
        end
        else
        begin
            repeat (divide_by)
                @ (clk_in);
        end
        clk_out = ~clk_out;
    end
end

endmodule
`endif
