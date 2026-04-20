module prng (
    input logic clk,
    input logic rst,
    input logic enable,
    output logic [63:0] output_val
);

    logic [63:0] s0 = 64'h1;
    logic [63:0] s1 = 64'h2;
    logic [63:0] result = 0;

    // rotate left function
    function automatic [63:0] rotl(input [63:0] x, input int k);
        return (x << k) | (x >> (64 - k));
    endfunction

    always_ff @(posedge clk) begin
        if (rst) begin
            // start with nonzero seeds
            s0 <= 64'h1;
            s1 <= 64'h2;
            result <= 0;
        end else if (enable) begin
            // preserve old state
            logic [63:0] s0_old, s1_old;
            logic [63:0] s1_xor;

            s0_old = s0;
            s1_old = s1;

            // result
            result <= rotl(s0_old * 5, 7) * 9;

            // xor step
            s1_xor = s1_old ^ s0_old;

            // state update
            s0 <= rotl(s0_old, 24) ^ s1_xor ^ (s1_xor << 16);
            s1 <= rotl(s1_xor, 37);
        end
    end

    assign output_val = result;

endmodule