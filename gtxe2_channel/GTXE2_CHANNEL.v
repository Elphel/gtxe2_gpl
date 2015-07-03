`include "gtxe2_chnl.v"
module GTXE2_CHANNEL(
        //------------------------------- CPLL Ports -------------------------------
output         CPLLFBCLKLOST                 , //(cpllfbclklost_out),
output         CPLLLOCK                      , //(cplllock_out),
input         CPLLLOCKDETCLK                , //(cplllockdetclk_in),
input         CPLLLOCKEN                    , //(tied_to_vcc_i),
input         CPLLPD                        , //(cpll_pd_i),
output         CPLLREFCLKLOST                , //(cpllrefclklost_out),
input [2:0]         CPLLREFCLKSEL                 , //(3'b001),
input         CPLLRESET                     , //(cpll_reset_i),
input [15:0]         GTRSVD                        , //(16'b0000000000000000),
input [15:0]         PCSRSVDIN                     , //(16'b0000000000000000),
input [4:0]         PCSRSVDIN2                    , //(5'b00000),
input [4:0]         PMARSVDIN                     , //(5'b00000),
input [4:0]         PMARSVDIN2                    , //(5'b00000),
input [19:0]         TSTIN                         , //(20'b11111111111111111111),
output [9:0]         TSTOUT                        , //(),
        //-------------------------------- Channel ---------------------------------
input [3:0]         CLKRSVD                       , //(4'b0000),
        //------------------------ Channel - Clocking Ports ------------------------
input         GTGREFCLK                     , //(tied_to_ground_i),
input         GTNORTHREFCLK0                , //(tied_to_ground_i),
input         GTNORTHREFCLK1                , //(tied_to_ground_i),
input         GTREFCLK0                     , //(gtrefclk0_in),
input         GTREFCLK1                     , //(tied_to_ground_i),
input         GTSOUTHREFCLK0                , //(tied_to_ground_i),
input         GTSOUTHREFCLK1                , //(tied_to_ground_i),
        //-------------------------- Channel - DRP Ports  --------------------------
input [8:0]         DRPADDR                       , //(drpaddr_in),
input         DRPCLK                        , //(drpclk_in),
input [15:0]         DRPDI                         , //(drpdi_in),
output [15:0]         DRPDO                         , //(drpdo_out),
input         DRPEN                         , //(drpen_in),
output         DRPRDY                        , //(drprdy_out),
input         DRPWE                         , //(drpwe_in),
        //----------------------------- Clocking Ports -----------------------------
output         GTREFCLKMONITOR               , //(),
input         QPLLCLK                       , //(qpllclk_in),
input         QPLLREFCLK                    , //(qpllrefclk_in),
input [1:0]         RXSYSCLKSEL                   , //(2'b00),
input [1:0]         TXSYSCLKSEL                   , //(2'b00),
        //------------------------- Digital Monitor Ports --------------------------
output [7:0]         DMONITOROUT                   , //(dmonitorout_out),
        //--------------- FPGA TX Interface Datapath Configuration  ----------------
input         TX8B10BEN                     , //(tied_to_vcc_i),
        //----------------------------- Loopback Ports -----------------------------
input [2:0]         LOOPBACK                      , //(tied_to_ground_vec_i[2:0]),
        //--------------------------- PCI Express Ports ----------------------------
output         PHYSTATUS                     , //(),
input [2:0]         RXRATE                        , //(tied_to_ground_vec_i[2:0]),
output         RXVALID                       , //(),
        //---------------------------- Power-Down Ports ----------------------------
input [1:0]         RXPD                          , //(2'b00),
input [1:0]         TXPD                          , //(2'b00),
        //------------------------ RX 8B/10B Decoder Ports -------------------------
input         SETERRSTATUS                  , //(tied_to_ground_i),
        //------------------- RX Initialization and Reset Ports --------------------
input         EYESCANRESET                  , //(eyescanreset_in),
input         RXUSERRDY                     , //(rxuserrdy_in),
        //------------------------ RX Margin Analysis Ports ------------------------
output         EYESCANDATAERROR              , //(eyescandataerror_out),
input         EYESCANMODE                   , //(tied_to_ground_i),
input         EYESCANTRIGGER                , //(eyescantrigger_in),
        //----------------------- Receive Ports - CDR Ports ------------------------
input         RXCDRFREQRESET                , //(tied_to_ground_i),
input         RXCDRHOLD                     , //(tied_to_ground_i),
output         RXCDRLOCK                     , //(),
input         RXCDROVRDEN                   , //(tied_to_ground_i),
input         RXCDRRESET                    , //(tied_to_ground_i),
input         RXCDRRESETRSV                 , //(tied_to_ground_i),
        //----------------- Receive Ports - Clock Correction Ports -----------------
output [1:0]         RXCLKCORCNT                   , //(),
        //-------- Receive Ports - FPGA RX Interface Datapath Configuration --------
input         RX8B10BEN                     , //(tied_to_vcc_i),
        //---------------- Receive Ports - FPGA RX Interface Ports -----------------
input         RXUSRCLK                      , //(rxusrclk_in),
input         RXUSRCLK2                     , //(rxusrclk2_in),
        //---------------- Receive Ports - FPGA RX interface Ports -----------------
output [63:0]         RXDATA                        , //(rxdata_i),
        //----------------- Receive Ports - Pattern Checker Ports ------------------
output         RXPRBSERR                     , //(),
input [2:0]         RXPRBSSEL                     , //(tied_to_ground_vec_i[2:0]),
        //----------------- Receive Ports - Pattern Checker ports ------------------
input         RXPRBSCNTRESET                , //(tied_to_ground_i),
        //------------------ Receive Ports - RX  Equalizer Ports -------------------
input         RXDFEXYDEN                    , //(tied_to_vcc_i),
input         RXDFEXYDHOLD                  , //(tied_to_ground_i),
input         RXDFEXYDOVRDEN                , //(tied_to_ground_i),
        //---------------- Receive Ports - RX 8B/10B Decoder Ports -----------------
output [7:0]         RXDISPERR                     , //({rxdisperr_float_i,rxdisperr_out}),
output [7:0]         RXNOTINTABLE                  , //({rxnotintable_float_i,rxnotintable_out}),
        //------------------------- Receive Ports - RX AFE -------------------------
input         GTXRXP                        , //(gtxrxp_in),
        //---------------------- Receive Ports - RX AFE Ports ----------------------
input         GTXRXN                        , //(gtxrxn_in),
        //----------------- Receive Ports - RX Buffer Bypass Ports -----------------
input         RXBUFRESET                    , //(tied_to_ground_i),
output [2:0]         RXBUFSTATUS                   , //(),
input         RXDDIEN                       , //(tied_to_ground_i),
input         RXDLYBYPASS                   , //(tied_to_vcc_i),
input         RXDLYEN                       , //(tied_to_ground_i),
input         RXDLYOVRDEN                   , //(tied_to_ground_i),
input         RXDLYSRESET                   , //(tied_to_ground_i),
output         RXDLYSRESETDONE               , //(),
input         RXPHALIGN                     , //(tied_to_ground_i),
output         RXPHALIGNDONE                 , //(),
input         RXPHALIGNEN                   , //(tied_to_ground_i),
input         RXPHDLYPD                     , //(tied_to_ground_i),
input         RXPHDLYRESET                  , //(tied_to_ground_i),
output [4:0]         RXPHMONITOR                   , //(),
input         RXPHOVRDEN                    , //(tied_to_ground_i),
output [4:0]         RXPHSLIPMONITOR               , //(),
output [2:0]         RXSTATUS                      , //(rxstatus_out),
        //------------ Receive Ports - RX Byte and Word Alignment Ports ------------
output         RXBYTEISALIGNED               , //(rxbyteisaligned_out),
output         RXBYTEREALIGN                 , //(),
output         RXCOMMADET                    , //(),
input         RXCOMMADETEN                  , //(tied_to_vcc_i),
input         RXMCOMMAALIGNEN               , //(tied_to_vcc_i),
input         RXPCOMMAALIGNEN               , //(tied_to_vcc_i),
        //---------------- Receive Ports - RX Channel Bonding Ports ----------------
output         RXCHANBONDSEQ                 , //(),
input         RXCHBONDEN                    , //(tied_to_ground_i),
input [2:0]         RXCHBONDLEVEL                 , //(tied_to_ground_vec_i[2:0]),
input         RXCHBONDMASTER                , //(tied_to_ground_i),
output [4:0]         RXCHBONDO                     , //(),
input         RXCHBONDSLAVE                 , //(tied_to_ground_i),
        //--------------- Receive Ports - RX Channel Bonding Ports  ----------------
output         RXCHANISALIGNED               , //(),
output         RXCHANREALIGN                 , //(),
        //------------------ Receive Ports - RX Equailizer Ports -------------------
input         RXLPMHFHOLD                   , //(tied_to_ground_i),
input         RXLPMHFOVRDEN                 , //(tied_to_ground_i),
input         RXLPMLFHOLD                   , //(tied_to_ground_i),
        //------------------- Receive Ports - RX Equalizer Ports -------------------
input         RXDFEAGCHOLD                  , //(rxdfeagchold_in),
input         RXDFEAGCOVRDEN                , //(tied_to_ground_i),
input         RXDFECM1EN                    , //(tied_to_ground_i),
input         RXDFELFHOLD                   , //(rxdfelfhold_in),
input         RXDFELFOVRDEN                 , //(tied_to_vcc_i),
input         RXDFELPMRESET                 , //(rxdfelpmreset_in),
input         RXDFETAP2HOLD                 , //(tied_to_ground_i),
input         RXDFETAP2OVRDEN               , //(tied_to_ground_i),
input         RXDFETAP3HOLD                 , //(tied_to_ground_i),
input         RXDFETAP3OVRDEN               , //(tied_to_ground_i),
input         RXDFETAP4HOLD                 , //(tied_to_ground_i),
input         RXDFETAP4OVRDEN               , //(tied_to_ground_i),
input         RXDFETAP5HOLD                 , //(tied_to_ground_i),
input         RXDFETAP5OVRDEN               , //(tied_to_ground_i),
input         RXDFEUTHOLD                   , //(tied_to_ground_i),
input         RXDFEUTOVRDEN                 , //(tied_to_ground_i),
input         RXDFEVPHOLD                   , //(tied_to_ground_i),
input         RXDFEVPOVRDEN                 , //(tied_to_ground_i),
input         RXDFEVSEN                     , //(tied_to_ground_i),
input         RXLPMLFKLOVRDEN               , //(tied_to_ground_i),
output [6:0]         RXMONITOROUT                  , //(rxmonitorout_out),
input [1:0]         RXMONITORSEL                  , //(rxmonitorsel_in),
input         RXOSHOLD                      , //(tied_to_ground_i),
input         RXOSOVRDEN                    , //(tied_to_ground_i),
        //---------- Receive Ports - RX Fabric ClocK Output Control Ports ----------
output         RXRATEDONE                    , //(),
        //------------- Receive Ports - RX Fabric Output Control Ports -------------
output         RXOUTCLK                      , //(rxoutclk_out),
output         RXOUTCLKFABRIC                , //(),
output         RXOUTCLKPCS                   , //(),
input [2:0]         RXOUTCLKSEL                   , //(3'b010),
        //-------------------- Receive Ports - RX Gearbox Ports --------------------
output         RXDATAVALID                   , //(),
output [2:0]         RXHEADER                      , //(),
output         RXHEADERVALID                 , //(),
output         RXSTARTOFSEQ                  , //(),
        //------------------- Receive Ports - RX Gearbox Ports  --------------------
input         RXGEARBOXSLIP                 , //(tied_to_ground_i),
        //----------- Receive Ports - RX Initialization and Reset Ports ------------
input         GTRXRESET                     , //(gtrxreset_in),
input         RXOOBRESET                    , //(tied_to_ground_i),
input         RXPCSRESET                    , //(tied_to_ground_i),
input         RXPMARESET                    , //(rxpmareset_in),
        //---------------- Receive Ports - RX Margin Analysis ports ----------------
input         RXLPMEN                       , //(tied_to_ground_i),
        //----------------- Receive Ports - RX OOB Signaling ports -----------------
output         RXCOMSASDET                   , //(),
output         RXCOMWAKEDET                  , //(rxcomwakedet_out),
        //---------------- Receive Ports - RX OOB Signaling ports  -----------------
output         RXCOMINITDET                  , //(rxcominitdet_out),
        //---------------- Receive Ports - RX OOB signalling Ports -----------------
output         RXELECIDLE                    , //(rxelecidle_out),
input [1:0]         RXELECIDLEMODE                , //(2'b00),
        //--------------- Receive Ports - RX Polarity Control Ports ----------------
input         RXPOLARITY                    , //(tied_to_ground_i),
        //-------------------- Receive Ports - RX gearbox ports --------------------
input         RXSLIDE                       , //(tied_to_ground_i),
        //----------------- Receive Ports - RX8B/10B Decoder Ports -----------------
output [7:0]         RXCHARISCOMMA                 , //(),
output [7:0]         RXCHARISK                     , //({rxcharisk_float_i,rxcharisk_out}),
        //---------------- Receive Ports - Rx Channel Bonding Ports ----------------
input [4:0]         RXCHBONDI                     , //(5'b00000),
        //------------ Receive Ports -RX Initialization and Reset Ports ------------
output         RXRESETDONE                   , //(rxresetdone_out),
        //------------------------------ Rx AFE Ports ------------------------------
input         RXQPIEN                       , //(tied_to_ground_i),
output         RXQPISENN                     , //(),
output         RXQPISENP                     , //(),
        //------------------------- TX Buffer Bypass Ports -------------------------
input         TXPHDLYTSTCLK                 , //(tied_to_ground_i),
        //---------------------- TX Configurable Driver Ports ----------------------
input [4:0]         TXPOSTCURSOR                  , //(5'b00000),
input         TXPOSTCURSORINV               , //(tied_to_ground_i),
input [4:0]         TXPRECURSOR                   , //(tied_to_ground_vec_i[4:0]),
input         TXPRECURSORINV                , //(tied_to_ground_i),
input         TXQPIBIASEN                   , //(tied_to_ground_i),
input         TXQPISTRONGPDOWN              , //(tied_to_ground_i),
input         TXQPIWEAKPUP                  , //(tied_to_ground_i),
        //------------------- TX Initialization and Reset Ports --------------------
input         CFGRESET                      , //(tied_to_ground_i),
input         GTTXRESET                     , //(gttxreset_in),
output [15:0]         PCSRSVDOUT                    , //(),
input         TXUSERRDY                     , //(txuserrdy_in),
        //-------------------- Transceiver Reset Mode Operation --------------------
input         GTRESETSEL                    , //(tied_to_ground_i),
input         RESETOVRD                     , //(tied_to_ground_i),
        //-------------- Transmit Ports - 8b10b Encoder Control Ports --------------
input [7:0]         TXCHARDISPMODE                , //(tied_to_ground_vec_i[7:0]),
input [7:0]         TXCHARDISPVAL                 , //(tied_to_ground_vec_i[7:0]),
        //---------------- Transmit Ports - FPGA TX Interface Ports ----------------
input         TXUSRCLK                      , //(txusrclk_in),
input         TXUSRCLK2                     , //(txusrclk2_in),
        //------------------- Transmit Ports - PCI Express Ports -------------------
input         TXELECIDLE                    , //(txelecidle_in),
input [2:0]         TXMARGIN                      , //(tied_to_ground_vec_i[2:0]),
input [2:0]         TXRATE                        , //(tied_to_ground_vec_i[2:0]),
input         TXSWING                       , //(tied_to_ground_i),
        //---------------- Transmit Ports - Pattern Generator Ports ----------------
input         TXPRBSFORCEERR                , //(tied_to_ground_i),
        //---------------- Transmit Ports - TX Buffer Bypass Ports -----------------
input         TXDLYBYPASS                   , //(tied_to_vcc_i),
input         TXDLYEN                       , //(tied_to_ground_i),
input         TXDLYHOLD                     , //(tied_to_ground_i),
input         TXDLYOVRDEN                   , //(tied_to_ground_i),
input         TXDLYSRESET                   , //(tied_to_ground_i),
output         TXDLYSRESETDONE               , //(),
input         TXDLYUPDOWN                   , //(tied_to_ground_i),
input         TXPHALIGN                     , //(tied_to_ground_i),
output         TXPHALIGNDONE                 , //(),
input         TXPHALIGNEN                   , //(tied_to_ground_i),
input         TXPHDLYPD                     , //(tied_to_ground_i),
input         TXPHDLYRESET                  , //(tied_to_ground_i),
input         TXPHINIT                      , //(tied_to_ground_i),
output         TXPHINITDONE                  , //(),
input         TXPHOVRDEN                    , //(tied_to_ground_i),
        //-------------------- Transmit Ports - TX Buffer Ports --------------------
output [1:0]         TXBUFSTATUS                   , //(),
        //------------- Transmit Ports - TX Configurable Driver Ports --------------
input [2:0]         TXBUFDIFFCTRL                 , //(3'b100),
input         TXDEEMPH                      , //(tied_to_ground_i),
input [3:0]         TXDIFFCTRL                    , //(4'b1000),
input         TXDIFFPD                      , //(tied_to_ground_i),
input         TXINHIBIT                     , //(tied_to_ground_i),
input [6:0]         TXMAINCURSOR                  , //(7'b0000000),
input         TXPISOPD                      , //(tied_to_ground_i),
        //---------------- Transmit Ports - TX Data Path interface -----------------
input [63:0]         TXDATA                        , //(txdata_i),
        //-------------- Transmit Ports - TX Driver and OOB signaling --------------
output         GTXTXN                        , //(gtxtxn_out),
output         GTXTXP                        , //(gtxtxp_out),
        //--------- Transmit Ports - TX Fabric Clock Output Control Ports ----------
output         TXOUTCLK                      , //(txoutclk_out),
output         TXOUTCLKFABRIC                , //(txoutclkfabric_out),
output         TXOUTCLKPCS                   , //(txoutclkpcs_out),
input [2:0]         TXOUTCLKSEL                   , //(3'b010),
output         TXRATEDONE                    , //(),
        //------------------- Transmit Ports - TX Gearbox Ports --------------------
input [7:0]         TXCHARISK                     , //({tied_to_ground_vec_i[5:0],txcharisk_in}),
output         TXGEARBOXREADY                , //(),
input [2:0]         TXHEADER                      , //(tied_to_ground_vec_i[2:0]),
input [6:0]         TXSEQUENCE                    , //(tied_to_ground_vec_i[6:0]),
input         TXSTARTSEQ                    , //(tied_to_ground_i),
        //----------- Transmit Ports - TX Initialization and Reset Ports -----------
input         TXPCSRESET                    , //(tied_to_ground_i),
input         TXPMARESET                    , //(tied_to_ground_i),
output         TXRESETDONE                   , //(txresetdone_out),
        //---------------- Transmit Ports - TX OOB signalling Ports ----------------
output         TXCOMFINISH                   , //(txcomfinish_out),
input         TXCOMINIT                     , //(tied_to_ground_i),
input         TXCOMSAS                      , //(tied_to_ground_i),
input         TXCOMWAKE                     , //(txcomwake_in),
input         TXPDELECIDLEMODE              , //(tied_to_ground_i),
        //--------------- Transmit Ports - TX Polarity Control Ports ---------------
input         TXPOLARITY                    , //(tied_to_ground_i),
        //------------- Transmit Ports - TX Receiver Detection Ports  --------------
input         TXDETECTRX                    , //(tied_to_ground_i),
        //---------------- Transmit Ports - TX8b/10b Encoder Ports -----------------
input [7:0]         TX8B10BBYPASS                 , //(tied_to_ground_vec_i[7:0]),
        //---------------- Transmit Ports - pattern Generator Ports ----------------
input [2:0]         TXPRBSSEL                     , //(tied_to_ground_vec_i[2:0]),
        //--------------------- Tx Configurable Driver  Ports ----------------------
output         TXQPISENN                     , //(),
output         TXQPISENP                      //()
);
//_______________________ Simulation-Only Attributes __________________
    
parameter   SIM_RECEIVER_DETECT_PASS     = "TRUE";
parameter   SIM_TX_EIDLE_DRIVE_LEVEL     = "X";
parameter   SIM_RESET_SPEEDUP            = "FALSE";
parameter   SIM_CPLLREFCLK_SEL           = 3'b001;
parameter   SIM_VERSION                  = "4.0";
            

//----------------RX Byte and Word Alignment Attributes---------------
parameter   ALIGN_COMMA_DOUBLE           = "FALSE";
parameter   ALIGN_COMMA_ENABLE           = 10'b1111111111;
parameter   ALIGN_COMMA_WORD             = 1;
parameter   ALIGN_MCOMMA_DET             = "TRUE";
parameter   ALIGN_MCOMMA_VALUE           = 10'b1010000011;
parameter   ALIGN_PCOMMA_DET             = "TRUE";
parameter   ALIGN_PCOMMA_VALUE           = 10'b0101111100;
parameter   SHOW_REALIGN_COMMA           = "TRUE";
parameter   RXSLIDE_AUTO_WAIT            = 7;
parameter   RXSLIDE_MODE                 = "OFF";
parameter   RX_SIG_VALID_DLY             = 10;

//----------------RX 8B/10B Decoder Attributes---------------
parameter   RX_DISPERR_SEQ_MATCH         = "TRUE";
parameter   DEC_MCOMMA_DETECT            = "TRUE";
parameter   DEC_PCOMMA_DETECT            = "TRUE";
parameter   DEC_VALID_COMMA_ONLY         = "FALSE";

//----------------------RX Clock Correction Attributes----------------------
parameter   CBCC_DATA_SOURCE_SEL         = "DECODED";
parameter   CLK_COR_SEQ_2_USE            = "FALSE";
parameter   CLK_COR_KEEP_IDLE            = "FALSE";
parameter   CLK_COR_MAX_LAT              = 9;
parameter   CLK_COR_MIN_LAT              = 7;
parameter   CLK_COR_PRECEDENCE           = "TRUE";
parameter   CLK_COR_REPEAT_WAIT          = 0;
parameter   CLK_COR_SEQ_LEN              = 1;
parameter   CLK_COR_SEQ_1_ENABLE         = 4'b1111;
parameter   CLK_COR_SEQ_1_1              = 10'b0100000000;
parameter   CLK_COR_SEQ_1_2              = 10'b0000000000;
parameter   CLK_COR_SEQ_1_3              = 10'b0000000000;
parameter   CLK_COR_SEQ_1_4              = 10'b0000000000;
parameter   CLK_CORRECT_USE              = "FALSE";
parameter   CLK_COR_SEQ_2_ENABLE         = 4'b1111;
parameter   CLK_COR_SEQ_2_1              = 10'b0100000000;
parameter   CLK_COR_SEQ_2_2              = 10'b0000000000;
parameter   CLK_COR_SEQ_2_3              = 10'b0000000000;
parameter   CLK_COR_SEQ_2_4              = 10'b0000000000;

//----------------------RX Channel Bonding Attributes----------------------
parameter   CHAN_BOND_KEEP_ALIGN         = "FALSE";
parameter   CHAN_BOND_MAX_SKEW           = 1;
parameter   CHAN_BOND_SEQ_LEN            = 1;
parameter   CHAN_BOND_SEQ_1_1            = 10'b0000000000;
parameter   CHAN_BOND_SEQ_1_2            = 10'b0000000000;
parameter   CHAN_BOND_SEQ_1_3            = 10'b0000000000;
parameter   CHAN_BOND_SEQ_1_4            = 10'b0000000000;
parameter   CHAN_BOND_SEQ_1_ENABLE       = 4'b1111;
parameter   CHAN_BOND_SEQ_2_1            = 10'b0000000000;
parameter   CHAN_BOND_SEQ_2_2            = 10'b0000000000;
parameter   CHAN_BOND_SEQ_2_3            = 10'b0000000000;
parameter   CHAN_BOND_SEQ_2_4            = 10'b0000000000;
parameter   CHAN_BOND_SEQ_2_ENABLE       = 4'b1111;
parameter   CHAN_BOND_SEQ_2_USE          = "FALSE";
parameter   FTS_DESKEW_SEQ_ENABLE        = 4'b1111;
parameter   FTS_LANE_DESKEW_CFG          = 4'b1111;
parameter   FTS_LANE_DESKEW_EN           = "FALSE";

//-------------------------RX Margin Analysis Attributes----------------------------
parameter   ES_CONTROL                   = 6'b000000;
parameter   ES_ERRDET_EN                 = "FALSE";
parameter   ES_EYE_SCAN_EN               = "TRUE";
parameter   ES_HORZ_OFFSET               = 12'h000;
parameter   ES_PMA_CFG                   = 10'b0000000000;
parameter   ES_PRESCALE                  = 5'b00000;
parameter   ES_QUALIFIER                 = 80'h00000000000000000000;
parameter   ES_QUAL_MASK                 = 80'h00000000000000000000;
parameter   ES_SDATA_MASK                = 80'h00000000000000000000;
parameter   ES_VERT_OFFSET               = 9'b000000000;

//-----------------------FPGA RX Interface Attributes-------------------------
parameter   RX_DATA_WIDTH                = 20;

//-------------------------PMA Attributes----------------------------
parameter   OUTREFCLK_SEL_INV            = 2'b11;
parameter   PMA_RSV                      = 32'h00018480;
parameter   PMA_RSV2                     = 16'h2050;
parameter   PMA_RSV3                     = 2'b00;
parameter   PMA_RSV4                     = 32'h00000000;
parameter   RX_BIAS_CFG                  = 12'b000000000100;
parameter   DMONITOR_CFG                 = 24'h000A00;
parameter   RX_CM_SEL                    = 2'b11;
parameter   RX_CM_TRIM                   = 3'b010;
parameter   RX_DEBUG_CFG                 = 12'b000000000000;
parameter   RX_OS_CFG                    = 13'b0000010000000;
parameter   TERM_RCAL_CFG                = 5'b10000;
parameter   TERM_RCAL_OVRD               = 1'b0;
parameter   TST_RSV                      = 32'h00000000;
parameter   RX_CLK25_DIV                 = 6;
parameter   TX_CLK25_DIV                 = 6;
parameter   UCODEER_CLR                  = 1'b0;

//-------------------------PCI Express Attributes----------------------------
parameter   PCS_PCIE_EN                  = "FALSE";

//-------------------------PCS Attributes----------------------------
parameter   PCS_RSVD_ATTR                = 48'h0100;

//-----------RX Buffer Attributes------------
parameter   RXBUF_ADDR_MODE              = "FAST";
parameter   RXBUF_EIDLE_HI_CNT           = 4'b1000;
parameter   RXBUF_EIDLE_LO_CNT           = 4'b0000;
parameter   RXBUF_EN                     = "TRUE";
parameter   RX_BUFFER_CFG                = 6'b000000;
parameter   RXBUF_RESET_ON_CB_CHANGE     = "TRUE";
parameter   RXBUF_RESET_ON_COMMAALIGN    = "FALSE";
parameter   RXBUF_RESET_ON_EIDLE         = "FALSE";
parameter   RXBUF_RESET_ON_RATE_CHANGE   = "TRUE";
parameter   RXBUFRESET_TIME              = 5'b00001;
parameter   RXBUF_THRESH_OVFLW           = 61;
parameter   RXBUF_THRESH_OVRD            = "FALSE";
parameter   RXBUF_THRESH_UNDFLW          = 4;
parameter   RXDLY_CFG                    = 16'h001F;
parameter   RXDLY_LCFG                   = 9'h030;
parameter   RXDLY_TAP_CFG                = 16'h0000;
parameter   RXPH_CFG                     = 24'h000000;
parameter   RXPHDLY_CFG                  = 24'h084020;
parameter   RXPH_MONITOR_SEL             = 5'b00000;
parameter   RX_XCLK_SEL                  = "RXREC";
parameter   RX_DDI_SEL                   = 6'b000000;
parameter   RX_DEFER_RESET_BUF_EN        = "TRUE";

//---------------------CDR Attributes-------------------------

//For Display Port, HBR/RBR- set RXCDR_CFG=72'h0380008bff40200008

//For Display Port, HBR2 -   set RXCDR_CFG=72'h038c008bff20200010

//For SATA Gen1 GTX- set RXCDR_CFG=72'h03_8000_8BFF_4010_0008

//For SATA Gen2 GTX- set RXCDR_CFG=72'h03_8800_8BFF_4020_0008

//For SATA Gen3 GTX- set RXCDR_CFG=72'h03_8000_8BFF_1020_0010

//For SATA Gen3 GTP- set RXCDR_CFG=83'h0_0000_87FE_2060_2444_1010

//For SATA Gen2 GTP- set RXCDR_CFG=83'h0_0000_47FE_2060_2448_1010

//For SATA Gen1 GTP- set RXCDR_CFG=83'h0_0000_47FE_1060_2448_1010
parameter   RXCDR_CFG                    = 72'h03000023ff10200020;
parameter   RXCDR_FR_RESET_ON_EIDLE      = 1'b0;
parameter   RXCDR_HOLD_DURING_EIDLE      = 1'b0;
parameter   RXCDR_PH_RESET_ON_EIDLE      = 1'b0;
parameter   RXCDR_LOCK_CFG               = 6'b010101;

//-----------------RX Initialization and Reset Attributes-------------------
parameter   RXCDRFREQRESET_TIME          = 5'b00001;
parameter   RXCDRPHRESET_TIME            = 5'b00001;
parameter   RXISCANRESET_TIME            = 5'b00001;
parameter   RXPCSRESET_TIME              = 5'b00001;
parameter   RXPMARESET_TIME              = 5'b00011;

//-----------------RX OOB Signaling Attributes-------------------
parameter   RXOOB_CFG                    = 7'b0000110;

//-----------------------RX Gearbox Attributes---------------------------
parameter   RXGEARBOX_EN                 = "FALSE";
parameter   GEARBOX_MODE                 = 3'b000;

//-----------------------PRBS Detection Attribute-----------------------
parameter   RXPRBS_ERR_LOOPBACK          = 1'b0;

//-----------Power-Down Attributes----------
parameter   PD_TRANS_TIME_FROM_P2        = 12'h03c;
parameter   PD_TRANS_TIME_NONE_P2        = 8'h3c;
parameter   PD_TRANS_TIME_TO_P2          = 8'h64;

//-----------RX OOB Signaling Attributes----------
parameter   SAS_MAX_COM                  = 64;
parameter   SAS_MIN_COM                  = 36;
parameter   SATA_BURST_SEQ_LEN           = 4'b0101;
parameter   SATA_BURST_VAL               = 3'b110;
parameter   SATA_EIDLE_VAL               = 3'b110;
parameter   SATA_MAX_BURST               = 8;
parameter   SATA_MAX_INIT                = 21;
parameter   SATA_MAX_WAKE                = 7;
parameter   SATA_MIN_BURST               = 4;
parameter   SATA_MIN_INIT                = 12;
parameter   SATA_MIN_WAKE                = 4;

//-----------RX Fabric Clock Output Control Attributes----------
parameter   TRANS_TIME_RATE              = 8'h0E;

//------------TX Buffer Attributes----------------
parameter   TXBUF_EN                     = "TRUE";
parameter   TXBUF_RESET_ON_RATE_CHANGE   = "TRUE";
parameter   TXDLY_CFG                    = 16'h001F;
parameter   TXDLY_LCFG                   = 9'h030;
parameter   TXDLY_TAP_CFG                = 16'h0000;
parameter   TXPH_CFG                     = 16'h0780;
parameter   TXPHDLY_CFG                  = 24'h084020;
parameter   TXPH_MONITOR_SEL             = 5'b00000;
parameter   TX_XCLK_SEL                  = "TXOUT";

//-----------------------FPGA TX Interface Attributes-------------------------
parameter   TX_DATA_WIDTH                = 20;

//-----------------------TX Configurable Driver Attributes-------------------------
parameter   TX_DEEMPH0                   = 5'b00000;
parameter   TX_DEEMPH1                   = 5'b00000;
parameter   TX_EIDLE_ASSERT_DELAY        = 3'b110;
parameter   TX_EIDLE_DEASSERT_DELAY      = 3'b100;
parameter   TX_LOOPBACK_DRIVE_HIZ        = "FALSE";
parameter   TX_MAINCURSOR_SEL            = 1'b0;
parameter   TX_DRIVE_MODE                = "DIRECT";
parameter   TX_MARGIN_FULL_0             = 7'b1001110;
parameter   TX_MARGIN_FULL_1             = 7'b1001001;
parameter   TX_MARGIN_FULL_2             = 7'b1000101;
parameter   TX_MARGIN_FULL_3             = 7'b1000010;
parameter   TX_MARGIN_FULL_4             = 7'b1000000;
parameter   TX_MARGIN_LOW_0              = 7'b1000110;
parameter   TX_MARGIN_LOW_1              = 7'b1000100;
parameter   TX_MARGIN_LOW_2              = 7'b1000010;
parameter   TX_MARGIN_LOW_3              = 7'b1000000;
parameter   TX_MARGIN_LOW_4              = 7'b1000000;

//-----------------------TX Gearbox Attributes--------------------------
parameter   TXGEARBOX_EN                 = "FALSE";

//-----------------------TX Initialization and Reset Attributes--------------------------
parameter   TXPCSRESET_TIME              = 5'b00001;
parameter   TXPMARESET_TIME              = 5'b00001;

//-----------------------TX Receiver Detection Attributes--------------------------
parameter   TX_RXDETECT_CFG              = 14'h1832;
parameter   TX_RXDETECT_REF              = 3'b100;

//--------------------------CPLL Attributes----------------------------
parameter   CPLL_CFG                     = 24'hBC07DC;
parameter   CPLL_FBDIV                   = 4;
parameter   CPLL_FBDIV_45                = 5;
parameter   CPLL_INIT_CFG                = 24'h00001E;
parameter   CPLL_LOCK_CFG                = 16'h01E8;
parameter   CPLL_REFCLK_DIV              = 1;
parameter   RXOUT_DIV                    = 2;
parameter   TXOUT_DIV                    = 2;
parameter   SATA_CPLL_CFG                = "VCO_3000MHZ";

//------------RX Initialization and Reset Attributes-------------
parameter   RXDFELPMRESET_TIME           = 7'b0001111;

//------------RX Equalizer Attributes-------------
parameter   RXLPM_HF_CFG                 = 14'b00000011110000;
parameter   RXLPM_LF_CFG                 = 14'b00000011110000;
parameter   RX_DFE_GAIN_CFG              = 23'h020FEA;
parameter   RX_DFE_H2_CFG                = 12'b000000000000;
parameter   RX_DFE_H3_CFG                = 12'b000001000000;
parameter   RX_DFE_H4_CFG                = 11'b00011110000;
parameter   RX_DFE_H5_CFG                = 11'b00011100000;
parameter   RX_DFE_KL_CFG                = 13'b0000011111110;
parameter   RX_DFE_LPM_CFG               = 16'h0954;
parameter   RX_DFE_LPM_HOLD_DURING_EIDLE = 1'b0;
parameter   RX_DFE_UT_CFG                = 17'b10001111000000000;
parameter   RX_DFE_VP_CFG                = 17'b00011111100000011;

//-----------------------Power-Down Attributes-------------------------
parameter   RX_CLKMUX_PD                 = 1'b1;
parameter   TX_CLKMUX_PD                 = 1'b1;

//-----------------------FPGA RX Interface Attribute-------------------------
parameter   RX_INT_DATAWIDTH             = 0;

//-----------------------FPGA TX Interface Attribute-------------------------
parameter   TX_INT_DATAWIDTH             = 0;

//----------------TX Configurable Driver Attributes---------------
parameter   TX_QPI_STATUS_EN             = 1'b0;

//-----------------------RX Equalizer Attributes--------------------------
parameter   RX_DFE_KL_CFG2               = 0;
parameter   RX_DFE_XYD_CFG               = 13'b0000000000000;

//-----------------------TX Configurable Driver Attributes--------------------------
parameter   TX_PREDRIVER_MODE            = 1'b0;

wire reset = EYESCANRESET | RXCDRFREQRESET | RXCDRRESET | RXCDRRESETRSV | RXPRBSCNTRESET | RXBUFRESET | RXDLYSRESET | RXPHDLYRESET | RXDFELPMRESET | GTRXRESET | RXOOBRESET | RXPCSRESET | RXPMARESET | CFGRESET | GTTXRESET | GTRESETSEL | RESETOVRD | TXDLYSRESET | TXPHDLYRESET | TXPCSRESET | TXPMARESET;

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

    .TXOUT_DIV              (TXOUT_DIV),
//  .TXRATE                 (TXRATE),
    .RXOUT_DIV              (RXOUT_DIV),
//  .RXRATE                 (RXRATE),

    .TX_INT_DATAWIDTH       (TX_INT_DATAWIDTH),
    .TX_DATA_WIDTH          (TX_DATA_WIDTH),

    .RX_DATA_WIDTH          (RX_DATA_WIDTH),
    .RX_INT_DATAWIDTH       (RX_INT_DATAWIDTH),
    .PRX8B10BEN             (1),

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
    .PTX8B10BEN             (1),

    .SATA_BURST_SEQ_LEN     (SATA_BURST_SEQ_LEN),
    .SATA_CPLL_CFG          (SATA_CPLL_CFG)
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

    .TXOUTCLKPMA            (TXOUTCLKPMA),
    .TXOUTCLKPCS            (TXOUTCLKPCS),
    .TXOUTCLK               (TXOUTCLK),
    .TXOUTCLKFABRIC         (TXOUTCLKFABRIC),
    .tx_serial_clk          (),

    .RXOUTCLKPMA            (RXOUTCLKPMA),
    .RXOUTCLKPCS            (RXOUTCLKPCS),
    .RXOUTCLK               (RXOUTCLK),
    .RXOUTCLKFABRIC         (RXOUTCLKFABRIC),
    .rx_serial_clk          ()
);


endmodule
            
        
