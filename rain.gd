extends Sprite2D
const RAIN = preload("res://resource/rain/rain.png")
const RAIN_01 = preload("res://resource/rain/rain01.png")
const RAIN_02 = preload("res://resource/rain/rain02.png")
const RAIN_03 = preload("res://resource/rain/rain03.png")

var timeChange = 0.25
var current_texture_index = 0
var textures = [RAIN,RAIN_01, RAIN_02, RAIN_03]
var isAvailable = false
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalControl.update_Terra_Status.connect(status_update)
	var timer = Timer.new()
	timer.wait_time = timeChange   # 1 giây
	timer.one_shot = false  # Lặp lại liên tục
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()


# Hàm này sẽ được gọi mỗi khi Timer timeout
func _on_timer_timeout() -> void:
	if isAvailable:
		raining()

func raining() -> void:
	# Đổi texture sau mỗi 1 giây
	current_texture_index = (current_texture_index + 1) % textures.size()
	if current_texture_index == 0:
		current_texture_index = 1
	texture = textures[current_texture_index]
	
func status_update()->void:
	# Kiểm tra xem pumper sensor có tồn tại trong Manage.Terra_Status hay không
	if Manage.Terra_Status.water_sensor and Manage.Terra_Status.water_sensor.data.size() > 0:
		# Lấy dữ liệu mới nhất từ pump_sensor
		var latest_data = Manage.Terra_Status.water_sensor.data[-1]  # Lấy phần tử cuối cùng trong mảng data
		
		# Kiểm tra và cập nhật biến isAvailable dựa trên trạng thái của pump
		if latest_data.has("data") and latest_data["data"].has("isAvailable"):
			isAvailable = latest_data["data"]["isAvailable"]
			if not isAvailable:
				texture = textures[0]
			print("Pump isAvailable status updated to: ", isAvailable)
		else:
			print("No isAvailable field available in the latest pump sensor data.")
	else:
		print("No data available for pump_sensor.")
