// Edge Detector
module Edge_Detector_Moore_Falling (
    input  wire  CLK,
    input  wire  RST,
    input  wire  IN,
    output reg  Tic_Moore
);

  localparam   s0 = 2'b00,
               s1 = 2'b01,
               s2 = 2'b11;

reg [1:0] current_state, next_state;

always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      current_state <= s0;
    else 
      current_state <= next_state;
  end

always @(*)
  begin
  Tic_Moore=1'b0;
case(current_state)
s0:begin
     if(IN)
        next_state=s1;
     else
        next_state=s0; 
    end

s1:begin
     if(IN)
     next_state=s1;
     else 
     next_state=s2;
   end

s2:begin
   Tic_Moore=1'b1;
      if(IN)
          next_state=s1;
      else
          next_state=s0;
   end
default:begin
       next_state=s0;
        end
 endcase   
end

endmodule