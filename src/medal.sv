module medal #(
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

    logic [12:0] bronze_medal, silver_medal, gold_medal, platinum_medal;

    sprite #(.ROM(BRONZE_ROM), .WIDTH(BRONZE_WIDTH), .HEIGHT(BRONZE_HEIGHT), .SCALE(SCALE)) bronze (
        .x(x), .y(y), .display(display), .h_count(h_count), .v_count(v_count), .pixel(bronze_medal)
    );

    sprite #(.ROM(SILVER_ROM), .WIDTH(SILVER_WIDTH), .HEIGHT(SILVER_HEIGHT), .SCALE(SCALE)) silver (
        .x(x), .y(y), .display(display), .h_count(h_count), .v_count(v_count), .pixel(silver_medal)
    );

    sprite #(.ROM(GOLD_ROM), .WIDTH(GOLD_WIDTH), .HEIGHT(GOLD_HEIGHT), .SCALE(SCALE)) gold (
        .x(x), .y(y), .display(display), .h_count(h_count), .v_count(v_count), .pixel(gold_medal)
    );

    sprite #(.ROM(PLATINUM_ROM), .WIDTH(PLATINUM_WIDTH), .HEIGHT(PLATINUM_HEIGHT), .SCALE(SCALE)) platinum (
        .x(x), .y(y), .display(display), .h_count(h_count), .v_count(v_count), .pixel(platinum_medal)
    );

    always_comb begin
        case (selected)
            0: pixel = bronze_medal;
            1: pixel = silver_medal;
            2: pixel = gold_medal;
            3: pixel = platinum_medal;
            default: pixel = '0;
        endcase
    end

endmodule