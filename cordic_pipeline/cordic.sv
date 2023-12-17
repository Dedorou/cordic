module cordic #(
parameter DATA_WIDTH = 16,
parameter ITERATION_CNT = 12
)(
input  logic                      aclk,
input  logic                      aresetn,

input  logic                      tvalid_data_i,
output logic                      tready_data_i,

input  logic [DATA_WIDTH - 1 : 0] x_i,
input  logic [DATA_WIDTH - 1 : 0] y_i,
input  logic [            31 : 0] z_i,

output logic                      tvalid_data_o,
input  logic                      tready_data_o,

output logic [DATA_WIDTH - 1 : 0] x_o,
output logic [DATA_WIDTH - 1 : 0] y_o,
output logic [            31 : 0] z_o
);

logic [ITERATION_CNT - 1 : 0] en;

pipe_ctrl #(
  .PIPE_WIDTH(ITERATION_CNT)
) pipe_ctrl (
  .aclk         (aclk),
  .aresetn      (aresetn),
  .en_o         (en),
  .tvalid_data_i(tvalid_data_i),
  .tready_data_i(tready_data_i),       
  .tvalid_data_o(tvalid_data_o),
  .tready_data_o(tready_data_o)
);

cordic_pipe #(
  .DATA_WIDTH   (DATA_WIDTH),
  .ITERATION_CNT(ITERATION_CNT)
) cordic_pipe (
  .aclk(aclk),
  .en (en),
  .x_i(x_i),
  .y_i(y_i),
  .z_i(z_i),
  .x_o(x_o),
  .y_o(y_o),
  .z_o(z_o)
);

endmodule 