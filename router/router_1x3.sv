module router_1x3 (
    input  logic        clk,
    input  logic        rst,
    input  logic [7:0]  data_in,
    input  logic        valid_in,
    input  logic [1:0]  addr,
    output logic [7:0]  data_out[3],
    output logic        valid_out[3]
);
    logic [2:0] sel_out;
    logic [7:0] reg_out;
    logic [7:0] fifo_out[3];
    logic       fifo_empty[3];

    router_fsm fsm_inst (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .addr(addr),
        .sel_out(sel_out)
    );

    router_register reg_inst (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .load(valid_in),
        .data_out(reg_out)
    );

    generate
        genvar i;
        for (i = 0; i < 3; i++) begin : fifo_gen
            router_fifo fifo_inst (
                .clk(clk),
                .rst(rst),
                .data_in(reg_out),
                .wr_en(sel_out[i] && valid_in),
                .rd_en(!fifo_empty[i]),
                .data_out(fifo_out[i]),
                .empty(fifo_empty[i])
            );
        end
    endgenerate

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out[0]  <= 8'b0;
            data_out[1]  <= 8'b0;
            data_out[2]  <= 8'b0;
            valid_out[0] <= 1'b0;
            valid_out[1] <= 1'b0;
            valid_out[2] <= 1'b0;
        end else begin
            for (int i = 0; i < 3; i++) begin
                data_out[i]  <= fifo_out[i];
                valid_out[i] <= !fifo_empty[i];
            end
        end
    end
endmodule

