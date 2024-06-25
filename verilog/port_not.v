`timescale 1ns / 1ps

module TopLevel;
  reg X;
  wire Z;
  port_not port(X,Z);

  initial begin
    X = 1'b0; #50
    $display("X = %b, Z = %b \n",X,Z);
    X = 1'b1; #50
    $display("X = %b, Z = %b \n",X,Z);
    $finish;
  end
endmodule

module port_not(X,Z);
  input X;
  output Z; wire Z;
  assign Z = ~X;
endmodule
