import constants_pkg::*;

module bird #(
    parameter int SCALE = 2
) (
    input logic signed [10:0] x,
    input logic signed [10:0] y,
    input logic [1:0] selected,

    input logic display,

    input logic signed [10:0] h_count,
    input logic signed [10:0] v_count,

    output logic [12:0] pixel
);

    logic [12:0] bird1_pixel, bird2_pixel, bird3_pixel;

    sprite #(.ROM(BIRD1_ROM), .WIDTH(BIRD1_WIDTH), .HEIGHT(BIRD1_HEIGHT), .SCALE(SCALE)) bird1 (
        .x(x), .y(y), .display(display), .h_count(h_count), .v_count(v_count), .pixel(bird1_pixel)
    );

    sprite #(.ROM(BIRD2_ROM), .WIDTH(BIRD2_WIDTH), .HEIGHT(BIRD2_HEIGHT), .SCALE(SCALE)) bird2 (
        .x(x), .y(y), .display(display), .h_count(h_count), .v_count(v_count), .pixel(bird2_pixel)
    );

    sprite #(.ROM(BIRD3_ROM), .WIDTH(BIRD3_WIDTH), .HEIGHT(BIRD3_HEIGHT), .SCALE(SCALE)) bird3 (
        .x(x), .y(y), .display(display), .h_count(h_count), .v_count(v_count), .pixel(bird3_pixel)
    );

    always_comb begin
        case (selected)
            0: pixel = bird1_pixel;
            1: pixel = bird2_pixel;
            2: pixel = bird3_pixel;
            3: pixel = bird2_pixel;
            default: pixel = '0;
        endcase
    end


endmodule