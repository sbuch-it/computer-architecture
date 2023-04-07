`timescale 1ns/1ps

module TopLevel;
  reg Ck,S,R;
  wire Q,QN;
  initial begin Ck <= 1; #200 Ck <= 0; end
  
  latch_sr_clock latch(Ck,S,R,Q,QN);
  
  initial begin
    S = 0; R = 0; #50
    $display("Ck = %b, S = %b, R = %b, Q = %b, QN = %b \n",Ck,S,R,Q,QN);
    S = 0; R = 1; #50
    $display("Ck = %b, S = %b, R = %b, Q = %b, QN = %b \n",Ck,S,R,Q,QN);
    S = 1; R = 0; #50
    $display("Ck = %b, S = %b, R = %b, Q = %b, QN = %b \n",Ck,S,R,Q,QN);
    S = 1; R = 1; #50
    $display("Ck = %b, S = %b, R = %b, Q = %b, QN = %b \n",Ck,S,R,Q,QN);
    S = 1'bx; R = 1'bx; #50
    $display("Ck = %b, S = %b, R = %b, Q = %b, QN = %b \n",Ck,S,R,Q,QN);
    $finish;
  end
endmodule

module latch_sr_clock(Ck,S,R,Q,QN);
  input Ck,S,R;
  output Q,QN; reg Q,QN;
  
  always @(Ck == 1) #1 begin
    assign Q = ~((R & Ck) | QN);
    assign QN = ~((Ck & S) | Q);
  end
endmodule
