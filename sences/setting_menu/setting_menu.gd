extends Control
@onready var red_button = $VBoxContainer/HBoxContainer/red_button
@onready var green_button = $VBoxContainer/HBoxContainer/green_button
@onready var blue_button = $VBoxContainer/HBoxContainer/blue_button
@onready var on_off_button = $VBoxContainer/HBoxContainer/on_off_button
@onready var light_color = $VBoxContainer/HBoxContainer/light_color

@onready var moisture_high = $VBoxContainer/HBoxContainer5/moisture_high
@onready var moisture_low = $VBoxContainer/HBoxContainer5/moisture_low
@onready var humid_high = $VBoxContainer/HBoxContainer4/humid_high
@onready var humid_low = $VBoxContainer/HBoxContainer4/humid_low
@onready var temperature_hot = $VBoxContainer/HBoxContainer3/temperature_hot
@onready var temperature_cold = $VBoxContainer/HBoxContainer3/temperature_cold
@onready var pump_on = $VBoxContainer/HBoxContainer2/pump_on
@onready var cooler_on = $VBoxContainer/HBoxContainer2/cooler_on

var light_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	load_setting()
	_on_on_off_button_pressed()
	SignalControl.re_render_lightColor.connect(render_color)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_apply_button_pressed():
	# Lấy trạng thái của Light, Pump, Cooler
	var red_value = 0
	var green_value = 0
	var blue_value = 0

	if red_button.is_On:
		red_value = 255

	if green_button.is_On:
		green_value = 255

	if blue_button.is_On:
		blue_value = 255

	var light_data = {
		"isActive": on_off_button.button_pressed,
		"Color": [red_value, green_value, blue_value]
	}
	var pump_data = {
		"isActive": pump_on.button_pressed
	}
	var cooler_data = {
		"isActive": cooler_on.button_pressed
	}

	# Cập nhật trạng thái vào Terra_Status
	var timestamp_ms
	if Manage.Terra_Status:
		timestamp_ms = int(Time.get_unix_time_from_system() * 1000)  # Chuyển Unix timestamp từ giây sang milliseconds và định dạng thành số nguyên
	print("apply time:", timestamp_ms)
	Manage.Terra_Status.light_sensor.add_data_entry({
		"timestamp": {"$date": {"$numberLong": str(timestamp_ms)}},  # Định dạng timestamp giống như định dạng mà server yêu cầu
		"data": light_data
	})
	Manage.Terra_Status.pump_sensor.add_data_entry({
		"timestamp": {"$date": {"$numberLong": str(timestamp_ms)}},  # Định dạng timestamp giống như định dạng mà server yêu cầu
		"data": pump_data
	})
	Manage.Terra_Status.cooler_sensor.add_data_entry({
		"timestamp": {"$date": {"$numberLong": str(timestamp_ms)}},  # Định dạng timestamp giống như định dạng mà server yêu cầu
		"data": cooler_data
	})

	# Cập nhật thresholds trong Manage
	Manage.threshold_hot = temperature_hot.text.to_int()
	Manage.threshold_cold = temperature_cold.text.to_int()
	Manage.threshold_airwet = humid_high.text.to_int()
	Manage.threshold_airdry = humid_low.text.to_int()
	Manage.threshold_wet = moisture_high.text.to_int()
	Manage.threshold_dry = moisture_low.text.to_int()
	
	
	print("Settings have been applied.")
	Manage.Terra_Status.sort_data()
	SignalControl.update_Terra_Status.emit()
	queue_free()
	pass # Replace with function body.


func _on_on_off_button_pressed():
	light_on = on_off_button.button_pressed
	if !light_on:
		deactive_light()
	else:
		active_light()
	pass # Replace with function body.

func deactive_light()->void:
	red_button.call_disable()
	green_button.call_disable()
	blue_button.call_disable()

func active_light()->void:
	red_button.call_active()
	green_button.call_active()
	blue_button.call_active()
	render_color()
	
func render_color()->void:
	var render_:Color = Color(0,0,0,1)
	if red_button.is_On:
		render_.r = 1
	if green_button.is_On:
		render_.g = 1
	if blue_button.is_On:
		render_.b = 1
	light_color.color = render_


func load_setting()->void:
	load_light()
	load_pump()
	load_cooler()
	load_threshold()
	pass
	
func load_light()->void:
	if Manage.Terra_Status.light_sensor and Manage.Terra_Status.light_sensor.data.size() > 0:
		var latest_data = Manage.Terra_Status.light_sensor.data[-1]  # Lấy phần tử cuối cùng trong mảng data
		if latest_data.has("data") and latest_data["data"].has("isActive"):
			light_on = latest_data["data"]["isActive"]
			on_off_button.button_pressed = light_on
		if latest_data.has("data") and latest_data["data"].has("Color"):
			var color_values = latest_data["data"]["Color"]
			red_button.is_On = color_values[0] > 200
			green_button.is_On = color_values[1] > 200
			blue_button.is_On = color_values[2] > 200
	else:
		print("No data available for light_sensor.")

func load_pump()->void:
	if Manage.Terra_Status.pump_sensor and Manage.Terra_Status.pump_sensor.data.size() > 0:
		var latest_data = Manage.Terra_Status.pump_sensor.data[-1] 
		if latest_data.has("data") and latest_data["data"].has("isActive"):
			var isActive = latest_data["data"]["isActive"]
			pump_on.button_pressed = isActive
		else:
			print("No isActive field available in the latest water sensor data.")
	else:
		print("No data available for water_sensor.")

func load_cooler()->void:
	if Manage.Terra_Status.cooler_sensor and Manage.Terra_Status.cooler_sensor.data.size() > 0:
		var latest_data = Manage.Terra_Status.cooler_sensor.data[-1] 
		if latest_data.has("data") and latest_data["data"].has("isActive"):
			var isActive = latest_data["data"]["isActive"]
			cooler_on.button_pressed = isActive
		else:
			print("No isActive field available in the latest cooler sensor data.")
	else:
		print("No data available for cooler sensor.")
		
func load_threshold()->void:
	moisture_high.text = str(Manage.threshold_wet)
	moisture_low.text = str(Manage.threshold_dry)
	humid_high.text = str(Manage.threshold_airwet)
	humid_low.text = str(Manage.threshold_airdry)
	temperature_hot.text = str(Manage.threshold_hot)
	temperature_cold.text = str(Manage.threshold_cold)

