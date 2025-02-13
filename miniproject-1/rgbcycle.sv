module top(
    input logic     clk, 
    output logic RGB_B,
    output logic RGB_G,
    output logic RGB_R
);

    // CLK frequency is 12MHz, so 6,000,000 cycles is 0.5s
    parameter BLINK_INTERVAL = 12000000;
    logic [$clog2(BLINK_INTERVAL) - 1:0] count = 0;

    initial begin
        RGB_R = 1'b1;
        RGB_G = 1'b1;
        RGB_B = 1'b1;
    end

    localparam INITIAL = 3'b111;
    localparam RED = 3'b011;
    localparam YELLOW = 3'b001;
    localparam GREEN = 3'b101;
    localparam CYAN = 3'b100;
    localparam BLUE = 3'b110;
    localparam MAGENTA = 3'b010;

    logic [0:2] color = INITIAL;

    always_ff @(posedge clk) begin
        if (count == BLINK_INTERVAL - 1) begin
            count <= 0;
            case (color)
                INITIAL:
                    color <= RED;
                RED:
                    color <= YELLOW;
                YELLOW:
                    color <= GREEN;
                GREEN:
                    color <= CYAN;
                CYAN:
                    color <= BLUE;
                BLUE:
                    color <= MAGENTA;
                MAGENTA:
                    color <= RED;
            endcase
            RGB_R <= color[0];
            RGB_G <= color[1];
            RGB_B <= color[2];
        end
        else begin
            count <= count + 1;
        end
    end

endmodule
