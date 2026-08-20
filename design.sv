// UART TX/RX IP CORE
// 8-bit data, 1 start bit, 1 stop bit, no parity (8-N-1)

module uart_tx #(
    parameter CLKS_PER_BIT = 10
)(
    input        clk,
    input        rst,
    input        tx_start,
    input  [7:0] tx_data,
    output reg   tx,
    output reg   tx_busy
);

    reg [2:0]  bit_count;
    reg [7:0]  data_reg;
    reg [15:0] clk_count;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            tx        <= 1'b1;
            tx_busy   <= 1'b0;
            bit_count <= 0;
            clk_count <= 0;
            data_reg  <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    clk_count <= 0;
                    if (tx_start) begin
                        data_reg <= tx_data;
                        tx_busy <= 1'b1;
                        tx <= 1'b0;
                        bit_count <= 0;
                        state <= START;
                    end
                end

                START: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        state <= DATA;
                        tx <= data_reg[0];
                    end
                    else clk_count <= clk_count + 1;
                end

                DATA: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        if (bit_count == 7) begin
                            state <= STOP;
                            tx <= 1'b1;
                        end
                        else begin
                            bit_count <= bit_count + 1;
                            tx <= data_reg[bit_count + 1];
                        end
                    end
                    else clk_count <= clk_count + 1;
                end

                STOP: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        state <= IDLE;
                        tx <= 1'b1;
                        tx_busy <= 1'b0;
                    end
                    else clk_count <= clk_count + 1;
                end
            endcase
        end
    end
endmodule


module uart_rx #(
    parameter CLKS_PER_BIT = 10
)(
    input        clk,
    input        rst,
    input        rx,
    output reg [7:0] rx_data,
    output reg       rx_valid
);

    reg [15:0] clk_count;
    reg [2:0]  bit_count;
    reg [7:0]  data_reg;

    localparam RX_IDLE  = 2'b00;
    localparam RX_START = 2'b01;
    localparam RX_DATA  = 2'b10;
    localparam RX_STOP  = 2'b11;

    reg [1:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state <= RX_IDLE;
            clk_count <= 0;
            bit_count <= 0;
            data_reg <= 0;
            rx_data <= 0;
            rx_valid <= 0;
        end
        else begin
            rx_valid <= 1'b0;

            case (state)
                RX_IDLE: begin
                    clk_count <= 0;
                    bit_count <= 0;
                    if (rx == 1'b0) state <= RX_START;
                end

                RX_START: begin
                    if (clk_count == (CLKS_PER_BIT/2)-1) begin
                        if (rx == 1'b0) begin
                            clk_count <= 0;
                            state <= RX_DATA;
                        end
                        else state <= RX_IDLE;
                    end
                    else clk_count <= clk_count + 1;
                end

                RX_DATA: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        data_reg[bit_count] <= rx;
                        if (bit_count == 7) begin
                            bit_count <= 0;
                            state <= RX_STOP;
                        end
                        else bit_count <= bit_count + 1;
                    end
                    else clk_count <= clk_count + 1;
                end

                RX_STOP: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        if (rx == 1'b1) begin
                            rx_data <= data_reg;
                            rx_valid <= 1'b1;
                        end
                        state <= RX_IDLE;
                    end
                    else clk_count <= clk_count + 1;
                end
            endcase
        end
    end
endmodule
