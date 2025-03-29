//Don't change the module I/O
module BC_I (
input clk,
input FGI,
output [11:0] PC,
output [11:0] AR,
output [15:0] IR,
output [15:0] AC,
output [15:0] DR
);

// Instantiate your datapath and controller here, then connect them.

localparam WORD_LENGTH = 16;
localparam ADDRESS_LENGTH = 12;
localparam MEMORY_SIZE = 4096;

wire [2:0] select_BUS;
wire [2:0] select_ALU;
wire write_enable_AR, reset_AR, incr_AR;
wire write_enable_PC, reset_PC, incr_PC;
wire write_enable_DR, reset_DR, incr_DR;
wire write_enable_AC, reset_AC, incr_AC;
wire write_enable_IR, reset_IR, incr_IR;
wire write_enable_TR, reset_TR, incr_TR;
wire write_enable_M;
wire write_enable_E, reset_E, cmp_E;
wire SET_IEN, RESET_IEN;
wire [WORD_LENGTH-1:0] BUS_OUT;
wire OUT_ALU_OVF, OUT_ALU_N, OUT_ALU_Z;
wire OUT_CO;
wire STATUS_IEN, STATUS_DR_Z;
wire STATUS_AC_N, STATUS_AC_Z;

Controller #(.WORD(WORD_LENGTH), .ADDRESS(ADDRESS_LENGTH)) CONTROL_UNIT
(
.clk(clk), 
.IR(IR), 
.STATUS_DR_Z(STATUS_DR_Z), 
.STATUS_OVF(OUT_ALU_OVF), .STATUS_N(OUT_ALU_N), .STATUS_Z(OUT_ALU_Z), 
.STATUS_AC_N(STATUS_AC_N), .STATUS_AC_Z(STATUS_AC_Z),
.STATUS_E(OUT_CO), 
.STATUS_FGI(FGI), 
.STATUS_IEN(STATUS_IEN), 
.setIEN(SET_IEN), .resetIEN(RESET_IEN), 
.write_enable_E(write_enable_E), .reset_E(reset_E), .cmp_E(cmp_E),
.write_enable_AR(write_enable_AR), .reset_AR(reset_AR), .incr_AR(incr_AR), 
.write_enable_PC(write_enable_PC), .reset_PC(reset_PC), .incr_PC(incr_PC), 
.write_enable_DR(write_enable_DR), .reset_DR(reset_DR), .incr_DR(incr_DR), 
.write_enable_AC(write_enable_AC), .reset_AC(reset_AC), .incr_AC(incr_AC), 
.write_enable_IR(write_enable_IR), .reset_IR(reset_IR), .incr_IR(incr_IR), 
.write_enable_TR(write_enable_TR), .reset_TR(reset_TR), .incr_TR(incr_TR), 
.write_enable_M(write_enable_M), 
.select_BUS(select_BUS), 
.select_ALU(select_ALU)
);

Datapath #(.WORD(WORD_LENGTH), .ADDRESS(ADDRESS_LENGTH), .SIZE(MEMORY_SIZE)) DATAPATH_UNIT
(
.clk(clk), 
.select_BUS(select_BUS), 
.select_ALU(select_ALU), 
.write_enable_AR(write_enable_AR), .reset_AR(reset_AR), .incr_AR(incr_AR), 
.write_enable_PC(write_enable_PC), .reset_PC(reset_PC), .incr_PC(incr_PC), 
.write_enable_DR(write_enable_DR), .reset_DR(reset_DR), .incr_DR(incr_DR), 
.write_enable_AC(write_enable_AC), .reset_AC(reset_AC), .incr_AC(incr_AC), 
.write_enable_IR(write_enable_IR), .reset_IR(reset_IR), .incr_IR(incr_IR), 
.write_enable_TR(write_enable_TR), .reset_TR(reset_TR), .incr_TR(incr_TR), 
.write_enable_M(write_enable_M), 
.write_enable_CO(write_enable_E), .reset_CO(reset_E), .cmp_CO(cmp_E),
.SET_IEN(SET_IEN), .RESET_IEN(RESET_IEN), 
.BUS_OUT(BUS_OUT), 
.PC_OUT(PC), 
.AR_OUT(AR), 
.IR_OUT(IR), 
.AC_OUT(AC), 
.DR_OUT(DR), 
.OUT_ALU_OVF(OUT_ALU_OVF), .OUT_ALU_N(OUT_ALU_N), .OUT_ALU_Z(OUT_ALU_Z), 
.OUT_CO(OUT_CO), 
.STATUS_IEN(STATUS_IEN), .STATUS_DR_Z(STATUS_DR_Z),
.STATUS_AC_N(STATUS_AC_N), .STATUS_AC_Z(STATUS_AC_Z)
);


endmodule
