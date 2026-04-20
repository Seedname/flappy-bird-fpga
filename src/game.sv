import constants_pkg::*;

// top level game
module game (
    input logic clk,
    input logic rst, // switch

    input logic pause, // switch

    input logic button0,
    input logic button1,

    output logic [3:0] red, green, blue,
    output logic h_sync, v_sync
);
    localparam WIDTH = 640;
    localparam HEIGHT = 480;
    localparam SCALE = 2;

    localparam PIPE_SPEED = 2;
    localparam PIPE_GAP = 100;
    localparam PIPE_SPACING = 170;

    localparam BIRD_X = START_X + BACKGROUND_WIDTH*SCALE/4 - BIRD1_WIDTH*SCALE/2;
    localparam BIRD_SPEED = 50;

    localparam int START_X = (WIDTH-BACKGROUND_WIDTH*SCALE)/2;
    localparam int GAME_WIDTH = BACKGROUND_WIDTH*SCALE;

    enum {START, GAME, OVER} state = START;

    localparam NUM_SPRITES = 7;

    // collection of pixels
    logic [12:0] elements [0:NUM_SPRITES-1];

    // moving or not
    logic moving = 1;

    // score
    localparam SCORE_WIDTH = 10;
    logic [3:0] high_score [0:SCORE_WIDTH-1] = '{0,0,0,0,0,0,0,0,0,0};
    logic [3:0] score [0:SCORE_WIDTH-1] = '{0,0,0,0,0,0,0,0,0,0};

    // x positions of pipes
    logic signed [10:0] pipe_x [0:2] = '{START_X + GAME_WIDTH, START_X + GAME_WIDTH + PIPE_SPACING, START_X + GAME_WIDTH + PIPE_SPACING*2};

    // y positions of pipes
    logic signed [10:0] pipe_y [0:2] = '{HEIGHT/2 , HEIGHT / 3, HEIGHT - HEIGHT/3};

    logic signed [14:0] bird_y = HEIGHT/2 <<< 3;
    logic signed [14:0] bird_vy = 0;
    logic signed [14:0] bird_ay = 1;

    // current pipe for collisions
    logic [1:0] current_pipe = 0;
    logic [3:0] selected_bird = 0;

    // video signals
    logic signed [10:0] h_count, v_count;
    logic video_on;

    vga vga_inst (
        .clk(clk),
        .h_count(h_count),
        .v_count(v_count),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .video_on(video_on)
    );

    // pseudo random number generator
    logic [63:0] next_random;
    prng random_number_generator (.clk(clk), .rst(rst), .enable(button0), .output_val(next_random));

    // check to see if a column is inside of the display region
    logic in_display_bounds; 
    assign in_display_bounds = h_count >= START_X && h_count < START_X+GAME_WIDTH;

    // background image
    sprite #(.ROM(BACKGROUND_ROM), .WIDTH(BACKGROUND_WIDTH), .HEIGHT(BACKGROUND_HEIGHT)) background (
        .x(START_X), .y(0), .display(1), .h_count(h_count), .v_count(v_count), .pixel(elements[0])
    );

    // pipes
    pipe #(.GAP_SIZE(PIPE_GAP)) pipe1 (.x(pipe_x[0]), .y(pipe_y[0]), .display(in_display_bounds), .h_count(h_count), .v_count(v_count), .pixel(elements[1]));
    pipe #(.GAP_SIZE(PIPE_GAP)) pipe2 (.x(pipe_x[1]), .y(pipe_y[1]), .display(in_display_bounds), .h_count(h_count), .v_count(v_count), .pixel(elements[2]));
    pipe #(.GAP_SIZE(PIPE_GAP)) pipe3 (.x(pipe_x[2]), .y(pipe_y[2]), .display(in_display_bounds), .h_count(h_count), .v_count(v_count), .pixel(elements[3]));

    // movement offset
    logic [5:0] floor_movement = 0;

    // emulate movement of the floor
    logic signed [10:0] floor_h;
    assign floor_h = (h_count + floor_movement) % 40 + START_X;

    localparam FLOOR_Y = 512-FLOOR_HEIGHT*SCALE;
    // floor
    sprite #(.ROM(FLOOR_ROM), .WIDTH(FLOOR_WIDTH), .HEIGHT(FLOOR_HEIGHT)) floor (
        .x(START_X), .y(FLOOR_Y), .display(in_display_bounds), .h_count(floor_h), .v_count(v_count), .pixel(elements[4])
    );

    // mix layers of pixels
    mixer #(.N(NUM_SPRITES)) video_out (.elements(elements), .video_on(video_on), .red(red), .green(green), .blue(blue));

    // score text
    number #(.DIGITS(10), .CHAR_GAP(0), .ALIGN(CENTER_ALIGN)) score_text (
        .num(score), .x(WIDTH / 2), .y(30), .display(1), .h_count(h_count), .v_count(v_count), .pixel(elements[5])
    );

    // bird
    bird bird_sprite (.x(BIRD_X), .y(bird_y >>> 3), .selected(selected_bird >> 2), .display(1), .h_count(h_count), .v_count(v_count), .pixel(elements[6]));

    logic jumped_last = 0;
    logic dead = 0;
    logic refresh_score = 0;

    always_ff @(negedge v_sync) begin
        if (rst) begin
            floor_movement <= 0;
            dead <= 0;
            moving <= 1;
            jumped_last <= 0;
            score <= '{0,0,0,0,0,0,0,0,0,0};
            pipe_x <= '{START_X + GAME_WIDTH, START_X + GAME_WIDTH + PIPE_SPACING, START_X + GAME_WIDTH + PIPE_SPACING*2};
            pipe_y <= '{HEIGHT/2 , HEIGHT / 3, HEIGHT - HEIGHT/3};

            bird_y <= HEIGHT/2;
            bird_vy <= 0;
            bird_ay <= 1;

            current_pipe <= 0;
            selected_bird <= 0;

            refresh_score <= 0;

        end else begin
            int cp;
            cp = current_pipe;

            // increment score if the bird is greater than the pipe and
            // it hasnt been counted for this pipe yet
            if (!refresh_score && BIRD_X > pipe_x[cp] + PIPE_BOTTOM_WIDTH*SCALE) begin
                logic carry = 1;

                for (int i = SCORE_WIDTH - 1; i >= 0; i--) begin
                    if (carry) begin
                        if (score[i] == 9) begin
                            score[i] <= 0;
                            carry = 1; // keep carrying
                        end else begin
                            score[i] <= score[i] + 1;
                            carry = 0; // stop carrying
                        end
                    end
                end

                refresh_score <= 1;
            end

            // jump
            if (!button0 && !dead) begin
                if (!jumped_last) begin
                    bird_vy <= -BIRD_SPEED;
                end

                jumped_last <= 1;
            end else begin
                jumped_last <= 0;
            end

            // check if bird collides with pipe
            if (!dead && BIRD_X + BIRD1_WIDTH*SCALE >= pipe_x[cp] && 
                BIRD_X < pipe_x[cp] + PIPE_BOTTOM_WIDTH*SCALE &&
                ((bird_y + bird_vy) >>> 3 <= pipe_y[cp] - PIPE_GAP || 
                (bird_y + bird_vy) >>> 3 > pipe_y[cp] - BIRD1_HEIGHT*SCALE)) begin

                dead <= 1;
                moving <= 0;

            end else if ((bird_y + bird_vy) >>> 3 > (FLOOR_Y - BIRD1_HEIGHT*SCALE)) begin
                // stop the bird
                bird_y <= (FLOOR_Y - (BIRD1_HEIGHT*SCALE)) <<< 3;
                bird_vy <= 0;

                // bird dies
                if (!dead) begin
                    dead <= 1;
                    moving <= 0;
                end

            end else begin
                // move the bird
                bird_y <= bird_y + bird_vy;
                bird_vy <= bird_vy + bird_ay;
            end

            if (moving) begin
                // move the floor
                floor_movement <= (floor_movement + PIPE_SPEED) % 40;

                // move pipes
                for (int i = 0; i < 3; i++) begin
                    pipe_x[i] <= pipe_x[i] - PIPE_SPEED;
                end

                // wrap the pipes around
                if (pipe_x[cp] + PIPE_BOTTOM_WIDTH * SCALE <= START_X) begin
                    pipe_x[cp] <= pipe_x[(cp + 2) % 3] + PIPE_SPACING;
                    pipe_y[cp] <= $signed(next_random % (FLOOR_Y - PIPE_GAP) + PIPE_GAP);
                    current_pipe <= (cp + 1) % 3;
                    refresh_score <= 0;
                end
            end

            if (!dead) begin
                selected_bird <= (selected_bird + 1);
            end
        end
    end

endmodule 
