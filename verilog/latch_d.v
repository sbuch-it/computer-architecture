`timescale 1ns/1ps

module TopLevel;
  reg Ck,D;
  wire Q,QN;
  initial begin Ck = 0; #55 Ck = 1; end
  
  latch_d latch(Ck,D,Q,QN);
  
  initial begin
    D = 1'bx; #50
    $display("Ck = %b, D = %b, Q = %b, QN = %b \n",Ck,D,Q,QN);
    D = 0; #50
    $display("Ck = %b, D = %b, Q = %b, QN = %b \n",Ck,D,Q,QN);
    D = 1; #50
    $display("Ck = %b, D = %b, Q = %b, QN = %b \n",Ck,D,Q,QN);
    $finish;
  end
endmodule

module latch_d(Ck,D,Q,QN);
  input Ck,D;
  output Q,QN; reg Q,QN;

  always @(Ck == 1) begin
    assign Q = ~((~D & Ck) | QN);
    assign QN = ~((Ck & D) | Q);
  end
endmodule
