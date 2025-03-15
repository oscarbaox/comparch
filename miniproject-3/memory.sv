// Sample memory module

module memory #(
    parameter INIT_FILE = ""
)(
    input logic     clk,
    input logic     [8:0] read_address,
    output logic    [9:0] read_data
);
    logic [8:0] sample_1 = 0;
    logic [8:0] sample_2 = 256;

    // Declare memory array for storing 128 9-bit samples of a sine function
    logic [8:0] sample_memory [0:127];

    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, sample_memory);
    end

    always_ff @(posedge clk) begin
        if (read_address < 128) begin
            sample_1 <= sample_memory[read_address];
            read_data <= sample_1 * 2;
        end
        else if (read_address >= 128 && read_address < 256) begin
            sample_1 <= sample_memory[255 - read_address];
            read_data <= sample_1 * 2;
        end
        else if (read_address >= 256 && read_address < 384) begin
            sample_1 <= sample_memory[read_address - 256];
            sample_2 <= 512 - sample_1;
            read_data <= sample_2 * 2;
        end
        else if (read_address >= 384 && read_address < 512) begin
            sample_1 <= sample_memory[511 - read_address];
            sample_2 <= 512 - sample_1;
            read_data <= sample_2 * 2;
        end

    end

endmodule
