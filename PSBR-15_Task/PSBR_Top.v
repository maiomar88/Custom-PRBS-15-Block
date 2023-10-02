module PSBR_Top #(parameter patt_width = 8, patt_num = 4 ,REPEAT_TIMES = 5)
	(
	input wire 		                             arst_n,
	input wire 		                                clk,
	input wire 		                             enable,
	input wire  [REPEAT_TIMES-1:0]                    n,
	input wire  [((patt_width << patt_num)/4)-1 :0]   Pattern,
	output wire                                    Valid,
	output wire  [patt_width-1:0]   	    	   byte_out
);   

  

////////////////////////////////////////////////////////
/////////////////// PSBR Instantation //////////////////
////////////////////////////////////////////////////////

PSBR  PSBR_Inst(.clk(clk),.arst_n(arst_n),.enable(enable),.n(n),.Pattern(Pattern),.byte_out(byte_out));

////////////////////////////////////////////////////////
///////////////////pattern_detector  Instantation///////
////////////////////////////////////////////////////////

pattern_detector pattern_detct_Inst(.clk(clk),.arst_n(arst_n),.byte_out(byte_out),.Valid(Valid),.n(n) );

endmodule 