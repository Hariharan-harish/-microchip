module router_tb;
    logic clk, rst, valid_in;
    logic [7:0] data_in;
    logic [1:0] addr;
    logic [7:0] data_out[3];
    logic valid_out[3];

    router_1x3 uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .valid_in(valid_in),
        .addr(addr),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; valid_in = 0;
        #10 rst = 0;

        #10 data_in = 8'hAA; addr = 2'b00; valid_in = 1;
        #10 valid_in = 0;

        #10 data_in = 8'hBB; addr = 2'b01; valid_in = 1;
        #10 valid_in = 0;

        #10 data_in = 8'hCC; addr = 2'b10; valid_in = 1;
        #10 valid_in = 0;

        #50 $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, router_tb);
        $monitor("Time=%0t | Data In=%h | Addr=%b | Out0=%h | Out1=%h | Out2=%h",
            $time, data_in, addr, data_out[0], data_out[1], data_out[2]);
    end
endmodule

