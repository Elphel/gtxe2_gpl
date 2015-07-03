`ifndef CLOCK_DIVIDER_V
`define CLOCK_DIVIDER_V
// non synthesisable!
module clock_divider(
    input   wire    clk_in,
    output  reg     clk_out,

    input   wire    [31:0]  div
);
parameter divide_by = 1;
parameter divide_by_param = 1;

reg     [31:0]  cnt = 0;

reg [31:0]  div_r;
initial
begin
    cnt = 0;
    clk_out = 1'b1;
    forever
    begin
        if (divide_by_param == 0)
        begin
            if (div > 32'h0) 
                div_r = div;
            else    
                div_r = 1;
            repeat (div_r)
                @ (clk_in);
        end
        else
        begin
            repeat (divide_by)
                @ (clk_in);
        end
        clk_out = ~clk_out;
    end
end

endmodule
`endif
