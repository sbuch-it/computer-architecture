`timescale 1ns/1ps

module TopLevel;
  reg [1:0] IN;
  wire [3:0] OUT;
  decoder_2_bit decoder(IN,OUT);
  
  initial begin
    IN = 2'b00; #50
    $display("IN = %b, OUT = %b \n",IN,OUT);
    IN = 2'b01; #50
    $display("IN = %b, OUT = %b \n",IN,OUT);
    IN = 2'b10; #50
    $display("IN = %b, OUT = %b \n",IN,OUT);
    IN = 2'b11; #50
    $finish;
  end
endmodule

module decoder_2_bit(IN,OUT);
  input [1:0] IN;
  output [3:0] OUT; wire [3:0] OUT;
  
  assign OUT[3] = IN[1] & IN[0];
  assign OUT[2] = IN[1] & ~IN[0];
  assign OUT[1] = ~IN[1] & IN[0];
  assign OUT[0] = ~IN[1] & ~IN[0];
endmodule
