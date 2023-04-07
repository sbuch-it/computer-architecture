`timescale 1ns/1ps

module TopLevel;
  reg A,B;
  wire Sum,Carry;
  half_adder_1_bit half_adder(A,B,Sum,Carry);

  initial begin
    A = 0; B = 0; #50
    $display("A = %b, B = %b, Sum = %b, Carry = %b \n",A,B,Sum,Carry);
    A = 0; B = 1; #50
    $display("A = %b, B = %b, Sum = %b, Carry = %b \n",A,B,Sum,Carry);
    A = 1; B = 0; #50
    $display("A = %b, B = %b, Sum = %b, Carry = %b \n",A,B,Sum,Carry);
    A = 1; B = 1; #50
    $display("A = %b, B = %b, Sum = %b, Carry = %b \n",A,B,Sum,Carry);
    $finish;
  end
endmodule

module half_adder_1_bit(A,B,Sum,Carry);
  input A,B;
  output Sum,Carry; wire Sum,Carry;

  assign Sum = A ^ B;
  assign Carry = A & B;
endmodule
