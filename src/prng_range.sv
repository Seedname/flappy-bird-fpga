module prng_range #(
    parameter int MIN, // min value of range
    parameter int MAX, // max value of range
    parameter int NUM_RANGES, // number of random values to output
    parameter int NUM_BITS // number of bits to use for each random value 
)(
    input logic [63:0] input_val,
    output logic [NUM_BITS-1:0] output_val [0:NUM_RANGES-1]
);    
    
    initial begin
        assert (MAX > MIN) else $fatal("MAX must be greater than MIN");
        assert (NUM_RANGES * NUM_BITS <= 64) else $fatal("NUM_RANGES * NUM_BITS must be <= 64");
        assert ($clog2(MAX) <= NUM_BITS) else $fatal("Not enough bits for range");
    end

    parameter int RANGE = MAX - MIN;

    always_comb begin
        for (int i = 0; i < NUM_RANGES; i++) begin
            logic [2*NUM_BITS-1:0] mult;
            logic [NUM_BITS-1:0] shifted;
            mult = input_val[i*NUM_BITS +: NUM_BITS] * RANGE; // multiply each random value by the range
            shifted = mult >> NUM_BITS; // divide by 2^NUM_BITS
            output_val[i] = shifted + MIN; // add lower bound
        end
    end

endmodule