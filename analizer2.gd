extends Node2D

var current_level = 0
var current_game = null

@onready var game_container = $MiniGameContainer
@onready var mission_label = $UI/Control/MissionLabel

func _ready():
	print("\n\n=================================")
	print("=== MAIN MANAGER STARTED ===")
	print("=================================")
	load_level()

func load_level():
	print("\n--- LOADING LEVEL ", current_level, " ---")
	
	# Remove old game
	if current_game:
		print("Removing previous game: ", current_game.name)
		current_game.queue_free()
		current_game = null
	
	# Load next game
	var path = ""
	match current_level:
		0:
			path = "res://minigames/SunspotMemory.tscn"
			mission_label.text = "Find the 6 sunspots"
		1:
			path = "res://minigames/ReserchSummery.tscn"
			mission_label.text = "Sunspot Research - Click computer to continue"
		2:
			path = "res://minigames/SolarFlare.tscn"
			mission_label.text = "Click the sun to trigger flare"
		3:
			path = "res://minigames/ReserchSummery.tscn"
			mission_label.text = "Flare Research - Click computer to continue"
		4:
			mission_label.text = "Research Complete!"
			print("All done!")
			return
	
	# Check if file exists
	if not FileAccess.file_exists(path):
		print("ERROR: File not found: ", path)
		return
	
	# Create game
	var scene = load(path)
	current_game = scene.instantiate()
	game_container.add_child(current_game)
	
	# Wait for scene to initialize
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Connect signals based on game type
	if current_level in [0, 2]: # Game levels
		print("Game level - connecting phase_completed")
		if current_game.has_signal("phase_completed"):
			current_game.phase_completed.connect(_on_level_done)
	else: # Summary levels (1 and 3)
		print("Summary level - setting up")
		
		# Set the UI text
		var ui_node = find_canvas_layer(current_game)
		if ui_node and ui_node.has_method("set_phase"):
			var phase_index = 0 if current_level == 1 else 1
			ui_node.set_phase(phase_index)
		
		# Connect to computer - this will advance the phase when clicked
		connect_to_computer()

func find_canvas_layer(node):
	if node is CanvasLayer:
		return node
	for child in node.get_children():
		var result = find_canvas_layer(child)
		if result:
			return result
	return null

func connect_to_computer():
	if not current_game:
		return
	
	print("\n🔍 Connecting to computer...")
	
	# Look for the Computer Area2D at root level (based on your hierarchy)
	for child in current_game.get_children():
		if child.name == "Computer" and child is Area2D:
			print("✅ Found Computer Area2D: ", child.name)
			
			# Connect to its computer_clicked signal
			if child.has_signal("computer_clicked"):
				if not child.computer_clicked.is_connected(_on_computer_clicked):
					child.computer_clicked.connect(_on_computer_clicked)
					print("✅ Connected! Clicking computer will now advance to next phase")
				return
	
	# Fallback: search all nodes
	var computer = find_node_with_signal(current_game, "computer_clicked")
	if computer:
		print("✅ Found computer with signal: ", computer.name)
		if not computer.computer_clicked.is_connected(_on_computer_clicked):
			computer.computer_clicked.connect(_on_computer_clicked)
			print("✅ Connected!")
	else:
		print("❌ No computer found!")

func find_node_with_signal(node, signal_name):
	if node.has_signal(signal_name):
		return node
	for child in node.get_children():
		var result = find_node_with_signal(child, signal_name)
		if result:
			return result
	return null

func _on_computer_clicked():
	print("\n✅✅✅ COMPUTER CLICKED! Moving to next phase ✅✅✅")
	_on_level_done()

func _on_level_done():
	print("Phase complete! Moving to next level: ", current_level + 1)
	current_level += 1
	load_level()
