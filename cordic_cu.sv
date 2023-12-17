module cordic_cu #(
parameter ITERATION_CNT = 6    
)(
input  logic         clk,
input  logic         rst,
input  logic         en,
output logic         mux_ctrl,
output logic [4 : 0] atan_addr
);

logic [$clog2(ITERATION_CNT) - 1 : 0] counter; 

always_ff @(posedge clk) begin 
  if (rst | (state == IDLE)) 
    counter <= 'h0;
  else if (counter_en)
    counter <= counter + 1;
end

assign atan_addr = counter;

enum logic
{
  IDLE        = 2'b0,
  LOAD_INPUT  = 2'b1,
  WORK        = 2'b2,
  LOAD_OUTPUT = 2'd3
}
state, next_state;

always_ff @(posedge clk) begin 
  if (rst)  
    state <= IDLE;
  else
    state <= next_state;
end

always_comb begin 
  next_state = state;
  case (state)
    IDLE : begin 
      mux_ctrl = 0;
      counter_en = 0;
    end
  endcase
end

endmodule