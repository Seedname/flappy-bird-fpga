// merge multiple pixels that never intersect together to save on the mixer depth
module merge #(
    parameter int N // number of elements to merge
) (
    input logic [12:0] pixels [0:N-1],
    output logic [12:0] pixel
);

    always_comb begin
        pixel = '0;

        for (int i = 0; i < N; i++) begin
            // if enabled, merge it (priority encoder)
            if (pixels[i][12]) begin
                pixel = pixel | pixels[i];
                break;
            end
        end
    end

endmodule