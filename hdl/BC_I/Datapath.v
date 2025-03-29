module Datapath
#(parameter WORD=16, parameter ADDRESS=12, parameter SIZE = 4096)
(
input clk,
input [2:0] select_BUS,
input [2:0] select_ALU,
input write_enable_AR, reset_AR, incr_AR,
input write_enable_PC, reset_PC, incr_PC,
input write_enable_DR, reset_DR, incr_DR,
input write_enable_AC, reset_AC, incr_AC,
input write_enable_IR, reset_IR, incr_IR,
input write_enable_TR, reset_TR, incr_TR,
input write_enable_M,
input write_enable_CO, reset_CO, cmp_CO,
input SET_IEN, RESET_IEN,
output reg [WORD-1:0] BUS_OUT,
output reg [ADDRESS-1:0] PC_OUT,
output reg [ADDRESS-1:0] AR_OUT,
output reg [WORD-1:0] IR_OUT,
output reg [WORD-1:0] AC_OUT,
output reg [WORD-1:0] DR_OUT,
output wire OUT_ALU_OVF, OUT_ALU_N, OUT_ALU_Z,
output wire OUT_CO,
output wire STATUS_IEN, STATUS_DR_Z,
output wire STATUS_AC_N, STATUS_AC_Z
);

wire [WORD-1:0] OUT_BUS, OUT_DR, OUT_AC, OUT_IR, OUT_TR, OUT_M, OUT_ALU;
wire [ADDRESS-1:0] OUT_AR, OUT_PC;
wire OUT_ALU_CO;

wire CO, IEN;

assign OUT_CO = CO; assign STATUS_AC_N = OUT_AC[WORD-1]; assign STATUS_AC_Z = ~(|OUT_AC); 
assign STATUS_DR_Z = ~(|OUT_DR);
assign STATUS_IEN = IEN;

localparam DANGLES = WORD - ADDRESS;

MUX_8_1 #(.WORD(WORD)) BUS(
.select(select_BUS),
.IN_0({WORD{1'b0}}),
.IN_1({{DANGLES{1'b0}},OUT_AR}),
.IN_2({{DANGLES{1'b0}},OUT_PC}),
.IN_3(OUT_DR),
.IN_4(OUT_AC),
.IN_5(OUT_IR),
.IN_6(OUT_TR),
.IN_7(OUT_M),
.OUT(OUT_BUS)
);

ALU #(.WORD(WORD)) ALU1
(
.AC(OUT_AC),
.DR(OUT_DR),
.E(OUT_CO),
.select(select_ALU),
.CO(OUT_ALU_CO), .OVF(OUT_ALU_OVF), .N(OUT_ALU_N), .Z(OUT_ALU_Z),
.OUT(OUT_ALU)
);

MemoryUnit #(.WORD(WORD), .ADDRESS(ADDRESS), .SIZE(SIZE)) M
(
.clk(clk), .write_enable(write_enable_M),
.write_data(OUT_BUS), 
.address(OUT_AR),
.read_data(OUT_M)
);

generic_register #(.WORD(ADDRESS)) AR
(
clk, write_enable_AR, reset_AR, incr_AR,
OUT_BUS[ADDRESS-1:0],
OUT_AR
);

generic_register #(.WORD(ADDRESS)) PC
(
clk, write_enable_PC, reset_PC, incr_PC,
OUT_BUS[ADDRESS-1:0],
OUT_PC
);

generic_register #(.WORD(WORD)) DR
(
clk, write_enable_DR, reset_DR, incr_DR,
OUT_BUS,
OUT_DR
);

generic_register #(.WORD(WORD)) AC
(
clk, write_enable_AC, reset_AC, incr_AC,
OUT_ALU,
OUT_AC
);

generic_register #(.WORD(WORD)) IR
(
clk, write_enable_IR, reset_IR, incr_IR,
OUT_BUS,
OUT_IR
);

generic_register #(.WORD(WORD)) TR
(
clk, write_enable_TR, reset_TR, incr_TR,
OUT_BUS,
OUT_TR
);

always @(*) begin
	BUS_OUT = OUT_BUS;
	PC_OUT = OUT_PC;
	AR_OUT = OUT_AR;
	IR_OUT = OUT_IR;
	AC_OUT = OUT_AC;
	DR_OUT = OUT_DR;
end

generic_register #(.WORD(1'b1)) CO_FF
(
.clk(clk), .write_enable(write_enable_CO), .reset(reset_CO), .incr(cmp_CO),
.DATA(OUT_ALU_CO),
.OUT(CO)
);

generic_register #(.WORD(1'b1)) IEN_FF
(
.clk(clk), .write_enable(SET_IEN), .reset(RESET_IEN), .incr(1'b0),
.DATA(1'b1),
.OUT(IEN)
);

endmodule
