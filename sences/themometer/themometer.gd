extends Sprite2D
const COLD = preload("res://resource/thermometer/cold.png")
const HOT = preload("res://resource/thermometer/hot.png")
const NORMAL = preload("res://resource/thermometer/normal.png")
@onready var temperature_lable = $temperature

var threshold_cold = 20
var threshold_hot = 30
var temperature

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
			temperature = latest_data["data"]["Value"]["temp"]
			temperature_lable.text = str(temperature) + "°C"
			print("Latest temperature: ", temperature)

			# So sánh nhiệt độ với các ngưỡng và thay đổi hình ảnh của Sprite2D
			if temperature <= threshold_cold:
				texture = COLD
				print("Temperature is cold. Switching to COLD texture.")
			elif temperature >= threshold_hot:
				texture = HOT
				print("Temperature is hot. Switching to HOT texture.")
			else:
				texture = NORMAL
				print("Temperature is normal. Switching to NORMAL texture.")
		else:
			print("No temperature data available in the latest dht sensor data.")
	else:
		print("No data available for dht_sensor.")
	
