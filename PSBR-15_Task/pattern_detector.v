

module pattern_detector  #( parameter REPEAT_TIMES = 5 , patt_width = 8)
 
(
 input   wire                                    clk,
 input   wire                                 arst_n,
 input   wire [patt_width-1:0]              byte_out, 
 input   wire [REPEAT_TIMES-1:0]                   n, 
 output  reg                                    Valid
);

//  state encoding
parameter   [2:0]      IDLE   = 3'b000,
                  A_State     = 3'b001,
					        B_State     = 3'b010,
					        C_State     = 3'b011, 
					        D_State     = 3'b100,
                  Rand_gen    = 3'b101,
                  Err_State   = 3'b110;
             

reg         [2:0]      current_state , next_state ;
reg                     Valid_comb   , error_flag  ;
reg [REPEAT_TIMES-1:0] count ;		
			
//state transiton 
always @ (posedge clk or negedge arst_n)
 begin
  if(!arst_n)
   begin
    current_state <= IDLE ;
   end
  else
   begin
    current_state <= next_state ;
   end
 end
 

// next state logic
always @ (*)
 begin
  error_flag     = 1'b0;
  Valid_comb     = 1'b0;
  case(current_state)
  IDLE   : begin
            if(byte_out == 8'h0A)
			 next_state = A_State ;
			else
			 next_state = Err_State ; 			
           end
  A_State  : begin
            if(byte_out == 8'h0B)
       next_state = B_State ;
      else
       next_state = Err_State ;      
           end
  B_State  : begin
            if(byte_out == 8'h0C)
       next_state = C_State ;
      else
       next_state = Err_State;      
           end
 C_State : begin
            if(byte_out == 8'h0D)
       next_state = D_State ;
      else
       next_state = Err_State ;      
           end
  D_State   : begin

          if(count == REPEAT_TIMES-1) 
          begin
                next_state = Rand_gen;  
           end
        else if(byte_out == 8'h0A)

                next_state = A_State ;
      else
       next_state = Err_State ; 

      end
Err_State: begin
         error_flag = 1'b1;
         next_state = IDLE ; 
end
Rand_gen: begin
         Valid_comb = 1'b1 ;
         next_state = IDLE ; 
end
  default: begin
			 next_state = IDLE ; 
           end	
  endcase                 	   
 end  


always @ (posedge clk or negedge arst_n) begin
  if(!arst_n)
               count  <= 0;
   else if (current_state == D_State)
               count  <= count +1;
   else if(current_state == IDLE)
               count  <= 0;
   end

//register output 
always @ (posedge clk or negedge arst_n)
 begin
  if(!arst_n)
   begin
    Valid <= 1'b0 ;
   end
  else
   begin
    Valid <= Valid_comb ;
   end
 end
  

endmodule
 
