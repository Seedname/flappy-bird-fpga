package constants_pkg;
	localparam BACKGROUND_ROM = "sprites/BACKGROUND.hex";
	localparam BACKGROUND_WIDTH = 144;
	localparam BACKGROUND_HEIGHT = 256;

	localparam FLOOR_ROM = "sprites/FLOOR.hex";
	localparam FLOOR_WIDTH = 154;
	localparam FLOOR_HEIGHT = 56;

	localparam SCOREBOARD_ROM = "sprites/SCOREBOARD.hex";
	localparam SCOREBOARD_WIDTH = 113;
	localparam SCOREBOARD_HEIGHT = 58;

	localparam BIRD1_ROM = "sprites/BIRD1.hex";
	localparam BIRD1_WIDTH = 17;
	localparam BIRD1_HEIGHT = 12;

	localparam BIRD2_ROM = "sprites/BIRD2.hex";
	localparam BIRD2_WIDTH = 17;
	localparam BIRD2_HEIGHT = 12;

	localparam BIRD3_ROM = "sprites/BIRD3.hex";
	localparam BIRD3_WIDTH = 17;
	localparam BIRD3_HEIGHT = 12;

	localparam START_ROM = "sprites/START.hex";
	localparam START_WIDTH = 40;
	localparam START_HEIGHT = 14;

	localparam SCORE_ROM = "sprites/SCORE.hex";
	localparam SCORE_WIDTH = 40;
	localparam SCORE_HEIGHT = 14;

	localparam OK_ROM = "sprites/OK.hex";
	localparam OK_WIDTH = 40;
	localparam OK_HEIGHT = 14;

	localparam NEW_ROM = "sprites/NEW.hex";
	localparam NEW_WIDTH = 16;
	localparam NEW_HEIGHT = 7;

	localparam FLAPPY_BIRD_ROM = "sprites/FLAPPY_BIRD.hex";
	localparam FLAPPY_BIRD_WIDTH = 96;
	localparam FLAPPY_BIRD_HEIGHT = 22;

	localparam GAME_OVER_ROM = "sprites/GAME_OVER.hex";
	localparam GAME_OVER_WIDTH = 94;
	localparam GAME_OVER_HEIGHT = 19;

	localparam GET_READY_ROM = "sprites/GET_READY.hex";
	localparam GET_READY_WIDTH = 87;
	localparam GET_READY_HEIGHT = 22;

	localparam PIPE_TOP_ROM = "sprites/PIPE_TOP.hex";
	localparam PIPE_TOP_WIDTH = 26;
	localparam PIPE_TOP_HEIGHT = 135;

	localparam PIPE_BOTTOM_ROM = "sprites/PIPE_BOTTOM.hex";
	localparam PIPE_BOTTOM_WIDTH = 26;
	localparam PIPE_BOTTOM_HEIGHT = 121;

	localparam TAP_ROM = "sprites/TAP.hex";
	localparam TAP_WIDTH = 39;
	localparam TAP_HEIGHT = 49;

	localparam BRONZE_ROM = "sprites/BRONZE.hex";
	localparam BRONZE_WIDTH = 22;
	localparam BRONZE_HEIGHT = 22;

	localparam SILVER_ROM = "sprites/SILVER.hex";
	localparam SILVER_WIDTH = 22;
	localparam SILVER_HEIGHT = 22;

	localparam GOLD_ROM = "sprites/GOLD.hex";
	localparam GOLD_WIDTH = 22;
	localparam GOLD_HEIGHT = 22;

	localparam PLATINUM_ROM = "sprites/PLATINUM.hex";
	localparam PLATINUM_WIDTH = 22;
	localparam PLATINUM_HEIGHT = 22;

	enum {BACKGROUND, FLOOR, SCOREBOARD, BIRD1, BIRD2, BIRD3, START, SCORE, OK, NEW, FLAPPY_BIRD, GAME_OVER, GET_READY, PIPE_TOP, PIPE_BOTTOM, TAP, BRONZE, SILVER, GOLD, PLATINUM, ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, ZERO_SMALL, ONE_SMALL, TWO_SMALL, THREE_SMALL, FOUR_SMALL, FIVE_SMALL, SIX_SMALL, SEVEN_SMALL, EIGHT_SMALL, NINE_SMALL} sprite_t;
	typedef enum logic [2:0] {LEFT_ALIGN, CENTER_ALIGN, RIGHT_ALIGN} align_t;
	localparam SCREEN_WIDTH = 640;
	localparam SCREEN_HEIGHT = 480;

endpackage