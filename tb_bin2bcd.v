// timescale định nghĩa đơn vị thời gian (1ns) và độ chính xác (1ps)
`timescale 1ns / 1ps

// Khai báo module testbench
module tb_bin2bcd;

    // 1. Khai báo các tín hiệu
    // Tín hiệu đầu vào cho DUT (Device Under Test) phải là kiểu 'reg'
    // vì chúng ta sẽ điều khiển giá trị của nó từ trong testbench.
    reg [5:0] bin_tb;

    // Tín hiệu đầu ra từ DUT phải là kiểu 'wire'
    // để testbench có thể "đọc" hoặc "lắng nghe" giá trị của nó.
    wire [7:0] bcd_tb;
    
    // Biến integer để dùng trong vòng lặp for
    integer i;

    // 2. Instantiate (tạo một bản sao của) module cần kiểm tra
    // Đây là bước kết nối module testbench với module bin2bcd.
    bin2bcd dut (
        .bin(bin_tb),   // Kết nối cổng 'bin' của DUT với tín hiệu 'bin_tb'
        .bcd(bcd_tb)    // Kết nối cổng 'bcd' của DUT với tín hiệu 'bcd_tb'
    );

    // 3. Khối tạo Stimulus (kích thích)
    // Khối initial này sẽ chạy một lần duy nhất khi mô phỏng bắt đầu.
    // Nhiệm vụ của nó là tạo ra các giá trị đầu vào để kiểm tra DUT.
    initial begin
        // Hiển thị tiêu đề cho kết quả
        $display("Bắt đầu kiểm tra module bin2bcd...");
        $display("----------------------------------------------------------");
        $display("Time | Input (dec) | Input (bin) | Output BCD (hex)");
        $display("----------------------------------------------------------");

        // Sử dụng vòng lặp for để kiểm tra tất cả các giá trị từ 0 đến 63
        for (i = 0; i < 64; i++) begin
            bin_tb = i;  // Gán giá trị đầu vào
            #10;         // Chờ 10ns để giá trị được cập nhật và dễ quan sát trên waveform
        end

        // Sau khi vòng lặp kết thúc
        #20; // Chờ thêm 20ns
        $display("----------------------------------------------------------");
        $display("Kiểm tra hoàn tất!");
        $finish; // Kết thúc mô phỏng
    end

    // 4. Khối giám sát (Monitoring)
    // Khối initial này cũng chạy một lần, song song với khối stimulus ở trên.
    // Nhiệm vụ của nó là theo dõi và in ra sự thay đổi của các tín hiệu.
    initial begin
        // $monitor sẽ tự động in ra dòng này mỗi khi một trong các tín hiệu
        // (bin_tb hoặc bcd_tb) thay đổi giá trị.
        $monitor("%4t ns |     %2d      |   %6b    |       %2h", $time, bin_tb, bin_tb, bcd_tb);
    end

endmodule