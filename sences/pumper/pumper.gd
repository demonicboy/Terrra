extends Sprite2D
var timeChange = 0.3
var isActive = false
@onready var pumper_02 = $Pumper02

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalControl.update_Terra_Status.connect(status_update)
	var timer = Timer.new()
	timer.wait_time = timeChange  # 1 giây
	timer.one_shot = false  # Lặp lại liên tục
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isActive:
		pumping()
	pass

func pumping() -> void:
	pumper_02.rotation = pumper_02.rotation+0.2

func status_update() -> void:
	# Kiểm tra xem pumper sensor có tồn tại trong Manage.Terra_Status hay không
	if Manage.Terra_Status.pump_sensor and Manage.Terra_Status.pump_sensor.data.size() > 0:
		# Lấy dữ liệu mới nhất từ pump_sensor
		var latest_data = Manage.Terra_Status.pump_sensor.data[-1]  # Lấy phần tử cuối cùng trong mảng data
		
		# Kiểm tra và cập nhật biến isActive dựa trên trạng thái của pump
		if latest_data.has("data") and latest_data["data"].has("isActive"):
			isActive = latest_data["data"]["isActive"]
			if isActive:
				print("Pump have water status updated to: ", isActive)
			else:
				print("Pump have no water status updated to: ", isActive)	
		else:
			print("No isActive field available in the latest water sensor data.")
	else:
		print("No data available for water_sensor.")
