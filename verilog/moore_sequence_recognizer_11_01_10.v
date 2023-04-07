`timescale 1ns/1ps

module TopLevel;
  reg Ck,reset_;
  reg [1:0] X;
  wire Z;
  
  initial begin Ck=0; forever #10 Ck<=(!Ck); end
  initial begin reset_=0; #10 reset_=1; #200 reset_=0; end
  
  moore_sequence_recognizer_11_01_10 moore(Ck,reset_,X,Z);
  
  initial begin
  X = 2'b00; #20 X = 2'b11; #20 X = 2'b01; #20 X = 2'b10; #20
  X = 2'b00; #20 X = 2'b11; #20 X = 2'b11; #20 X = 2'b01; #20
  X = 2'b10; #20 X = 2'b11; #20 X = 2'b10; #20 X = 2'b01; #20
  $finish;
  end
  
endmodule

module moore_sequence_recognizer_11_01_10(Ck,reset_,X,Z);
  input [1:0] X;
  input Ck,reset_;
  output Z; wire Z;
  reg [1:0] STAR;
  parameter S0=2'b00,S1=2'b01,S2=2'b10,S3=2'b11;
  
  always @(reset_==0) #1 STAR<=S0;
  assign Z = (STAR==S3)?1:0;

  always @(posedge Ck) if (reset_==1) #3
    casex(STAR)
      S0: STAR<=(X==2'b11)?S1:S0;
      S1: STAR<=(X==2'b01)?S2:(X==2'b11)?S1:S0;
      S2: STAR<=(X==2'b10)?S3:(X==2'b11)?S1:S0;
      S3: STAR<=(X==2'b11)?S1:S0;
    endcase
endmodule
