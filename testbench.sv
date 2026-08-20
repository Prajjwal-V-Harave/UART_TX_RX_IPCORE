module testbench;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;
wire [7:0] rx_data;
wire rx_valid;

uart_tx #(.CLKS_PER_BIT(10)) transmitter (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

uart_rx #(.CLKS_PER_BIT(10)) receiver (
    .clk(clk),
    .rst(rst),
    .rx(tx),
    .rx_data(rx_data),
    .rx_valid(rx_valid)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, testbench);

    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 0;

    #20;
    rst = 0;

    // Test 1
    tx_data = 8'hA5;
    tx_start = 1;
    #10;
    tx_start = 0;
    #1100;

    // Test 2
    tx_data = 8'h3C;
    tx_start = 1;
    #10;
    tx_start = 0;
    #1100;

    $finish;
end

always @(posedge rx_valid) begin
    $display("UART RECEIVED: 0x%h (%d)", rx_data, rx_data);
end

endmodule
