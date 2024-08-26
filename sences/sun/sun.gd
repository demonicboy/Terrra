extends Sprite2D
const SUN = preload("res://resource/sun/sun.png")
const SUN_01 = preload("res://resource/sun/sun01.png")
const SUN_02 = preload("res://resource/sun/sun02.png")
const SUN_03 = preload("res://resource/sun/sun03.png")


var timeChange = 0.3
var current_texture_index = 0
var textures = [SUN,SUN_01, SUN_02, SUN_03]
# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.wait_time = timeChange  # 1 giây
	timer.one_shot = false  # Lặp lại liên tục
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()


# Hàm này sẽ được gọi mỗi khi Timer timeout
func _on_timer_timeout() -> void:
	lighting()

func lighting() -> void:
	# Đổi texture sau mỗi 1 giây
	current_texture_index = (current_texture_index + 1) % textures.size()
	texture = textures[current_texture_index]
