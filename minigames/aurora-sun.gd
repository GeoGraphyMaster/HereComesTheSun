extends Area2D

signal launched(start_pos, velocity)

var dragging = false
var drag_start = Vector2.ZERO
var drag_current = Vector2.ZERO

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# 开始拖拽
			dragging = true
			drag_start = get_global_mouse_position()
		else:
			# 结束拖拽
			if dragging:
				dragging = false
				drag_current = get_global_mouse_position()
				var launch_vector = drag_start - drag_current
				# 限制最大发射速度
				if launch_vector.length() > 300:
					launch_vector = launch_vector.normalized() * 300
				emit_signal("launched", drag_start, launch_vector)

func _process(delta):
	if dragging:
		drag_current = get_global_mouse_position()
		queue_redraw()  # 请求重绘（Godot 4 中用 queue_redraw，Godot 3 用 update）

func _draw():
	if dragging:
		# 绘制从太阳到鼠标的连线
		draw_line(drag_start - global_position, drag_current - global_position, Color.YELLOW, 2)
