module router_fifo #(
    parameter DEPTH = 4
)(
    input  logic        clk,
    input  logic        rst,
    input  logic [7:0]  data_in,
    input  logic        wr_en,
    input  logic        rd_en,
    output logic [7:0]  data_out,
    output logic        empty,
    output logic        full
);

    logic [7:0] fifo_mem [DEPTH-1:0];
    logic [2:0] wr_ptr, rd_ptr, count;

    assign empty = (count == 0);
    assign full  = (count == DEPTH);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
        end else begin
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
                count  <= count + 1;
            end
            if (rd_en && !empty) begin
                data_out <= fifo_mem[rd_ptr];
                rd_ptr   <= rd_ptr + 1;
                count    <= count - 1;
            end
        end
    end
endmodule

