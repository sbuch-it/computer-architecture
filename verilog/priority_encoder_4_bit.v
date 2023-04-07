`timescale 1ns/1ps

module TopLevel;
  reg [3:0] D;
  wire [1:0] A;
  wire V;
  priority_encoder_4_bit priority_encoder(D,A,V);

  initial begin
    D = 4'b0000; #50
    $display("D = %b, A = %b, V = %b \n",D,A,V);
    D = 4'b0001; #50
    $display("D = %b, A = %b, V = %b \n",D,A,V);
    D = 4'b001x; #50
    $display("D = %b, A = %b, V = %b \n",D,A,V);
    D = 4'b01xx; #50
    $display("D = %b, A = %b, V = %b \n",D,A,V);
    D = 4'b1xxx; #50
    $display("D = %b, A = %b, V = %b \n",D,A,V);
    $finish;
  end
endmodule

module priority_encoder_4_bit(D,A,V);
  input [3:0] D;
  output [1:0] A; wire [1:0] A;
  output V; wire V;
  
  assign A[1] = (D[2] | D[3]);
  assign A[0] = D[3] | (D[1] & ~D[2]);
  assign V = (D[0] | D[1]) | (D[2] | D[3]);
endmodule
