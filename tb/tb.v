`timescale 1ps/1ps
//`include "gtxe2_top.v"
//`include "gtx_sata_2.v"
`include "GTXE2_CHANNEL.v"
`include "test.v"
module tb();
wire            reset;
wire            TXP;
wire            TXN;
wire    [63:0]  TXDATA;
wire            TXUSRCLK;
wire            TXUSRCLK2;
wire    [7:0]   TX8B10BBYPASS;
wire            TX8B10BEN;
wire    [7:0]   TXCHARDISPMODE;
wire    [7:0]   TXCHARDISPVAL;
wire    [7:0]   TXCHARISK;
wire    [1:0]   TXBUFSTATUS;
wire            TXPOLARITY;
wire    [2:0]   TXRATE;
wire    [2:0]   RXRATE;
wire            TXRATEDONE;
wire            TXCOMINIT;
wire            TXCOMWAKE;
wire            TXCOMFINISH;
wire            TXELECIDLE;
wire            RXP;
wire            RXN;
wire            RXUSRCLK;
wire            RXUSRCLK2;
wire    [63:0]  RXDATA;
wire    [1:0]   RXELECIDLEMODE;
wire            RXELECIDLE;
wire            RXCOMINITDET;
wire            RXCOMWAKEDET;
wire            RXPOLARITY;
wire            RXBYTEISALIGNED;
wire            RXBYTEREALIGN;
wire            RXCOMMADET;
wire            RXCOMMADETEN;
wire            RXPCOMMAALIGNEN;
wire            RXMCOMMAALIGNEN;
wire            RX8B10BEN;
wire    [7:0]   RXCHARISCOMMA;
wire    [7:0]   RXCHARISK;
wire    [7:0]   RXDISPERR;
wire    [7:0]   RXNOTINTABLE;
wire    [2:0]   CPLLREFCLKSEL;
wire            GTREFCLK0;
wire            GTREFCLK1;
wire            GTNORTHREFCLK0;
wire            GTNORTHREFCLK1;
wire            GTSOUTHREFCLK0;
wire            GTSOUTHREFCLK1;
wire            GTGREFCLK;
wire    [1:0]   RXSYSCLKSEL;
wire    [1:0]   TXSYSCLKSEL;
wire    [2:0]   TXOUTCLKSEL;
wire    [2:0]   RXOUTCLKSEL;
wire            TXDLYBYPASS;
wire            GTREFCLKMONITOR;
wire            CPLLLOCKDETCLK;
wire            CPLLLOCKEN;
wire            CPLLPD;
wire            CPLLRESET;
wire            CPLLFBCLKLOST;
wire            CPLLLOCK;
wire            CPLLREFCLKLOST;
wire            TXOUTCLKPMA;
wire            TXOUTCLKPCS;
wire            TXOUTCLK;
wire            TXOUTCLKFABRIC;
wire            tx_serial_clk;
wire            RXOUTCLKPMA;
wire            RXOUTCLKPCS;
wire            RXOUTCLK;
wire            RXOUTCLKFABRIC;
wire            rx_serial_clk;
wire    [2:0]   QPLLREFCLKSEL;
wire            QPLLOUTCLK;
wire            QPLLOUTREFCLK;
wire            QPLLLOCKDETCLK;
wire            QPLLLOCKEN;
wire            QPLLPD;
wire            QPLLRESET;
wire            QPLLFBCLKLOST;
wire            QPLLLOCK;
wire            QPLLREFCLKLOST;
wire            TXUSERRDY;
wire            RXUSERRDY;
wire            RXDFELFHOLD;
wire            RXDFEAGCHOLD;
wire            RXRESETDONE;
wire            TXRESETDONE;

test test(
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
    .RXRATE             (RXRATE),
    .TXRATEDONE         (TXRATEDONE),
    .TXCOMINIT          (TXCOMINIT),
    .TXCOMWAKE          (TXCOMWAKE),
    .TXCOMFINISH        (TXCOMFINISH),
    .TXELECIDLE         (TXELECIDLE),
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
    .RXUSERRDY          (RXUSERRDY),
    .TXUSERRDY          (TXUSERRDY),
    .CPLLREFCLKSEL      (CPLLREFCLKSEL),
    .GTREFCLK0          (GTREFCLK0),
    .GTREFCLK1          (GTREFCLK1),
    .GTNORTHREFCLK0     (GTNORTHREFCLK0),
    .GTNORTHREFCLK1     (GTNORTHREFCLK1),
    .GTSOUTHREFCLK0     (GTSOUTHREFCLK0),
    .GTSOUTHREFCLK1     (GTSOUTHREFCLK1),
    .GTGREFCLK          (GTGREFCLK),
    .RXSYSCLKSEL        (RXSYSCLKSEL),
    .TXSYSCLKSEL        (TXSYSCLKSEL),
    .TXOUTCLKSEL        (TXOUTCLKSEL),
    .RXOUTCLKSEL        (RXOUTCLKSEL),
    .TXDLYBYPASS        (TXDLYBYPASS),
    .GTREFCLKMONITOR    (GTREFCLKMONITOR),
    .CPLLLOCKDETCLK     (CPLLLOCKDETCLK ),
    .CPLLLOCKEN         (CPLLLOCKEN),
    .CPLLPD             (CPLLPD),
    .CPLLRESET          (CPLLRESET),
    .CPLLFBCLKLOST      (CPLLFBCLKLOST),
    .CPLLLOCK           (CPLLLOCK),
    .CPLLREFCLKLOST     (CPLLREFCLKLOST),
    .TXOUTCLKPMA        (TXOUTCLKPMA),
    .TXOUTCLKPCS        (TXOUTCLKPCS),
    .TXOUTCLK           (TXOUTCLK),
    .TXOUTCLKFABRIC     (TXOUTCLKFABRIC),
    .tx_serial_clk      (tx_serial_clk),
    .RXOUTCLKPMA        (RXOUTCLKPMA),
    .RXOUTCLKPCS        (RXOUTCLKPCS),
    .RXOUTCLK           (RXOUTCLK),
    .RXOUTCLKFABRIC     (RXOUTCLKFABRIC),
    .rx_serial_clk      (rx_serial_clk),
    .QPLLREFCLKSEL      (QPLLREFCLKSEL),
    .QPLLOUTCLK         (QPLLOUTCLK),
    .QPLLOUTREFCLK      (QPLLOUTREFCLK),
    .QPLLLOCKDETCLK     (QPLLLOCKDETCLK ),
    .QPLLLOCKEN         (QPLLLOCKEN),
    .QPLLPD             (QPLLPD),
    .QPLLRESET          (QPLLRESET),
    .QPLLFBCLKLOST      (QPLLFBCLKLOST),
    .QPLLLOCK           (QPLLLOCK),
    .QPLLREFCLKLOST     (QPLLREFCLKLOST),
    .RXDFELFHOLD        (RXDFELFHOLD),
    .RXDFEAGCHOLD       (RXDFEAGCHOLD),
    .TXRESETDONE        (TXRESETDONE),
    .RXRESETDONE        (RXRESETDONE)
);

/*
gtxe2_top dut(
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
    .RXRATE             (RXRATE),
    .TXRATEDONE         (TXRATEDONE),
    .TXCOMINIT          (TXCOMINIT),
    .TXCOMWAKE          (TXCOMWAKE),
    .TXCOMFINISH        (TXCOMFINISH),
    .TXELECIDLE         (TXELECIDLE),
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
    .CPLLREFCLKSEL      (CPLLREFCLKSEL),
    .GTREFCLK0          (GTREFCLK0),
    .GTREFCLK1          (GTREFCLK1),
    .GTNORTHREFCLK0     (GTNORTHREFCLK0),
    .GTNORTHREFCLK1     (GTNORTHREFCLK1),
    .GTSOUTHREFCLK0     (GTSOUTHREFCLK0),
    .GTSOUTHREFCLK1     (GTSOUTHREFCLK1),
    .GTGREFCLK          (GTGREFCLK),
    .RXSYSCLKSEL        (RXSYSCLKSEL),
    .TXSYSCLKSEL        (TXSYSCLKSEL),
    .TXOUTCLKSEL        (TXOUTCLKSEL),
    .RXOUTCLKSEL        (RXOUTCLKSEL),
    .TXDLYBYPASS        (TXDLYBYPASS),
    .GTREFCLKMONITOR    (GTREFCLKMONITOR),
    .CPLLLOCKDETCLK     (CPLLLOCKDETCLK ),
    .CPLLLOCKEN         (CPLLLOCKEN),
    .CPLLPD             (CPLLPD),
    .CPLLRESET          (CPLLRESET),
    .CPLLFBCLKLOST      (CPLLFBCLKLOST),
    .CPLLLOCK           (CPLLLOCK),
    .CPLLREFCLKLOST     (CPLLREFCLKLOST),
    .TXOUTCLKPMA        (TXOUTCLKPMA),
    .TXOUTCLKPCS        (TXOUTCLKPCS),
    .TXOUTCLK           (TXOUTCLK),
    .TXOUTCLKFABRIC     (TXOUTCLKFABRIC),
    .tx_serial_clk      (tx_serial_clk),
    .RXOUTCLKPMA        (RXOUTCLKPMA),
    .RXOUTCLKPCS        (RXOUTCLKPCS),
    .RXOUTCLK           (RXOUTCLK),
    .RXOUTCLKFABRIC     (RXOUTCLKFABRIC),
    .rx_serial_clk      (rx_serial_clk),
    .QPLLREFCLKSEL      (QPLLREFCLKSEL),
    .QPLLOUTCLK         (QPLLOUTCLK),
    .QPLLOUTREFCLK      (QPLLOUTREFCLK),
    .QPLLLOCKDETCLK     (QPLLLOCKDETCLK ),
    .QPLLLOCKEN         (QPLLLOCKEN),
    .QPLLPD             (QPLLPD),
    .QPLLRESET          (QPLLRESET),
    .QPLLFBCLKLOST      (QPLLFBCLKLOST),
    .QPLLLOCK           (QPLLLOCK),
    .QPLLREFCLKLOST     (QPLLREFCLKLOST)
);
*/

wire tied_to_vcc_i = 1'b1;
wire tied_to_ground_i = 1'b0;
wire [31:0] tied_to_ground_vec_i = 32'h00000000;

        GTXE2_CHANNEL #
        (
            //_______________________ Simulation-Only Attributes __________________
    
            .SIM_RECEIVER_DETECT_PASS   ("TRUE"),
            .SIM_TX_EIDLE_DRIVE_LEVEL   ("X"),
            .SIM_RESET_SPEEDUP          ("FALSE"),
            .SIM_CPLLREFCLK_SEL         (3'b001),
            .SIM_VERSION                ("4.0"),
            

           //----------------RX Byte and Word Alignment Attributes---------------
            .ALIGN_COMMA_DOUBLE                     ("FALSE"),
            .ALIGN_COMMA_ENABLE                     (10'b1111111111),
            .ALIGN_COMMA_WORD                       (1),
            .ALIGN_MCOMMA_DET                       ("TRUE"),
            .ALIGN_MCOMMA_VALUE                     (10'b1010000011),
            .ALIGN_PCOMMA_DET                       ("TRUE"),
            .ALIGN_PCOMMA_VALUE                     (10'b0101111100),
            .SHOW_REALIGN_COMMA                     ("TRUE"),
            .RXSLIDE_AUTO_WAIT                      (7),
            .RXSLIDE_MODE                           ("OFF"),
            .RX_SIG_VALID_DLY                       (10),

           //----------------RX 8B/10B Decoder Attributes---------------
            .RX_DISPERR_SEQ_MATCH                   ("TRUE"),
            .DEC_MCOMMA_DETECT                      ("TRUE"),
            .DEC_PCOMMA_DETECT                      ("TRUE"),
            .DEC_VALID_COMMA_ONLY                   ("FALSE"),

           //----------------------RX Clock Correction Attributes----------------------
            .CBCC_DATA_SOURCE_SEL                   ("DECODED"),
            .CLK_COR_SEQ_2_USE                      ("FALSE"),
            .CLK_COR_KEEP_IDLE                      ("FALSE"),
            .CLK_COR_MAX_LAT                        (9),
            .CLK_COR_MIN_LAT                        (7),
            .CLK_COR_PRECEDENCE                     ("TRUE"),
            .CLK_COR_REPEAT_WAIT                    (0),
            .CLK_COR_SEQ_LEN                        (1),
            .CLK_COR_SEQ_1_ENABLE                   (4'b1111),
            .CLK_COR_SEQ_1_1                        (10'b0100000000),
            .CLK_COR_SEQ_1_2                        (10'b0000000000),
            .CLK_COR_SEQ_1_3                        (10'b0000000000),
            .CLK_COR_SEQ_1_4                        (10'b0000000000),
            .CLK_CORRECT_USE                        ("FALSE"),
            .CLK_COR_SEQ_2_ENABLE                   (4'b1111),
            .CLK_COR_SEQ_2_1                        (10'b0100000000),
            .CLK_COR_SEQ_2_2                        (10'b0000000000),
            .CLK_COR_SEQ_2_3                        (10'b0000000000),
            .CLK_COR_SEQ_2_4                        (10'b0000000000),

           //----------------------RX Channel Bonding Attributes----------------------
            .CHAN_BOND_KEEP_ALIGN                   ("FALSE"),
            .CHAN_BOND_MAX_SKEW                     (1),
            .CHAN_BOND_SEQ_LEN                      (1),
            .CHAN_BOND_SEQ_1_1                      (10'b0000000000),
            .CHAN_BOND_SEQ_1_2                      (10'b0000000000),
            .CHAN_BOND_SEQ_1_3                      (10'b0000000000),
            .CHAN_BOND_SEQ_1_4                      (10'b0000000000),
            .CHAN_BOND_SEQ_1_ENABLE                 (4'b1111),
            .CHAN_BOND_SEQ_2_1                      (10'b0000000000),
            .CHAN_BOND_SEQ_2_2                      (10'b0000000000),
            .CHAN_BOND_SEQ_2_3                      (10'b0000000000),
            .CHAN_BOND_SEQ_2_4                      (10'b0000000000),
            .CHAN_BOND_SEQ_2_ENABLE                 (4'b1111),
            .CHAN_BOND_SEQ_2_USE                    ("FALSE"),
            .FTS_DESKEW_SEQ_ENABLE                  (4'b1111),
            .FTS_LANE_DESKEW_CFG                    (4'b1111),
            .FTS_LANE_DESKEW_EN                     ("FALSE"),

           //-------------------------RX Margin Analysis Attributes----------------------------
            .ES_CONTROL                             (6'b000000),
            .ES_ERRDET_EN                           ("FALSE"),
            .ES_EYE_SCAN_EN                         ("TRUE"),
            .ES_HORZ_OFFSET                         (12'h000),
            .ES_PMA_CFG                             (10'b0000000000),
            .ES_PRESCALE                            (5'b00000),
            .ES_QUALIFIER                           (80'h00000000000000000000),
            .ES_QUAL_MASK                           (80'h00000000000000000000),
            .ES_SDATA_MASK                          (80'h00000000000000000000),
            .ES_VERT_OFFSET                         (9'b000000000),

           //-----------------------FPGA RX Interface Attributes-------------------------
            .RX_DATA_WIDTH                          (20),

           //-------------------------PMA Attributes----------------------------
            .OUTREFCLK_SEL_INV                      (2'b11),
            .PMA_RSV                                (32'h00018480),
            .PMA_RSV2                               (16'h2050),
            .PMA_RSV3                               (2'b00),
            .PMA_RSV4                               (32'h00000000),
            .RX_BIAS_CFG                            (12'b000000000100),
            .DMONITOR_CFG                           (24'h000A00),
            .RX_CM_SEL                              (2'b11),
            .RX_CM_TRIM                             (3'b010),
            .RX_DEBUG_CFG                           (12'b000000000000),
            .RX_OS_CFG                              (13'b0000010000000),
            .TERM_RCAL_CFG                          (5'b10000),
            .TERM_RCAL_OVRD                         (1'b0),
            .TST_RSV                                (32'h00000000),
            .RX_CLK25_DIV                           (6),
            .TX_CLK25_DIV                           (6),
            .UCODEER_CLR                            (1'b0),

           //-------------------------PCI Express Attributes----------------------------
            .PCS_PCIE_EN                            ("FALSE"),

           //-------------------------PCS Attributes----------------------------
            .PCS_RSVD_ATTR                          (48'h0100),

           //-----------RX Buffer Attributes------------
            .RXBUF_ADDR_MODE                        ("FAST"),
            .RXBUF_EIDLE_HI_CNT                     (4'b1000),
            .RXBUF_EIDLE_LO_CNT                     (4'b0000),
            .RXBUF_EN                               ("TRUE"),
            .RX_BUFFER_CFG                          (6'b000000),
            .RXBUF_RESET_ON_CB_CHANGE               ("TRUE"),
            .RXBUF_RESET_ON_COMMAALIGN              ("FALSE"),
            .RXBUF_RESET_ON_EIDLE                   ("FALSE"),
            .RXBUF_RESET_ON_RATE_CHANGE             ("TRUE"),
            .RXBUFRESET_TIME                        (5'b00001),
            .RXBUF_THRESH_OVFLW                     (61),
            .RXBUF_THRESH_OVRD                      ("FALSE"),
            .RXBUF_THRESH_UNDFLW                    (4),
            .RXDLY_CFG                              (16'h001F),
            .RXDLY_LCFG                             (9'h030),
            .RXDLY_TAP_CFG                          (16'h0000),
            .RXPH_CFG                               (24'h000000),
            .RXPHDLY_CFG                            (24'h084020),
            .RXPH_MONITOR_SEL                       (5'b00000),
            .RX_XCLK_SEL                            ("RXREC"),
            .RX_DDI_SEL                             (6'b000000),
            .RX_DEFER_RESET_BUF_EN                  ("TRUE"),

           //---------------------CDR Attributes-------------------------

           //For Display Port, HBR/RBR- set RXCDR_CFG=72'h0380008bff40200008

           //For Display Port, HBR2 -   set RXCDR_CFG=72'h038c008bff20200010

           //For SATA Gen1 GTX- set RXCDR_CFG=72'h03_8000_8BFF_4010_0008

           //For SATA Gen2 GTX- set RXCDR_CFG=72'h03_8800_8BFF_4020_0008

           //For SATA Gen3 GTX- set RXCDR_CFG=72'h03_8000_8BFF_1020_0010

           //For SATA Gen3 GTP- set RXCDR_CFG=83'h0_0000_87FE_2060_2444_1010

           //For SATA Gen2 GTP- set RXCDR_CFG=83'h0_0000_47FE_2060_2448_1010

           //For SATA Gen1 GTP- set RXCDR_CFG=83'h0_0000_47FE_1060_2448_1010
            .RXCDR_CFG                              (72'h03000023ff10200020),
            .RXCDR_FR_RESET_ON_EIDLE                (1'b0),
            .RXCDR_HOLD_DURING_EIDLE                (1'b0),
            .RXCDR_PH_RESET_ON_EIDLE                (1'b0),
            .RXCDR_LOCK_CFG                         (6'b010101),

           //-----------------RX Initialization and Reset Attributes-------------------
            .RXCDRFREQRESET_TIME                    (5'b00001),
            .RXCDRPHRESET_TIME                      (5'b00001),
            .RXISCANRESET_TIME                      (5'b00001),
            .RXPCSRESET_TIME                        (5'b00001),
            .RXPMARESET_TIME                        (5'b00011),

           //-----------------RX OOB Signaling Attributes-------------------
            .RXOOB_CFG                              (7'b0000110),

           //-----------------------RX Gearbox Attributes---------------------------
            .RXGEARBOX_EN                           ("FALSE"),
            .GEARBOX_MODE                           (3'b000),

           //-----------------------PRBS Detection Attribute-----------------------
            .RXPRBS_ERR_LOOPBACK                    (1'b0),

           //-----------Power-Down Attributes----------
            .PD_TRANS_TIME_FROM_P2                  (12'h03c),
            .PD_TRANS_TIME_NONE_P2                  (8'h3c),
            .PD_TRANS_TIME_TO_P2                    (8'h64),

           //-----------RX OOB Signaling Attributes----------
            .SAS_MAX_COM                            (64),
            .SAS_MIN_COM                            (36),
            .SATA_BURST_SEQ_LEN                     (4'b0111),
            .SATA_BURST_VAL                         (3'b110),
            .SATA_EIDLE_VAL                         (3'b110),
            .SATA_MAX_BURST                         (8),
            .SATA_MAX_INIT                          (21),
            .SATA_MAX_WAKE                          (7),
            .SATA_MIN_BURST                         (4),
            .SATA_MIN_INIT                          (12),
            .SATA_MIN_WAKE                          (4),

           //-----------RX Fabric Clock Output Control Attributes----------
            .TRANS_TIME_RATE                        (8'h0E),

           //------------TX Buffer Attributes----------------
            .TXBUF_EN                               ("TRUE"),
            .TXBUF_RESET_ON_RATE_CHANGE             ("TRUE"),
            .TXDLY_CFG                              (16'h001F),
            .TXDLY_LCFG                             (9'h030),
            .TXDLY_TAP_CFG                          (16'h0000),
            .TXPH_CFG                               (16'h0780),
            .TXPHDLY_CFG                            (24'h084020),
            .TXPH_MONITOR_SEL                       (5'b00000),
            .TX_XCLK_SEL                            ("TXOUT"),

           //-----------------------FPGA TX Interface Attributes-------------------------
            .TX_DATA_WIDTH                          (20),

           //-----------------------TX Configurable Driver Attributes-------------------------
            .TX_DEEMPH0                             (5'b00000),
            .TX_DEEMPH1                             (5'b00000),
            .TX_EIDLE_ASSERT_DELAY                  (3'b110),
            .TX_EIDLE_DEASSERT_DELAY                (3'b100),
            .TX_LOOPBACK_DRIVE_HIZ                  ("FALSE"),
            .TX_MAINCURSOR_SEL                      (1'b0),
            .TX_DRIVE_MODE                          ("DIRECT"),
            .TX_MARGIN_FULL_0                       (7'b1001110),
            .TX_MARGIN_FULL_1                       (7'b1001001),
            .TX_MARGIN_FULL_2                       (7'b1000101),
            .TX_MARGIN_FULL_3                       (7'b1000010),
            .TX_MARGIN_FULL_4                       (7'b1000000),
            .TX_MARGIN_LOW_0                        (7'b1000110),
            .TX_MARGIN_LOW_1                        (7'b1000100),
            .TX_MARGIN_LOW_2                        (7'b1000010),
            .TX_MARGIN_LOW_3                        (7'b1000000),
            .TX_MARGIN_LOW_4                        (7'b1000000),

           //-----------------------TX Gearbox Attributes--------------------------
            .TXGEARBOX_EN                           ("FALSE"),

           //-----------------------TX Initialization and Reset Attributes--------------------------
            .TXPCSRESET_TIME                        (5'b00001),
            .TXPMARESET_TIME                        (5'b00001),

           //-----------------------TX Receiver Detection Attributes--------------------------
            .TX_RXDETECT_CFG                        (14'h1832),
            .TX_RXDETECT_REF                        (3'b100),

           //--------------------------CPLL Attributes----------------------------
            .CPLL_CFG                               (24'hBC07DC),
            .CPLL_FBDIV                             (4),
            .CPLL_FBDIV_45                          (5),
            .CPLL_INIT_CFG                          (24'h00001E),
            .CPLL_LOCK_CFG                          (16'h01E8),
            .CPLL_REFCLK_DIV                        (1),
            .RXOUT_DIV                              (2),
            .TXOUT_DIV                              (2),
            .SATA_CPLL_CFG                          ("VCO_3000MHZ"),

           //------------RX Initialization and Reset Attributes-------------
            .RXDFELPMRESET_TIME                     (7'b0001111),

           //------------RX Equalizer Attributes-------------
            .RXLPM_HF_CFG                           (14'b00000011110000),
            .RXLPM_LF_CFG                           (14'b00000011110000),
            .RX_DFE_GAIN_CFG                        (23'h020FEA),
            .RX_DFE_H2_CFG                          (12'b000000000000),
            .RX_DFE_H3_CFG                          (12'b000001000000),
            .RX_DFE_H4_CFG                          (11'b00011110000),
            .RX_DFE_H5_CFG                          (11'b00011100000),
            .RX_DFE_KL_CFG                          (13'b0000011111110),
            .RX_DFE_LPM_CFG                         (16'h0954),
            .RX_DFE_LPM_HOLD_DURING_EIDLE           (1'b0),
            .RX_DFE_UT_CFG                          (17'b10001111000000000),
            .RX_DFE_VP_CFG                          (17'b00011111100000011),

           //-----------------------Power-Down Attributes-------------------------
            .RX_CLKMUX_PD                           (1'b1),
            .TX_CLKMUX_PD                           (1'b1),

           //-----------------------FPGA RX Interface Attribute-------------------------
            .RX_INT_DATAWIDTH                       (0),

           //-----------------------FPGA TX Interface Attribute-------------------------
            .TX_INT_DATAWIDTH                       (0),

           //----------------TX Configurable Driver Attributes---------------
            .TX_QPI_STATUS_EN                       (1'b0),

           //-----------------------RX Equalizer Attributes--------------------------
            .RX_DFE_KL_CFG2                         (32'h301148AC),
            .RX_DFE_XYD_CFG                         (13'b0000000000000),

           //-----------------------TX Configurable Driver Attributes--------------------------
            .TX_PREDRIVER_MODE                      (1'b0)

            
        ) 
        dut 
        (
        
        //------------------------------- CPLL Ports -------------------------------
        .CPLLFBCLKLOST                  (CPLLFBCLKLOST),
        .CPLLLOCK                       (CPLLLOCK),
        .CPLLLOCKDETCLK                 (CPLLLOCKDETCLK),
        .CPLLLOCKEN                     (tied_to_vcc_i),
        .CPLLPD                         (CPLLPD),
        .CPLLREFCLKLOST                 (CPLLREFCLKLOST),
        .CPLLREFCLKSEL                  (3'b001),
        .CPLLRESET                      (CPLLRESET),
        .GTRSVD                         (16'b0000000000000000),
        .PCSRSVDIN                      (16'b0000000000000000),
        .PCSRSVDIN2                     (5'b00000),
        .PMARSVDIN                      (5'b00000),
        .PMARSVDIN2                     (5'b00000),
        .TSTIN                          (20'b11111111111111111111),
        .TSTOUT                         (),
        //-------------------------------- Channel ---------------------------------
        .CLKRSVD                        (4'b0000),
        //------------------------ Channel - Clocking Ports ------------------------
        .GTGREFCLK                      (tied_to_ground_i),
        .GTNORTHREFCLK0                 (tied_to_ground_i),
        .GTNORTHREFCLK1                 (tied_to_ground_i),
        .GTREFCLK0                      (GTREFCLK0),
        .GTREFCLK1                      (tied_to_ground_i),
        .GTSOUTHREFCLK0                 (tied_to_ground_i),
        .GTSOUTHREFCLK1                 (tied_to_ground_i),
        //-------------------------- Channel - DRP Ports  --------------------------
        .DRPADDR                        (1'b0),
        .DRPCLK                         (CPLLLOCKDETCKL),
        .DRPDI                          (1'b0),
        .DRPDO                          (),
        .DRPEN                          (1'b0),
        .DRPRDY                         (),
        .DRPWE                          (1'b0),
        //----------------------------- Clocking Ports -----------------------------
        .GTREFCLKMONITOR                (),
        .QPLLCLK                        (GTREFCLK0),
        .QPLLREFCLK                     (GTREFCLK0),
        .RXSYSCLKSEL                    (2'b00),
        .TXSYSCLKSEL                    (2'b00),
        //------------------------- Digital Monitor Ports --------------------------
        .DMONITOROUT                    (DMONITOROUT),
        //--------------- FPGA TX Interface Datapath Configuration  ----------------
        .TX8B10BEN                      (tied_to_vcc_i),
        //----------------------------- Loopback Ports -----------------------------
        .LOOPBACK                       (tied_to_ground_vec_i[2:0]),
        //--------------------------- PCI Express Ports ----------------------------
        .PHYSTATUS                      (),
        .RXRATE                         (tied_to_ground_vec_i[2:0]),
        .RXVALID                        (),
        //---------------------------- Power-Down Ports ----------------------------
        .RXPD                           (2'b00),
        .TXPD                           (2'b00),
        //------------------------ RX 8B/10B Decoder Ports -------------------------
        .SETERRSTATUS                   (tied_to_ground_i),
        //------------------- RX Initialization and Reset Ports --------------------
        .EYESCANRESET                   (reset),
        .RXUSERRDY                      (RXUSERRDY),
        //------------------------ RX Margin Analysis Ports ------------------------
        .EYESCANDATAERROR               (EYESCANDATAERROR),
        .EYESCANMODE                    (tied_to_ground_i),
        .EYESCANTRIGGER                 (1'b0),
        //----------------------- Receive Ports - CDR Ports ------------------------
        .RXCDRFREQRESET                 (tied_to_ground_i),
        .RXCDRHOLD                      (tied_to_ground_i),
        .RXCDRLOCK                      (),
        .RXCDROVRDEN                    (tied_to_ground_i),
        .RXCDRRESET                     (tied_to_ground_i),
        .RXCDRRESETRSV                  (tied_to_ground_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
        .RXCLKCORCNT                    (),
        //-------- Receive Ports - FPGA RX Interface Datapath Configuration --------
        .RX8B10BEN                      (tied_to_vcc_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
        .RXUSRCLK                       (RXUSRCLK),
        .RXUSRCLK2                      (RXUSRCLK2),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
        .RXDATA                         (RXDATA),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
        .RXPRBSERR                      (),
        .RXPRBSSEL                      (tied_to_ground_vec_i[2:0]),
        //----------------- Receive Ports - Pattern Checker ports ------------------
        .RXPRBSCNTRESET                 (tied_to_ground_i),
        //------------------ Receive Ports - RX  Equalizer Ports -------------------
        .RXDFEXYDEN                     (tied_to_vcc_i),
        .RXDFEXYDHOLD                   (tied_to_ground_i),
        .RXDFEXYDOVRDEN                 (tied_to_ground_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
        .RXDISPERR                      (RXDISPERR),
        .RXNOTINTABLE                   (RXNOTINTABLE),
        //------------------------- Receive Ports - RX AFE -------------------------
        .GTXRXP                         (RXP),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
        .GTXRXN                         (RXN),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
        .RXBUFRESET                     (tied_to_ground_i),
        .RXBUFSTATUS                    (),
        .RXDDIEN                        (tied_to_ground_i),
        .RXDLYBYPASS                    (tied_to_vcc_i),
        .RXDLYEN                        (tied_to_ground_i),
        .RXDLYOVRDEN                    (tied_to_ground_i),
        .RXDLYSRESET                    (tied_to_ground_i),
        .RXDLYSRESETDONE                (),
        .RXPHALIGN                      (tied_to_ground_i),
        .RXPHALIGNDONE                  (),
        .RXPHALIGNEN                    (tied_to_ground_i),
        .RXPHDLYPD                      (tied_to_ground_i),
        .RXPHDLYRESET                   (tied_to_ground_i),
        .RXPHMONITOR                    (),
        .RXPHOVRDEN                     (tied_to_ground_i),
        .RXPHSLIPMONITOR                (),
        .RXSTATUS                       (RXSTATUS),
        //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
        .RXBYTEISALIGNED                (RXBYTEISALIGNED),
        .RXBYTEREALIGN                  (),
        .RXCOMMADET                     (),
        .RXCOMMADETEN                   (tied_to_vcc_i),
        .RXMCOMMAALIGNEN                (tied_to_vcc_i),
        .RXPCOMMAALIGNEN                (tied_to_vcc_i),
        //---------------- Receive Ports - RX Channel Bonding Ports ----------------
        .RXCHANBONDSEQ                  (),
        .RXCHBONDEN                     (tied_to_ground_i),
        .RXCHBONDLEVEL                  (tied_to_ground_vec_i[2:0]),
        .RXCHBONDMASTER                 (tied_to_ground_i),
        .RXCHBONDO                      (),
        .RXCHBONDSLAVE                  (tied_to_ground_i),
        //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
        .RXCHANISALIGNED                (),
        .RXCHANREALIGN                  (),
        //------------------ Receive Ports - RX Equailizer Ports -------------------
        .RXLPMHFHOLD                    (tied_to_ground_i),
        .RXLPMHFOVRDEN                  (tied_to_ground_i),
        .RXLPMLFHOLD                    (tied_to_ground_i),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
        .RXDFEAGCHOLD                   (RXDFEAGCHOLD),
        .RXDFEAGCOVRDEN                 (tied_to_ground_i),
        .RXDFECM1EN                     (tied_to_ground_i),
        .RXDFELFHOLD                    (RXDFELFHOLD),
        .RXDFELFOVRDEN                  (tied_to_vcc_i),
        .RXDFELPMRESET                  (reset),
        .RXDFETAP2HOLD                  (tied_to_ground_i),
        .RXDFETAP2OVRDEN                (tied_to_ground_i),
        .RXDFETAP3HOLD                  (tied_to_ground_i),
        .RXDFETAP3OVRDEN                (tied_to_ground_i),
        .RXDFETAP4HOLD                  (tied_to_ground_i),
        .RXDFETAP4OVRDEN                (tied_to_ground_i),
        .RXDFETAP5HOLD                  (tied_to_ground_i),
        .RXDFETAP5OVRDEN                (tied_to_ground_i),
        .RXDFEUTHOLD                    (tied_to_ground_i),
        .RXDFEUTOVRDEN                  (tied_to_ground_i),
        .RXDFEVPHOLD                    (tied_to_ground_i),
        .RXDFEVPOVRDEN                  (tied_to_ground_i),
        .RXDFEVSEN                      (tied_to_ground_i),
        .RXLPMLFKLOVRDEN                (tied_to_ground_i),
        .RXMONITOROUT                   (RXMONITOROUT),
        .RXMONITORSEL                   (RXMONITORSEL),
        .RXOSHOLD                       (tied_to_ground_i),
        .RXOSOVRDEN                     (tied_to_ground_i),
        //---------- Receive Ports - RX Fabric ClocK Output Control Ports ----------
        .RXRATEDONE                     (),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
        .RXOUTCLK                       (RXOUTCLK),
        .RXOUTCLKFABRIC                 (),
        .RXOUTCLKPCS                    (),
        .RXOUTCLKSEL                    (3'b010),
        //-------------------- Receive Ports - RX Gearbox Ports --------------------
        .RXDATAVALID                    (),
        .RXHEADER                       (),
        .RXHEADERVALID                  (),
        .RXSTARTOFSEQ                   (),
        //------------------- Receive Ports - RX Gearbox Ports  --------------------
        .RXGEARBOXSLIP                  (tied_to_ground_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
        .GTRXRESET                      (reset),
        .RXOOBRESET                     (tied_to_ground_i),
        .RXPCSRESET                     (tied_to_ground_i),
        .RXPMARESET                     (reset),
        //---------------- Receive Ports - RX Margin Analysis ports ----------------
        .RXLPMEN                        (tied_to_ground_i),
        //----------------- Receive Ports - RX OOB Signaling ports -----------------
        .RXCOMSASDET                    (),
        .RXCOMWAKEDET                   (RXCOMWAKEDET),
        //---------------- Receive Ports - RX OOB Signaling ports  -----------------
        .RXCOMINITDET                   (RXCOMINITDET),
        //---------------- Receive Ports - RX OOB signalling Ports -----------------
        .RXELECIDLE                     (RXELECIDLE),
        .RXELECIDLEMODE                 (2'b00),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
        .RXPOLARITY                     (tied_to_ground_i),
        //-------------------- Receive Ports - RX gearbox ports --------------------
        .RXSLIDE                        (tied_to_ground_i),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        .RXCHARISCOMMA                  (),
        .RXCHARISK                      (RXCHARISK),
        //---------------- Receive Ports - Rx Channel Bonding Ports ----------------
        .RXCHBONDI                      (5'b00000),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
        .RXRESETDONE                    (RXRESETDONE),
        //------------------------------ Rx AFE Ports ------------------------------
        .RXQPIEN                        (tied_to_ground_i),
        .RXQPISENN                      (),
        .RXQPISENP                      (),
        //------------------------- TX Buffer Bypass Ports -------------------------
        .TXPHDLYTSTCLK                  (tied_to_ground_i),
        //---------------------- TX Configurable Driver Ports ----------------------
        .TXPOSTCURSOR                   (5'b00000),
        .TXPOSTCURSORINV                (tied_to_ground_i),
        .TXPRECURSOR                    (tied_to_ground_vec_i[4:0]),
        .TXPRECURSORINV                 (tied_to_ground_i),
        .TXQPIBIASEN                    (tied_to_ground_i),
        .TXQPISTRONGPDOWN               (tied_to_ground_i),
        .TXQPIWEAKPUP                   (tied_to_ground_i),
        //------------------- TX Initialization and Reset Ports --------------------
        .CFGRESET                       (tied_to_ground_i),
        .GTTXRESET                      (reset),
        .PCSRSVDOUT                     (),
        .TXUSERRDY                      (TXUSERRDY),
        //-------------------- Transceiver Reset Mode Operation --------------------
        .GTRESETSEL                     (tied_to_ground_i),
        .RESETOVRD                      (tied_to_ground_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
        .TXCHARDISPMODE                 (tied_to_ground_vec_i[7:0]),
        .TXCHARDISPVAL                  (tied_to_ground_vec_i[7:0]),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
        .TXUSRCLK                       (TXUSRCLK),
        .TXUSRCLK2                      (TXUSRCLK2),
        //------------------- Transmit Ports - PCI Express Ports -------------------
        .TXELECIDLE                     (TXELECIDLE),
        .TXMARGIN                       (tied_to_ground_vec_i[2:0]),
        .TXRATE                         (tied_to_ground_vec_i[2:0]),
        .TXSWING                        (tied_to_ground_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
        .TXPRBSFORCEERR                 (tied_to_ground_i),
        //---------------- Transmit Ports - TX Buffer Bypass Ports -----------------
        .TXDLYBYPASS                    (tied_to_vcc_i),
        .TXDLYEN                        (tied_to_ground_i),
        .TXDLYHOLD                      (tied_to_ground_i),
        .TXDLYOVRDEN                    (tied_to_ground_i),
        .TXDLYSRESET                    (tied_to_ground_i),
        .TXDLYSRESETDONE                (),
        .TXDLYUPDOWN                    (tied_to_ground_i),
        .TXPHALIGN                      (tied_to_ground_i),
        .TXPHALIGNDONE                  (),
        .TXPHALIGNEN                    (tied_to_ground_i),
        .TXPHDLYPD                      (tied_to_ground_i),
        .TXPHDLYRESET                   (tied_to_ground_i),
        .TXPHINIT                       (tied_to_ground_i),
        .TXPHINITDONE                   (),
        .TXPHOVRDEN                     (tied_to_ground_i),
        //-------------------- Transmit Ports - TX Buffer Ports --------------------
        .TXBUFSTATUS                    (),
        //------------- Transmit Ports - TX Configurable Driver Ports --------------
        .TXBUFDIFFCTRL                  (3'b100),
        .TXDEEMPH                       (tied_to_ground_i),
        .TXDIFFCTRL                     (4'b1000),
        .TXDIFFPD                       (tied_to_ground_i),
        .TXINHIBIT                      (tied_to_ground_i),
        .TXMAINCURSOR                   (7'b0000000),
        .TXPISOPD                       (tied_to_ground_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
        .TXDATA                         (TXDATA),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
        .GTXTXN                         (TXN),
        .GTXTXP                         (TXP),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
        .TXOUTCLK                       (TXOUTCLK),
        .TXOUTCLKFABRIC                 (TXOUTCLKFABRIC),
        .TXOUTCLKPCS                    (TXOUTCLKPCS),
        .TXOUTCLKSEL                    (3'b010),
        .TXRATEDONE                     (),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
        .TXCHARISK                      (TXCHARISK),
        .TXGEARBOXREADY                 (),
        .TXHEADER                       (tied_to_ground_vec_i[2:0]),
        .TXSEQUENCE                     (tied_to_ground_vec_i[6:0]),
        .TXSTARTSEQ                     (tied_to_ground_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
        .TXPCSRESET                     (tied_to_ground_i),
        .TXPMARESET                     (tied_to_ground_i),
        .TXRESETDONE                    (TXRESETDONE),
        //---------------- Transmit Ports - TX OOB signalling Ports ----------------
        .TXCOMFINISH                    (TXCOMFINISH),
        .TXCOMINIT                      (TXCOMINIT),
        .TXCOMSAS                       (tied_to_ground_i),
        .TXCOMWAKE                      (TXCOMWAKE),
        .TXPDELECIDLEMODE               (tied_to_ground_i),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
        .TXPOLARITY                     (tied_to_ground_i),
        //------------- Transmit Ports - TX Receiver Detection Ports  --------------
        .TXDETECTRX                     (tied_to_ground_i),
        //---------------- Transmit Ports - TX8b/10b Encoder Ports -----------------
        .TX8B10BBYPASS                  (tied_to_ground_vec_i[7:0]),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
        .TXPRBSSEL                      (tied_to_ground_vec_i[2:0]),
        //--------------------- Tx Configurable Driver  Ports ----------------------
        .TXQPISENN                      (),
        .TXQPISENP                      ()

     );
/*
gtx_sata_2 dut
(
    .sysclk_in                      (GTREFCLK0),
    .soft_reset_in                  (reset),
    .dont_reset_on_data_error_in    (1'b1),
    .gt0_tx_fsm_reset_done_out      (),
    .gt0_rx_fsm_reset_done_out      (),
    .gt0_data_valid_in              (1'b1),

    //_________________________________________________________________________
    //GT0  (X1Y0)
    //____________________________CHANNEL PORTS________________________________
    //------------------------------- CPLL Ports -------------------------------
    .gt0_cpllfbclklost_out          (CPLLFBCLKLOST),
    .gt0_cplllock_out               (CPLLLOCK),
    .gt0_cplllockdetclk_in          (CPLLLOCKDETCLK),
    .gt0_cpllreset_in               (CPLLRESET),
    //------------------------ Channel - Clocking Ports ------------------------
    .gt0_gtrefclk0_in               (GTREFCLK0),
    //-------------------------- Channel - DRP Ports  --------------------------
    .gt0_drpaddr_in                 (1'b0),
    .gt0_drpclk_in                  (CPLLLOCKDETCLK),
    .gt0_drpdi_in                   (1'b0),
    .gt0_drpdo_out                  (),
    .gt0_drpen_in                   (1'b0),
    .gt0_drprdy_out                 (),
    .gt0_drpwe_in                   (1'b0),
    //------------------------- Digital Monitor Ports --------------------------
    .gt0_dmonitorout_out            (),
    //--------------------------- PCI Express Ports ----------------------------
    .gt0_rxrate_in                  (RXRATE),
    //------------------- RX Initialization and Reset Ports --------------------
    .gt0_eyescanreset_in            (reset),
    .gt0_rxuserrdy_in               (RXUSERRDY),
    //------------------------ RX Margin Analysis Ports ------------------------
    .gt0_eyescandataerror_out       (),
    .gt0_eyescantrigger_in          (1'b0),
    //---------------- Receive Ports - FPGA RX Interface Ports -----------------
    .gt0_rxusrclk_in                (RXUSRCLK),
    .gt0_rxusrclk2_in               (RXUSRCLK2),
    //---------------- Receive Ports - FPGA RX interface Ports -----------------
    .gt0_rxdata_out                 (RXDATA),
    //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
    .gt0_rxdisperr_out              (RXDISPERR),
    .gt0_rxnotintable_out           (RXNOTINTABLE),
    //------------------------- Receive Ports - RX AFE -------------------------
    .gt0_gtxrxp_in                  (RXP),
    //---------------------- Receive Ports - RX AFE Ports ----------------------
    .gt0_gtxrxn_in                  (RXN),
    //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
    .gt0_rxphmonitor_out            (RXPHMONITOR),
    .gt0_rxphslipmonitor_out        (RXPHSLIPMONITOR),
    //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
    .gt0_rxbyteisaligned_out        (RXBYTEISALIGNED),
    .gt0_rxbyterealign_out          (RXBYTEREALIGN),
    .gt0_rxcommadet_out             (RXCOMMADET),
    //------------------- Receive Ports - RX Equalizer Ports -------------------
    .gt0_rxdfelpmreset_in           (reset),
    .gt0_rxmonitorout_out           (RXMONITOROUT),
    .gt0_rxmonitorsel_in            (1'b0),
    //---------- Receive Ports - RX Fabric ClocK Output Control Ports ----------
    .gt0_rxratedone_out             (RXRATEDONE),
    //------------- Receive Ports - RX Fabric Output Control Ports -------------
    .gt0_rxoutclk_out               (RXOUTCLK),
    //----------- Receive Ports - RX Initialization and Reset Ports ------------
    .gt0_gtrxreset_in               (reset),
    .gt0_rxpmareset_in              (reset),
    //----------------- Receive Ports - RX OOB Signaling ports -----------------
    .gt0_rxcomwakedet_out           (RXCOMWAKEDET),
    //---------------- Receive Ports - RX OOB Signaling ports  -----------------
    .gt0_rxcominitdet_out           (RXCOMINITDET),
    //---------------- Receive Ports - RX OOB signalling Ports -----------------
    .gt0_rxelecidle_out             (RXELECIDLE),
    //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    .gt0_rxchariscomma_out          (RXCHARISCOMMA),
    .gt0_rxcharisk_out              (RXCHARISK),
    //------------ Receive Ports -RX Initialization and Reset Ports ------------
    .gt0_rxresetdone_out            (RXRESETDONE),
    //------------------- TX Initialization and Reset Ports --------------------
    .gt0_gttxreset_in               (reset),
    .gt0_txuserrdy_in               (TXUSERRDY),
    //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
    .gt0_txusrclk_in                (TXUSRCLK),
    .gt0_txusrclk2_in               (TXUSRCLK2),
    //------------------- Transmit Ports - PCI Express Ports -------------------
    .gt0_txelecidle_in              (TXELECIDLE),
    .gt0_txrate_in                  (TXRATE),
    //---------------- Transmit Ports - TX Data Path interface -----------------
    .gt0_txdata_in                  (TXDATA),
    //-------------- Transmit Ports - TX Driver and OOB signaling --------------
    .gt0_gtxtxn_out                 (TXN),
    .gt0_gtxtxp_out                 (TXP),
    //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
    .gt0_txoutclk_out               (TXOUTCLK),
    .gt0_txoutclkfabric_out         (TXOUTCLKFABRIC),
    .gt0_txoutclkpcs_out            (TXOUTCLKPCS),
    .gt0_txratedone_out             (TXRATEDONE),
    //------------------- Transmit Ports - TX Gearbox Ports --------------------
    .gt0_txcharisk_in               (TXCHARISK),
    //----------- Transmit Ports - TX Initialization and Reset Ports -----------
    .gt0_txresetdone_out            (TXRESETDONE),
    //---------------- Transmit Ports - TX OOB signalling Ports ----------------
    .gt0_txcomfinish_out            (TXCOMFINISH),
    .gt0_txcominit_in               (TXCOMINIT),
    .gt0_txcomwake_in               (TXCOMWAKE),


    //____________________________COMMON PORTS________________________________
    .gt0_qplloutclk_in              (GTREFCLK0),
    .gt0_qplloutrefclk_in           (GTREFCLK0)
);*/
endmodule
