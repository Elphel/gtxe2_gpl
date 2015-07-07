/*******************************************************************************
 * Module: gtxe2_chnl_tx_oob
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: oob block implementation
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_tx_oob.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_tx_oob.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
module gtxe2_chnl_tx_oob #(
    parameter width = 20
)
(
// top-level ifaces
    input   wire                    TXCOMINIT,
    input   wire                    TXCOMWAKE,
    output  wire                    TXCOMFINISH,

// internal ifaces
    input   wire                    clk,
    input   wire                    reset,
    input   wire                    disparity,
    output  wire    [width - 1:0]   outdata,
    output  wire                    outval
);
parameter   [3:0]   SATA_BURST_SEQ_LEN = 4'b0101;
parameter           SATA_CPLL_CFG = "VCO_3000MHZ";

localparam  burst_len_mult  = SATA_CPLL_CFG == "VCO_3000MHZ" ? 4
                            : SATA_CPLL_CFG == "VCO_1500MHZ" ? 2 
                            : /*                VCO_750MHZ */  1;
localparam  burst_len       = burst_len_mult * 8; // = 106.7ns; each burst contains 16 SATA Gen1 words
localparam  quiet_len_init  = burst_len * 3; // = 320ns
localparam  quiet_len_wake  = burst_len; // = 106.7ns
localparam  init_bursts_cnt = SATA_BURST_SEQ_LEN;//3;
localparam  wake_bursts_cnt = SATA_BURST_SEQ_LEN;//5;

reg     [31:0]  bursts_cnt;
reg     [31:0]  stopwatch;
wire            stopwatch_clr;
wire            bursts_cnt_inc;
wire            bursts_cnt_clr;
wire    [31:0]  quiet_len;

// FSM Declarations
reg     state_burst;
reg     state_quiet;
wire    state_idle;

wire    set_burst;
wire    set_quiet;
wire    clr_burst;
wire    clr_quiet;

// remember what command was issued
reg             issued_init;
reg             issued_wake;

always @ (posedge clk)
begin
    issued_init <= reset | TXCOMFINISH | issued_wake ? 1'b0 : TXCOMINIT ? 1'b1 : state_idle ? 1'b0 : issued_init;
    issued_wake <= reset | TXCOMFINISH | issued_init ? 1'b0 : TXCOMWAKE ? 1'b1 : state_idle ? 1'b0 : issued_wake;
end

wire    [31:0]  bursts_cnt_togo;
assign  bursts_cnt_togo = issued_wake ? wake_bursts_cnt : init_bursts_cnt ;

// FSM

assign  state_idle = ~state_burst & ~state_quiet;
always @ (posedge clk)
begin
    state_burst <= (state_burst | set_burst) & ~reset & ~clr_burst;
    state_quiet <= (state_quiet | set_quiet) & ~reset & ~clr_quiet;
end

assign  set_burst = state_idle & (TXCOMINIT | TXCOMWAKE) | state_quiet & clr_quiet & ~TXCOMFINISH;
assign  set_quiet = state_burst & (bursts_cnt < bursts_cnt_togo - 1) & clr_burst;

assign  clr_burst = state_burst & stopwatch == burst_len;
assign  clr_quiet = state_quiet & stopwatch == quiet_len;

// bursts timing
assign  quiet_len = issued_wake ? quiet_len_wake : quiet_len_init;
assign  stopwatch_clr = set_burst | set_quiet | state_idle;
always @ (posedge clk)
    stopwatch   <= reset | stopwatch_clr ? 0 : stopwatch + burst_len_mult;

// total bursts count
assign  bursts_cnt_clr = state_idle;
assign  bursts_cnt_inc = state_burst & clr_burst;
always @ (posedge clk)
    bursts_cnt  <= reset | bursts_cnt_clr ? 0 : bursts_cnt_inc ? bursts_cnt + 1 : bursts_cnt;

// data to serializer
// only datawidth = 20 is supported for now
wire    [width - 1:0]   outdata_pos;
wire    [width - 1:0]   outdata_neg;
// outdata = {Align2 + Align1}, disparity always flips
assign  outdata_pos = stopwatch[0] == 1'b0 ? {10'b0101010101, 10'b1100000101}
                                           : {10'b1101100011, 10'b0101010101};
assign  outdata_neg = stopwatch[0] == 1'b0 ? {10'b0101010101, 10'b0011111010}
                                           : {10'b0010011100, 10'b0101010101};
assign  outdata     = disparity ? outdata_pos : outdata_neg;
assign  outval      = state_burst;

assign  TXCOMFINISH = bursts_cnt_clr & bursts_cnt == bursts_cnt_togo;

endmodule
