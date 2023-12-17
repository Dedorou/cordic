module cordic_pipe #(
parameter DATA_WIDTH = 16,
parameter ITERATION_CNT = 6
)(
input  logic                         aclk,
input  logic [ITERATION_CNT - 1 : 0] en,

input  logic [   DATA_WIDTH - 1 : 0] x_i,
input  logic [   DATA_WIDTH - 1 : 0] y_i,
input  logic [               31 : 0] z_i,
         
output logic [   DATA_WIDTH - 1 : 0] x_o,
output logic [   DATA_WIDTH - 1 : 0] y_o,
output logic [               31 : 0] z_o
);

logic [DATA_WIDTH - 1 : 0] x_pipe [0 : ITERATION_CNT];
logic [DATA_WIDTH - 1 : 0] y_pipe [0 : ITERATION_CNT];
logic [            31 : 0] z_pipe [0 : ITERATION_CNT];

assign x_pipe[0] = x_i;
assign y_pipe[0] = y_i;
assign z_pipe[0] = z_i;

generate
  for(genvar i = 0; i < ITERATION_CNT; i = i + 1) begin 
    coedic_pipe_stage #(
      .STAGE_NUMBER (i),
      .DATA_WIDTH   (DATA_WIDTH)
    ) coedic_pipe_stage (
      .clk(aclk),
      .en (en[i]),
      .x_i(x_pipe[i]),
      .y_i(y_pipe[i]),
      .z_i(z_pipe[i]),
      .x_o(x_pipe[i + 1]),
      .y_o(y_pipe[i + 1]),
      .z_o(z_pipe[i + 1])
    );
  end
endgenerate

//scaler x_scaler (
// .data_i ( x_pipe[ITERATION_CNT - 1]),
// .data_o (x_o)
//);
//
//scaler y_scaler (
// .data_i (y_pipe[ITERATION_CNT - 1]),
// .data_o (y_o)
//);

assign x_o = x_pipe[ITERATION_CNT];
assign y_o = y_pipe[ITERATION_CNT];
assign z_o = z_pipe[ITERATION_CNT];



endmodule