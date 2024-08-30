extends Sprite2D
const HUMIDITY_LOW = preload("res://resource/humidity/humidity_low.png")
const HUMIDITY_NORMAL = preload("res://resource/humidity/humidity_normal.png")
const HUMIDITY_HIGH = preload("res://resource/humidity/humidity_high.png")
@onready var value_label = $value

var humidity
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalControl.update_Terra_Status.connect(status_update)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func status_update() -> void:
	# Kiểm tra xem temperature sensor có tồn tại trong Manage.Terra_Status hay không
	if Manage.Terra_Status.dht_sensor and Manage.Terra_Status.dht_sensor.data.size() > 0:
		# Lấy dữ liệu mới nhất từ dht_sensor (sensor đo nhiệt độ)
		var latest_data = Manage.Terra_Status.dht_sensor.data[-1]  # Lấy phần tử cuối cùng trong mảng data
		
		# Kiểm tra và lấy giá trị nhiệt độ từ dữ liệu
		if latest_data.has("data") and latest_data["data"].has("Value") and latest_data["data"]["Value"].has("temp"):
			humidity = latest_data["data"]["Value"]["humid"]
			value_label.text = str(humidity) + "%"
			print("Latest humidity: ", humidity)

			# So sánh nhiệt độ với các ngưỡng và thay đổi hình ảnh của Sprite2D
			if humidity <= Manage.threshold_airdry:
				texture = HUMIDITY_LOW
				print("humidity is cold. Switching to COLD texture.")
			elif humidity >= Manage.threshold_airwet:
				texture = HUMIDITY_HIGH
				print("humidity is hot. Switching to HOT texture.")
			else:
				texture = HUMIDITY_NORMAL
				print("humidity is normal. Switching to NORMAL texture.")
		else:
			print("No humidity data available in the latest dht sensor data.")
	else:
		print("No data available for dht_sensor.")
