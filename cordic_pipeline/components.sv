module mux_2_1 #(
parameter WIDTH = 10
)(    
input  logic [WIDTH - 1 : 0] a, 
input  logic [WIDTH - 1 : 0] b, 
input  logic                 sel,
 
output logic [WIDTH - 1 : 0] y
);

assign y = sel ? b : a; 

endmodule

module param_reg #(
parameter WIDTH = 20
)(
input  logic                 clk,
input  logic                 rst,
input  logic                 en,
input  logic [WIDTH - 1 : 0] d,

output logic [WIDTH - 1 : 0] q
);

always_ff @(posedge clk) begin
  if (rst) 
    q <= 'h0;
  else if (en)
    q <= d;
end

endmodule 

module param_reg_no_rst #(
parameter WIDTH = 20
)(
input  logic                 clk,
input  logic                 en,
input  logic [WIDTH - 1 : 0] d,

output logic [WIDTH - 1 : 0] q
);

always_ff @(posedge clk) begin
  if (en)
    q <= d;
end

endmodule 
