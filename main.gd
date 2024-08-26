extends Control
const DeviceInfo = preload("res://scripts/device.gd").DeviceInfo
const LIST_BOX = preload("res://sences/listbox/list_box.tscn")
const BOX_BUTTON = preload("res://sences/listbox/box_button.tscn")
const TERRARIUM_BOX = preload("res://sences/terrariumbox/terrarium_box.tscn")

# Called when the node enters the scene tree for the first time.
var list_sence
var terra_sence
func _ready():
	SignalControl.devices_loaded.connect(load_devices)
	SignalControl.load_box.connect(load_box)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_devices()->void:
	list_sence = LIST_BOX.instantiate()
	
	var vbox_container = list_sence.get_node("VBoxContainer")
	for index in Manage.devices.size():
		var button_ = BOX_BUTTON.instantiate()
		button_.device_index = index
		vbox_container.add_child(button_)
	add_child(list_sence)
	pass

func load_box(index:int)->void:
	WebServices.request_performanceID(index)
	if list_sence:
		list_sence.queue_free()
	terra_sence = TERRARIUM_BOX.instantiate()
	add_child(terra_sence)
