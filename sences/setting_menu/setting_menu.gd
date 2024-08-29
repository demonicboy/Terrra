extends Control
@onready var red_button = $VBoxContainer/HBoxContainer/red_button
@onready var green_button = $VBoxContainer/HBoxContainer/green_button
@onready var blue_button = $VBoxContainer/HBoxContainer/blue_button
@onready var on_off_button = $VBoxContainer/HBoxContainer/on_off_button
@onready var light_color = $VBoxContainer/HBoxContainer/light_color



var light_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_on_off_button_pressed()
	SignalControl.re_render_lightColor.connect(render_color)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_apply_button_pressed():
	
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


