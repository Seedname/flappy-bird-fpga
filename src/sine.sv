module sine (
    input clk,
    input logic [8:0] angle, // 0-511 "degrees"
    output logic signed [10:0] out // 1024 * sin(angle)
);
    // lookup table
    logic signed [10:0] lut[0:128];

    // retrieve lookup table from file
    initial begin
        $readmemh("sine_lut.hex", lut);
    end

    // lookup table index
    logic [7:0] index;
    logic [1:0] quadrant;
 
    always_comb begin
        quadrant = angle / 128;

        unique case (quadrant)
            0: index = angle; // sin(angle)
            1: index = 256 - angle; // sin(256-angle)
            2: index = angle - 256; // -sin(angle-256)
            3: index = 512 - angle; // -sin(512-angle)
        endcase

        out = (quadrant < 2) ? lut[index] : -lut[index];
    end

endmodule