extends TextureRect

signal drop_attempted(layer, drop_zone)

var layer_name: String          # Set in the inspector
var layer_data: Dictionary      # Filled by GameManager
var game_manager: Node          # Set by GameManager

var dragging := false
var drag_offset := Vector2.ZERO
var original_position := Vector2.ZERO
var current_drop_zone = null

func _ready():
	custom_minimum_size = Vector2(100, 100)   
	mouse_filter = Control.MOUSE_FILTER_STOP
	print(name, " global position: ", global_position, " size: ", size)
	original_position = global_position
	mouse_filter = Control.MOUSE_FILTER_STOP   # Receive input even when over other controls
	add_to_group("layers")
	modulate = Color.GRAY   # Make it gray initially

func _gui_input(event):
	print("_gui_input received: ", event)  # 添加这一行
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("Mouse button pressed")  # 确认按下
			_start_drag()
		else:
			if dragging:
				print("Mouse button released")
				_end_drag()
		accept_event()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_drag()
		else:
			if dragging:
				_end_drag()
		accept_event()

func _start_drag():
	if not game_manager:
		print("ERROR: game_manager is null in _start_drag()")
		return
	dragging = true
	drag_offset = get_global_mouse_position() - global_position
	z_index = 100
	game_manager.show_layer_tooltip(self)
	dragging = true
	drag_offset = get_global_mouse_position() - global_position
	z_index = 100   # Bring to front
	game_manager.show_layer_tooltip(self)

func _end_drag():
	dragging = false
	z_index = 0
	game_manager.hide_tooltip()
	var drop_zone = _get_drop_zone_under_mouse()
	drop_attempted.emit(self, drop_zone)

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() - drag_offset
		var zone = _get_drop_zone_under_mouse()
		if zone != current_drop_zone:
			current_drop_zone = zone
			if zone:
				game_manager.show_zone_tooltip(zone)
			else:
				game_manager.show_layer_tooltip(self)

# Find an unoccupied drop zone under the mouse
func _get_drop_zone_under_mouse():
	var mouse_pos = get_global_mouse_position()
	for zone in get_tree().get_nodes_in_group("drop_zones"):
		if zone.occupied:
			continue
		if zone.get_global_rect().has_point(mouse_pos):
			return zone
	return null

# Called when correctly placed
func place_at_drop_zone(zone):
	global_position = zone.global_position
	mouse_filter = Control.MOUSE_FILTER_IGNORE   # Disable further dragging
	modulate = Color.WHITE   # Show that it's placed

# Return to original position (used on wrong drop)
func reset_position():
	global_position = original_position
