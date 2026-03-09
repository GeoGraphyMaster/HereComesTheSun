extends Area2D

signal computer_clicked

func _ready():
	print("Computer script loaded! Path: ", get_path())
	
	# Make sure it's clickable
	input_pickable = true
	
	# Connect input event
	input_event.connect(_on_input_event)
	print("Input event connected")
	
	# Connect mouse enter/exit
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	print("Mouse events connected")
	
	# Check if collision shape exists
	var collision_shape = get_node_or_null("CollisionShape2D")
	if collision_shape:
		print("Collision shape found: ", collision_shape)
	else:
		print("WARNING: No CollisionShape2D child found!")

func _on_input_event(viewport, event, shape_idx):
	print("Input event received!")  # This will show if ANY input is detected
	if event is InputEventMouseButton:
		print("Mouse button event: ", event.button_index, " pressed: ", event.pressed)
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("✅ COMPUTER CLICKED! Switching to next scene...")
			switch_to_next_scene()

func switch_to_next_scene():
	# Find the main manager and tell it to advance
	var main_manager = get_node("/root/AnalizeScene")
	if main_manager and main_manager.has_method("_on_computer_clicked"):
		main_manager._on_computer_clicked()
	else:
		print("ERROR: Could not find main manager with _on_computer_clicked method")
		# Fallback: try to call level done directly
		var scene_root = get_tree().current_scene
		if scene_root and scene_root.has_method("_on_level_done"):
			scene_root._on_level_done()

func _on_mouse_entered():
	print("Mouse entered computer area")
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	print("Mouse exited computer area")
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
