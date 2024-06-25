`timescale 1ns/1ps

module TopLevel;
  reg Ck,reset_,T;
  reg [3:0] Q;
  
  initial begin Ck=0; forever #10 Ck <= (!Ck); end
  initial begin reset_=0; #20 reset_=1; #330 reset_=0; end
  
  initial begin
    $display("time, \t Ck, \t reset_, \t QQQQ");
    $monitor("%g, \t %b, \t %b, \t %b",$time,Ck,reset_,Q);
    T=1; #400
    $finish;
  end

  serial_carry_counter counter(Ck,reset_,T,Q);
endmodule

module FFTnc(Ck,reset_,T,Q,C);
  input Ck,reset_,T;
  output Q,C; wire Q,C;
  reg STAR;
  parameter S0=0,S1=1;

  assign Q = (STAR==S0)?0:1;
  assign C = T & Q;
  always @(reset_==0) #1 STAR <= S0;
  always @(negedge Ck) if (reset_==1) #3
    casex(STAR)
      S0: STAR<=(T==0)?S0:S1;
      S1: STAR<=(T==0)?S1:S0;
    endcase
endmodule

module serial_carry_counter(Ck,reset_,T,Q);
  input Ck,reset_,T;
  output[3:0] Q; reg[3:0] Q;
  wire Q0,Q1,Q2,Q3,C0,C1,C2,C3;
  
  FFTnc ff0(Ck,reset_,T,Q0,C0);
  FFTnc ff1(Ck,reset_,C0,Q1,C1);
  FFTnc ff2(Ck,reset_,C1,Q2,C2);
  FFTnc ff3(Ck,reset_,C2,Q3,C3);
  
  always @(negedge Ck)
    begin Q[0]<=Q0; Q[1]<=Q1; Q[2]<=Q2; Q[3]<=Q3; end
endmodule
