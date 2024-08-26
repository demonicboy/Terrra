extends Node
const DeviceInfo = preload("res://scripts/device.gd").DeviceInfo

var devices = []# Mảng để lưu các đối tượng DeviceInfo

func extract_device_data(device_data):
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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
