module router_synchronizer (
    input  logic clk,
    input  logic rst,
    input  logic async_signal,
    output logic sync_signal
);
    logic meta_ff;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            meta_ff    <= 1'b0;
            sync_signal <= 1'b0;
        end else begin
            meta_ff    <= async_signal;
            sync_signal <= meta_ff;
        end
    end
endmodule

