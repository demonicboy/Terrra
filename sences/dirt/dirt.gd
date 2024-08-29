extends Sprite2D
const DIRT = preload("res://resource/dirt/dirt.png")
const DIRT_01 = preload("res://resource/dirt/dirt01.png")
const DIRT_02 = preload("res://resource/dirt/dirt02.png")
const DIRT_03 = preload("res://resource/dirt/dirt03.png")
const DIRT_04 = preload("res://resource/dirt/dirt04.png")
const DIRT_05 = preload("res://resource/dirt/dirt05.png")

var timeChange = 0.5
var current_texture_index = 0
var textures = [DIRT,DIRT_01, DIRT_02,DIRT_03,DIRT_04,DIRT_05]
var threshold_dry = 20  # Ngưỡng dưới để xác định đất quá khô
var threshold_wet = 80  # Ngưỡng trên để xác định đất quá ngập nước
var moisture_status =0
@onready var percent = $percent

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
	if moisture_status >= threshold_wet:
		wetting()

func wetting() -> void:
	# Đổi texture sau mỗi 1 giây
	current_texture_index = (current_texture_index + 1) % textures.size()
	if current_texture_index == 0:
		current_texture_index = 2
	texture = textures[current_texture_index]



func status_update() -> void:
	# Kiểm tra xem moisture sensor có tồn tại trong Manage.Terra_Status hay không
	if Manage.Terra_Status.moisture_sensor and Manage.Terra_Status.moisture_sensor.data.size() > 0:
		# Lấy dữ liệu mới nhất từ moisture_sensor
		var latest_data = Manage.Terra_Status.moisture_sensor.data[-1]  # Lấy phần tử cuối cùng trong mảng data
		
		# Kiểm tra và lấy giá trị độ ẩm từ dữ liệu
		if latest_data.has("data") and latest_data["data"].has("Moisture"):
			var moisture_level = latest_data["data"]["Moisture"]
			moisture_status = moisture_level
			percent.text = str(moisture_status)+"%"
			print("Latest moisture level: ", moisture_level)
			
			# Cập nhật texture dựa trên mức độ ẩm
			if moisture_level <= threshold_dry:
				texture = DIRT  # Quá khô
				print("Moisture level is too dry. Switching to DIRT texture.")
			elif moisture_level >= threshold_wet:
				texture = DIRT_02  # Quá ngập nước
				print("Moisture level is too wet. Switching to DIRT_02 texture.")
			else:
				texture = DIRT_01  # Độ ẩm bình thường
				print("Moisture level is normal. Switching to DIRT_01 texture.")
		else:
			print("No moisture data available in the latest moisture sensor data.")
	else:
		print("No data available for moisture_sensor.")

