module MUX_8_1 #(parameter WORD = 16)
(
input [2:0] select,
input [WORD-1:0] IN_0,
input [WORD-1:0] IN_1,
input [WORD-1:0] IN_2,
input [WORD-1:0] IN_3,
input [WORD-1:0] IN_4,
input [WORD-1:0] IN_5,
input [WORD-1:0] IN_6,
input [WORD-1:0]IN_7,
output reg [WORD-1:0] OUT
);


always @(*) begin
	case({select})
		3'd0: OUT = IN_0;
		3'd1: OUT = IN_1;
		3'd2: OUT = IN_2;
		3'd3: OUT = IN_3;
		3'd4: OUT = IN_4;
		3'd5: OUT = IN_5;
		3'd6: OUT = IN_6;
		3'd7: OUT = IN_7;
		default: OUT = IN_0;
	endcase
end

endmodule
