import constants_pkg::*;

module pipe #(
    parameter int GAP_SIZE = 100,
    parameter int SCALE = 2
) (
    input logic signed [10:0] x,
    input logic signed [10:0] y,

    input logic display,

    input logic signed [10:0] h_count,
    input logic signed [10:0] v_count,

    output logic [12:0] pixel
);


    logic [12:0] top_pixel, bottom_pixel;

    sprite #(.ROM(PIPE_TOP_ROM), .WIDTH(PIPE_TOP_WIDTH), .HEIGHT(PIPE_TOP_HEIGHT), .SCALE(SCALE)) pipe_top (
        .x(x), .y(y - PIPE_TOP_HEIGHT*SCALE - GAP_SIZE), .display(display), .h_count(h_count), .v_count(v_count), .pixel(top_pixel)
    );

    sprite #(.ROM(PIPE_BOTTOM_ROM), .WIDTH(PIPE_BOTTOM_WIDTH), .HEIGHT(PIPE_BOTTOM_HEIGHT), .SCALE(SCALE)) pipe_bottom (
        .x(x), .y(y), .display(display), .h_count(h_count), .v_count(v_count), .pixel(bottom_pixel)
    );

    assign pixel = top_pixel | bottom_pixel;

endmodule