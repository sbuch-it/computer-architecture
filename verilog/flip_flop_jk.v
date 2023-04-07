`timescale 1ns/1ps

module TopLevel;
  reg Ck,reset_,J,K;
  wire Q;
  flip_flop_jk ff(Ck,reset_,J,K,Q);

  initial begin Ck=0; forever #10 Ck<=(!Ck); end
  initial begin reset_=0; #20 reset_=1; end

  initial begin
    J = 1; K = 0; #50
    $display("J = %b, K = %b, Q = %b \n",J,K,Q);
    J = 0; K = 1; #50
    $display("J = %b, K = %b, Q = %b \n",J,K,Q);
    J = 0; K = 0; #50
    $display("J = %b, K = %b, Q = %b \n",J,K,Q);
    J = 1; K = 1; #50
    $display("J = %b, K = %b, Q = %b \n",J,K,Q);
    $finish;
  end
endmodule

module flip_flop_jk(Ck,reset_,J,K,Q);
  input Ck,reset_,J,K;
  output Q; wire Q;
  reg STAR;
  parameter S0=0,S1=1;
  
  assign Q = (STAR==S0)?0:1;
  always @(reset_==0) #1 STAR<=0;
  always @(posedge Ck) if (reset_==1) #3
    casex(STAR)
      S0: STAR<=(J==1)?S1:S0;
      S1: STAR<=(K==1)?S0:S1;
    endcase
endmodule
