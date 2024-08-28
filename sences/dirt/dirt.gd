extends Sprite2D
const DIRT = preload("res://resource/dirt/dirt.png")
const DIRT_01 = preload("res://resource/dirt/dirt01.png")
const DIRT_02 = preload("res://resource/dirt/dirt02.png")
var timeChange = 0.5
var current_texture_index = 0
var textures = [DIRT,DIRT_01, DIRT_02]
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalControl.update_Terra_Status.connect(status_update)
	var timer = Timer.new()
	timer.wait_time = timeChange   # 1 giây
	timer.one_shot = false  # Lặp lại liên tục
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()


# Hàm này sẽ được gọi mỗi khi Timer timeout
func _on_timer_timeout() -> void:
	wetting()

func wetting() -> void:
	# Đổi texture sau mỗi 1 giây
	current_texture_index = (current_texture_index + 1) % textures.size()

	texture = textures[current_texture_index]

func status_update()->void:
	
