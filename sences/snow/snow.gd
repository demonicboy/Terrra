extends Sprite2D

const SNOW_IMAGES = [
	preload("res://resource/snow/snow01.png"),
	preload("res://resource/snow/snow02.png"),
	preload("res://resource/snow/snow03.png"),
	preload("res://resource/snow/snow04.png"),
	preload("res://resource/snow/snow05.png"),
	preload("res://resource/snow/snow06.png")
]

# Điểm A và B xác định phạm vi xuất hiện của hạt tuyết
var point_a = Vector2(0, 200)
var point_b = Vector2(400, 300)

var speed = Vector2(randf_range(-20,20), randf_range(40,80))  # Tốc độ di chuyển theo trục y (có thể tùy chỉnh)
var rotation_speed = randf_range(-1,1) # Tốc độ xoay của hạt tuyết (có thể tùy chỉnh)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Chọn ngẫu nhiên một hình tuyết
	texture = SNOW_IMAGES[int(randf() * SNOW_IMAGES.size())]
	
	# Đặt vị trí ngẫu nhiên trong phạm vi từ điểm A đến điểm B
	position = Vector2(
		randf_range(point_a.x, point_b.x),
		randf_range(point_a.y, point_b.y)
	)
	
	# Đặt xoay ngẫu nhiên ban đầu cho hạt tuyết
	rotation = randf() * PI * 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Xoay hạt tuyết
	rotation += rotation_speed * delta
	
	# Di chuyển hạt tuyết xuống dưới
	position += speed * delta
	
	# Nếu hạt tuyết đi ra khỏi màn hình, xóa nó
	if position.y > get_viewport_rect().size.y:
		queue_free()
