module mixer #(
    parameter int N // number of elements to mix
) (
    input logic [12:0] elements [0:N-1],
    input logic video_on,

    output logic [3:0] red, green, blue
);

    always_comb begin
        red = '0;
        green = '0;
        blue = '0;

        if (video_on) begin
            for (int i = N-1; i >= 0; i--) begin
                if (elements[i][12]) begin
                    red = elements[i][11:8];
                    green = elements[i][7:4];
                    blue = elements[i][3:0];
                    break;
                end
            end
        end
    end

endmodule