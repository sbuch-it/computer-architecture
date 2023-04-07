`timescale 1ns/1ps

module TopLevel;
  reg [3:0] IN;
  wire [1:0] OUT;
  encoder_4_bit encoder(IN,OUT);

  initial begin
    IN = 4'b0001; #50
    $display("IN = %b, OUT = %b \n",IN,OUT);
    IN = 4'b0010; #50
    $display("IN = %b, OUT = %b \n",IN,OUT);
    IN = 4'b0100; #50
    $display("IN = %b, OUT = %b \n",IN,OUT);
    IN = 4'b1000; #50
    $display("IN = %b, OUT = %b \n",IN,OUT);
    $finish;
  end
endmodule

module encoder_4_bit(IN,OUT);
  input [3:0] IN;
  output [1:0] OUT; wire [1:0] OUT;
  
  assign OUT[0] = IN[1] | IN[3];
  assign OUT[1] = IN[2] | IN[3];
endmodule
