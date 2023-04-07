`timescale 1ns/1ps

module TopLevel;
  reg A,B,CarryIn;
  wire Sum,CarryOut;
  full_adder_1_bit full_adder(A,B,CarryIn,Sum,CarryOut);

  initial begin
    A = 0; B = 0; CarryIn = 0; #50
    $display("A = %b, B = %b, CarryIn = %b, Sum = %b, CarryOut = %b \n",A,B,CarryIn,Sum,CarryOut);
    A = 0; B = 0; CarryIn = 1; #50
    $display("A = %b, B = %b, CarryIn = %b, Sum = %b, CarryOut = %b \n",A,B,CarryIn,Sum,CarryOut);
    A = 0; B = 1; CarryIn = 0; #50
    $display("A = %b, B = %b, CarryIn = %b, Sum = %b, CarryOut = %b \n",A,B,CarryIn,Sum,CarryOut);
    A = 0; B = 1; CarryIn = 1; #50
    $display("A = %b, B = %b, CarryIn = %b, Sum = %b, CarryOut = %b \n",A,B,CarryIn,Sum,CarryOut);
    A = 1; B = 0; CarryIn = 0; #50
    $display("A = %b, B = %b, CarryIn = %b, Sum = %b, CarryOut = %b \n",A,B,CarryIn,Sum,CarryOut);
    A = 1; B = 0; CarryIn = 1; #50
    $display("A = %b, B = %b, CarryIn = %b, Sum = %b, CarryOut = %b \n",A,B,CarryIn,Sum,CarryOut);
    A = 1; B = 1; CarryIn = 0; #50
    $display("A = %b, B = %b, CarryIn = %b, Sum = %b, CarryOut = %b \n",A,B,CarryIn,Sum,CarryOut);
    A = 1; B = 1; CarryIn = 1; #50
    $display("A = %b, B = %b, CarryIn = %b, Sum = %b, CarryOut = %b \n",A,B,CarryIn,Sum,CarryOut);
    $finish;
  end
endmodule

module full_adder_1_bit(A,B,CarryIn,Sum,CarryOut);
    input A,B,CarryIn;
    output Sum,CarryOut; wire Sum,CarryOut;
    assign Sum = A ^ (B ^ CarryIn);
    assign CarryOut = (A & B) | (CarryIn & (A | B));
endmodule
