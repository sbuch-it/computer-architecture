`timescale 1ns/1ps

module TopLevel;
  reg Ck,D;
  wire Q,QN;
   
  initial begin
    Ck = 0;
    #40 Ck = 1; #10
    #40 Ck = 1; #10 Ck = 0;
    #40 Ck = 0; #10 Ck = 1;
    #40 Ck = 0; #10 Ck = 1;
  end
   
  flip_flop_d_positive_edge_triggered latch(Ck,D,Q,QN);
  
  initial begin
    D = 1'bx; #150
    $display("Ck = 0, D = %b, Q = %b, QN = %b \n",D,Q,QN);
    $display("Ck = 1, D = %b, Q = %b, QN = %b \n",D,Q,QN);
    $display("Ck = NEG, D = %b, Q = %b, QN = %b \n",D,Q,QN);
    D = 0; #50
    $display("Ck = POS, D = %b, Q = %b, QN = %b \n",D,Q,QN);
    D = 1; #50
    $display("Ck = POS, D = %b, Q = %b, QN = %b \n",D,Q,QN);
    $finish;
  end
endmodule

module flip_flop_d_positive_edge_triggered(Ck,D,Q,QN);
  input Ck,D;
  output Q,QN; reg Q,QN;

  always @(posedge Ck) begin
    assign Q = ~((~D & Ck) | QN);
    assign QN = ~((Ck & D) | Q);
  end
endmodule
