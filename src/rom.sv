module rom #(
    parameter ADDR_WIDTH = 17,
    parameter DATA_WIDTH = 13
)(
    input logic clk,
    input logic [ADDR_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] q
);

    // declare the ROM
    logic [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

    // initialize ROM contents
    initial begin
        $readmemh("spritesheet.hex", mem);
    end

    // synchronous read
    always_ff @(posedge clk) begin
        q <= mem[addr];
    end

endmodule
