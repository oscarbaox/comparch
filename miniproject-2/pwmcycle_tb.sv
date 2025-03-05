`timescale 10ns/10ns
`include "pwmcycle.sv"

module pwmcycle_tb;

    parameter PWM_INTERVAL = 1200;

    logic clk = 0;
    logic RGB_R;
    logic RGB_G;
    logic RGB_B;

    top # (
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u0 (
        .clk            (clk), 
        .RGB_R          (RGB_R),
        .RGB_G          (RGB_G),
        .RGB_B          (RGB_B)
    );

    initial begin
        $dumpfile("pwmcycle.vcd");
        $dumpvars(0, pwmcycle_tb);
        #100000000
        $finish;
    end

    always begin
        #4
        clk = ~clk;
    end

endmodule

