# Ứng dụng Kiểm Kê Hàng (PDA Style)

## Mô tả tổng quan
Ứng dụng kiểm kê hàng được phát triển bằng Flutter, thiết kế theo phong cách PDA (Personal Digital Assistant) để phục vụ công việc kiểm kê hàng hóa. Ứng dụng sẽ đồng bộ dữ liệu thông qua FTP server, cho phép nhập và xuất dữ liệu dưới dạng file txt.

## Tính năng chính

### 1. Đồng bộ dữ liệu qua FTP
- Tải file txt từ FTP server
- Đồng bộ kết quả kiểm kê lên FTP server
- Quản lý kết nối FTP (cấu hình server, đăng nhập)

### 2. Quản lý dữ liệu
- Đọc và phân tích file txt
- Lưu trữ dữ liệu cục bộ
- Xuất dữ liệu theo định dạng txt

### 3. Giao diện kiểm kê
- Thiết kế tối ưu cho thiết bị cầm tay
- Hỗ trợ nhập liệu nhanh
- Hiển thị thông tin sản phẩm
- Quét mã vạch (nếu thiết bị hỗ trợ)

### 4. Báo cáo và thống kê
- Xem tiến độ kiểm kê
- Tổng hợp số liệu
- Xuất báo cáo

## Cấu trúc dữ liệu

### File txt đầu vào
```
Mã_SP|Tên_SP|Đơn_vị|Số_lượng|Vị_trí
```

### File txt đầu ra
```
Mã_SP|Tên_SP|Đơn_vị|Số_lượng_kiểm|Vị_trí|Người_kiểm|Thời_gian
```

## Giao diện người dùng

### Màn hình chính
- Danh sách các đợt kiểm kê
- Trạng thái đồng bộ
- Menu chức năng

### Màn hình kiểm kê
- Ô tìm kiếm/quét mã
- Thông tin sản phẩm
- Nhập số lượng
- Lưu/Hủy

### Màn hình cài đặt
- Cấu hình FTP
- Tùy chọn hiển thị
- Thông tin người dùng

## Yêu cầu kỹ thuật

### FTP
- Sử dụng thư viện ftpconnect
- Xử lý kết nối không ổn định
- Bảo mật thông tin đăng nhập

### Lưu trữ cục bộ
- SQLite hoặc Hive cho dữ liệu cục bộ
- Shared Preferences cho cài đặt

### Giao diện
- Material Design 3
- Responsive layout
- Hỗ trợ xoay màn hình

## Quy trình làm việc

1. Khởi động ứng dụng
2. Đăng nhập (nếu cần)
3. Tải dữ liệu từ FTP
4. Thực hiện kiểm kê
5. Lưu kết quả cục bộ
6. Đồng bộ lên FTP

## Xử lý ngoại lệ

- Mất kết nối mạng
- Lỗi FTP
- Dữ liệu không hợp lệ
- Xung đột phiên bản

## Bảo mật

- Mã hóa thông tin đăng nhập
- Kiểm tra quyền truy cập
- Xác thực người dùng

## Hiệu suất

- Tối ưu bộ nhớ
- Xử lý bất đồng bộ
- Cache dữ liệu