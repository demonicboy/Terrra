class DeviceInfo:
	var id: String
	var created_at: String
	var updated_at: String
	var type: String
	var status: String
	var life_time: String
	var firmware_ver: int
	var app_ver: int
	var parentID: String
	var name: String
	var region: String
	var historyID: String
	var performanceID: String

	# Constructor để khởi tạo đối tượng DeviceInfo
	func _init(id: String, created_at: String, updated_at: String, type: String, status: String, life_time: String, firmware_ver: int, app_ver: int, parentID: String, name: String, region: String, historyID: String, performanceID: String):
		self.id = id
		self.created_at = created_at
		self.updated_at = updated_at
		self.type = type
		self.status = status
		self.life_time = life_time
		self.firmware_ver = firmware_ver
		self.app_ver = app_ver
		self.parentID = parentID
		self.name = name
		self.region = region
		self.historyID = historyID
		self.performanceID = performanceID
