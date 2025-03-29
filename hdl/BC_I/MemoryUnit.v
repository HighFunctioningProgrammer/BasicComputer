module MemoryUnit
#(parameter WORD=16, parameter ADDRESS=12, parameter SIZE = 4096)
(
input clk, write_enable,
input [WORD-1:0] write_data, 
input [ADDRESS-1:0] address,
output reg [WORD-1:0] read_data 
);
reg [WORD-1:0] memory [SIZE];

initial begin
	memory[12'h000] = 16'h400F ;  // (First time, branch to MAIN) ELSE RESERVED FOR INTRUPT CYCLE RETURN ADRESS
	memory[12'h001] = 16'h4004 ;  // Branch to Interupt Subroutine @M[x004]
	memory[12'h002] = 16'h0000 ;  // Temp AC Storage for ISBR
	memory[12'h003] = 16'h0000 ;  // CHECK : RESULT = 1
	memory[12'h004] = 16'h3002 ;  // 0 STA 000: Store AC into M[x002]
	memory[12'h005] = 16'h2003 ;  // LDA M[x003]
	memory[12'h006] = 16'h7020 ;  // INCAC
	memory[12'h007] = 16'h3003 ;  // 0 STA 003
	memory[12'h008] = 16'h2002 ;  // LDA M[x002]
	memory[12'h009] = 16'hF080 ;  // ION
	memory[12'h00A] = 16'hC000 ;  // 1 BUN 000 : Branch unconditionally TO MAIN
	memory[12'h00B] = 16'h0000 ;  // 
	memory[12'h00C] = 16'h0000 ;  // 
	memory[12'h00D] = 16'h0000 ;  // 
	memory[12'h00E] = 16'h0000 ;  // 
	memory[12'h00F] = 16'hF080 ;  // ION BEFORE MAIN
	memory[12'h010] = 16'h2014 ;  // MAIN: ROUTINE 1: LDA M[x013] -> AC (Load first number)
	memory[12'h011] = 16'h1015 ;  // ADD M[x014] -> AC = AC + M[x014]
	memory[12'h012] = 16'h3016 ;  // STA M[x015] -> Store AC into M[x015] (Result of addition)
	memory[12'h013] = 16'h4020 ;  // 0 BUN 020 : Branch unconditionally TO ROUTINE 2
	memory[12'h014] = 16'h0008 ;  // ROUTINE 1 : A = 8
	memory[12'h015] = 16'h0002 ;  // ROUTINE 1 : B = 2
	memory[12'h016] = 16'h0000 ;  // CHECK : ROUTINE 1 : RESULT(A+B) == 10
	memory[12'h017] = 16'h0000 ;  // 
	memory[12'h018] = 16'h0000 ;  // 
	memory[12'h019] = 16'h0000 ;  // 
	memory[12'h01A] = 16'h0000 ;  // 
	memory[12'h01B] = 16'h0000 ;  // 
	memory[12'h01C] = 16'h0000 ;  // 
	memory[12'h01D] = 16'h0000 ;  // 
	memory[12'h01E] = 16'h0000 ;  // 
	memory[12'h01F] = 16'h0000 ;  // 
	memory[12'h020] = 16'h2027 ;  // ROUTINE 2 DIRECT: LDA M[x027] -> AC (Load first number)
	memory[12'h021] = 16'h0028 ;  // AND M[x028] -> AC = AC & M[x028]
	memory[12'h022] = 16'h3029 ;  // STA M[x029] -> Store AC into M[x029] (Result of addition)
    memory[12'h023] = 16'h202A ;  // ROUTINE 2 INDIRECT: LDA M[x02A] -> AC (Load first number)
	memory[12'h024] = 16'h802B ;  // AND M[M[x02B]] -> AC = AC & M[M[x02B]]
	memory[12'h025] = 16'h302D ;  // STA M[x02D] -> Store AC into M[x02D] (Result of addition)
	memory[12'h026] = 16'h4030 ;  // 0 BUN 030 : Branch unconditionally TO ROUTINE 3
	memory[12'h027] = 16'h006F ;  // ROUTINE 2 : A = 0...0110 1111 = 006F
	memory[12'h028] = 16'h00DA ;  // ROUTINE 2 : B = 0...1101 1010 = 00DA
	memory[12'h029] = 16'h0000 ;  // CHECK : ROUTINE 2 : RESULT(A & B) == 0...0100 1010 = 004A
	memory[12'h02A] = 16'h0007 ;  // ROUTINE 2 : 0...00 0111
	memory[12'h02B] = 16'h002C ;  // ROUTINE 2 : x02C
	memory[12'h02C] = 16'h0019 ;  // ROUTINE 2 : 0...01 1001
	memory[12'h02D] = 16'h0000 ;  // CHECK : ROUTINE 2 : RESULT(A & B) == 0...00 0001 = 0001
	memory[12'h02E] = 16'h0000 ;  // 
	memory[12'h02F] = 16'h0000 ;  // 
	memory[12'h030] = 16'h2035 ;  // ROUTINE 3 DIRECT: LDA M[x035] -> AC (Load first number)
	memory[12'h031] = 16'h3036 ;  // STA M[x036] -> Store AC into M[x036] (Result of addition)
	memory[12'h032] = 16'hA037 ;  // ROUTINE 3 INDIRECT: LDA M[M[x037]] -> AC (Load first number)
	memory[12'h033] = 16'hB038 ;  // STA M[M[x038]] -> Store AC into M[M[x038]] (Result of addition)
	memory[12'h034] = 16'h403F ;  // 0 BUN 03F : Branch unconditionally TO ROUTINE 4
	memory[12'h035] = 16'hEEEE ;  // ROUTINE 3 :EEEE
	memory[12'h036] = 16'h0000 ;  // CHECK : ROUTINE 3 : RESULT == EEEE
	memory[12'h037] = 16'h0039 ;  // ROUTINE 3 : x039
	memory[12'h038] = 16'h003A ;  // ROUTINE 3 : x03A
	memory[12'h039] = 16'hFFFF ;  // ROUTINE 3 : FFFF
	memory[12'h03A] = 16'h0000 ;  // CHECK : ROUTINE 3 : RESULT = FFFF
	memory[12'h03B] = 16'h0000 ;  // 
	memory[12'h03C] = 16'h0000 ;  // 
	memory[12'h03D] = 16'h0000 ;  // 
	memory[12'h03E] = 16'h0000 ;  // 
	memory[12'h03F] = 16'hF040 ;  // IOF
	memory[12'h040] = 16'h5070 ;  // BSA 70 TO SUBROUTINE
	memory[12'h041] = 16'hF080 ;  // ION
	memory[12'h042] = 16'h7800 ;  // CLA
	memory[12'h043] = 16'h3058 ;  // STA x058
	memory[12'h044] = 16'h7200 ;  // CMA
	memory[12'h045] = 16'h3059 ;  // STA x059
	memory[12'h046] = 16'h1057 ;  // ADD x057
	memory[12'h047] = 16'h7002 ;  // SZE
	memory[12'h048] = 16'h7080 ;  // CIR
	memory[12'h049] = 16'h7002 ;  // SZE
	memory[12'h04A] = 16'h305A ;  // STA x05A
	memory[12'h04B] = 16'h7008 ;  // SNA
	memory[12'h04C] = 16'h305B ;  // STA x05B
	memory[12'h04D] = 16'h7080 ;  // CIR
	memory[12'h04E] = 16'h7010 ;  // SPA
	memory[12'h04F] = 16'h305C ;  // STA x05C
	memory[12'h050] = 16'h7800 ;  // CLA
	memory[12'h051] = 16'h7004 ;  // SZA
	memory[12'h052] = 16'h305D ;  // STA x05D
	memory[12'h053] = 16'h205E ;  // LDA x05E
	memory[12'h054] = 16'h7040 ;  // CIL
	memory[12'h055] = 16'h305F ;  // STA x05F
	memory[12'h056] = 16'h4080 ;  // BUN x080
	memory[12'h057] = 16'h0001 ;  // To be added 1 to ffff
	memory[12'h058] = 16'hCCCC ;  // CHECK : ROUTINE CLA : RESULT == 0x0000
	memory[12'h059] = 16'hCCCC ;  // CHECK : ROUTINE CMA : RESULT == 0xFFFF
	memory[12'h05A] = 16'hCCCC ;  // CHECK : ROUTINE SZE : RESULT == 0xCCCC
	memory[12'h05B] = 16'hCCCC ;  // CHECK : ROUTINE SNA : RESULT == 0xCCCC
	memory[12'h05C] = 16'hCCCC ;  // CHECK : ROUTINE SPA : RESULT == 0xCCCC
	memory[12'h05D] = 16'hCCCC ;  // CHECK : ROUTINE SZA : RESULT == 0xCCCC
	memory[12'h05E] = 16'h0040 ;  // VALUE TO CIL
	memory[12'h05F] = 16'hEEEE ;  // CHECK : ROUTINE CIL : RESULT == 0x0080
	memory[12'h060] = 16'h0000 ;  // 
	memory[12'h061] = 16'h0000 ;  // 
	memory[12'h062] = 16'h0000 ;  // 
	memory[12'h063] = 16'h0000 ;  // 
	memory[12'h064] = 16'h0000 ;  // 
	memory[12'h065] = 16'h0000 ;  // 
	memory[12'h066] = 16'h0000 ;  // 
	memory[12'h067] = 16'h0000 ;  // 
	memory[12'h068] = 16'h0000 ;  // 
	memory[12'h069] = 16'h0000 ;  // 
	memory[12'h06A] = 16'h0010 ;  // 
	memory[12'h06B] = 16'h0003 ;  // 
	memory[12'h06C] = 16'h0000 ;  // 
	memory[12'h06D] = 16'h0000 ;  // CHECK : ROUTINE ISZ : RESULT == 13
	memory[12'h06E] = 16'h0000 ;  // 
	memory[12'h06F] = 16'h0000 ;  // 
	memory[12'h070] = 16'h0000 ;  // ADRESS SAVE
	memory[12'h071] = 16'h206B ;  // SUBROUTINE FOR ISZ: LDA x06B
	memory[12'h072] = 16'h7200 ;  // CMA
	memory[12'h073] = 16'h306C ;  // STA x06C
	memory[12'h074] = 16'h206A ;  // LDA x06A
	memory[12'h075] = 16'h606C ;  // ISZ x06C
	memory[12'h076] = 16'h4079 ;  // BUN x079
	memory[12'h077] = 16'h306D ;  // STA x06D
	memory[12'h078] = 16'hC070 ;  // I BUN x070
	memory[12'h079] = 16'h7020 ;  // INC 
	memory[12'h07A] = 16'h4075 ;  // BUN x075
	memory[12'h07B] = 16'h0000 ;  // 
	memory[12'h07C] = 16'h0000 ;  // 
	memory[12'h07D] = 16'h0000 ;  // 
	memory[12'h07E] = 16'h0000 ;  // 
	memory[12'h07F] = 16'h0000 ;  // 
	memory[12'h080] = 16'h208A ;  // LDA x08A
	memory[12'h081] = 16'h7100 ;  // CME making E = 1
	memory[12'h082] = 16'h7080 ;  // CIR : PREV EAC = 1_0...01 NOW : EAC = 1_10...0 makin E = 1, AC = h8000
	memory[12'h083] = 16'h7002 ;  // SZE : won't skip since E = 1
	memory[12'h084] = 16'h308B ;  // STA x08B 8000, SHOULD HAPPEN
	memory[12'h085] = 16'h7400 ;  // CLE : making E = 0
	memory[12'h086] = 16'h7002 ;  // SZE : WILL skip since E = 0
	memory[12'h087] = 16'h306C ;  // STA x08C 8000, SHOULD NOT HAPPEN
	memory[12'h088] = 16'h4090 ;  // BUN x090
	memory[12'h089] = 16'h0000 ;  // 
	memory[12'h08A] = 16'h0001 ;  // 00...001
	memory[12'h08B] = 16'hEEEE ;  // CHECK : ROUTINE CME : RESULT == 0x8000
	memory[12'h08C] = 16'hEEEE ;  // CHECK : ROUTINE CLE : RESULT == 0xEEEE
	memory[12'h08D] = 16'h0000 ;  // 
	memory[12'h08E] = 16'h0000 ;  // 
	memory[12'h08F] = 16'h0000 ;  // 
	memory[12'h090] = 16'h7001 ;  // HLT: STOP EVERYTHING
	memory[12'h091] = 16'h2093 ;  // LDA x093
	memory[12'h092] = 16'h3094 ;  // STA x094
	memory[12'h093] = 16'hFFFF ;  // 
	memory[12'h094] = 16'h0000 ;  // CHECK : ROUTINE HLT : RESULT == 0x0000
	memory[12'h095] = 16'h0000 ;  // 
	memory[12'h096] = 16'h0000 ;  // 
	memory[12'h097] = 16'h0000 ;  // 
	memory[12'h098] = 16'h0000 ;  // 
	memory[12'h099] = 16'h0000 ;  // 
	memory[12'h09A] = 16'h0000 ;  // 
	memory[12'h09B] = 16'h0000 ;  // 
	memory[12'h09C] = 16'h0000 ;  // 
	memory[12'h09D] = 16'h0000 ;  // 
	memory[12'h09E] = 16'h0000 ;  // 
	memory[12'h09F] = 16'h0000 ;  // 
	memory[12'h0A0] = 16'h0000 ;  // 
end

always @(*) begin
	read_data = memory[address];
end

always @(posedge clk) begin
	case (write_enable)
		1'b1: memory[address] <= write_data;
		//default: memory[address] <= memory[address]; //better without it to synt as sync_rma
	endcase
end

endmodule
