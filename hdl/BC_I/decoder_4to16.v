module decoder_4to16
(
input IN0, IN1, IN2, IN3,
output reg [15:0] D
);

always @(*) begin
	case ({IN3,IN2,IN1,IN0})
		4'd0: D  = 16'h0001;
		4'd1: D  = 16'h0002;
		4'd2: D  = 16'h0004;
		4'd3: D  = 16'h0008;
		4'd4: D  = 16'h0010;
		4'd5: D  = 16'h0020;
		4'd6: D  = 16'h0040;
		4'd7: D  = 16'h0080;
		4'd8: D  = 16'h0100;
		4'd9: D  = 16'h0200;
		4'd10: D = 16'h0400;
		4'd11: D = 16'h0800;
		4'd12: D = 16'h1000;
		4'd13: D = 16'h2000;
		4'd14: D = 16'h4000;
		4'd15: D = 16'h8000;
		default: D = 16'h0001;
	endcase
end

endmodule
