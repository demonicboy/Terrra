extends Node
const DeviceInfo = preload("res://scripts/device.gd").DeviceInfo

var devices = []# Mảng để lưu các đối tượng DeviceInfo
var working_on_index = 0

var Terra_Status:Terra

var threshold_cold = 20
var threshold_hot = 30

var threshold_dry = 20  # Ngưỡng dưới để xác định đất quá khô
var threshold_wet = 80  # Ngưỡng trên để xác định đất quá ngập nước

var threshold_airdry = 20  # Ngưỡng dưới để xác định đất quá khô
var threshold_airwet = 80  # Ngưỡng trên để xác định đất quá ngập nước


func extract_device_data(device_data):
	print("test")
	print(device_data)
	# Duyệt qua từng device trong JSON response
	for device in device_data:
		var device_info = DeviceInfo.new(
			device.get("id", ""),
			device.get("created_at", ""),
			device.get("updated_at", ""),
			device.get("type", ""),
			device.get("status", ""),
			device.get("life_time", ""),
			device.get("firmware_ver", 0),
			device.get("app_ver", 0),
			device.get("parentID", ""),
			device.get("name", ""),
			device.get("region", ""),
			device.get("historyID", ""),
			device.get("performanceID", "")
		)

		# Thêm đối tượng DeviceInfo vào mảng
		devices.append(device_info)

	return devices

func get_performanceID(index:int,performanceID:String):
	devices[index].performanceID = performanceID
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
