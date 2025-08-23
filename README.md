#  Millennium Clock
<div align="center">

## Một project đồng hồ thiên niên kỷ được triển khai bằng Verilog trên FPGA.

</div>

# 1.Tổng quan
-   Dự án này triển khai một đồng hồ kỹ thuật số có khả năng đếm trong khoảng thời gian dài (đồng hồ thiên niên kỷ) bằng ngôn ngữ mô tả phần cứng Verilog. Thiết kế được tối ưu cho việc triển khai trên bo mạch FPGA DE2.
-   Hệ thống bao gồm các module chính sau:
*  gen_1hz.v: Tạo xung clock 1Hz từ đầu vào 50MHz của bo mạch.
*  Counter_DoThanhBinh: Module bộ đếm chính, thực hiện đếm giây, phút, giờ, ngày, tháng, năm.
*  Display.v: Module hiển thị, nhận dữ liệu BCD từ bộ đếm và xuất ra LED 7 đoạn.
*  Control_PhamTrieuMinh: Module điều khiển, xử lý tín hiệu từ các nút nhấn để thay đổi chế độ hiển thị và cài đặt thời gian.
*  binary_to_bcd.v: Module phụ trợ chuyển đổi dữ liệu từ nhị phân sang BCD để hiển thị.
*  Các testbench (tb_Display.v, tb_Gen_1Hz.v) cũng được cung cấp để kiểm tra hoạt động của từng module. Thiết kế hướng tới sự rõ ràng và module hóa, phù hợp cho mục đích học tập và làm nền tảng cho các hệ thống định thời phức tạp hơn.
## 2.Sơ đồ khối
Sơ đồ khối mô tả kiến trúc tổng thể của hệ thống, bao gồm các khối chính và luồng dữ liệu giữa chúng.
![Diagram](./diagram.png)
## 3.Tính năng
-   Tạo xung 1Hz chính xác: Sử dụng xung clock 1Hz làm nền tảng thời gian cho toàn bộ hệ thống.
-   Thiết kế theo module: Các thành phần được tách thành các module rõ ràng, giúp dễ dàng hiểu, bảo trì và tái sử dụng.
-   Chuyển đổi BCD: Đảm bảo dữ liệu được hiển thị dưới dạng số thập phân thân thiện với người dùng trên LED 7 đoạn.
-   Testbench toàn diện: Đi kèm các testbench để xác minh chức năng của các module riêng lẻ.
-   Khả năng điều chỉnh thời gian: Người dùng có thể cài đặt thời gian (giây, phút, giờ, ngày, tháng, năm) thông qua các nút nhấn.
## 4.Công nghệ sử dụng
-   Ngôn ngữ mô tả phần cứng: Verilog
## 5.Sử Dụng
### Yêu cầu
-   Một trình mô phỏng Verilog (ví dụ: Questasim,).
-   Phần mềm lập trình FPGA (ví dụ: Quartus II cho bo mạch DE2).
-   Cài đặt
-   Clone repository về máy:

```Bash

git clone https://github.com/minhnq1402/Millennium-Clock.git
cd Millennium-Clock
Mô phỏng bằng trình giả lập Verilog: Biên dịch các file Verilog và chạy các testbench. Tham khảo tài liệu của trình mô phỏng bạn chọn để biết hướng dẫn cụ thể.
```
## 6.Cấu trúc dự án
```Millennium-Clock/
├── Control_PhamTrieuMinh/
├── Counter_DoThanhBinh/
├── Display.v
├── binary_to_bcd.v
├── gen_1hz.v
├── tb_Display.v
└── tb_Gen_1Hz.v
```
## ️ Cấu hình
-   Không yêu cầu tệp cấu hình cụ thể; chức năng được định nghĩa hoàn toàn trong mã Verilog.
## 7.Kiểm thử
-   Các testbench được cung cấp cho module Display và 1Hz Generator:
-   tb_Display.v: Kiểm tra hoạt động của module Display.v.
-   tb_Gen_1Hz.v: Kiểm tra hoạt động của module gen_1hz.v.
-   Chạy các testbench này bằng trình mô phỏng Verilog của bạn để xác minh tính đúng đắn của chức năng.
<div align="center">

### made by MinhNQ142

</div>