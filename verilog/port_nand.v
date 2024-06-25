`timescale 1ns / 1ps

module TopLevel;
  reg X1,X2;
  wire Z;
  port_nand port(X1,X2,Z);
  
  initial begin
    X1 = 1'b0; X2 = 1'b0; #50
    $display("X1 = %b, X2 = %b, Z = %b \n",X1,X2,Z);
    X1 = 1'b0; X2 = 1'b1; #50
    $display("X1 = %b, X2 = %b, Z = %b \n",X1,X2,Z);
    X1 = 1'b1; X2 = 1'b0; #50
    $display("X1 = %b, X2 = %b, Z = %b \n",X1,X2,Z);
    X1 = 1'b1; X2 = 1'b1; #50
    $display("X1 = %b, X2 = %b, Z = %b \n",X1,X2,Z);
    $finish;
    end
endmodule

module port_nand(X1,X2,Z);
    input X1,X2;
    output Z; wire Z;
    assign Z = ~(X1 & X2);
endmodule
