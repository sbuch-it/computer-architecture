`timescale 1ns/1ps

module TopLevel;
  reg reset_; initial begin reset_=0;  #1 reset_=1; #350; $stop; end 
  reg clock1; initial clock1 =0; always #5 clock1 <=(!clock1);  
  reg clock2; initial clock2 =0; always #2 clock2 <=(!clock2);  
  wire[2:0] X,Y; 
  wire rfd, dav_; 
  wire[1:0]out; wire done; 
  wire[1:0] STAR=Xxx.STAR; 
  Consumatore Xxx(dav_,X,Y,rfd,out,done,clock1,reset_);  
  Produttore  PRO(rfd,dav_,X,Y,clock2,reset_); 
endmodule

module Produttore(rfd, dav_,X,Y, clock,reset_); 
  input rfd, clock,reset_; 
  output dav_; 
  output [2:0] X,Y;  
  reg DAV_;
  assign dav_ = DAV_;  
  reg [2:0] APP1_X,APP1_Y,APP2_X,APP2_Y;
  assign X=APP1_X, Y=APP1_Y; 
  reg [1:0] STAR;
  parameter S0=0, S1=1, S2=2; 
 
  always @(reset_==0) begin APP2_X<='B111; APP2_Y<=001; DAV_<=1; STAR<=S0; end 
 
  always @(posedge clock) if (reset_==1) #0.2 
    casex (STAR) 
      S0: begin DAV_=1; APP1_X<=APP2_X; APP1_Y<=APP2_Y; STAR<=(rfd==1)?S1:S0; end 
      S1: begin DAV_=0; APP2_X<=APP1_X+1; APP2_Y<=APP1_Y+1; STAR<=S2; end 
      S2: begin STAR<=(rfd==1)?S2:S0;end 
    endcase 
endmodule

module Consumatore(dav_,X,Y, rfd,out,done, clock,reset_); 
  input clock, reset_; 
  output [1:0] out; 
  output rfd,done; 
  input dav_; 
  input [2:0] X,Y; 
  reg [1:0] OUTR;
  assign out = OUTR; 
  reg RFD,DONE;
  assign rfd = RFD, done = DONE; 
  reg [1:0] STAR;
  parameter S0=0, S1=1, S2=2; 
 
  function [1:0] quadrant; 
    input [2:0] x,y; 
    quadrant = {x[2],~y[2]}; 
  endfunction 
 
  always @(reset_==0) begin DONE<=0; RFD<=1; STAR<=S0; end 
 
  always @(posedge clock) if(reset_==1) #3 
    casex (STAR) 
      S0: begin RFD<=1; STAR<=(dav_==1)?S0:S1; end 
      S1: begin RFD<=0; OUTR<=quadrant(X,Y);DONE<=1; STAR<=S2; end  
      S2: begin DONE<=0; STAR<=(dav_==0)?S2:S0; end 
    endcase 
endmodule
