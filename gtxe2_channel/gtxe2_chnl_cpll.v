/*******************************************************************************
 * Module: gtxe2_chnl_cpll
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: non-synthesizable pll implementation
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_cpll.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_cpll.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
`timescale 1ps/1ps
`include "gtxe2_chnl_cpll_def.v"
module gtxe2_chnl_cpll(
// top-level interfaces
    input   wire    CPLLLOCKDETCLK,
    input   wire    CPLLLOCKEN,
    input   wire    CPLLPD,
    input   wire    CPLLRESET,  // active high
    output  wire    CPLLFBCLKLOST,
    output  wire    CPLLLOCK,
    output  wire    CPLLREFCLKLOST,

    input   wire    GTRSVD,
    input   wire    PCSRSVDIN,
    input   wire    PCSRSVDIN2,
    input   wire    PMARSVDIN,
    input   wire    PMARSVDIN2,
    input   wire    TSTIN,
    output  wire    TSTOUT,

// internal
    input   wire    ref_clk,
    output  wire    clk_out,
    output  wire    pll_locked // equals CPLLLOCK
);

parameter   [23:0]  CPLL_CFG        = 29'h00BC07DC;
parameter   integer CPLL_FBDIV      = 4;
parameter   integer CPLL_FBDIV_45   = 5;
parameter   [23:0]  CPLL_INIT_CFG   = 24'h00001E;
parameter   [15:0]  CPLL_LOCK_CFG   = 16'h01E8;
parameter   integer CPLL_REFCLK_DIV = 1;
parameter   integer RXOUT_DIV       = 2;
parameter   integer TXOUT_DIV       = 2;
parameter           SATA_CPLL_CFG = "VCO_3000MHZ";
parameter   [1:0]   PMA_RSV3        = 1;

localparam          multiplier  = CPLL_FBDIV * CPLL_FBDIV_45;
localparam          divider     = CPLL_REFCLK_DIV;

assign  pll_locked = locked;
assign  CPLLLOCK = pll_locked;

wire    fb_clk_out;
wire    reset;
reg     mult_clk;
reg     mult_dev_clk;

assign  clk_out = mult_dev_clk;

// generate internal async reset
assign reset = CPLLPD | CPLLRESET;

// apply multipliers
time    last_edge;  // reference clock edge's absolute time
time    period;     // reference clock's period
integer locked_f;
reg     locked;

initial 
begin
    last_edge = 0;
    period = 0;
    forever @ (posedge ref_clk or posedge reset)
    begin
        period      = reset ? 0 : $time - (last_edge == 0 ? $time : last_edge);
        last_edge   = reset ? 0 : $time;
    end
end
reg tmp = 0;
initial
begin
    @ (posedge reset);
    forever @ (posedge ref_clk)
    begin
        tmp = ~tmp;
        if (period > 0)
        begin
            locked_f = 1;
            mult_clk = 1'b1;
            repeat (multiplier * 2 - 1)
            begin
                #(period/multiplier/2) 
                mult_clk = ~mult_clk;
            end
        end
        else
            locked_f = 0;
    end
end

// apply dividers
initial
begin
    mult_dev_clk = 1'b1;
    forever
    begin
        repeat (divider)
            @ (mult_clk);
        mult_dev_clk = ~mult_dev_clk;
    end
end

// show if 'pll' is locked
reg [31:0]  counter;
always @ (posedge ref_clk or posedge reset)
    counter <= reset | locked_f == 0 ? 0 : counter == `GTXE2_CHNL_CPLL_LOCK_TIME ? counter : counter + 1;

always @ (posedge ref_clk)
    locked <= counter == `GTXE2_CHNL_CPLL_LOCK_TIME;
/*
always @ (posedge ref_clk or posedge reset)
begin
    if (locked_f == 1 && ~reset)
    begin
        repeat (`GTXE2_CHNL_CPLL_LOCK_TIME) @ (posedge ref_clk);
        locked <= 1'b1;
    end
    else
        locked <= 1'b0;
end*/

endmodule
