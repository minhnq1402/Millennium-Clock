module Display (
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire smh_dmy,      
    input wire dem_chinh,    
    input wire [1:0] blink_led,


    input wire [7:0] bcd_ss,
    input wire [7:0] bcd_mm,
    input wire [7:0] bcd_hh,
    input wire [7:0] bcd_dd,
    input wire [7:0] bcd_mo,
    input wire [15:0] bcd_yyyy,


    output reg [6:0] led_segment, 
    output reg [7:0] dis_sel     
);


    reg [16:0] scan_counter;
    reg [24:0] blink_counter; 
    wire scan_clk, blink_enable;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_counter <= 0;
            blink_counter <= 0;
        end else begin
            scan_counter <= scan_counter + 1;
            blink_counter <= blink_counter + 1;
        end
    end

    assign scan_clk = scan_counter[16]; 
    assign blink_enable = blink_counter[24]; 

    reg [2:0] digit_select; 
    always @(posedge scan_clk or negedge rst_n) begin
        if (!rst_n) begin
            digit_select <= 3'd0;
        end else begin
            digit_select <= digit_select + 1;
        end
    end


    reg [3:0] bcd_to_decode;
    always @(smh_dmy or digit_select or bcd_ss or bcd_mm or bcd_hh or bcd_dd or bcd_mo or bcd_yyyy) begin
        if (smh_dmy == 0) begin 
            case(digit_select)
                3'd0: bcd_to_decode = bcd_ss[3:0];   // Seconds LSD
                3'd1: bcd_to_decode = bcd_ss[7:4];   // Seconds MSD
                3'd2: bcd_to_decode = bcd_mm[3:0];   // Minutes LSD
                3'd3: bcd_to_decode = bcd_mm[7:4];   // Minutes MSD
                3'd4: bcd_to_decode = bcd_hh[3:0];   // Hours LSD
                3'd5: bcd_to_decode = bcd_hh[7:4];   // Hours MSD
                3'd6: bcd_to_decode = 4'hF;          
                3'd7: bcd_to_decode = 4'hF;          
                default: bcd_to_decode = 4'hF;       // Default
            endcase
        end else begin 
             case(digit_select)
                3'd0: bcd_to_decode = bcd_yyyy[3:0];   // Year digit 1
                3'd1: bcd_to_decode = bcd_yyyy[7:4];   // Year digit 2
                3'd2: bcd_to_decode = bcd_yyyy[11:8];  // Year digit 3
                3'd3: bcd_to_decode = bcd_yyyy[15:12]; // Year digit 4
                3'd4: bcd_to_decode = bcd_mo[3:0];     // Month LSD
                3'd5: bcd_to_decode = bcd_mo[7:4];     // Month MSD
                3'd6: bcd_to_decode = bcd_dd[3:0];     // Day LSD
                3'd7: bcd_to_decode = bcd_dd[7:4];     // Day MSD
                default: bcd_to_decode = 4'hF;         // Default 
            endcase
        end
    end


    reg [6:0] decoded_seg;
    always @(bcd_to_decode) begin
        case(bcd_to_decode)
            4'h0: decoded_seg = 7'b1000000; // 0
            4'h1: decoded_seg = 7'b1111001; // 1
            4'h2: decoded_seg = 7'b0100100; // 2
            4'h3: decoded_seg = 7'b0110000; // 3
            4'h4: decoded_seg = 7'b0011001; // 4
            4'h5: decoded_seg = 7'b0010010; // 5
            4'h6: decoded_seg = 7'b0000010; // 6
            4'h7: decoded_seg = 7'b1111000; // 7
            4'h8: decoded_seg = 7'b0000000; // 8
            4'h9: decoded_seg = 7'b0010000; // 9
            default: decoded_seg = 7'b1111111; // Off 
        endcase
    end


    reg display_off;
    always @(dem_chinh or blink_enable or smh_dmy or blink_led or digit_select) begin
        display_off = 1'b0; 
        if (dem_chinh && blink_enable) begin 
            if (smh_dmy == 0) begin 
                case (blink_led)
                    2'b01: if (digit_select == 4 || digit_select == 5) display_off = 1'b1; // HH
                    2'b10: if (digit_select == 2 || digit_select == 3) display_off = 1'b1; // MM
                    2'b11: if (digit_select == 0 || digit_select == 1) display_off = 1'b1; // SS
                    default: display_off = 1'b0; 
                endcase
            end else begin 
                case (blink_led)
                    2'b01: if (digit_select == 6 || digit_select == 7) display_off = 1'b1; // DD
                    2'b10: if (digit_select == 4 || digit_select == 5) display_off = 1'b1; // MO
                    2'b11: if (digit_select >= 0 && digit_select <= 3) display_off = 1'b1; // YYYY
                    default: display_off = 1'b0; 
                endcase
            end
        end else begin
            display_off = 1'b0; 
        end
    end

    always @(en or display_off or decoded_seg or digit_select) begin
        if (!en || display_off) begin
            led_segment = 7'b1111111; 
            dis_sel = 8'b11111111;     
        end else begin
            led_segment = decoded_seg;
            dis_sel = ~(1 << digit_select); 
        end
    end

endmodule