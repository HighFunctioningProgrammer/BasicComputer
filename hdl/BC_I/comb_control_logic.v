module comb_control_logic
#(parameter WORD = 16, ADDRESS = 12)
(
input [ADDRESS-1:0] B,
input I,
input E,
input STATUS_DR_Z,
input STATUS_OVF, STATUS_N, STATUS_Z,
input STATUS_AC_N, STATUS_AC_Z,
input FGI,
input R,
input IEN,
input [7:0] D,
input [15:0] T,
output wire setR, resetR,
output wire write_enable_I,
output wire setS, resetS,
output wire setIEN, resetIEN,
output wire write_enable_E, reset_E, cmp_E,
output wire incrSC, clrSC,
output wire write_enable_AR, reset_AR, incr_AR,
output wire write_enable_PC, reset_PC, incr_PC,
output wire write_enable_DR, reset_DR, incr_DR,
output wire write_enable_AC, reset_AC, incr_AC,
output wire write_enable_IR, reset_IR, incr_IR,
output wire write_enable_TR, reset_TR, incr_TR,
output wire write_enable_M,
output reg [2:0] select_BUS,
output reg [2:0] select_ALU
);

wire r, p;

localparam [2:0] SELECT_AR = 3'd1;
localparam [2:0] SELECT_PC = 3'd2;
localparam [2:0] SELECT_DR = 3'd3;
localparam [2:0] SELECT_AC = 3'd4;
localparam [2:0] SELECT_IR = 3'd5;
localparam [2:0] SELECT_TR = 3'd6;
localparam [2:0] SELECT_M = 3'd7;

localparam ADD = 3'd0;
localparam AND = 3'd1;
localparam TRA = 3'd2;
localparam CMP = 3'd3;
localparam SHR = 3'd4;
localparam SHL = 3'd5;

wire ARtoBUS;
wire PCtoBUS;
wire DRtoBUS;
wire ACtoBUS;
wire IRtoBUS;
wire TRtoBUS;
wire MtoBUS;

wire ADD_signal;
wire AND_signal;
wire TRA_signal;
wire CMP_signal;
wire SHR_signal;
wire SHL_signal;


assign ARtoBUS = (D[4] && T[4]) || (D[5] && T[5]) ;
assign PCtoBUS = (~R && T[0]) || (R && T[0]) || (D[5] && T[4]) ;
assign DRtoBUS = (D[6] && T[6]) ;
assign ACtoBUS = (D[3] && T[4]) ;
assign IRtoBUS = (~R && T[2]) ;
assign TRtoBUS = (R && T[1]) ;
assign MtoBUS  = (~R && T[1]) || (~D[7] && I && T[3]) || 
(D[0] && T[4]) || (D[1] && T[4]) || (D[2] && T[4]) || 
(D[6] && T[4]) ;

assign ADD_signal = (D[1] && T[5]) ;
assign AND_signal = (D[0] && T[5]) ;
assign TRA_signal = (D[2] && T[5]) ;
assign CMP_signal = (r && B[9]) ;
assign SHR_signal = (r && B[7]) ;
assign SHL_signal = (r && B[6]) ;

always @(*) begin
	case({ADD_signal,AND_signal,TRA_signal,CMP_signal,SHR_signal,SHL_signal})
		6'b100000: select_ALU = ADD;
		6'b010000: select_ALU = AND;
		6'b001000: select_ALU = TRA;
		6'b000100: select_ALU = CMP;
		6'b000010: select_ALU = SHR;
		6'b000001: select_ALU = SHL;
		default: select_ALU = TRA;
	endcase
end

always @(*) begin
	case({ARtoBUS,PCtoBUS,DRtoBUS,ACtoBUS,IRtoBUS,TRtoBUS,MtoBUS})
		7'b1000000: select_BUS = SELECT_AR;
		7'b0100000: select_BUS = SELECT_PC;
		7'b0010000: select_BUS = SELECT_DR;
		7'b0001000: select_BUS = SELECT_AC;
		7'b0000100: select_BUS = SELECT_IR;
		7'b0000010: select_BUS = SELECT_TR;
		7'b0000001: select_BUS = SELECT_M;
		default: select_BUS = SELECT_AC;
	endcase
end

assign r = D[7] && (~I) && T[3];
assign p = D[7] && ( I) && T[3];

assign write_enable_AR 	= (~R && T[0]) || (~R && T[2]) || (~D[7] && I && T[3]) ;
assign reset_AR 		= (R && T[0]) ;
assign incr_AR 			= (D[5] && T[4]) ;

assign write_enable_PC 	= (D[4] && T[4]) || (D[5] && T[5]) ;
assign reset_PC 		= (R && T[1]) ;
assign incr_PC 			= (~R && T[1]) || (~STATUS_AC_N && r && B[4]) || 
(STATUS_AC_N && r && B[3]) || (STATUS_AC_Z && r && B[2]) || (~E && r && B[1]) || 
(R && T[2]) || (D[6] && T[6] && STATUS_DR_Z) ;

assign write_enable_DR 	= (D[0] && T[4]) || (D[1] && T[4]) || (D[2] && T[4]) || 
(D[6] && T[4]) ;
assign reset_DR 		= 1'b0 ;
assign incr_DR 			= (D[6] && T[5]) ;

assign write_enable_AC 	= (r && B[9]) || (r && B[7]) || (r && B[6]) || 
(D[0] && T[5]) || (D[2] && T[5]) || (D[1] && T[5]) ;
assign reset_AC 		= (r && B[11]) ;
assign incr_AC 			= (r && B[5]) ;

assign write_enable_E 	= (D[1] && T[5]) || (r && B[7]) || (r && B[6]) ;
//assign write_enable_E 	= ADD_signal || AND_signal || TRA_signal || CMP_signal || SHR_signal || SHL_signal;
assign reset_E 			= (r && B[10]) ;
assign cmp_E 			= (r && B[8]) ;

assign write_enable_IR 	= (~R && T[1]) ;
assign reset_IR 		= 1'b0 ;
assign incr_IR 			= 1'b0 ;

assign write_enable_TR 	= (R && T[0]) ;
assign reset_TR 		= 1'b0 ;
assign incr_TR 			= 1'b0 ;

assign write_enable_M 	= (R && T[1]) || (D[3] && T[4]) || (D[5] && T[4]) || 
(D[6] && T[6]) ;

assign write_enable_I 	= (~R && T[2]) ;

assign setR 		= ~(T[0] || T[1] || T[2]) && IEN && FGI;
assign resetR 		= (R && T[2]) ;
assign setS 		= (r && B[0]);
assign resetS 		= 1'b0 ;
assign setIEN 		= (p && B[7]) ;
assign resetIEN 	= (p && B[6]) || (R && T[2]) ;
assign incrSC 		= 1'b1;
assign clrSC 		= r || p || (R && T[2]) || 
(D[0] && T[5]) || (D[1] && T[5]) || (D[2] && T[5]) || 
(D[3] && T[4]) || (D[4] && T[4]) || (D[5] && T[5]) || 
(D[6] && T[6]) ;

endmodule
