extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_go_devices_pressed():
	SignalControl.go_devices_menu.emit()
	pass # Replace with function body.


func _on_go_setting_pressed():
	SignalControl.go_setting_menu.emit()
	pass # Replace with function body.
