// vga signal generation
module vga (
    input logic clk,
    output logic signed [10:0] h_count,
    output logic signed [10:0] v_count,
    output logic h_sync,
    output logic v_sync,
    output logic video_on
);

    // timings from https://projectf.io/posts/video-timings-vga-720p-1080p/
    localparam ACTIVE_VIDEO_H = 640;
    localparam FRONT_PORCH_H = 16;
    localparam SYNC_PULSE_H = 96;
    localparam BACK_PORCH_H = 48;
    localparam H_MAX = ACTIVE_VIDEO_H + FRONT_PORCH_H + SYNC_PULSE_H + BACK_PORCH_H;

    localparam ACTIVE_VIDEO_V = 480;
    localparam FRONT_PORCH_V = 10;
    localparam SYNC_PULSE_V = 2;
    localparam BACK_PORCH_V = 33;
    localparam V_MAX = ACTIVE_VIDEO_V + FRONT_PORCH_V + SYNC_PULSE_V + BACK_PORCH_V;


    logic video_clk = 0;

    always_ff @(posedge clk) begin
        // divide clk by 2 to get 25MHz clock speed
        video_clk <= ~video_clk;
    end

    logic signed [10:0] h_count_internal = 0;
    logic signed [10:0] v_count_internal = 0;

    always_ff @(posedge clk) begin
        if (video_clk) begin
            if (h_count_internal == H_MAX - 1) begin
                h_count_internal <= 0;

                if (v_count_internal == V_MAX - 1)
                    v_count_internal <= 0;
                else
                    v_count_internal <= v_count_internal + 1;

            end else begin
                h_count_internal <= h_count_internal + 1;
            end
        end
    end

    assign h_count = h_count_internal;
    assign v_count = v_count_internal;

    // calculate video on signal
    assign video_on = h_count < ACTIVE_VIDEO_H && v_count < ACTIVE_VIDEO_V;
    // calculate sync signals
    assign h_sync = ~(h_count >= (ACTIVE_VIDEO_H + FRONT_PORCH_H) && h_count < (ACTIVE_VIDEO_H + FRONT_PORCH_H + SYNC_PULSE_H));
    assign v_sync = ~(v_count >= (ACTIVE_VIDEO_V + FRONT_PORCH_V) && v_count < (ACTIVE_VIDEO_V + FRONT_PORCH_V + SYNC_PULSE_V));

endmodule