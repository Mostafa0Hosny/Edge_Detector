// Edge Detector
module Edge_Detector_Mealy_Rising_Falling (
    input  wire  CLK,
    input  wire  RST,
    input  wire  IN,
    output reg  Tic_Mealy
);

  localparam   s0 = 2'b00,
               s1 = 2'b01;

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
  Tic_Mealy=1'b0;
case(current_state)
s0:begin
     if(IN)
     begin
        next_state=s1;
        Tic_Mealy=1'b1;
     end
     else
        next_state=s0; 
    end

s1:begin
     if(IN)
     next_state=s1;
     else
     begin
      next_state=s0;
      Tic_Mealy=1'b1;
     end
   end

default:begin
       next_state=s0;
        end
 endcase   
end

endmodule