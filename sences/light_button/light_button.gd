extends ColorRect

var disable = false
var is_On = false
var color_button:Color

# Called when the node enters the scene tree for the first time.
func _ready():
	color_button = color
	if is_On:
		color_button.a = 1
	else:
		color_button.a =0.2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func call_disable()->void:
	disable = true
	color = Color.BLACK


func call_active()->void:
	disable = false
	color = color_button
	_correct_color()


func _on_gui_input(event):
	if not (event is InputEventMouseButton and event.pressed):
		return
	if disable:
		return
	is_On = !is_On
	
	_correct_color()

func _correct_color()->void:
	if is_On:
		color_button.a = 1
	else:
		color_button.a =0.2
	color =color_button
	SignalControl.re_render_lightColor.emit()
	pass # Replace with function body.
