module scaler #(
parameter WIDTH = 16
)(
input  logic [WIDTH - 1 : 0] data_i,
output logic [WIDTH - 1 : 0] data_o
);

localparam [31 : 0] K = 32'h4dbaa9b5;
//logic      [63 : 0] mul;
//logic      [31 : 0] data_ext;
//
//assign data_ext = {data_i,{(32 - WIDTH){1'b0}}};
//assign mul     = data_ext * K;
//assign data_o  = mul[63 : 63 - (WIDTH - 1)];

assign data_o = data_i * K;

endmodule 