extends Area2D

var velocity = Vector2.ZERO
var speed = 400.0

func _ready():
	# 连接太阳发射信号
	var sun = get_node("../Sun")
	sun.launched.connect(_on_sun_launched)

func _on_sun_launched(start_pos, vel):
	global_position = start_pos
	velocity = vel

func _process(delta):
	# 始终跟随鼠标移动
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	velocity = direction * speed
	global_position += velocity * delta
	
	# 可选：限制在屏幕内（避免跑出视野）
	var viewport = get_viewport_rect().size
	global_position = global_position.clamp(Vector2.ZERO, viewport)
