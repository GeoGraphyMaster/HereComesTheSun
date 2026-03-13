extends TextureRect

var dragging := false
var drag_offset := Vector2.ZERO
var original_position := Vector2.ZERO

var game_manager: Node

func _ready():
	original_position = global_position
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_to_group("layers")

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_drag()
		else:
			if dragging:
				_end_drag()
		accept_event()

func _start_drag():
	dragging = true
	drag_offset = get_global_mouse_position() - global_position
	z_index = 100
	if game_manager:
		game_manager.dragging_active = true

func _end_drag():
	dragging = false
	z_index = 0
	if game_manager:
		game_manager.dragging_active = false
	var drop_zone = _get_drop_zone_under_mouse()
	if drop_zone:
		# 放入放置区，吸附到中心
		global_position = drop_zone.global_position
		# 通知 GameManager 显示当前层的名称
		if game_manager:
			game_manager.display_layer_name(layer_name)
	else:
		# 放回原位
		global_position = original_position

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() - drag_offset

func _get_drop_zone_under_mouse():
	var mouse_pos = get_global_mouse_position()
	for zone in get_tree().get_nodes_in_group("drop_zones"):
		if zone.get_global_rect().has_point(mouse_pos):
			return zone
	return null
