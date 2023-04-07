`timescale 1ns / 1ps

module TopLevel;
  reg X1,X2,X3;
  wire Z;
  port_and port(X1,X2,X3,Z);
  
  initial begin
    X1 = 1'b0; X2 = 1'b0; X3 = 1'b0; #50
    $display("X1 = %b, X2 = %b, X3 = %b, Z = %b \n",X1,X2,X3,Z);
    X1 = 1'b0; X2 = 1'b0; X3 = 1'b1; #50
    $display("X1 = %b, X2 = %b, X3 = %b, Z = %b \n",X1,X2,X3,Z);
    X1 = 1'b0; X2 = 1'b1; X3 = 1'b0; #50
    $display("X1 = %b, X2 = %b, X3 = %b, Z = %b \n",X1,X2,X3,Z);
    X1 = 1'b0; X2 = 1'b1; X3 = 1'b1; #50
    $display("X1 = %b, X2 = %b, X3 = %b, Z = %b \n",X1,X2,X3,Z);
    X1 = 1'b1; X2 = 1'b0; X3 = 1'b0; #50
    $display("X1 = %b, X2 = %b, X3 = %b, Z = %b \n",X1,X2,X3,Z);
    X1 = 1'b1; X2 = 1'b0; X3 = 1'b1; #50
    $display("X1 = %b, X2 = %b, X3 = %b, Z = %b \n",X1,X2,X3,Z);
    X1 = 1'b1; X2 = 1'b1; X3 = 1'b0; #50
    $display("X1 = %b, X2 = %b, X3 = %b, Z = %b \n",X1,X2,X3,Z);
    X1 = 1'b1; X2 = 1'b1; X3 = 1'b1; #50
    $display("X1 = %b, X2 = %b, X3 = %b, Z = %b \n",X1,X2,X3,Z);
    $finish;
  end
endmodule

module port_and(X1,X2,X3,Z);
  input X1,X2,X3;
  output Z; wire Z;
  assign Z = ((X1 & X2) & X3);
endmodule
