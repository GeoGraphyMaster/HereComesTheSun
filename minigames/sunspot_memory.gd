extends Node2D

signal phase_completed

# Exactly 6 specific sunspots - no randomization!
var special_grids = ["Grid4", "Grid6", "Grid8", "Grid11", "Grid16", "Grid14", "Grid18", "Grid9"]
var clicked_grids = []
var attempts = 5
var game_active = true
var total_sunspots = 5

# Get references to the main scene's UI
@onready var main_scene = get_node("/root/AnalizeScene")
@onready var mission_label = main_scene.get_node("UI/Control/MissionLabel")
@onready var warning_label = main_scene.get_node("UI/Control/WarningLabel")
@onready var remaining_label = main_scene.get_node("UI/Control/RemainingAttempts")

# Don't store these as @onready - get them fresh each time
var grid_collision_shapes = []

func _ready():
	print("=== SUNSPOT MEMORY DEBUG ===")
	print("Sunspots to find: ", special_grids)
	
	# Find all grid collision shapes
	var sun_area = $Sun/Area2D
	if sun_area:
		for child in sun_area.get_children():
			if child is CollisionShape2D:
				grid_collision_shapes.append(child)
				print("Found grid: " + child.name + " at position: " + str(child.position))
	
	print("Total grids found: ", grid_collision_shapes.size())
	print("============================")
	
	# Update the main scene's UI
	update_attempts_display()
	if mission_label:
		mission_label.text = "Find " + str(total_sunspots) + " sunspots!"
	if warning_label:
		warning_label.text = ""

func _input(event):
	if not game_active or not event is InputEventMouseButton:
		return
		
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("\n--- CLICK DETECTED ---")
		print("Global click: ", event.global_position)
		
		# Get fresh reference to Sun node
		var current_sun_node = $Sun
		if current_sun_node and current_sun_node is Node2D:
			var local_click = current_sun_node.to_local(event.global_position)
			print("Local click (relative to Sun): ", local_click)
			check_click(local_click)
		else:
			print("ERROR: Cannot find Sun node! Current scene root children:")
			for child in get_children():
				print("  - ", child.name, " (", child.get_class(), ")")

func check_click(click_pos):
	var closest_grid = null
	var closest_distance = 50  # Threshold
	
	for grid in grid_collision_shapes:
		var distance = grid.position.distance_to(click_pos)
		if distance < closest_distance:
			closest_distance = distance
			closest_grid = grid.name
	
	if closest_grid:
		print("✅ GRID ACCEPTED: ", closest_grid, " (distance: ", closest_distance, ")")
		process_grid_click(closest_grid)
	else:
		print("❌ No grid within threshold. Closest was ", closest_distance, " pixels")

func process_grid_click(grid_name: String):
	print("Processing: " + grid_name)
	
	if grid_name in special_grids:
		if not grid_name in clicked_grids:
			clicked_grids.append(grid_name)
			update_attempts_display()
			
			if warning_label:
				warning_label.text = "Correct! (" + str(clicked_grids.size()) + "/" + str(total_sunspots) + ")"
				warning_label.modulate = Color(0, 1, 0)
			
			if clicked_grids.size() == total_sunspots:
				game_over(true)
		else:
			if warning_label:
				warning_label.text = "Already found!"
				warning_label.modulate = Color(1, 1, 0)
	else:
		attempts -= 1
		update_attempts_display()
		
		if warning_label:
			warning_label.text = "Wrong! (" + str(attempts) + " attempts left)"
			warning_label.modulate = Color(1, 0, 0)
		
		if attempts <= 0:
			game_over(false)

func update_attempts_display():
	if remaining_label:
		remaining_label.text = "Spots found: " + str(clicked_grids.size()) + "/" + str(total_sunspots)

func game_over(success):
	game_active = false
	
	if success:
		if mission_label:
			mission_label.text = "All " + str(total_sunspots) + " Sunspots Found!"
		if warning_label:
			warning_label.text = ""
		await get_tree().create_timer(2.0).timeout
		phase_completed.emit()
	else:
		if mission_label:
			mission_label.text = "Too many wrong clicks!"
		if warning_label:
			warning_label.text = "Restarting..."
		await get_tree().create_timer(2.0).timeout
		restart_game()

func restart_game():
	clicked_grids.clear()
	attempts = 5
	game_active = true
	update_attempts_display()
	if mission_label:
		mission_label.text = "Find " + str(total_sunspots) + " sunspots!"
	if warning_label:
		warning_label.text = ""
