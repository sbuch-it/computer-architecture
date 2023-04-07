module TopLevel;
  reg[2:0] A, B;
  wire[2:0] S;
  reg CI;
  wire CO;
  
  initial begin CI<=1; 
    A<=6; B<=1; #20 
    A<=5; B<=3; #20 
    A<=4; B<=6; #20 
    A<=7; B<=7; #20 
    $finish;
  end 
  RC_SUBTRACTOR rcs(A, B, CI, S, CO);
endmodule

module FULL_SUB(a, b, ci, s, c); 
  input a, b, ci;
  output s, c;
  assign s = (a ^ (~b ^ ci)); // s = a XOR NOT(b) XOR ci
  assign c = (a & (~b)) | (ci & (a | (~b)));
  // c = (a AND NOT(b)) + (ci AND (a + NOT(b)))
endmodule

module RC_SUBTRACTOR(A, B, CI, S, CO); 
  input [2:0] A, B;
  input CI;
  output [2:0] S;
  output CO;
  wire [2:0] C;
  assign CO = C[2];
  
  FULL_SUB s0(A[0], B[0], CI, S[0], C[0]);
  FULL_SUB s1(A[1], B[1], C[0], S[1], C[1]);
  FULL_SUB s2(A[2], B[2], C[1], S[2], C[2]);
endmodule
