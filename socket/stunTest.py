import stun

# Lựa chọn máy chủ STUN (bạn có thể thay thế bằng một máy chủ STUN khác)
nat_type, external_ip, external_port = stun.get_ip_info(stun_host="stun.l.google.com", stun_port=19302)

print(f"Loại NAT: {nat_type}")
print(f"Địa chỉ IP công khai: {external_ip}")
print(f"Cổng công khai: {external_port}")
