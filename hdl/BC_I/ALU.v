module ALU #(parameter WORD = 16)
(
input [WORD-1:0] AC,
input [WORD-1:0] DR,
input E,
input [2:0] select,
output reg CO, OVF, N, Z,
output reg [WORD-1:0] OUT
);

localparam ADD = 3'd0;
localparam AND = 3'd1;
localparam TRA = 3'd2;
localparam CMP = 3'd3;
localparam SHR = 3'd4;
localparam SHL = 3'd5;

always @(*) begin
	case({select})
		ADD: begin
			{CO, OUT} = AC + DR;
			OVF = ((AC[WORD-1] == DR[WORD-1]) && (AC[WORD-1] != OUT[WORD-1]));
			Z = ~(|OUT);
			N = OUT[WORD-1];
		end
		AND: begin
			OUT = AC & DR;
			CO = 1'b0;
			OVF = 1'b0;
			Z = ~(|OUT);
			N = OUT[WORD-1];
		end
		TRA: begin
			OUT = DR;
			CO = 1'b0;
			OVF = 1'b0;
			Z = ~(|OUT);
			N = OUT[WORD-1];
		end
		CMP: begin
			OUT = ~AC;
			CO = 1'b0;
			OVF = 1'b0;
			Z = ~(|OUT);
			N = OUT[WORD-1];
		end
		SHR: begin
			OUT = {E, AC[WORD-1:1]};
			CO = AC[0];
			OVF = 1'b0;
			Z = ~(|OUT);
			N = OUT[WORD-1];
		end
		SHL: begin
			OUT = {AC[WORD-2:0], E};
			CO = AC[WORD-1];
			OVF = 1'b0;
			Z = ~(|OUT);
			N = OUT[WORD-1];
		end
		default: begin
			OUT = AC;
			CO = 1'b0;
			OVF = 1'b0;
			Z = ~(|OUT);
			N = OUT[WORD-1];
		end
	endcase
end

endmodule
