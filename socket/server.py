import socket

# Cấu hình server
relay_port = 55555  # Port mà server sẽ lắng nghe

# Tạo socket UDP
relay_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
relay_sock.bind(('0.0.0.0', relay_port))

print(f"Relay server đang lắng nghe trên cổng {relay_port}...")

clients = []

while True:
    # Nhận dữ liệu từ client
    data, addr = relay_sock.recvfrom(1024)
    print(f"Nhận dữ liệu từ {addr}: {data.decode()}")

    # Lưu địa chỉ client nếu chưa có trong danh sách
    if addr not in clients:
        clients.append(addr)

    # Nếu có ít nhất 2 clients, gửi thông tin của nhau cho chúng
    if len(clients) >= 2:
        client_1 = clients.pop(0)
        client_2 = clients.pop(0)

        # Gửi thông tin của client 2 cho client 1
        relay_sock.sendto(f"{client_2[0]} {client_2[1]}".encode(), client_1)
        # Gửi thông tin của client 1 cho client 2
        relay_sock.sendto(f"{client_1[0]} {client_1[1]}".encode(), client_2)
        break

while True:
    msg = input("Nhập tin nhắn: ")
    relay_sock.sendto(msg.encode(), (client_2[0], int(client_2[1])))        