// Module cấp cao nhất, kết nối bộ xử lý thời gian với bộ hiển thị
module DigitalClock_Top (
    input wire clk,
    input wire rst_n,
    // ... các input khác như nút bấm để vào chế độ chỉnh sửa ...

    // Giả sử đây là các tín hiệu nhị phân từ một module đếm thời gian
    input wire [5:0] binary_seconds,
    input wire [5:0] binary_minutes,
    input wire [4:0] binary_hours,
    // ... các tín hiệu ngày, tháng, năm nhị phân khác
    
    // Các output để điều khiển LED
    output wire [6:0] led_segment,
    output wire [7:0] dis_sel
);

    // Dây nối để truyền dữ liệu BCD đã được chuyển đổi
    wire [7:0] bcd_ss_wire;
    wire [7:0] bcd_mm_wire;
    wire [7:0] bcd_hh_wire;
    // ... các dây nối BCD khác cho ngày, tháng, năm

    //----- BỘ CHUYỂN ĐỔI BINARY -> BCD -----

    // Tạo một thực thể (instance) của module bin2bcd cho Giây
    // Chú ý: bạn cần tạo các module chuyển đổi riêng cho phút, giờ, v.v.
    // Ở đây ta dùng lại module cho giây và phút vì chúng cùng là 6 bit.
    // Giờ (5 bit) hay Năm (ví dụ 12 bit) sẽ cần module bin2bcd riêng.
    
    bin2bcd seconds_converter (
        .bin_in(binary_seconds),
        .bcd_out(bcd_ss_wire)
    );

    bin2bcd minutes_converter (
        .bin_in(binary_minutes),
        .bcd_out(bcd_mm_wire)
    );

    // Cần một module bin2bcd 5-bit cho giờ, hoặc có thể nối 1 bit 0 vào đầu
    bin2bcd hours_converter (
        .bin_in({1'b0, binary_hours}), // Mở rộng 5 bit thành 6 bit
        .bcd_out(bcd_hh_wire)
    );
    
    // ... các bộ chuyển đổi khác cho ngày, tháng, năm ...


    //----- BỘ HIỂN THỊ -----
    
    // Tạo một thực thể của module Display gốc, không cần sửa đổi gì cả
    Display display_unit (
        .clk(clk),
        .rst_n(rst_n),
        .en(1'b1), // Luôn bật
        .smh_dmy(/* tín hiệu chọn chế độ */),
        .dem_chinh(/* tín hiệu chỉnh sửa */),
        .blink_led(/* tín hiệu chọn LED nháy */),

        // Nối đầu ra của các bộ chuyển đổi vào đầu vào của module Display
        .bcd_ss(bcd_ss_wire),
        .bcd_mm(bcd_mm_wire),
        .bcd_hh(bcd_hh_wire),
        .bcd_dd(/* bcd_dd_wire */),
        .bcd_mo(/* bcd_mo_wire */),
        .bcd_yyyy(/* bcd_yyyy_wire */),

        .led_segment(led_segment),
        .dis_sel(dis_sel)
    );

endmodule