extends Sprite2D
const SUN = preload("res://resource/sun/sun.png")
const SUN_01 = preload("res://resource/sun/sun01.png")
const SUN_02 = preload("res://resource/sun/sun02.png")
const SUN_03 = preload("res://resource/sun/sun03.png")
@onready var color_rect = $ColorRect
 

var timeChange = 0.3
var current_texture_index = 0
var textures = [SUN,SUN_01, SUN_02, SUN_03]
var isActive = false
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalControl.update_Terra_Status.connect(status_update)
	var timer = Timer.new()
	timer.wait_time = timeChange  # 1 giây
	timer.one_shot = false  # Lặp lại liên tục
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()


# Hàm này sẽ được gọi mỗi khi Timer timeout
func _on_timer_timeout() -> void:
	if isActive:
		lighting()

func lighting() -> void:
	# Đổi texture sau mỗi 1 giây
	current_texture_index = (current_texture_index + 1) % textures.size()
	texture = textures[current_texture_index]

func status_update() -> void:

	# Kiểm tra xem light_sensor có tồn tại trong Manage.Terra_Status hay không
	if Manage.Terra_Status.light_sensor and Manage.Terra_Status.light_sensor.data.size() > 0:
		# Lấy dữ liệu mới nhất từ light_sensor
		var latest_data = Manage.Terra_Status.light_sensor.data[-1]  # Lấy phần tử cuối cùng trong mảng data
		
		# Kiểm tra và cập nhật biến isActive
		if latest_data.has("data") and latest_data["data"].has("isActive"):
			isActive = latest_data["data"]["isActive"]
		
		# Tìm node ColorRect
		 # Đảm bảo rằng node ColorRect nằm dưới cùng cấp với node đang xử lý script này
		
		# Nếu isActive là False, đặt màu ColorRect thành màu trắng
		if not isActive:
			color_rect.color = Color(1, 1, 1)  # Màu trắng (RGB: 1, 1, 1)
			print("isActive is False. ColorRect color set to white.")
		else:
			# Nếu isActive là True, kiểm tra và lấy màu từ dữ liệu
			if latest_data.has("data") and latest_data["data"].has("Color"):
				var color_values = latest_data["data"]["Color"]
				var color = Color(color_values[0] / 255.0, color_values[1] / 255.0, color_values[2] / 255.0)
				
				# Thay đổi màu của ColorRect
				color_rect.color = color
				print("Updated ColorRect color to: ", color)
			else:
				print("No color data available in the latest light sensor data.")
	else:
		print("No data available for light_sensor.")
	
		
