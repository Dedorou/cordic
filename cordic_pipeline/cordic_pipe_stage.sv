module coedic_pipe_stage #(
parameter [4 : 0] STAGE_NUMBER = 5,
parameter         DATA_WIDTH   = 16
)(
input  logic clk,
input  logic en,

input  logic [DATA_WIDTH - 1 : 0] x_i,
input  logic [DATA_WIDTH - 1 : 0] y_i,
input  logic [            31 : 0] z_i,
 
output logic [DATA_WIDTH - 1 : 0] x_o,
output logic [DATA_WIDTH - 1 : 0] y_o,
output logic [            31 : 0] z_o
);

logic          z_sign;
logic [31 : 0] atan;

logic signed [DATA_WIDTH - 1 : 0] x_sh;
logic signed [DATA_WIDTH - 1 : 0] y_sh;

logic signed [DATA_WIDTH - 1 : 0] x_addsub;
logic signed [DATA_WIDTH - 1 : 0] y_addsub;
logic signed [            31 : 0] z_addsub;

assign z_sign = z_i[31];

assign x_sh = $signed(x_i) >>> STAGE_NUMBER;
assign y_sh = $signed(y_i) >>> STAGE_NUMBER;

assign x_addsub = z_sign ? x_i + y_sh : x_i - y_sh;
assign y_addsub = z_sign ? y_i - x_sh : y_i + x_sh;
assign z_addsub = z_sign ? z_i + atan : z_i - atan;

param_reg_no_rst #(
  .WIDTH (DATA_WIDTH)
) x_reg (
  .clk (clk),
  .en  (en),
  .d   (x_addsub),
  .q   (x_o)
);

param_reg_no_rst #(
  .WIDTH (DATA_WIDTH)
) y_reg (
  .clk (clk),
  .en  (en),
  .d   (y_addsub),
  .q   (y_o)
);

param_reg_no_rst #(
  .WIDTH (32)
) z_reg (
  .clk (clk),
  .en  (en),
  .d   (z_addsub),
  .q   (z_o)
);

atan_table_pipe #(
  .addr   (STAGE_NUMBER)
) atan_table (
  .data_o (atan)
);

endmodule 