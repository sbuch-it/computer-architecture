`timescale 1ns/1ps

module TopLevel;
  reg Ck,reset_,T;
  wire Q;
  
  initial begin Ck = 0; forever #10 Ck <= (!Ck); end
  initial begin reset_=0; #10 reset_=1; #250 reset_=0; end
  initial begin
    T=0; #20 T=1; #20 T=0; #20 T=1; #20 T=0; #20 T=1; #20 T=0;
    #100 T=1; #20 T=0; #20 T=1; #20 T=0; #20 T=1; #20 T=0;
    $finish;
  end

  flip_flop_t ff(Ck,reset_,T,Q);
endmodule

module flip_flop_t(Ck,reset_,T,Q);
  input Ck,reset_,T;
  output Q; wire Q;
  reg STAR;
  parameter S0=0,S1=1;

  assign Q = (STAR==S0)?0:1;
  always @(reset_==0) #1 STAR <= S0;
  always @(posedge Ck) if (reset_==1) #3
    casex(STAR)
      S0: STAR<=(T==0)?S0:S1;
      S1: STAR<=(T==0)?S1:S0;
    endcase
endmodule
