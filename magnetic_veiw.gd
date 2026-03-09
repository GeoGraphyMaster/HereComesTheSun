extends Button

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	var manager = get_node("/root/AnalizeScene/Sun/sun_view_manager")
	if manager:
		manager.toggle_magnetic()
	else:
		print("ERROR: Sun view manager not found")
