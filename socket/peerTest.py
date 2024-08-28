
import socket

# Thông tin về peer (giả sử bạn đã nhận được từ peer)
peer_ip = "171.255.162.226"
peer_port = 57535

# Tạo socket UDP
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Gửi một tin nhắn đến peer
sock.sendto(b"Hello, peer!", (peer_ip, peer_port))

msg = input("message: ")
sock.sendto(msg.encode(), (peer_ip, peer_port))
# Nhận phản hồi từ peer
data, addr = sock.recvfrom(1024)
print(f"Nhận được từ {addr}: {data.decode()}")
