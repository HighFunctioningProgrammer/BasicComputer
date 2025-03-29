module generic_register #(parameter WORD = 16)
(
input clk, write_enable, reset, incr,
input [WORD-1:0] DATA,
output reg [WORD-1:0] OUT
);

initial begin
        OUT <= {WORD{1'b0}};
end

wire [WORD-1:0] temp;

MUX_8_1 #(.WORD(WORD)) mux1(
.select({reset, write_enable, incr}),
.IN_0(OUT),
.IN_1(OUT + 1'b1),
.IN_2(DATA),
.IN_3(DATA),
.IN_4({WORD{1'b0}}),
.IN_5({WORD{1'b0}}),
.IN_6({WORD{1'b0}}),
.IN_7({WORD{1'b0}}),
.OUT(temp)
);

always @(posedge clk) begin
	OUT <= temp;
end

endmodule
