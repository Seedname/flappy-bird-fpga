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
    localparam int WIDTH = 640;
    localparam int HEIGHT = 480;
    localparam int SCALE = 2;

    localparam int PIPE_SPEED = 2;
    localparam int PIPE_GAP = 100;
    localparam int PIPE_SPACING = 170;

    localparam int BIRD_START_X = (WIDTH - FLAPPY_BIRD_WIDTH*SCALE)/2 + FLAPPY_BIRD_WIDTH*SCALE + 5;
    localparam int BIRD_START_Y = (BACKGROUND_HEIGHT*SCALE / 3 - BIRD1_HEIGHT*SCALE/2);
    
    localparam int BIRD_X = START_X + BACKGROUND_WIDTH*SCALE/4 - BIRD1_WIDTH*SCALE/2;
    localparam int BIRD_READY_Y = (HEIGHT / 2);

    localparam int BIRD_SPEED = 40;
    localparam int BIRD_ACCELERATION = 3;

    localparam int START_X = (WIDTH-BACKGROUND_WIDTH*SCALE)/2;
    localparam int GAME_WIDTH = BACKGROUND_WIDTH*SCALE;

    localparam int FLOOR_Y = 512-FLOOR_HEIGHT*SCALE;

    enum {START, READY, GAME, OVER} state = START;

    localparam int NUM_SPRITES = 6;

    // collection of pixels
    logic [12:0] elements [0:NUM_SPRITES-1];
    logic [12:0] elements_q [0:NUM_SPRITES-1];

    // score
    localparam int SCORE_WIDTH = 10;
    localparam int SCORE_BITS = $clog2(10 ** SCORE_WIDTH);
    logic [3:0] high_score [0:SCORE_WIDTH-1] = '{0,0,0,0,0,0,0,0,0,0};
    logic [3:0] score [0:SCORE_WIDTH-1] = '{0,0,0,0,0,0,0,0,0,0};

    logic [SCORE_BITS-1:0] high_score_binary = 0;
    logic [SCORE_BITS-1:0] score_binary = 0;

    logic new_best = 0;

    // x positions of pipes
    logic signed [10:0] pipe_x [0:2] = '{START_X + GAME_WIDTH, START_X + GAME_WIDTH + PIPE_SPACING, START_X + GAME_WIDTH + PIPE_SPACING*2};

    // y positions of pipes
    logic signed [10:0] pipe_y [0:2] = '{HEIGHT/2 , HEIGHT / 3, HEIGHT - HEIGHT/3};

    logic signed [10:0] bird_x;
    assign bird_x = state == START ? BIRD_START_X : BIRD_X;

    logic signed [14:0] bird_y = HEIGHT/2 <<< 3;
    logic signed [14:0] bird_vy = 0;
    logic signed [14:0] bird_ay = BIRD_ACCELERATION;

    // current pipe for collisions
    logic [1:0] current_pipe = 0;
    logic [3:0] selected_bird = 0;

    // game over screen constants
    localparam int GAME_OVER_OFFSET = HEIGHT - (HEIGHT / 4 - GAME_OVER_HEIGHT*SCALE/2);
    localparam int GAME_OVER_SPEED = 15;
    logic signed [10:0] game_over_offset = GAME_OVER_OFFSET;


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
    prng random_number_generator (.clk(v_sync), .rst(rst), .enable(button0), .output_val(next_random));

    localparam int MIN_PIPE_Y = FLOOR_Y - PIPE_BOTTOM_HEIGHT*SCALE;
    localparam int MAX_PIPE_Y = PIPE_TOP_HEIGHT*SCALE + PIPE_GAP;

    logic [9:0] random_values [0:2];
    prng_range #(.MIN(MIN_PIPE_Y), .MAX(MAX_PIPE_Y), .NUM_RANGES(3), .NUM_BITS(10)) range_generator (.input_val(next_random), .output_val(random_values));    

    // check to see if a column is inside of the display region
    logic in_display_bounds; 
    assign in_display_bounds = h_count >= START_X && h_count < START_X+GAME_WIDTH;

    // background image
    sprite #(.ROM(BACKGROUND_ROM), .WIDTH(BACKGROUND_WIDTH), .HEIGHT(BACKGROUND_HEIGHT)) background (
        .x(START_X), .y(0), .display(1), .h_count(h_count), .v_count(v_count), .pixel(elements[0])
    );

    // pipes
    logic [12:0] pipe_pixels [0:2];
    pipe #(.GAP_SIZE(PIPE_GAP)) pipe1 (.x(pipe_x[0]), .y(pipe_y[0]), .display(in_display_bounds), .h_count(h_count), .v_count(v_count), .pixel(pipe_pixels[0]));
    pipe #(.GAP_SIZE(PIPE_GAP)) pipe2 (.x(pipe_x[1]), .y(pipe_y[1]), .display(in_display_bounds), .h_count(h_count), .v_count(v_count), .pixel(pipe_pixels[1]));
    pipe #(.GAP_SIZE(PIPE_GAP)) pipe3 (.x(pipe_x[2]), .y(pipe_y[2]), .display(in_display_bounds), .h_count(h_count), .v_count(v_count), .pixel(pipe_pixels[2]));

    // merge pipe pixels because they never intersect
    merge #(.N(3)) pipe_merge (pipe_pixels, elements[1]);

    // movement offset
    logic [4:0] floor_movement = 0;

    // // emulate movement of the floor
    // logic signed [10:0] floor_h;
    // assign floor_h = (h_count + floor_movement) % 42 + START_X;

    // // floor
    // sprite #(.ROM(FLOOR_ROM), .WIDTH(FLOOR_WIDTH), .HEIGHT(FLOOR_HEIGHT)) floor (
    //     .x(START_X), .y(FLOOR_Y), .display(in_display_bounds), .h_count(floor_h), .v_count(v_count), .pixel(elements[2])
    // );
    floor floor_sprite (.x(START_X), .y(FLOOR_Y), .display(in_display_bounds), .offset(floor_movement), .h_count(h_count), .v_count(v_count), .pixel(elements[2]));

    // pixels for everything else that doesnt intersect
    logic [12:0] merge_pixels [0:9];

    // score text
    number #(.DIGITS(10), .CHAR_GAP(0), .ALIGN(CENTER_ALIGN)) score_text (
        .num(score), .x(WIDTH / 2), .y(30), .display(state == GAME), .h_count(h_count), .v_count(v_count), .pixel(merge_pixels[0])
    );

    // bird
    bird bird_sprite (.x(bird_x), .y(bird_y >>> 3), .selected(selected_bird >> 2), .display(1), .h_count(h_count), .v_count(v_count), .pixel(elements[3]));


    // start screen

    // flappy bird logo
    sprite #(.ROM(FLAPPY_BIRD_ROM), .WIDTH(FLAPPY_BIRD_WIDTH), .HEIGHT(FLAPPY_BIRD_HEIGHT)) flappy_bird_logo (
        .x((WIDTH - FLAPPY_BIRD_WIDTH*SCALE)/2), .y((bird_y >>> 3) - BIRD1_HEIGHT*SCALE/2), .display(state == START), .h_count(h_count), .v_count(v_count), .pixel(merge_pixels[1])
    );

    // start button
    sprite #(.ROM(START_ROM), .WIDTH(START_WIDTH), .HEIGHT(START_HEIGHT)) start_button (
        .x((WIDTH - START_WIDTH*SCALE)/2), .y(FLOOR_Y - 50), .display(state == START), .h_count(h_count), .v_count(v_count), .pixel(merge_pixels[2])
    );

    // ready screen

    // get ready logo
    sprite #(.ROM(GET_READY_ROM), .WIDTH(GET_READY_WIDTH), .HEIGHT(GET_READY_HEIGHT)) get_ready_logo (
        .x((WIDTH - GET_READY_WIDTH*SCALE)/2), .y(HEIGHT / 4 - GET_READY_HEIGHT*SCALE/2), .display(state == READY), .h_count(h_count), .v_count(v_count), .pixel(merge_pixels[3])
    );

    // tap button
    sprite #(.ROM(TAP_ROM), .WIDTH(TAP_WIDTH), .HEIGHT(TAP_HEIGHT)) tap_button (
        .x(WIDTH/2 - 20), .y(HEIGHT/2), .display(state == READY), .h_count(h_count), .v_count(v_count), .pixel(merge_pixels[4])
    );


    // game over screen
    sprite #(.ROM(GAME_OVER_ROM), .WIDTH(GAME_OVER_WIDTH), .HEIGHT(GAME_OVER_HEIGHT)) game_over_logo (
        .x((WIDTH - GAME_OVER_WIDTH*SCALE)/2), .y(HEIGHT / 4 - GAME_OVER_HEIGHT*SCALE/2), .display(state == OVER), .h_count(h_count), .v_count(v_count), .pixel(merge_pixels[5])
    );

    // scoreboard
    sprite #(.ROM(SCOREBOARD_ROM), .WIDTH(SCOREBOARD_WIDTH), .HEIGHT(SCOREBOARD_HEIGHT)) scoreboard_menu (
        .x((WIDTH - SCOREBOARD_WIDTH*SCALE)/2), .y(HEIGHT/2 - SCOREBOARD_HEIGHT*SCALE/2 + game_over_offset), .display(state == OVER), .h_count(h_count), .v_count(v_count), .pixel(elements[4])
    );

    // new best
    sprite #(.ROM(NEW_ROM), .WIDTH(NEW_WIDTH), .HEIGHT(NEW_HEIGHT)) new_best_text (
        .x((WIDTH - SCOREBOARD_WIDTH*SCALE)/2 + SCOREBOARD_WIDTH*SCALE - NEW_WIDTH*SCALE - 60), .y(HEIGHT/2 - SCOREBOARD_HEIGHT*SCALE/2 + 58 + game_over_offset), .display(state == OVER && new_best), .h_count(h_count), .v_count(v_count), .pixel(merge_pixels[6])
    );

    // old score text
    number #(.DIGITS(10), .CHAR_GAP(1), .ALIGN(RIGHT_ALIGN)) old_score_text (
        .num(score), .x((WIDTH - SCOREBOARD_WIDTH*SCALE)/2 + SCOREBOARD_WIDTH*SCALE - 20), .y(HEIGHT/2 - SCOREBOARD_HEIGHT*SCALE/2 + 32 + game_over_offset), .display(state == OVER), .h_count(h_count), .v_count(v_count), .pixel(merge_pixels[7])
    );

    // high score text
    number #(.DIGITS(10), .CHAR_GAP(1), .ALIGN(RIGHT_ALIGN)) high_score_text (
        .num(new_best ? score : high_score), .x((WIDTH - SCOREBOARD_WIDTH*SCALE)/2 + SCOREBOARD_WIDTH*SCALE - 20), .y(HEIGHT/2 - SCOREBOARD_HEIGHT*SCALE/2 + 74 + game_over_offset), .display(state == OVER), .h_count(h_count), .v_count(v_count), .pixel(merge_pixels[8])
    );

    localparam int MEDAL_X = (WIDTH - SCOREBOARD_WIDTH*SCALE)/2 + 26;
    localparam int MEDAL_Y = HEIGHT/2 - SCOREBOARD_HEIGHT*SCALE/2 + 42;
    logic [2:0] selected_medal;
    assign selected_medal = new_best ? (score_binary >= 40 ? 3 : (score_binary / 10 - 1)) : (high_score_binary >= 40 ? 3 : (high_score_binary / 10 - 1));
    medal medal_display (.x(MEDAL_X), .y(MEDAL_Y + game_over_offset), .selected(selected_medal), .display((score_binary >= 10 || high_score_binary >= 10) && state == OVER), .h_count(h_count), .v_count(v_count), .pixel(merge_pixels[9]));

    // merge text pixels + medal display
    merge #(.N(10)) merge_others (merge_pixels, elements[5]);

    always_ff @(negedge clk) begin
        elements_q <= elements;
    end

    // mix layers of pixels
    mixer #(.N(NUM_SPRITES)) video_out (.elements(elements_q), .video_on(video_on), .red(red), .green(green), .blue(blue));

    logic jumped_last = 0;
    logic dead = 0;
    logic refresh_score = 0;
    logic carry;

    logic [8:0] angle = 0;
    logic signed [10:0] sine_output;

    sine sine_lookup (.angle(angle), .out(sine_output));

    always_ff @(negedge v_sync) begin
        if (rst) begin
            state <= START;

            floor_movement <= 0;
            dead <= 0;
            jumped_last <= 0;

            score <= '{0,0,0,0,0,0,0,0,0,0};
            high_score <= '{0,0,0,0,0,0,0,0,0,0};

            score_binary <= '0;
            high_score_binary <= '0;

            pipe_x <= '{START_X + GAME_WIDTH, START_X + GAME_WIDTH + PIPE_SPACING, START_X + GAME_WIDTH + PIPE_SPACING*2};
            pipe_y <= '{HEIGHT/2 , HEIGHT / 3, HEIGHT - HEIGHT/3};

            bird_y <= BIRD_START_Y <<< 3;
            bird_vy <= 0;
            bird_ay <= BIRD_ACCELERATION;

            current_pipe <= 0;
            selected_bird <= 0;

            refresh_score <= 0;

            new_best <= 0;
            angle <= 0;

            game_over_offset <= GAME_OVER_OFFSET;
        end else begin
            int cp;
            cp = current_pipe;
            
            if (state == START || state == READY) begin
                if (!pause) angle <= angle + 4;

                if (state == START) begin
                    bird_y <= (BIRD_START_Y + (sine_output >>> 6)) <<< 3;

                    // if pressed button 0, continue to ready 
                    if (!button0) begin
                        state <= READY;
                        jumped_last <= 1;
                    end

                end else if (state == READY) begin
                    bird_y <= (BIRD_READY_Y + (sine_output >>> 7)) <<< 3;

                    // start playing game
                    if (!button0) begin
                        if (!jumped_last) begin
                            pipe_y <= '{random_values[0], random_values[1], random_values[2]};
                            state <= GAME;
                            bird_vy <= -BIRD_SPEED;
                        end
                        jumped_last <= 1;
                    end else begin
                        jumped_last <= 0;
                    end
                end

            end else begin

                // increment score if the bird is greater than the pipe and
                // it hasnt been counted for this pipe yet
                if (!refresh_score && BIRD_X > pipe_x[cp] + PIPE_BOTTOM_WIDTH*SCALE / 2) begin
                    carry = 1;

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

                    score_binary <= (score_binary + 1);

                    refresh_score <= 1;
                end

                // check if bird collides with pipe
                if (!dead && BIRD_X + BIRD1_WIDTH*SCALE >= pipe_x[cp] && 
                    BIRD_X < pipe_x[cp] + PIPE_BOTTOM_WIDTH*SCALE &&
                    ((bird_y + bird_vy) >>> 3 <= pipe_y[cp] - PIPE_GAP || 
                    (bird_y + bird_vy) >>> 3 > pipe_y[cp] - BIRD1_HEIGHT*SCALE)) begin

                    dead <= 1;
                    state <= OVER;

                end else if ((bird_y + bird_vy) >>> 3 > (FLOOR_Y - BIRD1_HEIGHT*SCALE)) begin
                    // stop the bird
                    bird_y <= (FLOOR_Y - (BIRD1_HEIGHT*SCALE)) <<< 3;
                    bird_vy <= 0;

                    // bird dies
                    if (!dead) begin
                        dead <= 1;
                        state <= OVER;
                    end

                end else if (!pause) begin
                    // move the bird
                    bird_y <= bird_y + bird_vy;
                    bird_vy <= bird_vy + bird_ay;

                    // jump
                    if (!button0 && !dead) begin
                        if (!jumped_last) begin
                            bird_y <= bird_y;
                            bird_vy <= -BIRD_SPEED;
                        end

                        jumped_last <= 1;
                    end else begin
                        jumped_last <= 0;
                    end
                end
            end

            if (!dead && !pause) begin
                // move the floor
                floor_movement <= (floor_movement + PIPE_SPEED / 2) % 7;

                if (state == GAME) begin
                    // move pipes
                    for (int i = 0; i < 3; i++) begin
                        pipe_x[i] <= pipe_x[i] - PIPE_SPEED;
                    end

                    // wrap the pipes around
                    if (pipe_x[cp] + PIPE_BOTTOM_WIDTH * SCALE <= START_X) begin
                        pipe_x[cp] <= pipe_x[(cp + 2) % 3] + PIPE_SPACING;
                        pipe_y[cp] <= random_values[0];
                        current_pipe <= (cp + 1) % 3;
                        refresh_score <= 0;
                    end
                end

                // bird animation
                selected_bird <= (selected_bird + 1);
            end

            if (state == OVER) begin
                new_best <= score_binary > high_score_binary;

                // move the game over screen
                if ((game_over_offset - GAME_OVER_SPEED) > 0) begin
                    game_over_offset <= (game_over_offset - GAME_OVER_SPEED);
                end else begin
                    game_over_offset <= 0;

                    // reset to main menu
                    if (!button0) begin
                        // set the new high score
                        if (new_best) begin
                            high_score <= score;
                            high_score_binary <= score_binary;
                        end
                        
                        state <= READY;
                        jumped_last <= 1;

                        floor_movement <= 0;
                        dead <= 0;
                        score <= '{0,0,0,0,0,0,0,0,0,0};
                        score_binary <= '0;
                        pipe_x <= '{START_X + GAME_WIDTH, START_X + GAME_WIDTH + PIPE_SPACING, START_X + GAME_WIDTH + PIPE_SPACING*2};
                        pipe_y <= '{random_values[0], random_values[1], random_values[2]};

                        bird_y <= BIRD_READY_Y <<< 3;
                        bird_vy <= 0;
                        bird_ay <= BIRD_ACCELERATION;

                        current_pipe <= 0;
                        selected_bird <= 0;

                        refresh_score <= 0;
                        new_best <= 0;

                        game_over_offset <= GAME_OVER_OFFSET;
                    end
                end
            end
        end
    end

endmodule 
