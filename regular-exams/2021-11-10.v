`timescale 1s/10ms 
module TopLevel; 
  reg reset_; initial begin reset_=0; #6 reset_=1; #300; $stop; end 
  reg clock; initial clock=1; always #2.5 clock<=(!clock); 
  reg SENSOR1,SENSOR2; 
  wire[1:0] VIA1=sem.via1; 
  wire[1:0] VIA2=sem.via2; 
  wire[1:0] STAR=sem.STAR; 
  initial begin 
    SENSOR1<=0; SENSOR2<=0; #0.5 
    SENSOR1<=1; SENSOR2<=0; #10 
    SENSOR1<=1; SENSOR2<=1; #5 
    SENSOR1<=0; SENSOR2<=1; #15 
    SENSOR1<=1; SENSOR2<=0; #15 
    SENSOR1<=0; SENSOR2<=0; #5 
    $finish; 
  end    
  SEMAFORO sem(VIA1,VIA2,SENSOR1,SENSOR2,clock,reset_); 
endmodule

module SEMAFORO(via1,via2,sens1,sens2,clock,reset_);
  output[1:0] via1,via2;
  input sens1,sens2,clock,reset_;
  reg[1:0] STAR;
  
  parameter S0=0,S1=1,S2=2,S3=3;
  parameter ROSSO=0,GIALLO=1,VERDE=2;

  always @(reset_==0) #1 STAR<=S0;
  assign via1=(STAR==S0)?VERDE:(STAR==S1)?GIALLO:ROSSO;
  assign via2=(STAR==S2)?VERDE:(STAR==S3)?GIALLO:ROSSO;

  always @(posedge clock) if (reset_==1) #0.5
    casex(STAR)
      S0: STAR<=(sens1==1)?S0:S1;
      S1: STAR<=S2;
      S2: STAR<=(sens2==1)?S2:S3;
      S3: STAR<=S0;
    endcase
endmodule
