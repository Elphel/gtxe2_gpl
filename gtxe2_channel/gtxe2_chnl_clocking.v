/*******************************************************************************
 * Module: gtxe2_chnl_clocking
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: channel's clocking top-level. Places muxes, plls, dividers,
 *              as they're depicted @ xilinx's ug476 p.36, p.46, p. 150, p. 211
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl_clocking.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl_clocking.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
`include "gtxe2_chnl_cpll_inmux.v"
`include "gtxe2_chnl_outclk_mux.v"
`include "gtxe2_chnl_cpll.v"
`include "clock_divider.v"
module gtxe2_chnl_clocking(
// top-level interfaces
    input   wire    [2:0]   CPLLREFCLKSEL,
    input   wire            GTREFCLK0,
    input   wire            GTREFCLK1,
    input   wire            GTNORTHREFCLK0,
    input   wire            GTNORTHREFCLK1,
    input   wire            GTSOUTHREFCLK0,
    input   wire            GTSOUTHREFCLK1,
    input   wire            GTGREFCLK,
    input   wire            QPLLCLK,
    input   wire            QPLLREFCLK, 
    input   wire    [1:0]   RXSYSCLKSEL,
    input   wire    [1:0]   TXSYSCLKSEL,
    input   wire    [2:0]   TXOUTCLKSEL,
    input   wire    [2:0]   RXOUTCLKSEL,
    input   wire            TXDLYBYPASS,
    output  wire            GTREFCLKMONITOR,

    input   wire            CPLLLOCKDETCLK, 
    input   wire            CPLLLOCKEN,
    input   wire            CPLLPD,
    input   wire            CPLLRESET,
    output  wire            CPLLFBCLKLOST,
    output  wire            CPLLLOCK,
    output  wire            CPLLREFCLKLOST,

    input   wire    [2:0]   TXRATE,
    input   wire    [2:0]   RXRATE,

// phy-level interfaces
    output  wire            TXOUTCLKPMA,
    output  wire            TXOUTCLKPCS,
    output  wire            TXOUTCLK,
    output  wire            TXOUTCLKFABRIC,
    output  wire            tx_serial_clk,
    output  wire            tx_piso_clk,

    output  wire            RXOUTCLKPMA,
    output  wire            RXOUTCLKPCS,
    output  wire            RXOUTCLK,
    output  wire            RXOUTCLKFABRIC,
    output  wire            rx_serial_clk,
    output  wire            tx_sipo_clk
);
// CPLL
parameter   [23:0]  CPLL_CFG        = 29'h00BC07DC;
parameter   integer CPLL_FBDIV      = 4;
parameter   integer CPLL_FBDIV_45   = 5;
parameter   [23:0]  CPLL_INIT_CFG   = 24'h00001E;
parameter   [15:0]  CPLL_LOCK_CFG   = 16'h01E8;
parameter   integer CPLL_REFCLK_DIV = 1;
parameter           SATA_CPLL_CFG = "VCO_3000MHZ";
parameter   [1:0]   PMA_RSV3        = 1;

parameter   TXOUT_DIV   = 2;
//parameter   TXRATE      = 3'b000;
parameter   RXOUT_DIV   = 2;
//parameter   RXRATE      = 3'b000;

parameter   TX_INT_DATAWIDTH    = 0;
parameter   TX_DATA_WIDTH       = 20;
parameter   RX_INT_DATAWIDTH    = 0;
parameter   RX_DATA_WIDTH       = 20;
/*
localparam  tx_serial_divider   = TXRATE == 3'b001 ? 1
                                : TXRATE == 3'b010 ? 2
                                : TXRATE == 3'b011 ? 4
                                : TXRATE == 3'b100 ? 8
                                : TXRATE == 3'b101 ? 16 : TXOUT_DIV ;
localparam  rx_serial_divider   = RXRATE == 3'b001 ? 1
                                : RXRATE == 3'b010 ? 2
                                : RXRATE == 3'b011 ? 4
                                : RXRATE == 3'b100 ? 8
                                : RXRATE == 3'b101 ? 16 : RXOUT_DIV ;
*/
localparam  tx_pma_divider1 = TX_INT_DATAWIDTH == 1 ? 4 : 2;
localparam  tx_pcs_divider1 = tx_pma_divider1;
localparam  tx_pma_divider2 = TX_DATA_WIDTH == 20 | TX_DATA_WIDTH == 40 | TX_DATA_WIDTH == 80 ? 5 : 4;
localparam  tx_pcs_divider2 = tx_pma_divider2;
localparam  rx_pma_divider1 = RX_INT_DATAWIDTH == 1 ? 4 : 2;
localparam  rx_pma_divider2 = RX_DATA_WIDTH == 20 | RX_DATA_WIDTH == 40 | RX_DATA_WIDTH == 80 ? 5 : 4;

wire    clk_mux_out;
wire    cpll_clk_out;
wire    tx_phy_clk;
wire    rx_phy_clk;
wire    TXPLLREFCLK_DIV1;
wire    TXPLLREFCLK_DIV2;
wire    RXPLLREFCLK_DIV1;
wire    RXPLLREFCLK_DIV2;

assign  tx_phy_clk          = TXSYSCLKSEL[0] ? QPLLCLK : cpll_clk_out;
assign  TXPLLREFCLK_DIV1    = TXSYSCLKSEL[1] ? QPLLREFCLK : clk_mux_out;
assign  rx_phy_clk          = RXSYSCLKSEL[0] ? QPLLCLK : cpll_clk_out;
assign  RXPLLREFCLK_DIV1    = RXSYSCLKSEL[1] ? QPLLREFCLK : clk_mux_out;

assign  tx_serial_clk = tx_phy_clk;
assign  rx_serial_clk = rx_phy_clk;

// piso and sipo clocks
// are not used in the design - no need to use ddr mode during simulation. much easier just multi serial clk by 2
wire    [31:0]  tx_serial_divider;
wire    [31:0]  rx_serial_divider;
assign  tx_serial_divider = TXRATE == 3'b001 ? 1
                          : TXRATE == 3'b010 ? 2
                          : TXRATE == 3'b011 ? 4
                          : TXRATE == 3'b100 ? 8
                          : TXRATE == 3'b101 ? 16 : TXOUT_DIV ;
assign  rx_serial_divider = RXRATE == 3'b001 ? 1
                          : RXRATE == 3'b010 ? 2
                          : RXRATE == 3'b011 ? 4
                          : RXRATE == 3'b100 ? 8
                          : RXRATE == 3'b101 ? 16 : RXOUT_DIV ;
clock_divider #(
//    .divide_by  (tx_serial_divider),
    .divide_by_param (0)
)
tx_toserialclk_div(
    .clk_in     (tx_phy_clk),
    .clk_out    (tx_piso_clk),

    .div        (tx_serial_divider)
);
clock_divider #(
//    .divide_by  (rx_serial_divider),
    .divide_by_param (0)
)
rx_toserialclk_div(
    .clk_in     (rx_phy_clk),
    .clk_out    (rx_sipo_clk),

    .div        (rx_serial_divider)
);

// TXOUTCLKPCS/TXOUTCLKPMA generation
wire    tx_pma_div1_clk;
assign  TXOUTCLKPCS = TXOUTCLKPMA;

clock_divider #(
    .divide_by (tx_pma_divider1)
)
tx_pma_div1(
    .clk_in     (tx_piso_clk),
    .clk_out    (tx_pma_div1_clk)
);

clock_divider #(
    .divide_by (tx_pma_divider2)
)
tx_pma_div2(
    .clk_in     (tx_pma_div1_clk),
    .clk_out    (TXOUTCLKPMA)
);

// RXOUTCLKPCS/RXOUTCLKPMA generation
wire    rx_pma_div1_clk;
assign  RXOUTCLKPCS = RXOUTCLKPMA;
clock_divider #(
    .divide_by  (rx_pma_divider1)
)
rx_pma_div1(
    .clk_in     (rx_sipo_clk),
    .clk_out    (rx_pma_div1_clk)
);

clock_divider #(
    .divide_by  (rx_pma_divider2)
)
rx_pma_div2(
    .clk_in     (rx_pma_div1_clk),
    .clk_out    (RXOUTCLKPMA)
);

//
clock_divider #(
    .divide_by  (2)
)
txpllrefclk_div2(
    .clk_in     (TXPLLREFCLK_DIV1),
    .clk_out    (TXPLLREFCLK_DIV2)
);
clock_divider #(
    .divide_by  (2)
)
rxpllrefclk_div2(
    .clk_in     (RXPLLREFCLK_DIV1),
    .clk_out    (RXPLLREFCLK_DIV2)
);

gtxe2_chnl_outclk_mux tx_out_mux(
    .TXPLLREFCLK_DIV1  (TXPLLREFCLK_DIV1),
    .TXPLLREFCLK_DIV2  (TXPLLREFCLK_DIV2),
    .TXOUTCLKPMA       (TXOUTCLKPMA),
    .TXOUTCLKPCS       (TXOUTCLKPCS),
    .TXOUTCLKSEL       (TXOUTCLKSEL),
    .TXDLYBYPASS       (TXDLYBYPASS),
    .TXOUTCLK          (TXOUTCLK)
);

gtxe2_chnl_outclk_mux rx_out_mux(
    .TXPLLREFCLK_DIV1  (RXPLLREFCLK_DIV1),
    .TXPLLREFCLK_DIV2  (RXPLLREFCLK_DIV2),
    .TXOUTCLKPMA       (RXOUTCLKPMA),
    .TXOUTCLKPCS       (RXOUTCLKPCS),
    .TXOUTCLKSEL       (RXOUTCLKSEL),
    .TXDLYBYPASS       (RXDLYBYPASS),
    .TXOUTCLK          (RXOUTCLK)
);


gtxe2_chnl_cpll_inmux clk_mux(
    .CPLLREFCLKSEL      (CPLLREFCLKSEL),

    .GTREFCLK0          (GTREFCLK0),
    .GTREFCLK1          (GTREFCLK1),
    .GTNORTHREFCLK0     (GTNORTHREFCLK0),
    .GTNORTHREFCLK1     (GTNORTHREFCLK1),
    .GTSOUTHREFCLK0     (GTSOUTHREFCLK0),
    .GTSOUTHREFCLK1     (GTSOUTHREFCLK1),
    .GTGREFCLK          (GTGREFCLK),

    .CPLL_MUX_CLK_OUT   (clk_mux_out)
);

gtxe2_chnl_cpll #(
    .CPLL_FBDIV      (4),
    .CPLL_FBDIV_45   (5),
    .CPLL_REFCLK_DIV (1)
)
cpll(
    .CPLLLOCKDETCLK     (CPLLLOCKDETCLK),
    .CPLLLOCKEN         (CPLLLOCKEN),
    .CPLLPD             (CPLLPD),
    .CPLLRESET          (CPLLRESET),
    .CPLLFBCLKLOST      (CPLLFBCLKLOST),
    .CPLLLOCK           (CPLLLOCK),
    .CPLLREFCLKLOST     (CPLLREFCLKLOST),
    
    .GTRSVD             (GTRSVD),
    .PCSRSVDIN          (PCSRSVDIN),
    .PCSRSVDIN2         (PCSRSVDIN2),
    .PMARSVDIN          (PMARSVDIN),
    .PMARSVDIN2         (PMARSVDIN2),
    .TSTIN              (TSTIN),
    .TSTOUT             (TSTOUT),
    
    .ref_clk            (clk_mux_out),
    .clk_out            (cpll_clk_out),
    .pll_locked         (pll_locked)
);

endmodule
