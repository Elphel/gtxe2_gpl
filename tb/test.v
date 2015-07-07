/*******************************************************************************
 * Module: test
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: Generates test payload for GTXE2_CHANNEL
 *
 * Copyright (c) 2015 Elphel, Inc.
 * test.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * test.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
/*
 * simple aligner test + oob + checking for a corrent decoding
 */
module test(
    output  wire            reset,
    output  wire            rx_early_reset,
    input   wire            TXRESETDONE,
    input   wire            RXRESETDONE,
/*
 * TX
 */
    input   wire            TXP,
    input   wire            TXN,

    output  wire    [63:0]  TXDATA,
    output  wire            TXUSRCLK,
    output  wire            TXUSRCLK2,
    output  wire            TXUSERRDY,

// 8/10 encoder
    output  wire    [7:0]   TX8B10BBYPASS,
    output  wire            TX8B10BEN,
    output  wire    [7:0]   TXCHARDISPMODE,
    output  wire    [7:0]   TXCHARDISPVAL,
    output  wire    [7:0]   TXCHARISK,

// TX Buffer
    input   wire    [1:0]   TXBUFSTATUS,

// TX Polarity
    output  wire            TXPOLARITY,

// TX Fabric Clock Control
    output  wire    [2:0]   TXRATE,
    input   wire            TXRATEDONE,

// TX OOB
    output  wire            TXCOMINIT,
    output  wire            TXCOMWAKE,
    input   wire            TXCOMFINISH,

// TX Driver Control
    output  wire            TXELECIDLE,

/*
 * RX
 */ 
    output  wire            RXP,
    output  wire            RXN,
    
    output  wire            RXUSRCLK,
    output  wire            RXUSRCLK2,
    output  wire            RXUSERRDY,
    input   wire    [63:0]  RXDATA,

    output  wire    [2:0]   RXRATE,

// oob
    output  wire    [1:0]   RXELECIDLEMODE,
    input   wire            RXELECIDLE,

    input   wire            RXCOMINITDET,
    input   wire            RXCOMWAKEDET,

// polarity
    output  wire            RXPOLARITY,

// aligner
    input   wire            RXBYTEISALIGNED,
    input   wire            RXBYTEREALIGN,
    input   wire            RXCOMMADET,

    output  wire            RXCOMMADETEN,
    output  wire            RXPCOMMAALIGNEN,
    output  wire            RXMCOMMAALIGNEN,

// 10/8 decoder
    output  wire            RX8B10BEN,

    input   wire    [7:0]   RXCHARISCOMMA,
    input   wire    [7:0]   RXCHARISK,
    input   wire    [7:0]   RXDISPERR,
    input   wire    [7:0]   RXNOTINTABLE,

/*
 * Clocking
 */
// top-level interfaces
    output  wire    [2:0]   CPLLREFCLKSEL,
    output  wire            GTREFCLK0,
    output  wire            GTREFCLK1,
    output  wire            GTNORTHREFCLK0,
    output  wire            GTNORTHREFCLK1,
    output  wire            GTSOUTHREFCLK0,
    output  wire            GTSOUTHREFCLK1,
    output  wire            GTGREFCLK,
    output  wire    [1:0]   RXSYSCLKSEL,
    output  wire    [1:0]   TXSYSCLKSEL,
    output  wire    [2:0]   TXOUTCLKSEL,
    output  wire    [2:0]   RXOUTCLKSEL,
    output  wire            TXDLYBYPASS,
    input   wire            GTREFCLKMONITOR,

    output  wire            CPLLLOCKDETCLK, 
    output  wire            CPLLLOCKEN,
    output  wire            CPLLPD,
    output  wire            CPLLRESET,
    input   wire            CPLLFBCLKLOST,
    input   wire            CPLLLOCK,
    input   wire            CPLLREFCLKLOST,

// phy-level interfaces
    input   wire            TXOUTCLKPMA,
    input   wire            TXOUTCLKPCS,
    input   wire            TXOUTCLK,
    input   wire            TXOUTCLKFABRIC,
    input   wire            tx_serial_clk,

    input   wire            RXOUTCLKPMA,
    input   wire            RXOUTCLKPCS,
    input   wire            RXOUTCLK,
    input   wire            RXOUTCLKFABRIC,
    input   wire            rx_serial_clk,

    output  wire            RXDFELFHOLD,
    output  wire            RXDFEAGCHOLD,


/*
 * GTXE2_COMMON
 */
    output  wire    [2:0]   QPLLREFCLKSEL,
    input   wire            QPLLOUTCLK,
    input   wire            QPLLOUTREFCLK,
    
    output  wire            QPLLLOCKDETCLK, 
    output  wire            QPLLLOCKEN,
    output  wire            QPLLPD,
    output  wire            QPLLRESET,
    input   wire            QPLLFBCLKLOST,
    input   wire            QPLLLOCK,
    input   wire            QPLLREFCLKLOST
);
reg gtxreset;
reg hard_rst;

initial #1 $display("HI THERE");
initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,tb);
end

// simulation stop condition
initial
//    #10000 $stop;
    #100000000 $finish;

// ref clock
reg clk = 1'b0;
always #3000
    clk = ~clk;

// reset
initial 
begin
    hard_rst = 1'b0;
    #1000000;
    hard_rst <= 1'b1;
    #1000000;
    hard_rst <= 1'b0;
end

initial
begin
    gtxreset = 1'b0;
    @ (negedge hard_rst);
    gtxreset <= 1'b1;
    #1000000;
    gtxreset <= 1'b0;
end

// data
reg [15:0] data;
reg align_switch = 0;
reg [7:0] control = 0;
assign  TXDATA = {47'h0, data};
initial
begin
    data = 16'h0;
    @ (negedge reset);
//    @ (negedge reset);
//#2000000;
    @ (posedge RXCOMWAKEDET or posedge TXCOMFINISH);
    @ (posedge RXCOMWAKEDET or posedge TXCOMFINISH);
/*    repeat (30) 
        @ (posedge clk);
    @ (posedge clk) data <= 16'hde;
    @ (posedge clk) data <= 16'had;
    @ (posedge clk) data <= 16'hbe;
    @ (posedge clk) data <= 16'hef;*/
    repeat (30) 
        @ (posedge clk);
                    align_switch <= 1'b1;
    @ (posedge clk) data <= 16'hde;
    @ (posedge clk) data <= 16'had;
    @ (posedge clk) data <= 16'hbe;
    @ (posedge clk) data <= 16'hef;
    @ (posedge clk) data <= 16'hbc; //comma
                    control <= 8'b01;
    @ (posedge clk) data <= 16'hde;
                    control <= 8'b00;
    @ (posedge clk) data <= 16'had;
    @ (posedge clk) data <= 16'hbe;
    @ (posedge clk) data <= 16'hef;
    @ (posedge clk) data <= 16'hbc; //comma
                    control <= 8'b01;
    @ (posedge clk) data <= 16'hde;
                    control <= 8'b00;
    @ (posedge clk) data <= 16'had;
    @ (posedge clk) data <= 16'hbe;
    @ (posedge clk) data <= 16'hef;
end

assign  TXCHARISK   = control;

// oob
reg oob_idle;
reg oob_init;
reg oob_wake;

assign  TXELECIDLE  = oob_idle;
assign  TXCOMINIT   = oob_init;
assign  TXCOMWAKE   = oob_wake;

initial
begin
    oob_idle = 0;
    oob_init = 0;
    oob_wake = 0;
    #1000000;
//    @ (negedge reset);
//    @ (negedge reset);
    @ (posedge RXRESETDONE or TXRESETDONE);
    @ (posedge RXRESETDONE or TXRESETDONE);
    #2000000;
    repeat (10)
        @ (posedge clk);
    @ (posedge clk) oob_idle <= 1'b1;
    @ (posedge clk) oob_init <= 1'b1;
    @ (posedge clk) oob_init <= 1'b0;
    @ (posedge RXCOMINITDET or posedge TXCOMFINISH);
    @ (posedge RXCOMINITDET or posedge TXCOMFINISH);
    @ (posedge clk);
    @ (posedge clk) oob_wake <= 1'b1;
    @ (posedge clk) oob_wake <= 1'b0;
    @ (posedge RXCOMWAKEDET or posedge TXCOMFINISH);
    @ (posedge RXCOMWAKEDET or posedge TXCOMFINISH);
    repeat (5)
        @ (posedge clk);
    @ (posedge clk) oob_idle <= 1'b0;
end

/*
 * TXUSERRDY/RXUSERRDY
 */
reg rx_userrdy = 1'b0;
reg tx_userrdy = 1'b0;

initial
begin
    @ (negedge gtxreset);
    repeat (100) 
        @ (posedge RXUSRCLK);
    rx_userrdy <= 1'b1;
end

initial
begin
    @ (negedge gtxreset);
    repeat (100) 
        @ (posedge TXUSRCLK);
    tx_userrdy <= 1'b1;
end

/*
 * Make some disalignments
 */
/*reg xn;
reg xp;

always @ (posedge rx_serial_clk)
begin
    xp <= TXP;
    xn <= TXN;
end*/
reg [10:0] xn;
reg [10:0] xp;
always #300 //every serial clk 
begin
    xn[0] <= TXN;
    xp[0] <= TXP;
    xp[10:1] <= xp[9:0];
    xn[10:1] <= xn[9:0];
end
assign  RXN         = align_switch ? xn[10] : TXN;
assign  RXP         = align_switch ? xp[10] : TXP;

/*
 * loopbacks
 */

assign  CPLLRESET   = hard_rst;
assign  QPLLRESET   = hard_rst;
assign  reset       = ~CPLLLOCK | gtxreset | hard_rst;
assign  TXUSERRDY   = tx_userrdy;
assign  RXUSERRDY   = rx_userrdy;
assign  CPLLPD      = 1'b0;
assign  QPLLPD      = 1'b0;
assign  GTREFCLK0   = clk; // 150Mhz
assign  TXUSRCLK    = TXOUTCLK;
assign  TXUSRCLK2   = TXOUTCLK;
assign  RXUSRCLK    = TXOUTCLK;
assign  RXUSRCLK2   = TXOUTCLK;
assign  TXSYSCLKSEL = 2'b00;
assign  RXSYSCLKSEL = 2'b00;
assign  CPLLREFCLKSEL = 3'b001;
assign  RXOUTCLKSEL = 3'b011;
assign  TXOUTCLKSEL = 3'b011;
assign  TXPOLARITY  = 1'b0;
assign  RXPOLARITY  = 1'b0;
assign  RXPCOMMAALIGNEN = 1'b1;
assign  RXMCOMMAALIGNEN = 1'b1;
assign  RXCOMMADETEN    = 1'b1;
assign  TXRATE      = 3'b010;
assign  RXRATE      = 3'b010;

assign  RXDFELFHOLD = 1'b0;
assign  RXDFEAGCHOLD = 1'b0;

/*
 * IP only : cplllockdetclk
 */
reg cplldetclk = 0;
assign  CPLLLOCKDETCLK = cplldetclk;
always #8000
    cplldetclk = ~cplldetclk;

endmodule

