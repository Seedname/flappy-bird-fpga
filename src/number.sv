import constants_pkg::align_t;

// bitmap lookup
module numset_big (
    input logic [3:0] num,
    output logic [0:69] bitmap,
    output logic [0:69] enabled
);
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
endmodule

module numset_small (
    input logic [3:0] num,
    output logic [0:41] bitmap,
    output logic [0:41] enabled
);
    // lookup table for 7x6 characters
    always_comb begin
        case (num)
            0: begin bitmap = 42'b000000011110010010010010010010011110000000; enabled = 42'b111111111111111111111111111111111111111111; end
            1: begin bitmap = 42'b000000000010000010000010000010000010000000; enabled = 42'b000111000111000111000111000111000111000111; end
            2: begin bitmap = 42'b000000011110000010011110010000011110000000; enabled = 42'b111111111111111111111111111111111111111111; end
            3: begin bitmap = 42'b000000011110000010011110000010011110000000; enabled = 42'b111111111111111111111111111111111111111111; end
            4: begin bitmap = 42'b000000010010010010011110000010000010000000; enabled = 42'b111111111111111111111111111111000111000111; end
            5: begin bitmap = 42'b000000011110010000011110000010011110000000; enabled = 42'b111111111111111111111111111111111111111111; end
            6: begin bitmap = 42'b000000011110010000011110010010011110000000; enabled = 42'b111111111111111111111111111111111111111111; end
            7: begin bitmap = 42'b000000011110000010000010000010000010000000; enabled = 42'b111111111111111111000111000111000111000111; end
            8: begin bitmap = 42'b000000011110010010011110010010011110000000; enabled = 42'b111111111111111111111111111111111111111111; end
            9: begin bitmap = 42'b000000011110010010011110000010011110000000; enabled = 42'b111111111111111111111111111111111111111111; end
            default: begin bitmap = '0; enabled = '0; end
        endcase
    end
endmodule


// number generator
module number #(
    parameter int DIGITS = 1,  // number of digits
    parameter int SIZE = 2,    // number of pixels for each pixel of the character
    parameter int CHAR_GAP = 1, // gap between characters
    parameter USE_SMALL = 0, // use small digits instead of big digits
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

    parameter int LENGTH = USE_SMALL ? 42 : 70;
    parameter int WIDTH = USE_SMALL ? 6 : 7;
    parameter int HEIGHT = USE_SMALL ? 7 : 10;

    logic [3:0] num_lookup;
    logic [0:LENGTH-1] bitmap;
    logic [0:LENGTH-1] enabled;

    generate
        if (USE_SMALL) begin : gen_small
            numset_small lookup (.num(num_lookup), .bitmap(bitmap), .enabled(enabled));
        end else begin : gen_big
            numset_big lookup (.num(num_lookup), .bitmap(bitmap), .enabled(enabled));
        end
    endgenerate

    int num_digits;
    logic signed [10:0] x_aligned;

    always_comb begin
        pixel = '0;
        num_lookup = '0;
        // if the first N-1 digits are 0, it will just use the last digit
        num_digits = 1;

        // calculate num_digits as the number of digits without a leading 0
        for (int i = 0; i < DIGITS - 1; i++) begin
            if (num[i] != 0) begin
                num_digits = DIGITS - i;
                break;
            end
        end

        if (ALIGN == LEFT_ALIGN) begin
            x_aligned = x;
        end else if (ALIGN == CENTER_ALIGN) begin
            x_aligned = x - (num_digits * SIZE * (WIDTH + CHAR_GAP)) / 2;
        end else if (ALIGN == RIGHT_ALIGN) begin
            x_aligned = x - num_digits * (WIDTH + CHAR_GAP) * SIZE;
        end

        // check if its in bounds
        if (display && // only display if display is true
            h_count >= x_aligned && h_count < x_aligned + ((WIDTH + CHAR_GAP) * SIZE) * num_digits &&
            v_count >= y && v_count < y + HEIGHT * SIZE) begin

            // pull the ASCII character from the string, getting the index by dividing the 
            // current x offset by the width of the character (plus the character gap) in pixels
            num_lookup = num[(h_count - x_aligned) / ((WIDTH + CHAR_GAP)*SIZE) + (DIGITS - num_digits)];

            // if a scaled pixel is in the gap (more than width scaled pixels) then dont draw a pixel
            // because it should be blank there. if not, draw a pixel
            if (((h_count - x_aligned) / SIZE) % (WIDTH + CHAR_GAP) < WIDTH) begin
                // get the index on the bitmap for the current position
                // scale by the size, and also reset the x offset depending on the current character
                // multiply the row by the width and add the column since the bitmap is in order from top->down left->right
                // and is height rows x width columns
                pixel = {enabled[((v_count - y) / SIZE) * WIDTH + ((h_count - x_aligned) / SIZE) % (WIDTH + CHAR_GAP)], {12{bitmap[((v_count - y) / SIZE) * WIDTH + ((h_count - x_aligned) / SIZE) % (WIDTH + CHAR_GAP)]}}};
            end
        end
    end
endmodule