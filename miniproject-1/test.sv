module top(
    input logic     clk, 
    // output logic RGB_B,
    // output logic RGB_G,
    output logic RGB_R
);

    // CLK frequency is 12MHz, so 6,000,000 cycles is 0.5s
    parameter BLINK_INTERVAL = 12000000;
    logic [$clog2(BLINK_INTERVAL) - 1:0] count = 0;

    initial begin
        RGB_R = 1'b1;
        RGB_G = 1'b0;
        RGB_B = 1'b0;
    end
    
    // localparam RED = 3'b100;
    // logic [2:0] color = RED;

    always_ff @(posedge clk) begin
        // RGB_R = color[0];
        // RGB_G = color[1];
        // RGB_B = color[2];
        RGB_R = 1'b0;
        // RGB_G = 1'b0;
        // RGB_B = 1'b0;

    end

endmodule

// module top(
//     input logic     clk, 
//     output logic    RGB_R
// );

//     // CLK frequency is 12MHz, so 6,000,000 cycles is 0.5s
//     parameter BLINK_INTERVAL = 12000000;
//     logic [$clog2(BLINK_INTERVAL) - 1:0] count = 0;

//     initial begin
//         RGB_R = 1'b1;
//     end

//     always_ff @(posedge clk) begin
//         if (count == BLINK_INTERVAL - 1) begin
//             count <= 0;
//             RGB_R <= ~RGB_R;
//         end
//         else begin
//             count <= count + 1;
//         end
//     end

// endmodule

