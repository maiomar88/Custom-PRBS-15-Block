`timescale 1ns/1ps
module PSBR_tb #(parameter patt_width = 8, patt_num = 4 ,REPEAT_TIMES = 5)();

//Testbench Signals
reg                                          clk_TB;
reg                                        arstn_TB;
reg 		                                  enable_TB;
reg  [REPEAT_TIMES-1:0]                        n_TB;
reg  [((patt_width << patt_num)/4)-1 :0] Pattern_TB;
wire                                       Valid_TB;
wire [patt_width-1:0]   	             	    byte_TB;
integer indx;
reg [patt_width-1:0] Pattern_expected [patt_num-1:0] ;

//Initial 
initial
 begin

//initialization
initialize() ;

//Reset the design
reset();
 
 //inject error
inject_error('h0D0C0B04,3);
inject_error('h0D000B04,4);

//Pattern Operations
correct_pattern ('h0D0C0B0A,5) ;    // first argument is the pattern & second argument is n-repetition
correct_pattern ('h0D0C0B0A,4) ;

repeat(100)@(negedge clk_TB) $stop ;

end

////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize ;
 begin
  clk_TB    = 1'b0 ; 
  enable_TB = 1'b0 ;
  indx      = 1'b0 ;
 end
endtask

///////////////////////// RESET /////////////////////////

task reset ;
 begin
   arstn_TB = 1'b1  ;             // rst is deactivated
  repeat(5)@(negedge clk_TB);
   arstn_TB = 1'b0  ;            // rst is activated
  repeat(5)@(negedge clk_TB);
   arstn_TB = 1'b1  ;  
 end
endtask

////////////////// PSBR Operation ////////////////////

task correct_pattern ;
input  [((patt_width << patt_num)/4)-1 :0]    Pattern ;
input  [REPEAT_TIMES-1:0]                       n ;

 begin
  enable_TB  = 1'b1;
 Pattern_TB  = Pattern;
      n_TB   = n;
  @(negedge clk_TB) enable_TB  = 1'b0 ;
  repeat((n*patt_num)+patt_num)@(negedge clk_TB);
 end
endtask

///////////////Pattern_expexted/////////////////
task inject_error;
  input  [((patt_width << patt_num)/4)-1 :0]    Pattern_expected ;
  input  [REPEAT_TIMES-1:0]                       n ;
  begin
    enable_TB   = 1'b1;
    Pattern_TB  = Pattern_expected;
    n_TB        = n;
  @(negedge clk_TB) enable_TB  = 1'b0 ;
  repeat((n*patt_num)+patt_num)@(negedge clk_TB);
  end
endtask

////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

always #5 clk_TB = ~clk_TB ;


////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////
PSBR_Top DUT (
.clk(clk_TB),
.arst_n(arstn_TB),
.enable(enable_TB),
.n(n_TB),
.Pattern(Pattern_TB),
.Valid(Valid_TB),
.byte_out(byte_TB)
);

endmodule 