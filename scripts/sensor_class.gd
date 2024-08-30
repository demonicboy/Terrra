extends Resource
class_name Sensor

var sensor_name: String
var sensor_type: String
var data: Array

# Hàm khởi tạo (constructor)
func _init(sensor_name: String = "", sensor_type: String = ""):
	self.sensor_name = sensor_name
	self.sensor_type = sensor_type
	self.data = []

# Hàm để thêm dữ liệu mới và đảm bảo mảng data luôn được sắp xếp
func add_data_entry(entry: Dictionary):
	# Thêm dữ liệu mới vào mảng
	data.append(entry)
	# Sắp xếp mảng theo timestamp từ cũ tới mới
	sort_data()

func sort_data()->void:
	data.sort_custom(_compare_timestamp)
# Hàm so sánh timestamp trong entry để sắp xếp
func _compare_timestamp(a: Dictionary, b: Dictionary) -> int:
	var time_a = a["timestamp"]["$date"]["$numberLong"].to_int()
	var time_b = b["timestamp"]["$date"]["$numberLong"].to_int()
	
	if time_a < time_b:
		return -1
	elif time_a > time_b:
		return 1
	else:
		return 0
