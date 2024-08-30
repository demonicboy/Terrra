extends Node

const url_api = "http://127.0.0.1:5000"
var access_token =""

func _ready():
	SignalControl.login_api.connect(request_devices)
	SignalControl.load_performance.connect(request_performance)
	
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed",Callable(self, "_http_request_completed"))
	#SignalControl.login_api.emit()
	## Perform a GET request. The URL below returns JSON as of writing.
	#var error = http_request.request("https://httpbin.org/get")
	#if error != OK:
		#push_error("An error occurred in the HTTP request.")

	# Perform a POST request. The URL below returns JSON as of writing.
	# Note: Don't make simultaneous requests using a single HTTPRequest node.
	# The snippet below is provided for reference only.
	var body = JSON.stringify({"username": "admin", "password": "admin"})
	var headers = ["Content-Type: application/json"]  # Thêm Content-Type header
	var error = http_request.request(url_api+"/api/login", headers, HTTPClient.METHOD_POST, body)
	
	if error != OK:
		push_error("An error occurred in the HTTP request.")


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	print("get token")
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	var response = json.get_data()
	print(response)
	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	access_token = response["access_token"]
	
	SignalControl.login_api.emit()

# Hàm gửi yêu cầu GET đến /api/devices
func request_devices():
	print("request_devices")
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_devices_request_completed"))

	# Thiết lập header với Bearer token
	var headers = ["Cookie: access_token=" + access_token]
	var error = http_request.request(url_api + "/api/devices", headers, HTTPClient.METHOD_GET)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Hàm xử lý phản hồi từ /api/devices
func _devices_request_completed(result, response_code, headers, body):
	print("get device")
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	print(json.get_data())
	if response_code == 200:
		#var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		
		print("Devices data: " + str(response["data"]))
		Manage.extract_device_data(response["data"])
		SignalControl.devices_loaded.emit()
	else:
		print("Failed to retrieve devices with response code: " + str(response_code))

func request_performanceID(index:int):
	Manage.working_on_index = index
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_request_performanceID_completed"))

	# Thiết lập header với Bearer token
	var headers = ["Cookie: access_token=" + access_token]
	print(url_api + "/api/"+Manage.devices[index].id)
	var error = http_request.request(url_api + "/api/devices/"+Manage.devices[index].id, headers, HTTPClient.METHOD_GET)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _request_performanceID_completed(result, response_code, headers, body):
	print("get performanceID")
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	print(json.get_data())
	if response_code == 200:
		#var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		
		print("Devices data: " + str(response["data"]))
		Manage.get_performanceID(Manage.working_on_index,response["data"].get("performanceID", ""))
	else:
		print("Failed to retrieve devices with response code: " + str(response_code))
	request_performance(Manage.devices[Manage.working_on_index].performanceID)

func request_performance(performanceID:String):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_request_performance_completed"))

	# Thiết lập header với Bearer token
	var headers = ["Cookie: access_token=" + access_token]
	var error = http_request.request(url_api + "/api/performances/"+performanceID, headers, HTTPClient.METHOD_GET)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _request_performance_completed(result, response_code, headers, body):
	print("Performance Info")
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	if parse_result == OK:
		var response = json.get_data()
		if response_code == 200:
			print("Devices data: " + str(response["data"]))
			
			# Clear current data in Terra_Status if necessary
			Manage.Terra_Status = Terra.new()

			# Parse the payload and update Manage.Terra_Status
			for sensor_data in response["data"]["Payload"]:
				# Get sensor name and data
				var sensor_name = sensor_data["sensor_name"]
				var data_entry = {
					"timestamp": sensor_data["timestamp"],
					"data": sensor_data["data"]
				}
				# Add data entry to the appropriate sensor in Terra_Status
				Manage.Terra_Status.add_sensor_data(sensor_name, data_entry)

			# Optional: You can print or log the entire Manage.Terra_Status to verify the data
			print("Updated Terra_Status: ", Manage.Terra_Status)
			SignalControl.update_Terra_Status.emit()
		else:
			print("Failed to retrieve devices with response code: " + str(response_code))
	else:
		print("Failed to parse JSON with error: " + str(parse_result))
