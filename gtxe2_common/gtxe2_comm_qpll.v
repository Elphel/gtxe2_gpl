`include "gtxe2_comm_qpll_def.v"
module gtxe2_comm_qpll(
// top-level interfaces
    input   wire    QPLLLOCKDETCLK, // shall not be used here
    input   wire    QPLLLOCKEN,
    input   wire    QPLLPD,
    input   wire    QPLLRESET,  // active high
    output  wire    QPLLFBCLKLOST,
    output  wire    QPLLLOCK,
    output  wire    QPLLREFCLKLOST,

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
    output  wire    pll_locked // equals QPLLLOCK
);

parameter   [23:0]  QPLL_CFG        = 27'h04801C7;
parameter   integer QPLL_FBDIV      = 10'b0000100000;
parameter   integer QPLL_FBDIV_45   = 1;
parameter   [23:0]  QPLL_INIT_CFG   = 24'h000006;
parameter   [15:0]  QPLL_LOCK_CFG   = 16'h05E8;
parameter   integer QPLL_REFCLK_DIV = 1;
parameter   integer RXOUT_DIV       = 1;
parameter   integer TXOUT_DIV       = 1;
parameter           SATA_QPLL_CFG = "VCO_3000MHZ";
parameter   [1:0]   PMA_RSV3        = 1;

localparam          multiplier  = QPLL_FBDIV * QPLL_FBDIV_45;
localparam          divider     = QPLL_REFCLK_DIV;

assign  QPLLLOCK = pll_locked;

wire    fb_clk_out;
wire    reset;
reg     mult_clk;
reg     mult_dev_clk;

assign  clk_out = mult_dev_clk;

// generate internal async reset
assign reset = QPLLPD | QPLLRESET;

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
        period      = reset ? 0 : $time - last_edge;
        last_edge   = reset ? 0 : $time;
    end
end

initial
forever @ (posedge ref_clk)
begin
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
always @ (posedge ref_clk or posedge reset)
begin
    if (locked_f == 1 && ~reset)
    begin
        #`GTXE2_COMM_QPLL_LOCK_TIME;
        locked <= 1'b1;
    end
    else
        locked <= 1'b0;
end

endmodule
