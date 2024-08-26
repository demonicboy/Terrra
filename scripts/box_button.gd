extends Button
var device_index:int

	

# Called when the node enters the scene tree for the first time.
func _ready():
	device_index = device_index
	text = Manage.devices[device_index].name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	SignalControl.load_box.emit(device_index)
	pass # Replace with function body.
