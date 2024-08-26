extends Sprite2D
const RAIN = preload("res://resource/rain/rain.png")
const RAIN_01 = preload("res://resource/rain/rain01.png")
const RAIN_02 = preload("res://resource/rain/rain02.png")
const RAIN_03 = preload("res://resource/rain/rain03.png")

var timeChange = 0.25
var current_texture_index = 0
var textures = [RAIN,RAIN_01, RAIN_02, RAIN_03]
# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.wait_time = timeChange   # 1 giây
	timer.one_shot = false  # Lặp lại liên tục
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()


# Hàm này sẽ được gọi mỗi khi Timer timeout
func _on_timer_timeout() -> void:
	raining()

func raining() -> void:
	# Đổi texture sau mỗi 1 giây
	current_texture_index = (current_texture_index + 1) % textures.size()
	if current_texture_index == 0:
		current_texture_index = 1
	texture = textures[current_texture_index]
