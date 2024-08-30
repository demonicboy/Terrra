extends Control
const SNOW = preload("res://sences/snow/snow.tscn")

var spawn_interval = 0.5  # Bắt đầu với 0.5 giây
var min_interval = 0.1  # Thời gian ngắn nhất giữa các lần tạo hạt tuyết
var time_passed = 0.0  # Thời gian đã trôi qua

var snowing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalControl.update_Terra_Status.connect(status_update)

	set_process(true)
	var timer = Timer.new()
	add_child(timer)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not snowing:
		spawn_interval =0.5
		return
		
	time_passed += delta
	if time_passed >= spawn_interval:
		_spawn_snowflake()
		time_passed = 0.0
		spawn_interval = max(spawn_interval - 0.01, min_interval)
	pass

func _spawn_snowflake():
	var snowflake = SNOW.instantiate()
	add_child(snowflake)
	# Bạn có thể tùy chỉnh vị trí hoặc các thuộc tính khác của hạt tuyết ở đây
	#snowflake.position = Vector2(randf() * get_viewport_rect().size.x, 0)

func _on_go_devices_pressed():
	SignalControl.go_devices_menu.emit()
	pass # Replace with function body.


func _on_go_setting_pressed():
	SignalControl.go_setting_menu.emit()
	pass # Replace with function body.

func status_update()->void:
	if Manage.Terra_Status.cooler_sensor and Manage.Terra_Status.cooler_sensor.data.size() > 0:
		# Lấy dữ liệu mới nhất từ cooler_sensor
		var latest_data = Manage.Terra_Status.cooler_sensor.data[-1]  # Lấy phần tử cuối cùng trong mảng data
		# Kiểm tra và cập nhật biến isAvailable dựa trên trạng thái của pump
		if latest_data.has("data") and latest_data["data"].has("isActive"):
			var isActive = latest_data["data"]["isActive"]
			snowing = isActive
			print("Snow isActive status updated to: ", isActive)
		else:
			print("No isActive field available in the latest cooler sensor data.")
	else:
		print("No data available for cooler sensor .")


