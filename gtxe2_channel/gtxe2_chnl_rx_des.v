// 20-bit width only, for now
// assuming inclk and outclk are completely aligned (have the same source)
`include "resync_fifo_nonsynt.v"
module gtxe2_chnl_rx_des #(
    parameter [31:0] width = 20
)
(
    input   wire                    reset,
    input   wire                    inclk,
    input   wire                    outclk,
    input   wire                    indata,
//    input   wire                    idle_in,
    output  wire    [width - 1:0]   outdata
//    output  wire                    idle_out
);

reg     [31:0]          bitcounter;
reg     [width - 1:0]   inbuffer;
wire                    empty_rd;
wire                    full_wr;
wire                    val_wr;
wire                    val_rd;

always @ (posedge inclk)
    bitcounter  <= reset | bitcounter == (width - 1) ? 32'h0 : bitcounter + 1'b1;

genvar ii;
generate
for (ii = 0; ii < width; ii = ii + 1)
begin: splicing
    always @ (posedge inclk)
        inbuffer[ii] <= reset ? 1'b0 : (bitcounter == ii) ? indata : inbuffer[ii];
end
endgenerate

assign  val_rd  = ~empty_rd & ~almost_empty_rd;
assign  val_wr  = ~full_wr & bitcounter == (width - 1);

always @ (posedge inclk)
    if (full_wr)
    begin
        $display("FIFO in %m is full, that is not an appropriate behaviour");
        $finish;
    end

resync_fifo_nonsynt #(
    .width      (width),
    .log_depth  (3)
)
fifo(
    .rst_rd     (reset),
    .rst_wr     (reset),
    .clk_wr     (inclk),
    .val_wr     (val_wr),
    .data_wr    ({indata, inbuffer[width - 2:0]}),
    .clk_rd     (outclk),
    .val_rd     (val_rd),
    .data_rd    (outdata),

    .empty_rd   (empty_rd),
    .full_wr    (full_wr),

    .almost_empty_rd (almost_empty_rd)
);


endmodule
