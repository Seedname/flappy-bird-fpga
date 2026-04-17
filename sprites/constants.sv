package constants_pkg;
	localparam BACKGROUND_ADDRESS = 0;
	localparam BACKGROUND_WIDTH = 144;
	localparam BACKGROUND_HEIGHT = 256;

	localparam FLOOR_ADDRESS = 36864;
	localparam FLOOR_WIDTH = 154;
	localparam FLOOR_HEIGHT = 56;

	localparam SCOREBOARD_ADDRESS = 45488;
	localparam SCOREBOARD_WIDTH = 113;
	localparam SCOREBOARD_HEIGHT = 58;

	localparam BIRD1_ADDRESS = 52042;
	localparam BIRD1_WIDTH = 17;
	localparam BIRD1_HEIGHT = 12;

	localparam BIRD2_ADDRESS = 52246;
	localparam BIRD2_WIDTH = 17;
	localparam BIRD2_HEIGHT = 12;

	localparam BIRD3_ADDRESS = 52450;
	localparam BIRD3_WIDTH = 17;
	localparam BIRD3_HEIGHT = 12;

	localparam START_ADDRESS = 52654;
	localparam START_WIDTH = 40;
	localparam START_HEIGHT = 14;

	localparam SCORE_ADDRESS = 53214;
	localparam SCORE_WIDTH = 40;
	localparam SCORE_HEIGHT = 14;

	localparam OK_ADDRESS = 53774;
	localparam OK_WIDTH = 40;
	localparam OK_HEIGHT = 14;

	localparam NEW_ADDRESS = 54334;
	localparam NEW_WIDTH = 16;
	localparam NEW_HEIGHT = 7;

	localparam FLAPPY_BIRD_ADDRESS = 54446;
	localparam FLAPPY_BIRD_WIDTH = 96;
	localparam FLAPPY_BIRD_HEIGHT = 22;

	localparam GAME_OVER_ADDRESS = 56558;
	localparam GAME_OVER_WIDTH = 94;
	localparam GAME_OVER_HEIGHT = 19;

	localparam GET_READY_ADDRESS = 58344;
	localparam GET_READY_WIDTH = 87;
	localparam GET_READY_HEIGHT = 22;

	localparam PIPE_TOP_ADDRESS = 60258;
	localparam PIPE_TOP_WIDTH = 26;
	localparam PIPE_TOP_HEIGHT = 135;

	localparam PIPE_BOTTOM_ADDRESS = 63768;
	localparam PIPE_BOTTOM_WIDTH = 26;
	localparam PIPE_BOTTOM_HEIGHT = 121;

	localparam TAP_ADDRESS = 66914;
	localparam TAP_WIDTH = 39;
	localparam TAP_HEIGHT = 49;

	localparam BRONZE_ADDRESS = 68825;
	localparam BRONZE_WIDTH = 22;
	localparam BRONZE_HEIGHT = 22;

	localparam SILVER_ADDRESS = 69309;
	localparam SILVER_WIDTH = 22;
	localparam SILVER_HEIGHT = 22;

	localparam GOLD_ADDRESS = 69793;
	localparam GOLD_WIDTH = 22;
	localparam GOLD_HEIGHT = 22;

	localparam PLATINUM_ADDRESS = 70277;
	localparam PLATINUM_WIDTH = 22;
	localparam PLATINUM_HEIGHT = 22;

	localparam ZERO_ADDRESS = 70761;
	localparam ZERO_WIDTH = 7;
	localparam ZERO_HEIGHT = 10;

	localparam ONE_ADDRESS = 70831;
	localparam ONE_WIDTH = 7;
	localparam ONE_HEIGHT = 10;

	localparam TWO_ADDRESS = 70901;
	localparam TWO_WIDTH = 7;
	localparam TWO_HEIGHT = 10;

	localparam THREE_ADDRESS = 70971;
	localparam THREE_WIDTH = 7;
	localparam THREE_HEIGHT = 10;

	localparam FOUR_ADDRESS = 71041;
	localparam FOUR_WIDTH = 7;
	localparam FOUR_HEIGHT = 10;

	localparam FIVE_ADDRESS = 71111;
	localparam FIVE_WIDTH = 7;
	localparam FIVE_HEIGHT = 10;

	localparam SIX_ADDRESS = 71181;
	localparam SIX_WIDTH = 7;
	localparam SIX_HEIGHT = 10;

	localparam SEVEN_ADDRESS = 71251;
	localparam SEVEN_WIDTH = 7;
	localparam SEVEN_HEIGHT = 10;

	localparam EIGHT_ADDRESS = 71321;
	localparam EIGHT_WIDTH = 7;
	localparam EIGHT_HEIGHT = 10;

	localparam NINE_ADDRESS = 71391;
	localparam NINE_WIDTH = 7;
	localparam NINE_HEIGHT = 10;

	localparam ZERO_SMALL_ADDRESS = 71461;
	localparam ZERO_SMALL_WIDTH = 6;
	localparam ZERO_SMALL_HEIGHT = 7;

	localparam ONE_SMALL_ADDRESS = 71503;
	localparam ONE_SMALL_WIDTH = 6;
	localparam ONE_SMALL_HEIGHT = 7;

	localparam TWO_SMALL_ADDRESS = 71545;
	localparam TWO_SMALL_WIDTH = 6;
	localparam TWO_SMALL_HEIGHT = 7;

	localparam THREE_SMALL_ADDRESS = 71587;
	localparam THREE_SMALL_WIDTH = 6;
	localparam THREE_SMALL_HEIGHT = 7;

	localparam FOUR_SMALL_ADDRESS = 71629;
	localparam FOUR_SMALL_WIDTH = 6;
	localparam FOUR_SMALL_HEIGHT = 7;

	localparam FIVE_SMALL_ADDRESS = 71671;
	localparam FIVE_SMALL_WIDTH = 6;
	localparam FIVE_SMALL_HEIGHT = 7;

	localparam SIX_SMALL_ADDRESS = 71713;
	localparam SIX_SMALL_WIDTH = 6;
	localparam SIX_SMALL_HEIGHT = 7;

	localparam SEVEN_SMALL_ADDRESS = 71755;
	localparam SEVEN_SMALL_WIDTH = 6;
	localparam SEVEN_SMALL_HEIGHT = 7;

	localparam EIGHT_SMALL_ADDRESS = 71797;
	localparam EIGHT_SMALL_WIDTH = 6;
	localparam EIGHT_SMALL_HEIGHT = 7;

	localparam NINE_SMALL_ADDRESS = 71839;
	localparam NINE_SMALL_WIDTH = 6;
	localparam NINE_SMALL_HEIGHT = 7;

	enum {BACKGROUND, FLOOR, SCOREBOARD, BIRD1, BIRD2, BIRD3, START, SCORE, OK, NEW, FLAPPY_BIRD, GAME_OVER, GET_READY, PIPE_TOP, PIPE_BOTTOM, TAP, BRONZE, SILVER, GOLD, PLATINUM, ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, ZERO_SMALL, ONE_SMALL, TWO_SMALL, THREE_SMALL, FOUR_SMALL, FIVE_SMALL, SIX_SMALL, SEVEN_SMALL, EIGHT_SMALL, NINE_SMALL} sprite_t;
endpackage