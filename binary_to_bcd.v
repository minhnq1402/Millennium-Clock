module binary_to_bcd_no_arith (
    input wire [5:0] binary_in,
    output reg [7:0] bcd_out
);

    reg [3:0] bcd_tens;
    reg [3:0] bcd_ones;


    always @(binary_in) begin

        reg [5:0] temp_binary;
        reg [3:0] temp_bcd_tens;
        reg [3:0] temp_bcd_ones;


        temp_binary = binary_in;
        temp_bcd_tens = 4'h0;
        temp_bcd_ones = 4'h0;


        for (int i = 0; i < 6; i = i + 1) begin

            if (temp_bcd_ones >= 5) begin
                temp_bcd_ones = temp_bcd_ones + 3;
            end
            if (temp_bcd_tens >= 5) begin
                temp_bcd_tens = temp_bcd_tens + 3;
            end


            temp_bcd_tens = temp_bcd_tens << 1;
            temp_bcd_tens[0] = temp_bcd_ones[3]; 
            
            temp_bcd_ones = temp_bcd_ones << 1;
            temp_bcd_ones[0] = temp_binary[5]; 
            
            temp_binary = temp_binary << 1;
        end
        

        bcd_tens = temp_bcd_tens;
        bcd_ones = temp_bcd_ones;
        bcd_out = {bcd_tens, bcd_ones};
    end
endmodule