from flask import Flask, request, jsonify
import uuid
import jwt
from datetime import datetime, timezone,timedelta
import random
app = Flask(__name__)

# Secret key to encode the JWT token
SECRET_KEY = "key_168"

# A simple user database (for demonstration purposes only)
users_db = {
    "admin": "admin",
    "user2": "password2"
}

def generate_sensor_data(sensor_type, timestamp):
    if sensor_type == "DHT":
        return {
            "data": {
                "Value": {
                    "temp": 16.0 + 24.0 * (uuid.uuid4().int % 100) / 100.0,  # Giá trị giả lập nhiệt độ (float) trong khoảng từ 16 đến 40
                    "humid": 50.0 + 10.0 * (uuid.uuid4().int % 10)  # Giá trị giả lập độ ẩm (float)
                }
            },
            "sensor_name": "dht",
            "sensor_type": sensor_type,
            "timestamp": {
                "$date": {
                    "$numberLong": str(int(timestamp.timestamp() * 1000))
                }
            }
        }
    elif sensor_type == "Pump": 
        return {
            "data": {
                "isActive": bool(uuid.uuid4().int % 2)  # Trạng thái hoạt động True/False
            },
            "sensor_name": "pumpRelay",
            "sensor_type": sensor_type,
            "timestamp": {
                "$date": {
                    "$numberLong": str(int(timestamp.timestamp() * 1000))
                }
            }
        }
    elif sensor_type == "Valve": 
        return {
            "data": {
                "isActive": bool(uuid.uuid4().int % 2)  # Trạng thái hoạt động True/False
            },
            "sensor_name": "valveRelay",
            "sensor_type": sensor_type,
            "timestamp": {
                "$date": {
                    "$numberLong": str(int(timestamp.timestamp() * 1000))
                }
            }
        }
    elif sensor_type == "Light": 
        return {
            "data": {
                "isActive": bool(uuid.uuid4().int % 2),  # Trạng thái hoạt động True/False
                "Color": [uuid.uuid4().int % 256, uuid.uuid4().int % 256, uuid.uuid4().int % 256]  # Giá trị màu RGB
            },
            "sensor_name": "Light",
            "sensor_type": sensor_type,
            "timestamp": {
                "$date": {
                    "$numberLong": str(int(timestamp.timestamp() * 1000))
                }
            }
        }
    elif sensor_type == "Moisture": 
        return {
            "data": {
                "Moisture": 30.0 + 10.0 * (uuid.uuid4().int % 10)  # Giá trị giả lập độ ẩm đất (float)
            },
            "sensor_name": "Moisture",
            "sensor_type": sensor_type,
            "timestamp": {
                "$date": {
                    "$numberLong": str(int(timestamp.timestamp() * 1000))
                }
            }
        }
    elif sensor_type == "Water": 
        return {
            "data": {
                "isAvailable": bool(uuid.uuid4().int % 2)  # Trạng thái có nước True/False
            },
            "sensor_name": "Water",
            "sensor_type": sensor_type,
            "timestamp": {
                "$date": {
                    "$numberLong": str(int(timestamp.timestamp() * 1000))
                }
            }
        }


# Hàm giả lập để tạo tên ngẫu nhiên mô phỏng địa chỉ MAC
def generate_random_mac():
    return ":".join(["{:02X}".format(random.randint(0, 255)) for _ in range(6)])

# Hàm giả lập để tạo dữ liệu thiết bị
def generate_device(id):
    return {
        "id": str(id),
        "created_at": datetime.now(timezone.utc).isoformat() + "Z",
        "updated_at": datetime.now(timezone.utc).isoformat()+ "Z",
        "type": "family",
        "status": "Active",
        "life_time": "0001-01-01T00:00:00Z",
        "firmware_ver": 1,
        "app_ver": 1,
        "parentID": "",
        "name": generate_random_mac(),
        "region": "",
        "historyID": str(uuid.uuid4()),
        "performanceID": str(uuid.uuid4())
    }

# Hàm xác thực Access Token
def verify_token(token):
    try:
        # Giải mã token để xác thực
        decoded_token = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        return decoded_token
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None

# API endpoint để lấy danh sách các thiết bị
@app.route('/api/devices', methods=['GET'])
def get_devices():
    # # Lấy access token từ header của yêu cầu
    # auth_header = request.headers.get('Authorization')
    # if not auth_header:
    #     return jsonify({"httpCode": 401, "message": "Missing access token", "Error": "Unauthorized"}), 401

    # # Kiểm tra token có định dạng 'Bearer token' hay không
    # token = auth_header.split(" ")[1] if len(auth_header.split(" ")) == 2 else None
    token = request.cookies.get('access_token')
    if not token or not verify_token(token):
        return jsonify({"httpCode": 401, "message": "Invalid or expired access token", "Error": "Unauthorized"}), 401

    # Nếu token hợp lệ, trả về danh sách các thiết bị
    devices = [generate_device(uuid.uuid4()) for _ in range(3)]
    for device in devices:
        device["performanceID"] = ""

    response = {
        "httpCode": 200,
        "data": devices,
        "message": "",
        "Error": None
    }
    
    return jsonify(response), 200

@app.route('/api/devices/<string:device_id>', methods=['GET'])
def get_device_by_id(device_id):
    # Lấy access token từ cookie
    token = request.cookies.get('access_token')
    if not token or not verify_token(token):
        return jsonify({"httpCode": 401, "message": "Invalid or expired access token", "Error": "Unauthorized"}), 401

    # Giả lập thông tin thiết bị với device_id
    device = generate_device(device_id)
    
    response = {
        "httpCode": 200,
        "data": device,
        "message": "",
        "Error": None
    }
    
    return jsonify(response), 200

@app.route('/api/login', methods=['POST'])
def login():
    try:
        # Get the username and password from the request body
        data = request.get_json()
        
        if data is None:
            return jsonify({'message': 'Request body must be JSON format'}), 400
        
        username = data.get('username')
        password = data.get('password')
        
        # Check if the username and password are correct
        if username in users_db and users_db[username] == password:
            # Create a token with an expiration time
            token = jwt.encode({
                'username': username,
                'exp': datetime.now(timezone.utc) + timedelta(minutes=30)
            }, SECRET_KEY, algorithm="HS256")
            
            # Return the token as a response
            return jsonify({'access_token': token}), 200
        else:
            # Return an error message if the login credentials are incorrect
            return jsonify({'message': 'Invalid credentials'}), 401
    except Exception as e:
        # Return an error message if there's an issue with the JSON parsing or other errors
        return jsonify({'message': 'An error occurred', 'error': str(e)}), 500


from datetime import datetime, timedelta, timezone

@app.route('/api/performances/<string:device_id>', methods=['GET'])
def get_device_performance(device_id):
    try:
        token = request.cookies.get('access_token')
        if not token or not verify_token(token):
            return jsonify({"httpCode": 401, "message": "Invalid or expired access token", "Error": "Unauthorized"}), 401

        # Lấy các tham số từ URL
        from_date = request.args.get('from')
        to_date = request.args.get('to')
        
        # Nếu không có from_date hoặc to_date, đặt khoảng thời gian mặc định là 24 giờ trước đến hiện tại
        if not from_date:
            from_datetime = datetime.now(timezone.utc) - timedelta(hours=24)
        else:
            from_datetime = datetime.fromisoformat(from_date.replace('Z', '+00:00'))
        
        if not to_date:
            to_datetime = datetime.now(timezone.utc)
        else:
            to_datetime = datetime.fromisoformat(to_date.replace('Z', '+00:00'))

        # Giả lập dữ liệu cảm biến
        sensors = ["DHT", "Pump", "Valve", "Light", "Moisture", "Water"]
        payload = []
        for sensor in sensors:
            # Giả lập một số dữ liệu trong khoảng thời gian được chỉ định
            # current_time = from_datetime
            # while current_time <= to_datetime:
            #     payload.append(generate_sensor_data(sensor, current_time))
            #     current_time += (to_datetime - from_datetime) / 5  # Tạo 5 mẫu dữ liệu
            payload.append(generate_sensor_data(sensor, to_datetime))
        # Giả lập phản hồi API
        response = {
            "httpCode": 200,
            "data": {
                "Id": device_id,
                "CreatedAt": from_datetime.isoformat(),
                "UpdatedAt": to_datetime.isoformat(),
                "DocumentName": "Device Performance Data",
                "Payload": payload
            },
            "message": "",
            "Error": None
        }
        
        return jsonify(response), 200
    except Exception as e:
        return jsonify({"message": "An error occurred", "error": str(e)}), 500


if __name__ == '__main__':
    app.run(port=5000, debug=True)
