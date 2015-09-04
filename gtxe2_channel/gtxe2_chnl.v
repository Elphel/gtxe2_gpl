/*******************************************************************************
 * Module: gtxe2_chnl
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: top-level module gtxe2_chnl = tx + rx + clocking
 *
 * Copyright (c) 2015 Elphel, Inc.
 * gtxe2_chnl.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * gtxe2_chnl.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
`include "gtxe2_chnl_clocking.v"
`include "gtxe2_chnl_tx.v"
`include "gtxe2_chnl_rx.v"
module gtxe2_chnl(
    input   wire            reset,
/*
 * TX
 */
    output  wire            TXP,
    output  wire            TXN,

    input   wire    [63:0]  TXDATA,
    input   wire            TXUSRCLK,
    input   wire            TXUSRCLK2,

// 8/10 encoder
    input   wire    [7:0]   TX8B10BBYPASS,
    input   wire            TX8B10BEN,
    input   wire    [7:0]   TXCHARDISPMODE,
    input   wire    [7:0]   TXCHARDISPVAL,
    input   wire    [7:0]   TXCHARISK,

// TX Buffer
    output  wire    [1:0]   TXBUFSTATUS,

// TX Polarity
    input   wire            TXPOLARITY,

// TX Fabric Clock Control
    input   wire    [2:0]   TXRATE,
    output  wire            TXRATEDONE,

// TX OOB
    input   wire            TXCOMINIT,
    input   wire            TXCOMWAKE,
    output  wire            TXCOMFINISH,

// TX Driver Control
    input   wire            TXELECIDLE,

/*
 * RX
 */ 
    input   wire            RXP,
    input   wire            RXN,
    
    input   wire            RXUSRCLK,
    input   wire            RXUSRCLK2,

    output  wire    [63:0]  RXDATA,

    input   wire    [2:0]   RXRATE,

// oob
    input   wire    [1:0]   RXELECIDLEMODE,
    output  wire            RXELECIDLE,

    output  wire            RXCOMINITDET,
    output  wire            RXCOMWAKEDET,

// polarity
    input   wire            RXPOLARITY,

// aligner
    output  wire            RXBYTEISALIGNED,
    output  wire            RXBYTEREALIGN,
    output  wire            RXCOMMADET,

    input   wire            RXCOMMADETEN,
    input   wire            RXPCOMMAALIGNEN,
    input   wire            RXMCOMMAALIGNEN,

// 10/8 decoder
    input   wire            RX8B10BEN,

    output  wire    [7:0]   RXCHARISCOMMA,
    output  wire    [7:0]   RXCHARISK,
    output  wire    [7:0]   RXDISPERR,
    output  wire    [7:0]   RXNOTINTABLE,

/*
 * Clocking
 */
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
    input   wire            RXDLYBYPASS,
    output  wire            GTREFCLKMONITOR,

    input   wire            CPLLLOCKDETCLK, 
    input   wire            CPLLLOCKEN,
    input   wire            CPLLPD,
    input   wire            CPLLRESET,
    output  wire            CPLLFBCLKLOST,
    output  wire            CPLLLOCK,
    output  wire            CPLLREFCLKLOST,

// phy-level interfaces
    output  wire            TXOUTCLKPMA,
    output  wire            TXOUTCLKPCS,
    output  wire            TXOUTCLK,
    output  wire            TXOUTCLKFABRIC,
    output  wire            tx_serial_clk,

    output  wire            RXOUTCLKPMA,
    output  wire            RXOUTCLKPCS,
    output  wire            RXOUTCLK,
    output  wire            RXOUTCLKFABRIC,
    output  wire            rx_serial_clk
);
parameter   [23:0]  CPLL_CFG        = 29'h00BC07DC;
parameter   integer CPLL_FBDIV      = 4;
parameter   integer CPLL_FBDIV_45   = 5;
parameter   [23:0]  CPLL_INIT_CFG   = 24'h00001E;
parameter   [15:0]  CPLL_LOCK_CFG   = 16'h01E8;
parameter   integer CPLL_REFCLK_DIV = 1;
parameter   [1:0]   PMA_RSV3        = 1;

parameter   TXOUT_DIV   = 2;
//parameter   TXRATE      = 3'b000;
parameter   RXOUT_DIV   = 2;
//parameter   RXRATE      = 3'b000;

parameter   integer TX_INT_DATAWIDTH    = 0;
parameter   integer TX_DATA_WIDTH       = 20;

parameter   integer RX_DATA_WIDTH       = 20;
parameter   integer RX_INT_DATAWIDTH    = 0;

parameter   DEC_MCOMMA_DETECT = "TRUE";
parameter   DEC_PCOMMA_DETECT = "TRUE";

parameter   [9:0]   ALIGN_MCOMMA_VALUE  = 10'b1010000011;
parameter           ALIGN_MCOMMA_DET    = "TRUE";
parameter   [9:0]   ALIGN_PCOMMA_VALUE  = 10'b0101111100;
parameter           ALIGN_PCOMMA_DET    = "TRUE";
parameter   [9:0]   ALIGN_COMMA_ENABLE  = 10'b1111111111;
parameter           ALIGN_COMMA_DOUBLE  = "FALSE";


parameter   [3:0]   SATA_BURST_SEQ_LEN = 4'b1111;
parameter           SATA_CPLL_CFG = "VCO_3000MHZ";

gtxe2_chnl_tx #(
    .TX_DATA_WIDTH      (TX_DATA_WIDTH),
    .TX_INT_DATAWIDTH   (TX_INT_DATAWIDTH),
    .SATA_BURST_SEQ_LEN (SATA_BURST_SEQ_LEN),
    .SATA_CPLL_CFG      (SATA_CPLL_CFG)
)
tx(
    .reset              (reset),
    .TXP                (TXP),
    .TXN                (TXN),

    .TXDATA             (TXDATA),
    .TXUSRCLK           (TXUSRCLK),
    .TXUSRCLK2          (TXUSRCLK2),

    .TX8B10BBYPASS      (TX8B10BBYPASS),
    .TX8B10BEN          (TX8B10BEN),
    .TXCHARDISPMODE     (TXCHARDISPMODE),
    .TXCHARDISPVAL      (TXCHARDISPVAL),
    .TXCHARISK          (TXCHARISK),

    .TXBUFSTATUS        (TXBUFSTATUS),

    .TXPOLARITY         (TXPOLARITY),

    .TXRATE             (TXRATE),
    .TXRATEDONE         (TXRATEDONE),

    .TXCOMINIT          (TXCOMINIT),
    .TXCOMWAKE          (TXCOMWAKE),
    .TXCOMFINISH        (TXCOMFINISH),

    .TXELECIDLE         (TXELECIDLE),

    .serial_clk         (tx_serial_clk)
);

gtxe2_chnl_rx #(
    .RX_DATA_WIDTH          (RX_DATA_WIDTH),
    .RX_INT_DATAWIDTH       (RX_INT_DATAWIDTH),

    .DEC_MCOMMA_DETECT      (DEC_MCOMMA_DETECT),
    .DEC_PCOMMA_DETECT      (DEC_PCOMMA_DETECT),

    .ALIGN_MCOMMA_VALUE     (ALIGN_MCOMMA_VALUE),
    .ALIGN_MCOMMA_DET       (ALIGN_MCOMMA_DET),
    .ALIGN_PCOMMA_VALUE     (ALIGN_PCOMMA_VALUE),
    .ALIGN_PCOMMA_DET       (ALIGN_PCOMMA_DET),
    .ALIGN_COMMA_ENABLE     (ALIGN_COMMA_ENABLE),
    .ALIGN_COMMA_DOUBLE     (ALIGN_COMMA_DOUBLE)
)
rx(
    .reset              (reset),
    .RXP                (RXP),
    .RXN                (RXN),

    .RXUSRCLK           (RXUSRCLK),
    .RXUSRCLK2          (RXUSRCLK2),

    .RXDATA             (RXDATA),

    .RXELECIDLEMODE     (RXELECIDLEMODE),
    .RXELECIDLE         (RXELECIDLE),
    .RXCOMINITDET       (RXCOMINITDET),
    .RXCOMWAKEDET       (RXCOMWAKEDET),

    .RXPOLARITY         (RXPOLARITY),

    .RXBYTEISALIGNED    (RXBYTEISALIGNED),
    .RXBYTEREALIGN      (RXBYTEREALIGN),
    .RXCOMMADET         (RXCOMMADET),

    .RXCOMMADETEN       (RXCOMMADETEN),
    .RXPCOMMAALIGNEN    (RXPCOMMAALIGNEN),
    .RXMCOMMAALIGNEN    (RXMCOMMAALIGNEN),

    .RX8B10BEN          (RX8B10BEN),

    .RXCHARISCOMMA      (RXCHARISCOMMA),
    .RXCHARISK          (RXCHARISK),
    .RXDISPERR          (RXDISPERR),
    .RXNOTINTABLE       (RXNOTINTABLE),

    .serial_clk         (rx_serial_clk)
);

gtxe2_chnl_clocking #(
    .CPLL_CFG           (CPLL_CFG),
    .CPLL_FBDIV         (CPLL_FBDIV),
    .CPLL_FBDIV_45      (CPLL_FBDIV_45),
    .CPLL_INIT_CFG      (CPLL_INIT_CFG),
    .CPLL_LOCK_CFG      (CPLL_LOCK_CFG),
    .CPLL_REFCLK_DIV    (CPLL_REFCLK_DIV),
    .RXOUT_DIV          (RXOUT_DIV),
    .TXOUT_DIV          (TXOUT_DIV),
    .SATA_CPLL_CFG      (SATA_CPLL_CFG),
    .PMA_RSV3           (PMA_RSV3),

    .TX_INT_DATAWIDTH   (TX_INT_DATAWIDTH),
    .TX_DATA_WIDTH      (TX_DATA_WIDTH),
    .RX_INT_DATAWIDTH   (RX_INT_DATAWIDTH),
    .RX_DATA_WIDTH      (RX_DATA_WIDTH)
)
clocking(
    .CPLLREFCLKSEL      (CPLLREFCLKSEL),
    .GTREFCLK0          (GTREFCLK0),
    .GTREFCLK1          (GTREFCLK1),
    .GTNORTHREFCLK0     (GTNORTHREFCLK0),
    .GTNORTHREFCLK1     (GTNORTHREFCLK1),
    .GTSOUTHREFCLK0     (GTSOUTHREFCLK0),
    .GTSOUTHREFCLK1     (GTSOUTHREFCLK1),
    .GTGREFCLK          (GTGREFCLK),
    .QPLLCLK            (QPLLCLK),
    .QPLLREFCLK         (QPLLREFCLK ),
    .RXSYSCLKSEL        (RXSYSCLKSEL),
    .TXSYSCLKSEL        (TXSYSCLKSEL),
    .TXOUTCLKSEL        (TXOUTCLKSEL),
    .RXOUTCLKSEL        (RXOUTCLKSEL),
    .TXDLYBYPASS        (TXDLYBYPASS),
    .RXDLYBYPASS        (RXDLYBYPASS),
    .GTREFCLKMONITOR    (GTREFCLKMONITOR),

    .CPLLLOCKDETCLK     (CPLLLOCKDETCLK),
    .CPLLLOCKEN         (CPLLLOCKEN),
    .CPLLPD             (CPLLPD),
    .CPLLRESET          (CPLLRESET),
    .CPLLFBCLKLOST      (CPLLFBCLKLOST),
    .CPLLLOCK           (CPLLLOCK),
    .CPLLREFCLKLOST     (CPLLREFCLKLOST),

    .TXRATE             (TXRATE),
    .RXRATE             (RXRATE),

    .TXOUTCLKPMA        (TXOUTCLKPMA),
    .TXOUTCLKPCS        (TXOUTCLKPCS),
    .TXOUTCLK           (TXOUTCLK),
    .TXOUTCLKFABRIC     (TXOUTCLKFABRIC),
    .tx_serial_clk      (tx_serial_clk),

    .RXOUTCLKPMA        (RXOUTCLKPMA),
    .RXOUTCLKPCS        (RXOUTCLKPCS),
    .RXOUTCLK           (RXOUTCLK),
    .RXOUTCLKFABRIC     (RXOUTCLKFABRIC),
    .rx_serial_clk      (rx_serial_clk)
);

endmodule
