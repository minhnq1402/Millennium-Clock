// Đây là module cấp cao nhất, kết nối tất cả các khối con
module Millennium_Clock (
    // Inputs từ bo mạch FPGA (nút nhấn, clock ngoài)
    input wire CLK_50MHZ,
    input wire RST_N,
    input wire UP_PUSH,
    input wire DOWN_PUSH,
    input wire MODEL_SEL,
    input wire SELECT_ITEM,
    // ... các nút nhấn khác nếu có

    // Outputs ra bo mạch FPGA (LED 7 đoạn)
    output wire [6:0] LED_SEGMENT,
    output wire [7:0] DIS_SEL
);

    //----------------------------------------------------------------------
    // Khai báo các dây tín hiệu nội bộ để kết nối các khối
    //----------------------------------------------------------------------

    // Tín hiệu từ Gen_1Hz
    wire clk_1hz_signal;

    // Tín hiệu từ Control đến các khối khác
    wire en_display, en_counter;
    wire mode_smh_dmy;
    wire mode_dem_chinh;
    wire [1:0] blink_select;
    wire [2:0] item_select; // Giả sử 3 bit để chọn item
    wire up_signal;
    wire down_signal;

    // Tín hiệu dữ liệu BCD từ Counter đến Display
    wire [7:0]  bcd_ss_out, bcd_mm_out, bcd_hh_out;
    wire [7:0]  bcd_dd_out, bcd_mo_out;
    wire [15:0] bcd_yyyy_out;


    //----------------------------------------------------------------------
    // Ghép nối (instantiate) các khối con
    //----------------------------------------------------------------------

    // 1. Khối tạo xung 1Hz
    Gen_1Hz u0_gen_1hz (
        .clk_50Mhz(CLK_50MHZ),
        .rst_n(RST_N),
        .clk_1Hz(clk_1hz_signal)
    );

    // 2. Khối điều khiển (Control) - do thành viên khác làm
    Control u1_control (
        // Inputs
        .clk(CLK_50MHZ), // Khối control có thể cần clock nhanh
        .rst_n(RST_N),
        .Up_Push(UP_PUSH),
        .Down(DOWN_PUSH),
        .ModelSel(MODEL_SEL),
        .Select_Item(SELECT_ITEM),
        // Outputs
        .En_1(en_display),
        .En_Counter(en_counter), // Cần thêm dây này để bật/tắt khối Counter
        .smh_dmy(mode_smh_dmy),
        .dem_chinh(mode_dem_chinh),
        .blink_led(blink_select),
        .select_item(item_select),
        .Up(up_signal),
        .Down(down_signal)
    );

    // 3. Khối đếm (Counter) - do thành viên khác làm
    Counter u2_counter (
        .clk(clk_1hz_signal), // Khối đếm hoạt động với xung 1Hz
        .rst_n(RST_N),
        .en(en_counter), // Cho phép đếm từ khối Control
        .select_item(item_select),
        .up(up_signal),
        .down(down_signal),
        // Outputs BCD
        .bcd_ss(bcd_ss_out),
        .bcd_mm(bcd_mm_out),
        .bcd_hh(bcd_hh_out),
        .bcd_dd(bcd_dd_out),
        .bcd_mo(bcd_mo_out),
        .bcd_yyyy(bcd_yyyy_out)
    );

    // 4. Khối hiển thị (Display) - khối bạn vừa tạo
    Display u3_display (
        .clk(CLK_50MHZ), // Display cần clock nhanh để quét LED
        .rst_n(RST_N),
        .en(en_display),
        .smh_dmy(mode_smh_dmy),
        .dem_chinh(mode_dem_chinh),
        .blink_led(blink_select),
        .bcd_ss(bcd_ss_out),
        .bcd_mm(bcd_mm_out),
        .bcd_hh(bcd_hh_out),
        .bcd_dd(bcd_dd_out),
        .bcd_mo(bcd_mo_out),
        .bcd_yyyy(bcd_yyyy_out),
        // Outputs
        .led_segment(LED_SEGMENT),
        .dis_sel(DIS_SEL)
    );

endmodule