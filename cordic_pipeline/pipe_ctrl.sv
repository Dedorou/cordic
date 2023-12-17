module pipe_ctrl #(
parameter PIPE_WIDTH = 6
)(
input  logic                      aclk,
input  logic                      aresetn,
output logic [PIPE_WIDTH - 1 : 0] en_o,

input  logic                      tvalid_data_i,
output logic                      tready_data_i,
                    
output logic                      tvalid_data_o,
input  logic                      tready_data_o
);

logic tvalid [PIPE_WIDTH : 0];
logic tready [PIPE_WIDTH : 0];

assign tvalid[0]          = tvalid_data_i;
assign tready[PIPE_WIDTH] = tready_data_o;

generate
  for (genvar i = 0; i < PIPE_WIDTH; i = i + 1) begin 
    pipe_ctrl_stage pipe_ctrl_stage(
      .aclk      (aclk), 
      .aresetn   (aresetn),
      .en        (en_o[i]),
      .us_tvalid (tvalid[i]),
      .us_tready (tready[i]),
      .ds_tvalid (tvalid[i + 1]),
      .ds_tready (tready[i + 1])
    ); 

  end
endgenerate

assign tvalid_data_o = tvalid[PIPE_WIDTH];
assign tready_data_i = tready[0];

endmodule 

module pipe_ctrl_stage (
input  logic aclk, 
input  logic aresetn,

output logic en,

input  logic us_tvalid,
output logic us_tready,

output logic ds_tvalid,
input  logic ds_tready
);

always_ff @(posedge aclk) begin 
  if (!aresetn) begin 
    ds_tvalid <= 0;
  end else if (us_tready) begin 
    ds_tvalid <= us_tvalid;
  end
end

assign us_tready = ds_tready || (!ds_tvalid);
assign en = us_tvalid;

endmodule 