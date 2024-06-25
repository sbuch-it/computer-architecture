`timescale 1ns/1ps

module TopLevel;
  reg [63:0] X0,X1,X2,X3;
  reg [1:0] B;
  wire [63:0] Z;
  multiplexer_4_inputs multiplexer(X0,X1,X2,X3,B,Z);
  
  initial begin
    X0 = 1; X1 = 2; X2 = 4; X3 = 8;
    B = 2'b00; #50
    $display("X0 = %b, X1 = %b, X2 = %b, X3 = %b, B = %b, Z = %b \n",X0,X1,X2,X3,B,Z);
    B = 2'b01; #50
    $display("X0 = %b, X1 = %b, X2 = %b, X3 = %b, B = %b, Z = %b \n",X0,X1,X2,X3,B,Z);
    B = 2'b10; #50
    $display("X0 = %b, X1 = %b, X2 = %b, X3 = %b, B = %b, Z = %b \n",X0,X1,X2,X3,B,Z);
    B = 2'b11; #50
    $display("X0 = %b, X1 = %b, X2 = %b, X3 = %b, B = %b, Z = %b \n",X0,X1,X2,X3,B,Z);
    $finish;
  end
endmodule

module multiplexer_4_inputs(X0,X1,X2,X3,B,Z);
  input [63:0] X0,X1,X2,X3;
  input [1:0] B;
  output [63:0] Z; reg [63:0] Z;
  
  always @(X0 or X1 or X2 or X3 or B)
    casex(B)
      2'b00: Z <= X0;
      2'b01: Z <= X1;
      2'b10: Z <= X2;
      2'b11: Z <= X3;
      default: Z <= 64'bx;
    endcase
endmodule
