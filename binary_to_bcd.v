module bin2bcd (
    input wire [5:0] bin,
    output reg [7:0] bcd
);
    always @(bin) begin
        reg [7:0] bcd_temp; 
        integer i;
        bcd_temp = 8'b0;
        
        for (i = 0; i <= 5; i = i + 1) begin
            if (bcd_temp[3:0] >= 5) begin
                bcd_temp[3:0] = bcd_temp[3:0] + 3;
            end
            
            if (bcd_temp[7:4] >= 5) begin
                bcd_temp[7:4] = bcd_temp[7:4] + 3;
            end

            bcd_temp = {bcd_temp[6:0], bin[5-i]};
        end

        bcd = bcd_temp;
    end

endmodule