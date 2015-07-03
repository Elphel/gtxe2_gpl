module gtxe2_chnl_outclk_mux(
    input   wire            TXPLLREFCLK_DIV1,
    input   wire            TXPLLREFCLK_DIV2,
    input   wire            TXOUTCLKPMA,
    input   wire            TXOUTCLKPCS,
    input   wire    [2:0]   TXOUTCLKSEL,
    input   wire            TXDLYBYPASS,
    output  wire            TXOUTCLK
);

assign  TXOUTCLK    = TXOUTCLKSEL == 3'b001 ? TXOUTCLKPCS                       
                    : TXOUTCLKSEL == 3'b010 ? TXOUTCLKPMA                      
                    : TXOUTCLKSEL == 3'b011 ? TXPLLREFCLK_DIV1                           
                    : TXOUTCLKSEL == 3'b100 ? TXPLLREFCLK_DIV2
                    : /* 3'b000 */            1'b1; 
endmodule
