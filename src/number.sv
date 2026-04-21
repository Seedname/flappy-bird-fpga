import constants_pkg::align_t;

// bitmap lookup
module numset #(
    parameter int SCALE = 2
) (
    input logic [3:0] num,

    input logic signed [10:0] x,
    input logic signed [10:0] y,

    input logic display,

    input logic signed [10:0] h_count,
    input logic signed [10:0] v_count,

    output [12:0] pixel
);
    parameter int LENGTH = 70;
    parameter int WIDTH = 7;
    parameter int HEIGHT = 10;

    logic [0:LENGTH-1] bitmap, enabled;

    //lookup table for 10x7 characters
    always_comb begin
        case (num)
            0: begin bitmap = 70'b0000000011111001111100110110011011001101100110110011111001111100000000; enabled = 70'b1111111111111111111111111111111111111111111111111111111111111111111111; end
            1: begin bitmap = 70'b0000000000111000011100000110000011000001100000110000011000001100000000; enabled = 70'b0011111001111100111110011111000111100011110001111000111100011110001111; end
            2: begin bitmap = 70'b0000000011111001111100000110011111001111100110000011111001111100000000; enabled = 70'b1111111111111111111111111111111111111111111111111111111111111111111111; end
            3: begin bitmap = 70'b0000000011111001111100000110011111001111100000110011111001111100000000; enabled = 70'b1111111111111111111111111111111111111111111111111111111111111111111111; end
            4: begin bitmap = 70'b0000000011011001101100110110011111001111100000110000011000001100000000; enabled = 70'b1111111111111111111111111111111111111111111111111000111100011110001111; end
            5: begin bitmap = 70'b0000000011111001111100110000011111001111100000110011111001111100000000; enabled = 70'b1111111111111111111111111111111111111111111111111111111111111111111111; end
            6: begin bitmap = 70'b0000000011111001111100110000011111001111100110110011111001111100000000; enabled = 70'b1111111111111111111111111111111111111111111111111111111111111111111111; end
            7: begin bitmap = 70'b0000000011111001111100000110000011000001100000110000011000001100000000; enabled = 70'b1111111111111111111111111111000111100011110001111000111100011110001111; end
            8: begin bitmap = 70'b0000000011111001111100110110011111001111100110110011111001111100000000; enabled = 70'b1111111111111111111111111111111111111111111111111111111111111111111111; end
            9: begin bitmap = 70'b0000000011111001111100110110011111001111100000110011111001111100000000; enabled = 70'b1111111111111111111111111111111111111111111111111111111111111111111111; end
            default: begin bitmap = '0; enabled = '0; end
        endcase
    end

    logic in_bounds;
    assign in_bounds = (h_count - x >= 0 && h_count - x < WIDTH*SCALE && v_count - y >= 0 && v_count - y < HEIGHT*SCALE);

    // calculate the index
    logic [$clog2(LENGTH)-1:0] index;
    assign index = (v_count - y) / SCALE * WIDTH + (h_count - x) / SCALE;

    logic [11:0] value;
    // if out of bounds, value=0. otherwise, read the address
    assign value = in_bounds ? {12{bitmap[index]}} : '0;

    logic pixel_on;
    // only draw the pixel if it's in bounds, not transparent, and displayed
    assign pixel_on = enabled[index] && in_bounds && display;

    // pixel is enabled + lower 12 bits
    assign pixel = {pixel_on, value};

endmodule


// number generator
module number #(
    parameter int DIGITS = 1,  // number of digits
    parameter int SIZE = 2,    // number of pixels for each pixel of the character
    parameter int CHAR_GAP = 1, // gap between characters
    parameter align_t ALIGN = LEFT_ALIGN
) (
    input logic [3:0] num [0:DIGITS-1], // number in BCD

    input logic signed [10:0] x,
    input logic signed [10:0] y,

    input logic display, // whether or not to show the string

    input logic signed [10:0] h_count,
    input logic signed [10:0] v_count,

    output logic [12:0] pixel
);

    parameter int LENGTH = 70;
    parameter int WIDTH = 7;
    parameter int HEIGHT = 10;

    localparam int SPACING = SIZE * (WIDTH + CHAR_GAP);

    logic signed [10:0] number_x [0:DIGITS-1];
    logic [12:0] pixels [0:DIGITS-1];

    genvar i;
    generate
        for (i = 0; i < DIGITS; i++) begin : lookup_gen
            numset #(.SCALE(SIZE)) lookup (.num(num[i]), .x(number_x[i]), .y(y), .display(1), .h_count(h_count), .v_count(v_count), .pixel(pixels[i]));
        end
    endgenerate

    int num_digits;

    always_comb begin
        pixel = '0;

        // if the first N-1 digits are 0, it will just use the last digit
        num_digits = 1;

        // calculate num_digits as the number of digits without a leading 0
        for (int i = 0; i < DIGITS - 1; i++) begin
            if (num[i] != 0) begin
                num_digits = DIGITS - i;
                break;
            end
        end

        for (int i = 0; i < DIGITS; i++) begin
            if (ALIGN == LEFT_ALIGN) begin
                number_x[i] = x + (i - (DIGITS - num_digits)) * SPACING;
            end else if (ALIGN == CENTER_ALIGN) begin
                number_x[i] = x + (i - (DIGITS - num_digits)) * SPACING - (num_digits * SPACING) / 2;
            end else if (ALIGN == RIGHT_ALIGN) begin
                number_x[i] = x + (i - (DIGITS - num_digits)) * SPACING - num_digits * SPACING;
            end
        end

        if (display) begin
            // or all the pixels together. they dont overlap so this will just produce the correct pixel
            for (int i = 0; i < DIGITS; i++) begin
                if (i >= DIGITS - num_digits) begin
                    pixel = pixel | pixels[i];
                end
            end
        end else begin
            pixel = '0;
        end
    end
endmodule