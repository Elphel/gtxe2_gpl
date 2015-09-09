/*******************************************************************************
 * Module: GTXE2_CHANNEL
 * Date: 2015-07-06  
 * Author: Alexey     
 * Description: A wrapper maintaining interface compability
 *
 * Copyright (c) 2015 Elphel, Inc.
 * GTXE2_CHANNEL_GPL.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * GTXE2_CHANNEL_GPL.v file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
/**
 * Original unisims primitive's interfaces, according to xilinx's user guide:
 * "7 Series FPGAs GTX/GTH Transceivers User Guide UG476(v1.11)", which is further 
 * referenced as ug476 or UG476
 *
 * Due to lack of functionality of gtxe2_gpl project as compared to the xilinx's primitive, 
 * not all of the inputs are used and not all of the outputs are driven.
 **/
`include "gtxe2_chnl.v"
module GTXE2_CHANNEL(
// clocking ports, UG476 p.37
    input   [2:0]       CPLLREFCLKSEL,
    input               GTGREFCLK,
    input               GTNORTHREFCLK0,
    input               GTNORTHREFCLK1,
    input               GTREFCLK0,
    input               GTREFCLK1,
    input               GTSOUTHREFCLK0,
    input               GTSOUTHREFCLK1,
    input   [1:0]       RXSYSCLKSEL,
    input   [1:0]       TXSYSCLKSEL,
    output              GTREFCLKMONITOR,
// CPLL Ports, UG476 p.48
    input               CPLLLOCKDETCLK,
    input               CPLLLOCKEN,
    input               CPLLPD,
    input               CPLLRESET,
    output              CPLLFBCLKLOST,
    output              CPLLLOCK,
    output              CPLLREFCLKLOST,
    output              TSTOUT,
    input   [15:0]      GTRSVD,
    input   [15:0]      PCSRSVDIN,
    input   [4:0]       PCSRSVDIN2,
    input   [4:0]       PMARSVDIN,
    input   [4:0]       PMARSVDIN2,
    input   [19:0]      TSTIN,
// Reset Mode ports, ug476 p.62
    input               GTRESETSEL,
    input               RESETOVRD,
// TX Reset ports, ug476 p.65
    input               CFGRESET,
    input               GTTXRESET,
    input               TXPCSRESET,
    input               TXPMARESET,
    output              TXRESETDONE,
    input               TXUSERRDY,
    output              PCSRSVDOUT,
// RX Reset ports, UG476 p.73
    input               GTRXRESET,
    input               RXPMARESET,
    input               RXCDRRESET,
    input               RXCDRFREQRESET,
    input               RXDFELPMRESET,
    input               EYESCANRESET,
    input               RXPCSRESET,
    input               RXBUFRESET,
    input               RXUSERRDY,
    output              RXRESETDONE,
    input               RXOOBRESET,
// Power Down ports, ug476 p.88
    input   [1:0]       RXPD,
    input   [1:0]       TXPD,
    input               TXPDELECIDLEMODE,
    input               TXPHDLYPD,
    input               RXPHDLYPD,
// Loopback ports, ug476 p.91
    input   [2:0]       LOOPBACK,
// Dynamic Reconfiguration Port, ug476 p.92
    input   [8:0]       DRPADDR,
    input               DRPCLK,
    input   [15:0]      DRPDI,
    output  [15:0]      DRPDO,
    input               DRPEN,
    output              DRPRDY,
    input               DRPWE,
// Digital Monitor Ports, ug476 p.95
    input   [3:0]       CLKRSVD,
    output  [7:0]       DMONITOROUT,
// TX Interface Ports, ug476 p.110
    input   [7:0]       TXCHARDISPMODE,
    input   [7:0]       TXCHARDISPVAL,
    input   [63:0]      TXDATA,
    input               TXUSRCLK,
    input               TXUSRCLK2,
// TX 8B/10B encoder ports, ug476 p.118
    input   [7:0]       TX8B10BBYPASS,
    input               TX8B10BEN,
    input   [7:0]       TXCHARISK,
// TX Gearbox ports, ug476 p.122
    output              TXGEARBOXREADY,
    input   [2:0]       TXHEADER,
    input   [6:0]       TXSEQUENCE,
    input               TXSTARTSEQ,
// TX BUffer Ports, ug476 p.134
    output  [1:0]       TXBUFSTATUS,
// TX Buffer Bypass Ports, ug476 p.136
    input               TXDLYSRESET,
    input               TXPHALIGN,
    input               TXPHALIGNEN,
    input               TXPHINIT,
    input               TXPHOVRDEN,
    input               TXPHDLYRESET,
    input               TXDLYBYPASS,
    input               TXDLYEN,
    input               TXDLYOVRDEN,
    input               TXPHDLYTSTCLK,
    input               TXDLYHOLD,
    input               TXDLYUPDOWN,
    output              TXPHALIGNDONE,
    output              TXPHINITDONE,
    output              TXDLYSRESETDONE,
/*    input               TXSYNCMODE,
    input               TXSYNCALLIN,
    input               TXSYNCIN,
    output              TXSYNCOUT,
    output              TXSYNCDONE,*/
// TX Pattern Generator, ug476 p.147
    input   [2:0]       TXPRBSSEL,
    input               TXPRBSFORCEERR,
// TX Polarity Control Ports, ug476 p.149
    input               TXPOLARITY,
// TX Fabric Clock Output Control Ports, ug476 p.152
    input   [2:0]       TXOUTCLKSEL,
    input   [2:0]       TXRATE,
    output              TXOUTCLKFABRIC,
    output              TXOUTCLK,
    output              TXOUTCLKPCS,
    output              TXRATEDONE,
// TX Phase Interpolator PPM Controller Ports, ug476 p.154
// GTH only
/*    input               TXPIPPMEN,
    input               TXPIPPMOVRDEN,
    input               TXPIPPMSEL,
    input               TXPIPPMPD,
    input   [4:0]       TXPIPPMSTEPSIZE,*/
// TX Configurable Driver Ports, ug476 p.156
    input   [2:0]       TXBUFDIFFCTRL,
    input               TXDEEMPH,
    input   [3:0]       TXDIFFCTRL,
    input               TXELECIDLE,
    input               TXINHIBIT,
    input   [6:0]       TXMAINCURSOR,
    input   [2:0]       TXMARGIN,
    input               TXQPIBIASEN,
    output              TXQPISENN,
    output              TXQPISENP,
    input               TXQPISTRONGPDOWN,
    input               TXQPIWEAKPUP,
    input   [4:0]       TXPOSTCURSOR,
    input               TXPOSTCURSORINV,
    input   [4:0]       TXPRECURSOR,
    input               TXPRECURSORINV,
    input               TXSWING,
    input               TXDIFFPD,
    input               TXPISOPD,
// TX Receiver Detection Ports, ug476 p.165
    input               TXDETECTRX,
    output              PHYSTATUS,
    output  [2:0]       RXSTATUS,
// TX OOB Signaling Ports, ug476 p.166
    output              TXCOMFINISH,
    input               TXCOMINIT,
    input               TXCOMSAS,
    input               TXCOMWAKE,
// RX AFE Ports, ug476 p.171
    output              RXQPISENN,
    output              RXQPISENP,
    input               RXQPIEN,
// RX OOB Signaling Ports, ug476 p.178
    input   [1:0]       RXELECIDLEMODE,
    output              RXELECIDLE,
    output              RXCOMINITDET,
    output              RXCOMSASDET,
    output              RXCOMWAKEDET,
// RX Equalizer Ports, ug476 p.189
    input               RXLPMEN,
    input               RXOSHOLD,
    input               RXOSOVRDEN,
    input               RXLPMLFHOLD,
    input               RXLPMLFKLOVRDEN,
    input               RXLPMHFHOLD,
    input               RXLPMHFOVRDEN,
    input               RXDFEAGCHOLD,
    input               RXDFEAGCOVRDEN,
    input               RXDFELFHOLD,
    input               RXDFELFOVRDEN,
    input               RXDFEUTHOLD,
    input               RXDFEUTOVRDEN,
    input               RXDFEVPHOLD,
    input               RXDFEVPOVRDEN,
    input               RXDFETAP2HOLD,
    input               RXDFETAP2OVRDEN,
    input               RXDFETAP3HOLD,
    input               RXDFETAP3OVRDEN,
    input               RXDFETAP4HOLD,
    input               RXDFETAP4OVRDEN,
    input               RXDFETAP5HOLD,
    input               RXDFETAP5OVRDEN,
    input               RXDFECM1EN,
    input               RXDFEXYDHOLD,
    input               RXDFEXYDOVRDEN,
    input               RXDFEXYDEN,
    input   [1:0]       RXMONITORSEL,
    output  [6:0]       RXMONITOROUT,
// CDR Ports, ug476 p.202
    input               RXCDRHOLD,
    input               RXCDROVRDEN,
    input               RXCDRRESETRSV,
    input   [2:0]       RXRATE,
    output              RXCDRLOCK,
// RX Fabric Clock Output Control Ports, ug476 p.213
    input   [2:0]       RXOUTCLKSEL,
    output              RXOUTCLKFABRIC,
    output              RXOUTCLK,
    output              RXOUTCLKPCS,
    output              RXRATEDONE,
    input               RXDLYBYPASS,
// RX Margin Analysis Ports, ug476 p.220
    output              EYESCANDATAERROR,
    input               EYESCANTRIGGER,
    input               EYESCANMODE,
// RX Polarity Control Ports, ug476 p.224
    input               RXPOLARITY,
// Pattern Checker Ports, ug476 p.225
    input               RXPRBSCNTRESET,
    input   [2:0]       RXPRBSSEL,
    output              RXPRBSERR,
// RX Byte and Word Alignment Ports, ug476 p.233
    output              RXBYTEISALIGNED,
    output              RXBYTEREALIGN,
    output              RXCOMMADET,
    input               RXCOMMADETEN,
    input               RXPCOMMAALIGNEN,
    input               RXMCOMMAALIGNEN,
    input               RXSLIDE,
// RX 8B/10B Decoder Ports, ug476 p.241
    input               RX8B10BEN,
    output  [7:0]       RXCHARISCOMMA,
    output  [7:0]       RXCHARISK,
    output  [7:0]       RXDISPERR,
    output  [7:0]       RXNOTINTABLE,
    input               SETERRSTATUS,
// RX Buffer Bypass Ports, ug476 p.244
    input               RXPHDLYRESET,
    input               RXPHALIGN,
    input               RXPHALIGNEN,
    input               RXPHOVRDEN,
    input               RXDLYSRESET,
    input               RXDLYEN,
    input               RXDLYOVRDEN,
    input               RXDDIEN,
    output              RXPHALIGNDONE,
    output              RXPHMONITOR,
    output              RXPHSLIPMONITOR,
    output              RXDLYSRESETDONE,
// RX Buffer Ports, ug476 p.259
    output  [2:0]       RXBUFSTATUS,
// RX Clock Correction Ports, ug476 p.263
    output  [1:0]       RXCLKCORCNT,
// RX Channel Bonding Ports, ug476 p.274
    output              RXCHANBONDSEQ,
    output              RXCHANISALIGNED,
    output              RXCHANREALIGN,
    input   [4:0]       RXCHBONDI,
    output  [4:0]       RXCHBONDO,
    input   [2:0]       RXCHBONDLEVEL,
    input               RXCHBONDMASTER,
    input               RXCHBONDSLAVE,
    input               RXCHBONDEN,
// RX Gearbox Ports, ug476 p.285
    output              RXDATAVALID,
    input               RXGEARBOXSLIP,
    output  [2:0]       RXHEADER,
    output              RXHEADERVALID,
    output              RXSTARTOFSEQ,
// FPGA RX Interface Ports, ug476 p.299
    output  [63:0]      RXDATA,
    input               RXUSRCLK,
    input               RXUSRCLK2,

// ug476, p.323
    output              RXVALID,
// for correct clocking scheme in case of multilane structure
    input               QPLLCLK,
    input               QPLLREFCLK,

// Diffpairs
    input               GTXRXP,
    input               GTXRXN,
    output              GTXTXN,
    output              GTXTXP
);
// simulation common attributes, UG476 p.28
parameter   SIM_RESET_SPEEDUP            = "TRUE";
parameter   SIM_CPLLREFCLK_SEL           = 3'b001;
parameter   SIM_RECEIVER_DETECT_PASS     = "TRUE"; 
parameter   SIM_TX_EIDLE_DRIVE_LEVEL     = "X";
parameter   SIM_VERSION                  = "1.0";
// Clocking Atributes, UG476 p.38
parameter   OUTREFCLK_SEL_INV            = 1'b0;
// CPLL Attributes, UG476 p.49
parameter   CPLL_CFG                     = 24'h0;
parameter   CPLL_FBDIV                   = 4;
parameter   CPLL_FBDIV_45                = 5;
parameter   CPLL_INIT_CFG                = 24'h0;
parameter   CPLL_LOCK_CFG                = 16'h0;
parameter   CPLL_REFCLK_DIV              = 1;
parameter   RXOUT_DIV                    = 2;
parameter   TXOUT_DIV                    = 2;
parameter   SATA_CPLL_CFG                = "VCO_3000MHZ";
parameter   PMA_RSV3                     = 2'b00;
// TX Initialization and Reset Attributes, ug476 p.66
parameter   TXPCSRESET_TIME              = 5'b00001;
parameter   TXPMARESET_TIME              = 5'b00001;
// RX Initialization and Reset Attributes, UG476 p.75
parameter   RXPMARESET_TIME              = 5'h0;
parameter   RXCDRPHRESET_TIME            = 5'h0;
parameter   RXCDRFREQRESET_TIME          = 5'h0;
parameter   RXDFELPMRESET_TIME           = 7'h0;
parameter   RXISCANRESET_TIME            = 7'h0;
parameter   RXPCSRESET_TIME              = 5'h0;
parameter   RXBUFRESET_TIME              = 5'h0;
// Power Down attributes, ug476 p.88
parameter   PD_TRANS_TIME_FROM_P2        = 12'h0;
parameter   PD_TRANS_TIME_NONE_P2        = 8'h0;
parameter   PD_TRANS_TIME_TO_P2          = 8'h0;
parameter   TRANS_TIME_RATE              = 8'h0;
parameter   RX_CLKMUX_PD                 = 1'b0;
parameter   TX_CLKMUX_PD                 = 1'b0;
// GTX Digital Monitor Attributes, ug476 p.96
parameter   DMONITOR_CFG                 = 24'h008101;
// TX Interface attributes, ug476 p.111
parameter   TX_DATA_WIDTH                = 20;
parameter   TX_INT_DATAWIDTH             = 0;
// TX Gearbox Attributes, ug476 p.121
parameter   GEARBOX_MODE                 = 3'h0;
parameter   TXGEARBOX_EN                 = "FALSE";
// TX BUffer Attributes, ug476 p.134
parameter   TXBUF_EN                     = "TRUE";
// TX Bypass buffer, ug476 p.138
parameter   TX_XCLK_SEL                  = "TXOUT";
parameter   TXPH_CFG                     = 16'h0;
parameter   TXPH_MONITOR_SEL             = 5'h0;
parameter   TXPHDLY_CFG                  = 24'h0;
parameter   TXDLY_CFG                    = 16'h0;
parameter   TXDLY_LCFG                   = 9'h0;
parameter   TXDLY_TAP_CFG                = 16'h0;
parameter   TXSYNC_MULTILANE             = 1'b0;
parameter   TXSYNC_SKIP_DA               = 1'b0;
parameter   TXSYNC_OVRD                  = 1'b1;
parameter   LOOPBACK_CFG                 = 1'b0;
// TX Pattern Generator, ug476 p.147
parameter   RXPRBS_ERR_LOOPBACK          = 1'b0;
// TX Fabric Clock Output Control Attributes, ug476 p. 153
parameter   TXBUF_RESET_ON_RATE_CHANGE   = "TRUE";
// TX Phase Interpolator PPM Controller Attributes, ug476 p.155
// GTH only
/*parameter   TXPI_SYNCFREQ_PPM            = 3'b001;
parameter   TXPI_PPM_CFG                 = 8'd0;
parameter   TXPI_INVSTROBE_SEL           = 1'b0;
parameter   TXPI_GREY_SEL                = 1'b0;
parameter   TXPI_PPMCLK_SEL              = "12345";*/
// TX Configurable Driver Attributes, ug476 p.162
parameter   TX_DEEMPH0                   = 5'b10100;
parameter   TX_DEEMPH1                   = 5'b01101;
parameter   TX_DRIVE_MODE                = "DIRECT";
parameter   TX_MAINCURSOR_SEL            = 1'b0;
parameter   TX_MARGIN_FULL_0             = 7'b0;
parameter   TX_MARGIN_FULL_1             = 7'b0;
parameter   TX_MARGIN_FULL_2             = 7'b0;
parameter   TX_MARGIN_FULL_3             = 7'b0;
parameter   TX_MARGIN_FULL_4             = 7'b0;
parameter   TX_MARGIN_LOW_0              = 7'b0;
parameter   TX_MARGIN_LOW_1              = 7'b0;
parameter   TX_MARGIN_LOW_2              = 7'b0;
parameter   TX_MARGIN_LOW_3              = 7'b0;
parameter   TX_MARGIN_LOW_4              = 7'b0;
parameter   TX_PREDRIVER_MODE            = 1'b0;
parameter   TX_QPI_STATUS_EN             = 1'b0;
parameter   TX_EIDLE_ASSERT_DELAY        = 3'b110;
parameter   TX_EIDLE_DEASSERT_DELAY      = 3'b100;
parameter   TX_LOOPBACK_DRIVE_HIZ        = "FALSE";
// TX Receiver Detection Attributes, ug476 p.165
parameter   TX_RXDETECT_CFG              = 14'h0;
parameter   TX_RXDETECT_REF              = 3'h0;
// TX OOB Signaling Attributes
parameter   SATA_BURST_SEQ_LEN           = 4'b0101;
// RX AFE Attributes, ug476 p.171
parameter   RX_CM_SEL                    = 2'b11;
parameter   TERM_RCAL_CFG                = 5'b0;
parameter   TERM_RCAL_OVRD               = 1'b0;
parameter   RX_CM_TRIM                   = 3'b010;
// RX OOB Signaling Attributes, ug476 p.179
parameter   PCS_RSVD_ATTR                = 48'h0100; // oob is up
parameter   RXOOB_CFG                    = 7'b0000110;
parameter   SATA_BURST_VAL               = 3'b110;
parameter   SATA_EIDLE_VAL               = 3'b110;
parameter   SAS_MIN_COM                  = 36;
parameter   SATA_MIN_INIT                = 12;
parameter   SATA_MIN_WAKE                = 4;
parameter   SATA_MAX_BURST               = 8;
parameter   SATA_MIN_BURST               = 4;
parameter   SAS_MAX_COM                  = 64;
parameter   SATA_MAX_INIT                = 21;
parameter   SATA_MAX_WAKE                = 7;
// RX Equalizer Attributes, ug476 p.193
parameter   RX_OS_CFG                    = 13'h0080;
parameter   RXLPM_LF_CFG                 = 14'h00f0;
parameter   RXLPM_HF_CFG                 = 14'h00f0;
parameter   RX_DFE_LPM_CFG               = 16'h0;
parameter   RX_DFE_GAIN_CFG              = 23'h020FEA;
parameter   RX_DFE_H2_CFG                = 12'h0;
parameter   RX_DFE_H3_CFG                = 12'h040;
parameter   RX_DFE_H4_CFG                = 11'h0e0;
parameter   RX_DFE_H5_CFG                = 11'h0e0;
parameter   PMA_RSV                      = 32'h00018480;
parameter   RX_DFE_LPM_HOLD_DURING_EIDLE = 1'b0;
parameter   RX_DFE_XYD_CFG               = 13'h0;
parameter   PMA_RSV4                     = 32'h0;
parameter   PMA_RSV2                     = 16'h0;
parameter   RX_BIAS_CFG                  = 12'h040;
parameter   RX_DEBUG_CFG                 = 12'h0;
parameter   RX_DFE_KL_CFG                = 13'h0;
parameter   RX_DFE_KL_CFG2               = 32'h0;
parameter   RX_DFE_UT_CFG                = 17'h11e00;
parameter   RX_DFE_VP_CFG                = 17'h03f03;
// CDR Attributes, ug476 p.203
parameter   RXCDR_CFG                    = 72'h0;
parameter   RXCDR_LOCK_CFG               = 6'h0;
parameter   RXCDR_HOLD_DURING_EIDLE      = 1'b0;
parameter   RXCDR_FR_RESET_ON_EIDLE      = 1'b0;
parameter   RXCDR_PH_RESET_ON_EIDLE      = 1'b0;
// RX Fabric Clock Output Control Attributes
parameter   RXBUF_RESET_ON_RATE_CHANGE   = "TRUE";
// RX Margin Analysis Attributes
parameter   ES_VERT_OFFSET               = 9'h0;
parameter   ES_HORZ_OFFSET               = 12'h0;
parameter   ES_PRESCALE                  = 5'h0;
parameter   ES_SDATA_MASK                = 80'h0;
parameter   ES_QUALIFIER                 = 80'h0;
parameter   ES_QUAL_MASK                 = 80'h0;
parameter   ES_EYE_SCAN_EN               = 1'b1;
parameter   ES_ERRDET_EN                 = 1'b0;
parameter   ES_CONTROL                   = 6'h0;
parameter   es_control_status            = 4'b000;
parameter   es_rdata                     = 80'h0;
parameter   es_sdata                     = 80'h0;
parameter   es_error_count               = 16'h0;
parameter   es_sample_count              = 16'h0;
parameter   RX_DATA_WIDTH                = 20;
parameter   RX_INT_DATAWIDTH             = 0;
parameter   ES_PMA_CFG                   = 10'h0;
// Pattern Checker Attributes, ug476 p.226
parameter   RX_PRBS_ERR_CNT              = 16'h15c;
// RX Byte and Word Alignment Attributes, ug476 p.235
parameter   ALIGN_COMMA_WORD             = 1;
parameter   ALIGN_COMMA_ENABLE           = 10'b1111111111;
parameter   ALIGN_COMMA_DOUBLE           = "FALSE";
parameter   ALIGN_MCOMMA_DET             = "TRUE";
parameter   ALIGN_MCOMMA_VALUE           = 10'b1010000011;
parameter   ALIGN_PCOMMA_DET             = "TRUE";
parameter   ALIGN_PCOMMA_VALUE           = 10'b0101111100;
parameter   SHOW_REALIGN_COMMA           = "TRUE";
parameter   RXSLIDE_MODE                 = "OFF";
parameter   RXSLIDE_AUTO_WAIT            = 7;
parameter   RX_SIG_VALID_DLY             = 10;
parameter   COMMA_ALIGN_LATENCY          = 9'h14e;
// RX 8B/10B Decoder Attributes, ug476 p.242
parameter   RX_DISPERR_SEQ_MATCH         = "TRUE";
parameter   DEC_MCOMMA_DETECT            = "TRUE";
parameter   DEC_PCOMMA_DETECT            = "TRUE";
parameter   DEC_VALID_COMMA_ONLY         = "FALSE";
parameter   UCODEER_CLR                  = 1'b0;
// RX Buffer Bypass Attributes, ug476 p.247
parameter   RXBUF_EN                     = "TRUE";
parameter   RX_XCLK_SEL                  = "RXREC";
parameter   RXPH_CFG                     = 24'h0;
parameter   RXPH_MONITOR_SEL             = 5'h0;
parameter   RXPHDLY_CFG                  = 24'h0;
parameter   RXDLY_CFG                    = 16'h0;
parameter   RXDLY_LCFG                   = 9'h0;
parameter   RXDLY_TAP_CFG                = 16'h0;
parameter   RX_DDI_SEL                   = 6'h0;
parameter   TST_RSV                      = 32'h0;
// RX Buffer Attributes, ug476 p.259
parameter   RX_BUFFER_CFG                = 6'b0;
parameter   RX_DEFER_RESET_BUF_EN        = "TRUE";
parameter   RXBUF_ADDR_MODE              = "FAST";
parameter   RXBUF_EIDLE_HI_CNT           = 4'b0;
parameter   RXBUF_EIDLE_LO_CNT           = 4'b0;
parameter   RXBUF_RESET_ON_CB_CHANGE     = "TRUE";
parameter   RXBUF_RESET_ON_COMMAALIGN    = "FALSE";
parameter   RXBUF_RESET_ON_EIDLE         = "FALSE";
parameter   RXBUF_THRESH_OVFLW           = 0;
parameter   RXBUF_THRESH_OVRD            = "FALSE";
parameter   RXBUF_THRESH_UNDFLW          = 0;
// RX Clock Correction Attributes, ug476 p.265
parameter   CBCC_DATA_SOURCE_SEL         = "DECODED";
parameter   CLK_CORRECT_USE              = "FALSE";
parameter   CLK_COR_SEQ_2_USE            = "FALSE";
parameter   CLK_COR_KEEP_IDLE            = "FALSE";
parameter   CLK_COR_MAX_LAT              = 9;
parameter   CLK_COR_MIN_LAT              = 7;
parameter   CLK_COR_PRECEDENCE           = "TRUE";
parameter   CLK_COR_REPEAT_WAIT          = 0;
parameter   CLK_COR_SEQ_LEN              = 1;
parameter   CLK_COR_SEQ_1_ENABLE         = 4'b1111;
parameter   CLK_COR_SEQ_1_1              = 10'b0;
parameter   CLK_COR_SEQ_1_2              = 10'b0;
parameter   CLK_COR_SEQ_1_3              = 10'b0;
parameter   CLK_COR_SEQ_1_4              = 10'b0;
parameter   CLK_COR_SEQ_2_ENABLE         = 4'b1111;
parameter   CLK_COR_SEQ_2_1              = 10'b0;
parameter   CLK_COR_SEQ_2_2              = 10'b0;
parameter   CLK_COR_SEQ_2_3              = 10'b0;
parameter   CLK_COR_SEQ_2_4              = 10'b0;
// RX Channel Bonding Attributes, ug476 p.276
parameter   CHAN_BOND_MAX_SKEW           = 1;
parameter   CHAN_BOND_KEEP_ALIGN         = "FALSE";
parameter   CHAN_BOND_SEQ_LEN            = 1;
parameter   CHAN_BOND_SEQ_1_1            = 10'b0;
parameter   CHAN_BOND_SEQ_1_2            = 10'b0;
parameter   CHAN_BOND_SEQ_1_3            = 10'b0;
parameter   CHAN_BOND_SEQ_1_4            = 10'b0;
parameter   CHAN_BOND_SEQ_1_ENABLE       = 4'b1111;
parameter   CHAN_BOND_SEQ_2_1            = 10'b0;
parameter   CHAN_BOND_SEQ_2_2            = 10'b0;
parameter   CHAN_BOND_SEQ_2_3            = 10'b0;
parameter   CHAN_BOND_SEQ_2_4            = 10'b0;
parameter   CHAN_BOND_SEQ_2_ENABLE       = 4'b1111;
parameter   CHAN_BOND_SEQ_2_USE          = "FALSE";
parameter   FTS_DESKEW_SEQ_ENABLE        = 4'b1111;
parameter   FTS_LANE_DESKEW_CFG          = 4'b1111;
parameter   FTS_LANE_DESKEW_EN           = "FALSE";
parameter   PCS_PCIE_EN                  = "FALSE";
// RX Gearbox Attributes, ug476 p.287
parameter   RXGEARBOX_EN                 = "FALSE";

// ug476 table p.326 - undocumented parameters
parameter   RX_CLK25_DIV                 = 6;
parameter   TX_CLK25_DIV                 = 6;

// clocking reset ( + TX PMA)
wire clk_reset = EYESCANRESET | RXCDRFREQRESET | RXCDRRESET | RXCDRRESETRSV | RXPRBSCNTRESET | RXBUFRESET | RXDLYSRESET | RXPHDLYRESET | RXDFELPMRESET | GTRXRESET | RXOOBRESET | RXPCSRESET | RXPMARESET | CFGRESET | GTTXRESET | GTRESETSEL | RESETOVRD | TXDLYSRESET | TXPHDLYRESET | TXPCSRESET | TXPMARESET;
// have to wait before an external pll (mmcm) locks with usrclk, after that PCS can be resetted. Actually, we reset PMA also, because why not
reg reset;
reg [31:0] reset_timer = 0;
always @ (posedge TXUSRCLK)
    reset_timer <= ~TXUSERRDY ? 32'h0 : reset_timer == 32'hffffffff ? reset_timer : reset_timer + 1'b1;

always @ (posedge TXUSRCLK)
    reset <= ~TXUSERRDY ? 1'b0 : reset_timer < 32'd20 ? 1'b1 : 1'b0;


reg rx_rst_done = 1'b0;
reg tx_rst_done = 1'b0;
assign  RXRESETDONE = rx_rst_done;
assign  TXRESETDONE = tx_rst_done;
initial
forever @ (posedge reset)
begin
    tx_rst_done <= 1'b0;
    @ (negedge reset);
    repeat (80)
        @ (posedge GTREFCLK0);
    tx_rst_done <= 1'b1;
end
initial
forever @ (posedge reset)
begin
    rx_rst_done <= 1'b0;
    @ (negedge reset);
    repeat (100)
        @ (posedge GTREFCLK0);
    rx_rst_done <= 1'b1;
end

gtxe2_chnl #(
    .CPLL_CFG               (CPLL_CFG),
    .CPLL_FBDIV             (CPLL_FBDIV),
    .CPLL_FBDIV_45          (CPLL_FBDIV_45),
    .CPLL_INIT_CFG          (CPLL_INIT_CFG),
    .CPLL_LOCK_CFG          (CPLL_LOCK_CFG),
    .CPLL_REFCLK_DIV        (CPLL_REFCLK_DIV),
    .RXOUT_DIV              (RXOUT_DIV),
    .TXOUT_DIV              (TXOUT_DIV),
    .SATA_CPLL_CFG          (SATA_CPLL_CFG),
    .PMA_RSV3               (PMA_RSV3),

    .TX_INT_DATAWIDTH       (TX_INT_DATAWIDTH),
    .TX_DATA_WIDTH          (TX_DATA_WIDTH),

    .RX_DATA_WIDTH          (RX_DATA_WIDTH),
    .RX_INT_DATAWIDTH       (RX_INT_DATAWIDTH),

    .DEC_MCOMMA_DETECT      (DEC_MCOMMA_DETECT),
    .DEC_PCOMMA_DETECT      (DEC_PCOMMA_DETECT),

    .ALIGN_MCOMMA_VALUE     (ALIGN_MCOMMA_VALUE),
    .ALIGN_MCOMMA_DET       (ALIGN_MCOMMA_DET),
    .ALIGN_PCOMMA_VALUE     (ALIGN_PCOMMA_VALUE),
    .ALIGN_PCOMMA_DET       (ALIGN_PCOMMA_DET),
    .ALIGN_COMMA_ENABLE     (ALIGN_COMMA_ENABLE),
    .ALIGN_COMMA_DOUBLE     (ALIGN_COMMA_DOUBLE),

    .TX_DATA_WIDTH          (TX_DATA_WIDTH),
    .TX_INT_DATAWIDTH       (TX_INT_DATAWIDTH),

    .SATA_BURST_SEQ_LEN     (SATA_BURST_SEQ_LEN)
)
channel(
    .reset                  (reset),
    .TXP                    (GTXTXP),
    .TXN                    (GTXTXN),

    .TXDATA                 (TXDATA),
    .TXUSRCLK               (TXUSRCLK),
    .TXUSRCLK2              (TXUSRCLK2),

    .TX8B10BBYPASS          (TX8B10BBYPASS),
    .TX8B10BEN              (TX8B10BEN),
    .TXCHARDISPMODE         (TXCHARDISPMODE),
    .TXCHARDISPVAL          (TXCHARDISPVAL),
    .TXCHARISK              (TXCHARISK),

    .TXBUFSTATUS            (TXBUFSTATUS),

    .TXPOLARITY             (TXPOLARITY),

    .TXRATE                 (TXRATE),
    .RXRATE                 (RXRATE),
    .TXRATEDONE             (TXRATEDONE),

    .TXCOMINIT              (TXCOMINIT),
    .TXCOMWAKE              (TXCOMWAKE),
    .TXCOMFINISH            (TXCOMFINISH),

    .TXELECIDLE             (TXELECIDLE),

    .RXP                    (GTXRXP),
    .RXN                    (GTXRXN),

    .RXUSRCLK               (RXUSRCLK),
    .RXUSRCLK2              (RXUSRCLK2),

    .RXDATA                 (RXDATA),

    .RXELECIDLEMODE         (RXELECIDLEMODE),
    .RXELECIDLE             (RXELECIDLE),
    .RXCOMINITDET           (RXCOMINITDET),
    .RXCOMWAKEDET           (RXCOMWAKEDET),

    .RXPOLARITY             (RXPOLARITY),

    .RXBYTEISALIGNED        (RXBYTEISALIGNED),
    .RXBYTEREALIGN          (RXBYTEREALIGN),
    .RXCOMMADET             (RXCOMMADET),

    .RXCOMMADETEN           (RXCOMMADETEN),
    .RXPCOMMAALIGNEN        (RXPCOMMAALIGNEN),
    .RXMCOMMAALIGNEN        (RXMCOMMAALIGNEN),

    .RX8B10BEN              (RX8B10BEN),

    .RXCHARISCOMMA          (RXCHARISCOMMA),
    .RXCHARISK              (RXCHARISK),
    .RXDISPERR              (RXDISPERR),
    .RXNOTINTABLE           (RXNOTINTABLE),

    .CPLLREFCLKSEL          (CPLLREFCLKSEL),
    .GTREFCLK0              (GTREFCLK0),
    .GTREFCLK1              (GTREFCLK1),
    .GTNORTHREFCLK0         (GTNORTHREFCLK0),
    .GTNORTHREFCLK1         (GTNORTHREFCLK1),
    .GTSOUTHREFCLK0         (GTSOUTHREFCLK0),
    .GTSOUTHREFCLK1         (GTSOUTHREFCLK1),
    .GTGREFCLK              (GTGREFCLK),
    .QPLLCLK                (QPLLCLK),
    .QPLLREFCLK             (QPLLREFCLK),
    .RXSYSCLKSEL            (RXSYSCLKSEL),
    .TXSYSCLKSEL            (TXSYSCLKSEL),
    .TXOUTCLKSEL            (TXOUTCLKSEL),
    .RXOUTCLKSEL            (RXOUTCLKSEL),
    .TXDLYBYPASS            (TXDLYBYPASS),
    .GTREFCLKMONITOR        (GTREFCLKMONITOR),

    .CPLLLOCKDETCLK         (CPLLLOCKDETCLK ),
    .CPLLLOCKEN             (CPLLLOCKEN),
    .CPLLPD                 (CPLLPD),
    .CPLLRESET              (CPLLRESET),
    .CPLLFBCLKLOST          (CPLLFBCLKLOST),
    .CPLLLOCK               (CPLLLOCK),
    .CPLLREFCLKLOST         (CPLLREFCLKLOST),

    .GTRSVD                 (GTRSVD),
    .PCSRSVDIN              (PCSRSVDIN),
    .PCSRSVDIN2             (PCSRSVDIN2),
    .PMARSVDIN              (PMARSVDIN),
    .PMARSVDIN2             (PMARSVDIN2),
    .TSTIN                  (TSTIN),
    .TSTOUT                 (TSTOUT),
    
    .TXOUTCLKPMA            (),
    .TXOUTCLKPCS            (TXOUTCLKPCS),
    .TXOUTCLK               (TXOUTCLK),
    .TXOUTCLKFABRIC         (TXOUTCLKFABRIC),
    .tx_serial_clk          (),

    .RXOUTCLKPMA            (),
    .RXOUTCLKPCS            (RXOUTCLKPCS),
    .RXOUTCLK               (RXOUTCLK),
    .RXOUTCLKFABRIC         (RXOUTCLKFABRIC),
    .rx_serial_clk          (),

    .RXDLYBYPASS            (RXDLYBYPASS)
);


endmodule
            
        
