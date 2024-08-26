extends Node

const url_api = "http://127.0.0.1:5000"
var access_token =""
func _ready():
	SignalControl.login_api.connect(request_devices)
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed",Callable(self, "_http_request_completed"))

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
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	access_token = response["access_token"]
	SignalControl.login_api.emit()

# Hàm gửi yêu cầu GET đến /api/devices
func request_devices():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_devices_request_completed"))

	# Thiết lập header với Bearer token
	var headers = ["Authorization: Bearer " + access_token]
	var error = http_request.request(url_api + "/api/devices", headers, HTTPClient.METHOD_GET)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Hàm xử lý phản hồi từ /api/devices
func _devices_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		
		print("Devices data: " + str(response["data"]))
		Manage.extract_device_data(response["data"])
		SignalControl.devices_loaded.emit()
	else:
		print("Failed to retrieve devices with response code: " + str(response_code))

