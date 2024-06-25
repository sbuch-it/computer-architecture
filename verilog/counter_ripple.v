`timescale 1ns/1ps

module TopLevel;
  reg Ck,reset_,T;
  wire [3:0] Q;
  
  initial begin Ck=0; forever #10 Ck <= (!Ck); end
  initial begin reset_=0; #20 reset_=1; #330 reset_=0; end
  
  initial begin
    $display("time, \t Ck, \t reset_, \t QQQQ");
    $monitor("%g, \t %b, \t %b, \t %b",$time,Ck,reset_,Q);
    T=1; #400
    $finish;
  end
  ripple_counter counter(Ck,reset_,T,Q);
endmodule

module FFTn(Ck,reset_,T,Q);
  input Ck,reset_,T;
  output Q; wire Q;
  reg STAR;
  parameter S0=0,S1=1;
  
  assign Q = (STAR==S0)?0:1;
  always @(reset_==0) #1 STAR <= S0;
  always @(negedge Ck) if (reset_==1) #3
    casex(STAR)
      S0: STAR<=(T==0)?S0:S1;
      S1: STAR<=(T==0)?S1:S0;
    endcase
endmodule

module ripple_counter(Ck,reset_,T,Q);
  input Ck,reset_,T;
  output[3:0] Q; reg[3:0] Q;
  wire Q0,Q1,Q2,Q3;
  
  FFTn rc0(Ck,reset_,T,Q0);
  FFTn rc1(Q0,reset_,T,Q1);
  FFTn rc2(Q1,reset_,T,Q2);
  FFTn rc3(Q2,reset_,T,Q3);
  
  always @(negedge Ck)
    begin Q[0]<=Q0; Q[1]<=Q1; Q[2]<=Q2; Q[3]<=Q3; end
endmodule
