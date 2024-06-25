`timescale 1ns/1ps

module cpu_testbench;
  reg reset_;
  initial begin reset_=0; #22 reset_=1; #400; $stop; end
  reg clock; initial clock=0; always #5 clock<=(!clock);
  wire[63:0] PC;
  wire[11:0] IMM;
  wire[31:0] IR;
  wire[6:0]OPCODE, FUNCT7;
  wire[2:0] FUNCT3,ALUCTRL;
  wire[4:0] RD, RS1, RS2;
  wire[1:0] ALUOP;
  assign PC=cpu.mycore.dp.pc,IR=cpu.mycore.dp.instr, ALUCTRL=cpu.mycore.dp.alu.aluctrl;
  assign ALUOP=cpu.mycore.c.ad.aluop;
  assign OPCODE=cpu.mycore.c.opcode,FUNCT7=cpu.mycore.c.funct7;
  assign FUNCT3=cpu.mycore.c.funct3,RD=cpu.mycore.dp.rf.wa3;
  assign RS1=cpu.mycore.dp.rf.ra1,RS2=cpu.mycore.dp.rf.ra2;
  wire[63:0] A,B,RESULT;
  assign A=cpu.mycore.dp.srca,B=cpu.mycore.dp.srcb;
  assign RESULT=cpu.mycore.dp.result, IMM=cpu.mycore.dp.genimm.y;
  initial begin wait(reset_); #180
    $display("X5=%h (should contain '00000007')",cpu.mycore.dp.rf.rf[5]);
    $finish;
  end
  riscv cpu(clock,reset_);
endmodule

module riscv(clk,reset_);
  input clk,reset_;
  wire memwrite;
  wire [63:0] readdata,pc,aluout,writedata;
  wire [31:0] instr;
  // instantiate processor and memories
  core mycore(clk,reset_,readdata,instr, pc,memwrite,aluout,writedata);
  imem imem(pc[7:2], instr);
  dmem dmem(clk,memwrite,aluout[5:0],writedata,readdata);
endmodule

module core(clk,reset,readdata,instr,pc, memwrite, aluout, writedata);
  input clk, reset;
  input[63:0] readdata;
  input[31:0] instr;
  output[63:0] pc,aluout,writedata;
  output memwrite;
  wire memtoreg,alusrc,regdst,regwrite,pcsrc, zero,overflow;
  wire[2:0] alucontrol;
  controller c(instr[31:25],instr[14:12],instr[6:0],zero,memtoreg,memwrite,pcsrc,alusrc,regwrite,alucontrol);
  datapath dp(clk,reset,memtoreg,pcsrc,alusrc,regwrite,alucontrol,instr,readdata,zero,pc,aluout,writedata);
endmodule

module controller(funct7,funct3,opcode,zero,memtoreg,memwrite,pcsrc,alusrc,regwrite,alucontrol);
  input[2:0] funct3;
  input[6:0] opcode,funct7;
  input zero;
  output memtoreg,memwrite,pcsrc,alusrc, regwrite;
  output [2:0] alucontrol;
  wire [1:0] aluop;
  wire branch;
  maindec md(opcode, memtoreg,memwrite, branch,alusrc,regwrite,aluop);
  aludec ad(funct7,funct3,aluop, alucontrol);
  assign pcsrc = branch & zero;
endmodule

module maindec(opcode, memtoreg,memwrite,branch,alusrc,regwrite,aluop);
  input [6:0] opcode;
  output memtoreg,memwrite,branch,alusrc,regwrite;
  output [1:0] aluop;
  reg [7:0] controls;
  assign {regwrite,alusrc,branch,memwrite,memtoreg,aluop} = controls;
  always @(opcode)
    casex(opcode)
      7'b0110011: controls <= 7'b1000010; // R-TYPE
      7'b0000011: controls <= 7'b1100100; // LW
      7'b0100011: controls <= 7'b0101000; // SW
      7'b1100011: controls <= 7'b0010001; // BEQ
      7'b0010011: controls <= 7'b1100000; // ADDI
      default: controls <= 7'bxxxxxxx; // illegal op
    endcase
endmodule

module aludec(funct7,funct3,aluop, alucontrol);
  input [6:0] funct7;
  input [2:0] funct3;
  input [1:0] aluop;
  output [2:0] alucontrol; reg [2:0] alucontrol;
  always @(aluop or funct3 or funct7)
    casex(aluop)
      2'b00: alucontrol <= 3'b010; // add (for lw/sw/addi)
      2'b01: alucontrol <= 3'b110; // sub (for beq)
      2'b10:
        casex(funct3) // R-TYPE instructions
          3'b000:
            casex(funct7) // add or sub
              7'b0000000: alucontrol <= 3'b010; // add
              7'b0100000: alucontrol <= 3'b110; // sub
              default: alucontrol <= 3'bxxx; // ???
            endcase
          3'b111: alucontrol <= 3'b000; // and
          3'b110: alucontrol <= 3'b001; // or
          3'b010: alucontrol <= 3'b111; // slt
          default: alucontrol <= 3'bxxx; // ???
        endcase
      default: alucontrol <= 3'bxxx; // ???
    endcase
endmodule

module datapath(clk,reset,memtoreg,pcsrc,alusrc,regwrite, alucontrol, instr, readdata, zero, pc, aluout, writedata);
  input clk, reset, memtoreg, pcsrc, alusrc, regwrite;
  input[2:0] alucontrol;
  input[31:0] instr;
  input[63:0] readdata;
  output zero;
  output[63:0] pc, aluout, writedata;
  wire[4:0] writereg;
  wire[63:0] pcnext, pcplus4, pcbranch;
  wire[63:0] signimm, signimmsh, srca, srcb, result;
  // next PC logic
  flopr #(64) pcreg(clk,reset,pcnext, pc);
  adder pcadd1(pc,64'b100, pcplus4);
  sl1 immsh(signimm, signimmsh);
  adder pcadd2(pc,signimmsh, pcbranch);
  mux2 #(64) pcbrmux(pcplus4,pcbranch,pcsrc, pcnext);
  // register file logic
  regfile rf(clk,regwrite,instr[19:15],instr[24:20],instr[11:7],result, srca, writedata);
  mux2 #(64) resmux(aluout,readdata,memtoreg, result);
  genimm genimm(instr, signimm);
  // ALU logic
  mux2 #(64) srcbmux(writedata,signimm,alusrc, srcb);
  alu alu(srca, srcb, alucontrol, aluout, zero);
endmodule

module regfile(clk, we3, ra1, ra2, wa3, wd3, rd1, rd2);
  input clk,we3;
  input[4:0] ra1, ra2, wa3;
  input[63:0] wd3;
  output[63:0] rd1, rd2; reg[63:0] rd1, rd2;
  reg[63:0] rf[0:31];
  // three ported register file: read two ports combinationally
  // write third port on falling edge of clk; register 0 hardwired to 0
  always @(negedge clk) if (we3) rf[wa3] <= wd3;
  always @(ra1) rd1 <= (ra1 != 0) ? rf[ra1] : 0;
  always @(ra2) rd2 <= (ra2 != 0) ? rf[ra2] : 0;
endmodule

module alu(a, b, aluctrl, aluout, zero);
  input[63:0] a, b;
  input[2:0] aluctrl;
  output[63:0] aluout; reg[63:0] aluout;
  output zero;
  assign zero = (aluout==0); //v------ delay to av. inf. speed loops
  always @(aluctrl or a or b) #0.1//re-evaluate if these change
    casex (aluctrl)
      0: aluout <= a & b;
      1: aluout <= a | b;
      2: aluout <= a + b;
      6: aluout <= a - b;
      7: aluout <= a<b ? 1:0;
      default: aluout<=0; //default to 0, should not happen
    endcase
endmodule

module adder(a, b, aluout);
  input[63:0] a, b;
  output[63:0] aluout;
  assign aluout=a+b;
endmodule

module signext(a, y);
// sign_extension_unit
  input [11:0] a;
  output [63:0] y;
  assign y = {{52{a[11]}}, a};
endmodule

module sl1(a, y); // shift left by 1
  input [63:0] a; output [63:0] y;
  assign y = {a[62:0], 1'b0};
endmodule

module genimm(a, z);
  input[31:0] a;
  output[63:0] z;
  reg[11:0] y;
  wire[6:0] opc;
  assign opc=a[6:0];
  always @(a or opc)
    casex(opc)
      7'b00x0011: y <= a[31:20];
      7'b0100011: y <={a[31:25],a[11:7]};
      7'b1100011: y <={a[31],a[7],a[30:25],a[11:8]};
      default: y <=12'bxxxxxxxxxxxx; // ???
    endcase
  assign z = {{52{y[11]}}, y};
endmodule

module flopr (clk,reset_,d, q);
  parameter WIDTH = 8;
  input [WIDTH-1:0] d;
  input clk, reset_;
  output [WIDTH-1:0] q; reg [WIDTH-1:0] q;
  always @(posedge clk) // posedge reset)
    #1.1if (!reset_) q <= 0; //delay inserted to avoid infinite speed loops
  else q <= d;
endmodule

module mux2 (d0,d1,s, y);
  parameter WIDTH = 64;
  input [WIDTH-1:0] d0, d1;
  input s;
  output [WIDTH-1:0] y;
  assign y = s ? d1 : d0;
endmodule

module imem(a, rd);
// instruction_memory
  input[5:0] a;
  output[31:0] rd;
  reg[31:0] RAM[0:63];
  initial $readmemh("risc_v_memfile.txt", RAM);
  assign rd = RAM[a]; // word aligned
endmodule

module dmem(clk,we,a,wd, rd);
  input clk, we;
  input[5:0] a;
  input[63:0] wd;
  output[63:0] rd;
  reg[63:0] RAM2[0:63];
  assign rd = RAM2[a[5:2]]; // word aligned
  always @(posedge clk) if (we) RAM2[a[5:2]] <= wd;
endmodule

