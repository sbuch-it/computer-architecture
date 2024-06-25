`timescale 1ns/1ps

module TopLevel;
  reg Ck,S,R;
  wire Q,QN;
   
  initial begin
    Ck = 0;
    #40 Ck = 1;
    #50 Ck = 0; #10 Ck = 1;
    #50 Ck = 0; #10 Ck = 1;
    #50 Ck = 0; #10 Ck = 1;
    #50 Ck = 0; #10 Ck = 1;
  end
  
  flip_flop_sr_negative_edge_triggered ff(Ck,S,R,Q,QN);
  
  initial begin
    S = 1'bx; R = 1'bx; #150
    $display("Ck = 0, S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    $display("Ck = 1, S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    $display("Ck = POS, S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    S = 0; R = 0; #50
    $display("Ck = NEG, S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    S = 0; R = 1; #50
    $display("Ck = NEG, S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    S = 1; R = 0; #50
    $display("Ck = NEG, S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    S = 1; R = 1; #50
    $display("Ck = NEG, S = %b, R = %b, Q = %b, QN = %b \n",S,R,Q,QN);
    $finish;
  end
endmodule

module flip_flop_sr_negative_edge_triggered(Ck,S,R,Q,QN);
  input Ck,S,R;
  output Q,QN; reg Q,QN;
  
  always @(negedge Ck) begin
    assign Q = ~((R & Ck) | QN);
    assign QN = ~((Ck & S) | Q);
  end
endmodule
