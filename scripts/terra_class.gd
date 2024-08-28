extends Resource
class_name Terra

# Khai báo các sensor
var dht_sensor: Sensor
var pump_sensor: Sensor
var valve_sensor: Sensor
var light_sensor: Sensor
var moisture_sensor: Sensor
var water_sensor: Sensor

# Hàm khởi tạo (constructor)
func _init():
	# Khởi tạo các sensor với tên và loại tương ứng
	dht_sensor = Sensor.new("dht", "DHT")
	pump_sensor = Sensor.new("pumpRelay", "Pump")
	valve_sensor = Sensor.new("valveRelay", "Valve")
	light_sensor = Sensor.new("Light", "Light")
	moisture_sensor = Sensor.new("Moisture", "Moisture")
	water_sensor = Sensor.new("Water", "Water")

# Hàm để thêm dữ liệu cho từng sensor (tên sensor và dữ liệu cần thêm)
func add_sensor_data(sensor_name: String, data: Dictionary):
	match sensor_name:
		"dht":
			dht_sensor.add_data_entry(data)
		"pumpRelay":
			pump_sensor.add_data_entry(data)
		"valveRelay":
			valve_sensor.add_data_entry(data)
		"Light":
			light_sensor.add_data_entry(data)
		"Moisture":
			moisture_sensor.add_data_entry(data)
		"Water":
			water_sensor.add_data_entry(data)
		_:
			print("Sensor name not recognized: ", sensor_name)
