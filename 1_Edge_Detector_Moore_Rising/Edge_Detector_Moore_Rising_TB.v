// Edge Detector
module Edge_Detector_TB ();
    reg  CLK_tb;
    reg  RST_tb;
    reg  IN_tb;
    wire Tic_Moore_tb;
/*
Edge_Detector_Moore_Rising dut(
.CLK(CLK_tb),
.RST(RST_tb),
.IN(IN_tb),
.Tic_Moore(Tic_Moore_tb) );
*/

Edge_Detector_Moore_Falling dut(
.CLK(CLK_tb),
.RST(RST_tb),
.IN(IN_tb),
.Tic_Moore(Tic_Moore_tb) );


/*
Edge_Detector_Mealy_Rising dut(
.CLK(CLK_tb),
.RST(RST_tb),
.IN(IN_tb),
.Tic_Moore(Tic_Moore_tb) );
*/

/*
Edge_Detector_Mealy_Falling dut(
.CLK(CLK_tb),
.RST(RST_tb),
.IN(IN_tb),
.Tic_Moore(Tic_Moore_tb) );
*/

/*
Edge_Detector_Moore_Rising_Falling dut(
.CLK(CLK_tb),
.RST(RST_tb),
.IN(IN_tb),
.Tic_Moore(Tic_Moore_tb) );
*/

/*
Edge_Detector_Mealy_Rising_Falling dut(
.CLK(CLK_tb),
.RST(RST_tb),
.IN(IN_tb),
.Tic_Moore(Tic_Moore_tb) );
*/

always #5 CLK_tb = ~CLK_tb ;

initial
begin

 // System Functions
 $dumpfile("Edge Detector.vcd") ;       
 $dumpvars; 
CLK_tb = 1'b0;
RST_tb = 1'b0;
IN_tb  = 1'b0;
#10
RST_tb = 1'b1;

IN_tb = 1'b0;
#10 IN_tb = 1'b1;
#15 IN_tb = 1'b0;
#10 IN_tb = 1'b1;
#10 IN_tb = 1'b0;

#300
$stop;
end


endmodule