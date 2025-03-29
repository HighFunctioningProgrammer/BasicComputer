module Controller 
#(parameter WORD = 16, ADDRESS = 12)
(
input clk,
input [WORD-1:0] IR,
input STATUS_DR_Z,
input STATUS_OVF, STATUS_N, STATUS_Z,
input STATUS_AC_N, STATUS_AC_Z,
input STATUS_E,
input STATUS_FGI,
input STATUS_IEN,
output wire setIEN, resetIEN,
output wire write_enable_E, reset_E, cmp_E,
output wire write_enable_AR, reset_AR, incr_AR,
output wire write_enable_PC, reset_PC, incr_PC,
output wire write_enable_DR, reset_DR, incr_DR,
output wire write_enable_AC, reset_AC, incr_AC,
output wire write_enable_IR, reset_IR, incr_IR,
output wire write_enable_TR, reset_TR, incr_TR,
output wire write_enable_M,
output wire [2:0] select_BUS,
output wire [2:0] select_ALU
);

wire [7:0] D;
wire [3:0] T_4bit;
wire [15:0] T;
wire I, R, S;

wire write_enable_I, reset_I, incr_I;
wire write_enable_R, reset_R, incr_R;
wire write_enable_S, reset_S, incr_S;

generic_register #(.WORD(1'b1)) I_FF
(
.clk(clk), .write_enable(write_enable_I), .reset(reset_I), .incr(incr_I),
.DATA(IR[WORD-1]),
.OUT(I)
);

generic_register #(.WORD(1'b1)) R_FF
(
.clk(clk), .write_enable(write_enable_R), .reset(reset_R), .incr(incr_R),
.DATA(1'b1),
.OUT(R)
);

generic_register #(.WORD(1'b1)) S_FF
(
.clk(clk), .write_enable(write_enable_S), .reset(reset_S), .incr(incr_S),
.DATA(1'b1),
.OUT(S)
);

assign write_enable_I  = write_enable_I_RAW && ~S ; assign reset_I  = 1'b0 ; assign incr_I  = 1'b0 ;
assign write_enable_R  = setR_RAW && ~S ; assign reset_R = resetR_RAW && ~S ; assign incr_R  = 1'b0 ;
assign write_enable_S  = setS_RAW && ~S ; assign reset_S  = resetS_RAW ; assign incr_S  = 1'b0 ;

wire setR_RAW, resetR_RAW;
wire setS_RAW, resetS_RAW;
wire write_enable_I_RAW;
wire incrSC_RAW, clrSC_RAW;
wire setIEN_RAW, resetIEN_RAW;
wire write_enable_E_RAW, reset_E_RAW, cmp_E_RAW;
wire write_enable_AR_RAW, reset_AR_RAW, incr_AR_RAW;
wire write_enable_PC_RAW, reset_PC_RAW, incr_PC_RAW;
wire write_enable_DR_RAW, reset_DR_RAW, incr_DR_RAW;
wire write_enable_AC_RAW, reset_AC_RAW, incr_AC_RAW;
wire write_enable_IR_RAW, reset_IR_RAW, incr_IR_RAW;
wire write_enable_TR_RAW, reset_TR_RAW, incr_TR_RAW;
wire write_enable_M_RAW;
wire [2:0] select_BUS_RAW;
wire [2:0] select_ALU_RAW;

assign setIEN  = setIEN_RAW && ~S ; assign resetIEN  = resetIEN_RAW && ~S ;
assign write_enable_E  = write_enable_E_RAW && ~S ; assign reset_E  = reset_E_RAW && ~S ; assign cmp_E  = cmp_E_RAW && ~S ;
assign write_enable_AR  = write_enable_AR_RAW && ~S ; assign reset_AR  = reset_AR_RAW && ~S ; assign incr_AR  = incr_AR_RAW && ~S ;
assign write_enable_PC  = write_enable_PC_RAW && ~S ; assign reset_PC  = reset_PC_RAW && ~S ; assign incr_PC  = incr_PC_RAW && ~S ;
assign write_enable_DR  = write_enable_DR_RAW && ~S ; assign reset_DR  = reset_DR_RAW && ~S ; assign incr_DR  = incr_DR_RAW && ~S ;
assign write_enable_AC  = write_enable_AC_RAW && ~S ; assign reset_AC  = reset_AC_RAW && ~S ; assign incr_AC  = incr_AC_RAW && ~S ;
assign write_enable_IR  = write_enable_IR_RAW && ~S ; assign reset_IR  = reset_IR_RAW && ~S ; assign incr_IR  = incr_IR_RAW && ~S ;
assign write_enable_TR  = write_enable_TR_RAW && ~S ; assign reset_TR  = reset_TR_RAW && ~S ; assign incr_TR  = incr_TR_RAW && ~S ;
assign write_enable_M  = write_enable_M_RAW && ~S ;
assign select_BUS  = select_BUS_RAW & {3{~S}} ;
assign select_ALU  = select_ALU_RAW & {3{~S}} ;

comb_control_logic
#(.WORD(WORD), .ADDRESS(ADDRESS)) COMBCONTROL
(
.B(IR[ADDRESS-1:0]),
.I(I),
.E(STATUS_E),
.STATUS_DR_Z(STATUS_DR_Z),
.STATUS_OVF(STATUS_OVF), .STATUS_N(STATUS_N), .STATUS_Z(STATUS_Z),
.STATUS_AC_N(STATUS_AC_N), .STATUS_AC_Z(STATUS_AC_Z),
.FGI(STATUS_FGI),
.R(R),
.IEN(STATUS_IEN),
.D(D),
.T(T),
.setR(setR_RAW), .resetR(resetR_RAW),
.write_enable_I(write_enable_I_RAW),
.setS(setS_RAW), .resetS(resetS_RAW),
.setIEN(setIEN_RAW), .resetIEN(resetIEN_RAW),
.write_enable_E(write_enable_E_RAW), .reset_E(reset_E_RAW), .cmp_E(cmp_E_RAW),
.incrSC(incrSC_RAW), .clrSC(clrSC_RAW),
.write_enable_AR(write_enable_AR_RAW), .reset_AR(reset_AR_RAW), .incr_AR(incr_AR_RAW),
.write_enable_PC(write_enable_PC_RAW), .reset_PC(reset_PC_RAW), .incr_PC(incr_PC_RAW),
.write_enable_DR(write_enable_DR_RAW), .reset_DR(reset_DR_RAW), .incr_DR(incr_DR_RAW),
.write_enable_AC(write_enable_AC_RAW), .reset_AC(reset_AC_RAW), .incr_AC(incr_AC_RAW),
.write_enable_IR(write_enable_IR_RAW), .reset_IR(reset_IR_RAW), .incr_IR(incr_IR_RAW),
.write_enable_TR(write_enable_TR_RAW), .reset_TR(reset_TR_RAW), .incr_TR(incr_TR_RAW),
.write_enable_M(write_enable_M_RAW),
.select_BUS(select_BUS_RAW),
.select_ALU(select_ALU_RAW)
);

decoder_3to8 OPR_DECODER
(
.IN0(IR[WORD-1-3]), .IN1(IR[WORD-1-2]), .IN2(IR[WORD-1-1]),
.D(D)
);

sequence_counter SC
(
.clk(clk),
.INCR(incrSC_RAW && ~S), .CLR(clrSC_RAW && ~S),
.T(T_4bit)
);

decoder_4to16 T_DECODER
(
.IN0(T_4bit[0]), .IN1(T_4bit[1]), .IN2(T_4bit[2]), .IN3(T_4bit[3]),
.D(T)
);


endmodule
