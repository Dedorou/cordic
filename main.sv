module cordic #(
parameter    WIDTH = 16,
parameter    ITERATION_CNT = 6    
)(
input  logic clk,
input  logic rst,

input  logic [WIDTH - 1 : 0] x_i,
input  logic [WIDTH - 1 : 0] y_i,
input  logic [       31 : 0] z_i,
 
output logic [WIDTH - 1 : 0] x_o,
output logic [WIDTH - 1 : 0] y_o
);

//localparam ADDR_WIDTH = $clog2(ITERATION_CNT);



logic          reg_en;
logic          mux_ctrl;
logic          z_sign;
logic [31 : 0] atan;
logic [4  : 0] atan_addr;

logic [4 : 0] counter;
logic counter_en;
always_ff @(posedge clk) begin 
  if (rst) 
    counter <= 0;
  else if (counter_en) 
    counter <= counter + 1;
end
assign atan_addr = counter;

logic signed [WIDTH - 1 : 0] x_mux_o;
logic signed [WIDTH - 1 : 0] y_mux_o;
logic signed [31 : 0] z_mux_o;

logic signed [WIDTH - 1 : 0] x_reg_o;
logic signed [WIDTH - 1 : 0] y_reg_o;
logic signed [31 : 0] z_reg_o;

logic signed [WIDTH - 1 : 0] x_reg_sh;
logic signed [WIDTH - 1 : 0] y_reg_sh;

logic signed [WIDTH - 1 : 0] x_addsub;
logic signed [WIDTH - 1 : 0] y_addsub;
logic signed [31 : 0] z_addsub;

assign z_sign   = z_reg_o[31];

assign x_reg_sh = x_reg_o >>> counter;
assign y_reg_sh = y_reg_o >>> counter;

assign x_addsub = z_sign ? x_reg_o + y_reg_sh : x_reg_o - y_reg_sh;
assign y_addsub = z_sign ? y_reg_o - x_reg_sh : y_reg_o + x_reg_sh;
assign z_addsub = z_sign ? z_reg_o + atan     : z_reg_o - atan;

atan_table atan_table (
 .addr   (atan_addr),
 .data_o (atan)
);

mux_2_1 #(
  .WIDTH (WIDTH)
) x_mux (
  .a   (x_i),
  .b   (x_addsub),
  .sel (mux_ctrl),
  .y   (x_mux_o)
);

mux_2_1 #(
  .WIDTH (WIDTH)
) y_mux (
  .a   (y_i),
  .b   (y_addsub),
  .sel (mux_ctrl),
  .y   (y_mux_o)
);

mux_2_1 #(
  .WIDTH (32)
) z_mux (
  .a   (z_i),
  .b   (z_addsub),
  .sel (mux_ctrl),
  .y   (z_mux_o)
);

param_reg #(
  .WIDTH (WIDTH)
) x_input_reg (
  .clk (clk),
  .rst (rst),
  .en  (reg_en),
  .d   (x_mux_o),
  .q   (x_reg_o)
);

param_reg #(
  .WIDTH (WIDTH)
) y_input_reg (
  .clk (clk),
  .rst (rst),
  .en  (reg_en),
  .d   (y_mux_o),
  .q   (y_reg_o)
);

param_reg #(
  .WIDTH (32)
) z_input_reg (
  .clk (clk),
  .rst (rst),
  .en  (reg_en),
  .d   (z_mux_o),
  .q   (z_reg_o)
);

scaler x_scaler (
 .data_i (x_addsub),
 .data_o (x_o)
);

scaler y_scaler (
 .data_i (y_addsub),
 .data_o (y_o)
);

endmodule 