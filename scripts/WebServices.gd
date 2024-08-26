extends Node

const url_api = "http://192.168.1.59"
var access_token ="eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICItZjlfc2I0WGJrRDNzRkR3cjlvZE13Z0RzMzJlMExmd0tKY0FDYjJSRlFJIn0.eyJleHAiOjE3MjQ2NzQ3NDAsImlhdCI6MTcyNDY3NDQ0MCwiYXV0aF90aW1lIjoxNzI0Njc0NDQwLCJqdGkiOiI2M2I4YmNiMy00YmVlLTRjMTYtOWJjMy00OTY4ZDg3MDk2MzQiLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjkwMDAvcmVhbG1zL1JESVBzIiwiYXVkIjpbInJlYWxtLW1hbmFnZW1lbnQiLCJicm9rZXIiLCJhY2NvdW50Il0sInN1YiI6IjMzZmY3Njk3LTRiMjgtNDQwOC04NGFjLTZlMDQ5YWRiOTBhMCIsInR5cCI6IkJlYXJlciIsImF6cCI6InJkaXBzLWNsaWVudCIsInNpZCI6IjU4MTRlZTk2LTM3MzItNDkwYy1hOTZiLTA1MjUyYjBiZGU1YiIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cDovL2xvY2FsaG9zdDo4MDgwIiwiaHR0cHM6Ly9zdW5mbG93ZXItcmRpcHMudGVjaCIsImh0dHA6Ly9sb2NhbGhvc3QiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIlVzZXIiLCJkZWZhdWx0LXJvbGVzLXN1bmZsb3dlciIsIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iLCJBZG1pbiJdfSwicmVzb3VyY2VfYWNjZXNzIjp7InJlYWxtLW1hbmFnZW1lbnQiOnsicm9sZXMiOlsidmlldy1yZWFsbSIsInZpZXctaWRlbnRpdHktcHJvdmlkZXJzIiwibWFuYWdlLWlkZW50aXR5LXByb3ZpZGVycyIsImltcGVyc29uYXRpb24iLCJyZWFsbS1hZG1pbiIsImNyZWF0ZS1jbGllbnQiLCJtYW5hZ2UtdXNlcnMiLCJxdWVyeS1yZWFsbXMiLCJ2aWV3LWF1dGhvcml6YXRpb24iLCJxdWVyeS1jbGllbnRzIiwicXVlcnktdXNlcnMiLCJtYW5hZ2UtZXZlbnRzIiwibWFuYWdlLXJlYWxtIiwidmlldy1ldmVudHMiLCJ2aWV3LXVzZXJzIiwidmlldy1jbGllbnRzIiwibWFuYWdlLWF1dGhvcml6YXRpb24iLCJtYW5hZ2UtY2xpZW50cyIsInF1ZXJ5LWdyb3VwcyJdfSwiYnJva2VyIjp7InJvbGVzIjpbInJlYWQtdG9rZW4iXX0sImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJ2aWV3LWFwcGxpY2F0aW9ucyIsInZpZXctY29uc2VudCIsInZpZXctZ3JvdXBzIiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJkZWxldGUtYWNjb3VudCIsIm1hbmFnZS1jb25zZW50Iiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBlbWFpbCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhZG1pbiJ9.sodTUUcDx94jaqtO5XQFJr5R7VSUMMVWhqjeO7d1sWTPn5_jXFX4NxqRvu-YB9Dl3xrzSdJaMJbnVTBldyn5HwDCuJLoPPENI8OEfwUn0Z6sUpm1nEv2bJIcRWHBpqXQY94dGX9-gzChQK9sHR8nC-la7uKUcQYgb2LVRL6Ilu4szRkaAnqkJMqbI6an7b4Ueb_X62qmecPmfq__Q9H5SPtYqRmGhyTTonauvjPCYhvy5y-O3v0UYXDywt3o7IaX_YMflrDjiJGTsxU-9RGGHTJrPiAfr-NDStgPJpGQl1ZekSg2Dcp31rkQxxTyZEokem3bMmEgld968z7j8b-opg"

func _ready():
	SignalControl.login_api.connect(request_devices)
	SignalControl.load_performance.connect(request_performance)
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	#http_request.connect("request_completed",Callable(self, "_http_request_completed"))
	SignalControl.login_api.emit()
	## Perform a GET request. The URL below returns JSON as of writing.
	#var error = http_request.request("https://httpbin.org/get")
	#if error != OK:
		#push_error("An error occurred in the HTTP request.")

	# Perform a POST request. The URL below returns JSON as of writing.
	# Note: Don't make simultaneous requests using a single HTTPRequest node.
	# The snippet below is provided for reference only.
	var body = JSON.stringify({"username": "admin", "password": "admin"})
	var headers = ["Content-Type: application/json"]  # Thêm Content-Type header
	var error = http_request.request(url_api+"/api/login", headers, HTTPClient.METHOD_GET, body)
	
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
	#access_token = response["access_token"]
	
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
	json.parse(body.get_string_from_utf8())
	print(json.get_data())
	if response_code == 200:
		#var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		print("Devices data: " + str(response["data"]))
	else:
		print("Failed to retrieve devices with response code: " + str(response_code))
