// Edge Detector
module Edge_Detector_TB ();
    reg  CLK_tb;
    reg  RST_tb;
    reg  IN_tb;
    wire Tic_Mealy_tb;



Edge_Detector_Mealy_Falling dut(
.CLK(CLK_tb),
.RST(RST_tb),
.IN(IN_tb),
.Tic_Mealy(Tic_Mealy_tb) );


always #5 CLK_tb = ~CLK_tb ;

initial
begin

// System Functions
$dumpfile("Edge Detector.vcd") ;       
$dumpvars; 
CLK_tb = 1'b0;
IN_tb  = 1'b0;
RST_tb = 1'b0;
#5
RST_tb = 1'b1;
#5

#20 IN_tb = 1'b1;
#20 IN_tb = 1'b0;
#20 IN_tb = 1'b1;
#20 IN_tb = 1'b0;

#300
$stop;
end


endmodule