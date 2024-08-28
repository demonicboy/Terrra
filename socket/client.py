import socket

# Địa chỉ của Relay Server
relay_server_ip = '15.235.142.203'
relay_server_port = 55555
local_listen_port = 50001  # Port mà client sẽ lắng nghe

# Tạo socket UDP cho client
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('0.0.0.0', local_listen_port))

# Gửi thông tin đến Relay Server để đăng ký
sock.sendto(b'ready', (relay_server_ip, relay_server_port))

# Nhận thông tin về peer từ Relay Server
data, _ = sock.recvfrom(1024)
peer_ip, peer_port = data.decode().split(' ')
peer_port = int(peer_port)
print(f"Nhận được thông tin peer: {peer_ip}:{peer_port}")
sock.sendto(b'ready', (peer_ip, peer_port))
print("punched")
# Thiết lập kết nối trực tiếp với peer
while True:
    msg = input("Nhập tin nhắn: ")
    sock.sendto(msg.encode(), (peer_ip, peer_port))

    #Nhận phản hồi từ peer
    # data, _ = sock.recvfrom(1024)
    # print(f"Phản hồi từ peer: {data.decode()}")
