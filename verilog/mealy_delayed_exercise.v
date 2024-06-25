`timescale 1ns/1ps

module TopLevel;
  reg Ck,reset_,X;
  wire Z1 = xxx.Z[1];
  wire Z0 = xxx.Z[0];

  initial begin reset_=0; #22 reset_=1; #400; end
  initial begin Ck=0; forever #5 Ck <=(!Ck); end
  
  initial begin X=0;
    wait(reset_==1); #5
    @(posedge Ck); X<=1; @(posedge Ck); X<=1; @(posedge Ck); X<=0; @(posedge Ck); X<=0;
    @(posedge Ck); X<=0; @(posedge Ck); X<=0; @(posedge Ck); X<=0; @(posedge Ck); X<=0;
    @(posedge Ck); X<=1; @(posedge Ck); X<=1; @(posedge Ck); X<=0; @(posedge Ck); X<=0;
    @(posedge Ck); X<=0; @(posedge Ck); X<=1; @(posedge Ck); X<=0; @(posedge Ck); X<=1;
    @(posedge Ck); X<=0; @(posedge Ck); X<=0; @(posedge Ck); X<=0; @(posedge Ck); X<=0;
    $finish;
  end
  XXX xxx(Ck,reset_,X,Z);
endmodule

module XXX(Ck,reset_,X,Z);
  input Ck,reset_,X;
  output[1:0] Z; wire [1:0] Z;
  reg[1:0] OUTR;
  reg[2:0] STAR;
  parameter S0=3'b000,S1=3'b0001,S2=3'b011,S3=3'b010,S4=3'b100,S5=3'b101,S6=3'b111;

  always @(reset_==0) #1 begin STAR<=S0; OUTR<=0; end
  assign Z = OUTR;

  always @(posedge Ck) if(reset_==1) #3
    casex(STAR)
      S0:begin STAR<=(X==0)?S4:S1; OUTR<=0; end
      S1:begin STAR<=(X==0)?S4:S2; OUTR<=0; end
      S2:begin STAR<=(X==0)?S3:S2; OUTR<=0; end
      S3:begin STAR<=(X==0)?S0:S5; OUTR<=(X==0)?2'b11:2'b00; end
      S4:begin STAR<=(X==0)?S4:S5; OUTR<=0; end
      S5:begin STAR<=(X==0)?S6:S2; OUTR<=0; end
      S6:begin STAR<=(X==0)?S4:S0; OUTR<=(X==1)?2'b10:2'b00; end
    endcase
endmodule
