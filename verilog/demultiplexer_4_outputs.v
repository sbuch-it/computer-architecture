`timescale 1ns/1ps
module TopLevel;
  reg [63:0] X;
  reg [1:0] B;
  wire [63:0] Z0,Z1,Z2,Z3;
  demultiplexer_4_outputs demultiplexer(X,B,Z0,Z1,Z2,Z3);

  initial begin
    X = 1; B = 2'b00; #50
    $display("X = %b, B = %b, Z0 = %b, Z1 = %b, Z2 = %b, Z3 = %b \n",X,B,Z0,Z1,Z2,Z3);
    X = 2; B = 2'b01; #50
    $display("X = %b, B = %b, Z0 = %b, Z1 = %b, Z2 = %b, Z3 = %b \n",X,B,Z0,Z1,Z2,Z3);
    X = 4; B = 2'b10; #50
    $display("X = %b, B = %b, Z0 = %b, Z1 = %b, Z2 = %b, Z3 = %b \n",X,B,Z0,Z1,Z2,Z3);
    X = 8; B = 2'b11; #50
    $display("X = %b, B = %b, Z0 = %b, Z1 = %b, Z2 = %b, Z3 = %b \n",X,B,Z0,Z1,Z2,Z3);
    $finish;
  end
endmodule

module demultiplexer_4_outputs(X,B,Z0,Z1,Z2,Z3);
  input [63:0] X;
  input [1:0] B;
  output [63:0] Z0,Z1,Z2,Z3;
  reg [63:0] Z0,Z1,Z2,Z3;

  always @(X or B)
    casex(B)
      2'b00: begin Z0<=X; Z1<=0; Z2<=0; Z3<=0; end
      2'b01: begin Z0<=0; Z1<=X; Z2<=0; Z3<=0; end
      2'b10: begin Z0<=0; Z1<=0; Z2<=X; Z3<=0; end
      2'b11: begin Z0<=0; Z1<=0; Z2<=0; Z3<=X; end
      default: begin Z0<=64'bz; Z1<=64'bz; Z2<=64'bz; Z3<=64'bz; end
    endcase
endmodule
