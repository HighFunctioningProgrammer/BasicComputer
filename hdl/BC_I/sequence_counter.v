module sequence_counter
(
input clk,
input INCR, CLR,
output reg [3:0] T
);

initial begin
        T <= 4'b000;
end

always @(posedge clk) begin
	if (CLR) begin T <= 4'b0000; end
	else begin
		if (INCR) begin 
			if (&T) begin T <= 4'b0000; end
			else begin T <= T + 4'b0001; end
		end
		else begin T <= T; end
	end
end

endmodule
