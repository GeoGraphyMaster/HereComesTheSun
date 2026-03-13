extends Area2D

signal launched(start_pos, velocity)

var dragging = false
var drag_start = Vector2.ZERO
var drag_current = Vector2.ZERO

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_start = get_global_mouse_position()
		else:
			if dragging:
				dragging = false
				drag_current = get_global_mouse_position()
				var launch_vector = drag_start - drag_current
				if launch_vector.length() > 300:
					launch_vector = launch_vector.normalized() * 300
				emit_signal("launched", drag_start, launch_vector)

func _process(delta):
	if dragging:
		drag_current = get_global_mouse_position()
		queue_redraw()

func _draw():
	if dragging:
		draw_line(drag_start - global_position, drag_current - global_position, Color.YELLOW, 2)
