module top (
    input logic clk,  
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

    initial begin
        RGB_R = 1'b1;
        RGB_G = 1'b1;
        RGB_B = 1'b1;
    end

    localparam SIXTY_DEGREE = 2000000;
    localparam INC_DEC_INTERVAL = 20000;
    localparam INC_DEC_MAX = SIXTY_DEGREE / INC_DEC_INTERVAL;
    parameter PWM_INTERVAL = 1200;       // CLK frequency is 12MHz, so 1,200 cycles is 100us
    localparam INC_DEC_VAL = PWM_INTERVAL / INC_DEC_MAX;
    

    // Define state variable values
    localparam PWM_INC = 1'b0;
    localparam PWM_DEC = 1'b1;

    // Declare state variables
    logic current_state = PWM_INC;
    logic next_state;

    // Declare variables for timing state transitions
    logic [$clog2(INC_DEC_INTERVAL) - 1:0] count = 0;
    logic [$clog2(INC_DEC_MAX) - 1:0] inc_dec_count = 0;
    logic time_to_inc_dec = 1'b0;
    logic time_to_transition = 1'b0;

    // Declare PWM generator counter variable
    logic [$clog2(PWM_INTERVAL) - 1:0] pwm_count = 0;

    logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value = 0;
    logic pwm_out;

    logic [$clog2(12000000) -1:0] overall_count = 0;

    initial begin
        pwm_value = 0;
    end

    // Register the next state of the FSM
    always_ff @(posedge time_to_transition)
        current_state <= next_state;

    // Compute the next state of the FSM
    always_comb begin
        next_state = 1'bx;
        case (current_state)
            PWM_INC:
                next_state = PWM_DEC;
            PWM_DEC:
                next_state = PWM_INC;
        endcase
    end

    // Implement counter for incrementing / decrementing PWM value
    always_ff @(posedge clk) begin
        if (count == INC_DEC_INTERVAL - 1) begin
            count <= 0;
            time_to_inc_dec <= 1'b1;
        end
        else begin
            count <= count + 1;
            time_to_inc_dec <= 1'b0;
        end
    end

    // Increment / Decrement PWM value as appropriate given current state
    always_ff @(posedge time_to_inc_dec) begin
        case (current_state)
            PWM_INC:
                pwm_value <= pwm_value + INC_DEC_VAL;
            PWM_DEC:
                pwm_value <= pwm_value - INC_DEC_VAL;
        endcase
    end

    // Implement counter for timing state transitions
    always_ff @(posedge time_to_inc_dec) begin
        if (inc_dec_count == INC_DEC_MAX - 1) begin
            inc_dec_count <= 0;
            time_to_transition <= 1'b1;
        end
        else begin
            inc_dec_count <= inc_dec_count + 1;
            time_to_transition <= 1'b0;
        end
    end


    // Implement counter for timing transition in PWM output signal
    always_ff @(posedge clk) begin
        if (pwm_count == PWM_INTERVAL - 1) begin
            pwm_count <= 0;
        end
        else begin
            pwm_count <= pwm_count + 1;
        end
        // Generate PWM output signal
        pwm_out = (pwm_count > pwm_value) ? 1'b0 : 1'b1;
    end


    // Handy state machine to define each color's behavior
    always_ff @(posedge clk) begin
        if (overall_count < SIXTY_DEGREE) begin
            RGB_R <= 1'b0;
            RGB_G <= ~pwm_out;
            RGB_B <= 1'b1;
        end
        else if (overall_count >= SIXTY_DEGREE && overall_count < 2*SIXTY_DEGREE) begin
            RGB_R <= ~pwm_out;
            RGB_G <= 1'b0;
            RGB_B <= 1'b1;
        end
        else if (overall_count >= 2*SIXTY_DEGREE && overall_count < 3*SIXTY_DEGREE) begin
            RGB_R <= 1'b1;
            RGB_G <= 1'b0;
            RGB_B <= ~pwm_out;
        end
        else if (overall_count >= 3*SIXTY_DEGREE && overall_count < 4*SIXTY_DEGREE) begin
            RGB_R <= 1'b1;
            RGB_G <= ~pwm_out;
            RGB_B <= 1'b0;
        end
        else if (overall_count >= 4*SIXTY_DEGREE && overall_count < 5*SIXTY_DEGREE) begin
            RGB_R <= ~pwm_out;
            RGB_G <= 1'b1;
            RGB_B <= 1'b0;
        end
        else if (overall_count >= 5*SIXTY_DEGREE && overall_count < 6*SIXTY_DEGREE) begin
            RGB_R <= 1'b0;
            RGB_G <= 1'b1;
            RGB_B <= ~pwm_out;
        end
        else begin
            overall_count <= 0;
            RGB_R <= 1'b1;
            RGB_G <= 1'b1;
            RGB_B <= 1'b1;
        end
        overall_count <= overall_count + 1;
    end



endmodule
