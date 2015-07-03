module gtxe2_comm_qpll_inmux(
    input   wire    [2:0]   QPLLREFCLKSEL,
    input   wire            GTREFCLK0,
    input   wire            GTREFCLK1,
    input   wire            GTNORTHREFCLK0,
    input   wire            GTNORTHREFCLK1,
    input   wire            GTSOUTHREFCLK0,
    input   wire            GTSOUTHREFCLK1,
    input   wire            GTGREFCLK,
    output  wire            QPLL_MUX_CLK_OUT
);

// clock multiplexer - pre-syntesis simulation only
assign QPLL_MUX_CLK_OUT = QPLLREFCLKSEL == 3'b000 ?     1'b0 // reserved
                        : QPLLREFCLKSEL == 3'b001 ?     GTREFCLK0
                        : QPLLREFCLKSEL == 3'b010 ?     GTREFCLK1
                        : QPLLREFCLKSEL == 3'b011 ?     GTNORTHREFCLK0
                        : QPLLREFCLKSEL == 3'b100 ?     GTNORTHREFCLK1
                        : QPLLREFCLKSEL == 3'b101 ?     GTSOUTHREFCLK0
                        : QPLLREFCLKSEL == 3'b110 ?     GTSOUTHREFCLK1
                        : /*CPLLREFCLKSEL == 3'b111 ?*/ GTGREFCLK;

endmodule

