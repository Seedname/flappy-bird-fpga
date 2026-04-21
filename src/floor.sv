module floor #(
    parameter int SCALE = 2
) (
    input logic signed [10:0] x,
    input logic signed [10:0] y,
    input logic [4:0] offset, // offset from 0 to 9

    input logic display,

    input logic signed [10:0] h_count,
    input logic signed [10:0] v_count,

    output [12:0] pixel
);

    // each sprite has its own rom. 13-bit data for 12 bit color + transparency
    logic [12:0] rom [0:FLOOR_WIDTH*FLOOR_HEIGHT-1];

    // initialize ROM contents
    initial begin
        $readmemh(FLOOR_ROM, rom);
    end

    logic in_bounds;
    assign in_bounds = (h_count - x >= 0 && h_count - x < FLOOR_WIDTH*SCALE && v_count - y >= 0 && v_count - y < FLOOR_HEIGHT*SCALE);

    logic [12:0] value;
    // if out of bounds, value=0. otherwise, read the address
    assign value = in_bounds ? rom[(v_count - y) / SCALE * FLOOR_WIDTH + ((h_count - x) / SCALE + offset) % 7] : 0;

    logic enabled;
    // only draw the pixel if it's in bounds, not transparent, and displayed
    assign enabled = !value[12] && in_bounds && display;

    // pixel is enabled + lower 12 bits
    assign pixel = {enabled, value[11:0]};

endmodule