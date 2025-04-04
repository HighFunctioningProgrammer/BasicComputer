module decoder_3to8
(
input IN0, IN1, IN2,
output reg [7:0] D
);

always @(*) begin
	case ({IN2,IN1,IN0})
		3'd0: D = 8'b0000_0001;
		3'd1: D = 8'b0000_0010;
		3'd2: D = 8'b0000_0100;
		3'd3: D = 8'b0000_1000;
		3'd4: D = 8'b0001_0000;
		3'd5: D = 8'b0010_0000;
		3'd6: D = 8'b0100_0000;
		3'd7: D = 8'b1000_0000;
		default: D = 8'b0000_0001;
	endcase
end

endmodule
