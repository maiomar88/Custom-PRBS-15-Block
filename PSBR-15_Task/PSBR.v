module PSBR #(parameter patt_width = 8, patt_num = 4 ,REPEAT_TIMES = 5)  //ABCD <=4 , A=8'h
	

(
	input wire 		                                 arst_n,
	input wire 		                                    clk,
	input wire 		                                 enable,
	input wire  [REPEAT_TIMES-1:0]                      n,
	input wire  [((patt_width << patt_num)/4)-1 :0]   Pattern,
	output reg  [patt_width-1:0]  			         byte_out
);


integer I ;
reg [patt_width-1:0] pattArr [patt_num-1:0] ;   
reg [REPEAT_TIMES-1:0] N_count ;
reg [REPEAT_TIMES-1:0] byte_count;        

//regestering pattArr
always @(posedge clk,negedge arst_n) begin

	if (!arst_n) begin

		for (I=0 ; I < patt_num ; I = I +1)
        begin
          pattArr[I] <= 0 ;
        end
	end

 //filling the paatern array with the pattern with +: operator used when it a variable part selsection (synth)

	else  begin
		 for (I = 0; I < patt_num; I = I + 1) begin
            pattArr[I] <= Pattern[patt_width*I +: patt_width];
            
        end	
	end
end

//setting byte out 

always @(posedge clk or negedge arst_n ) begin 
	if(!arst_n)
              byte_out <=0 ;
 else if(enable) begin
              N_count    <= n ;
              byte_count <= 0 ;
	end else if (N_count == 0)    //shifting the bits left and XORing bit 13 and bit 14 for feedback in PSBR.
             byte_out = {pattArr[0][patt_width - 2:0], Pattern[13]^Pattern[14]} ;
	else begin
		   if(byte_count==patt_num) begin
		   	    N_count    <= N_count-1;
            byte_count <= 1;
			      byte_out   <= pattArr[0];
			       
        end else  begin
          	 byte_out     <= pattArr[byte_count] ;
		       	 byte_count   <= byte_count+1;
    end
	end
	
end

endmodule 