`include "gtxe2_comm_qpll_inmux.v"
`include "gtxe2_comm_qpll.v"
module gtxe2_comm_clocking(
// top-level interfaces
    input   wire    [2:0]   QPLLREFCLKSEL,
    input   wire            GTREFCLK0,
    input   wire            GTREFCLK1,
    input   wire            GTNORTHREFCLK0,
    input   wire            GTNORTHREFCLK1,
    input   wire            GTSOUTHREFCLK0,
    input   wire            GTSOUTHREFCLK1,
    input   wire            GTGREFCLK,
    output  wire            QPLLOUTCLK,
    output  wire            QPLLOUTREFCLK,
    output  wire            REFCLKOUTMONITOR,
    
    input   wire            QPLLLOCKDETCLK, 
    input   wire            QPLLLOCKEN,
    input   wire            QPLLPD,
    input   wire            QPLLRESET,
    output  wire            QPLLFBCLKLOST,
    output  wire            QPLLLOCK,
    output  wire            QPLLREFCLKLOST
);

wire    clk_mux_out;
wire    qpll_clk_out; //TODO

assign  REFCLKOUTMONITOR = clk_mux_out;
assign  QPLLOUTREFCLK = clk_mux_out;
assign  QPLLOUTCLK = qpll_clk_out;




gtxe2_comm_qpll_inmux clk_mux(
    .QPLLREFCLKSEL      (QPLLREFCLKSEL),

    .GTREFCLK0          (GTREFCLK0),
    .GTREFCLK1          (GTREFCLK1),
    .GTNORTHREFCLK0     (GTNORTHREFCLK0),
    .GTNORTHREFCLK1     (GTNORTHREFCLK1),
    .GTSOUTHREFCLK0     (GTSOUTHREFCLK0),
    .GTSOUTHREFCLK1     (GTSOUTHREFCLK1),
    .GTGREFCLK          (GTGREFCLK),

    .QPLL_MUX_CLK_OUT   (clk_mux_out)
);

gtxe2_comm_qpll qpll(
    .QPLLLOCKDETCLK     (QPLLLOCKDETCLK),
    .QPLLLOCKEN         (QPLLLOCKEN),
    .QPLLPD             (QPLLPD),
    .QPLLRESET          (QPLLRESET),
    .QPLLFBCLKLOST      (QPLLFBCLKLOST),
    .QPLLLOCK           (QPLLLOCK),
    .QPLLREFCLKLOST     (QPLLREFCLKLOST),
    
    .GTRSVD             (GTRSVD),
    .PCSRSVDIN          (PCSRSVDIN),
    .PCSRSVDIN2         (PCSRSVDIN2),
    .PMARSVDIN          (PMARSVDIN),
    .PMARSVDIN2         (PMARSVDIN2),
    .TSTIN              (TSTIN),
    .TSTOUT             (TSTOUT),
    
    .ref_clk            (clk_mux_out),
    .clk_out            (qpll_clk_out),
    .pll_locked         (pll_locked)
);

endmodule
