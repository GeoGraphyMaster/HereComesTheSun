extends Node2D

signal computer_clicked

@onready var ui_container = $UI  # Adjust path to your UI container
@onready var hide_button = $UI/HideButton  # Adjust path to your button

func _ready():
	if hide_button:
		hide_button.pressed.connect(_on_hide_button_pressed)

func _on_hide_button_pressed():
	print("Hide button clicked - hiding UI")
	
	if ui_container:
		ui_container.visible = false
		
	# Optional: Show a message that UI is hidden
	print("Research UI hidden")
	
	# If you want to show it again after some time or action:
	# await get_tree().create_timer(3.0).timeout
	# ui_container.visible = true

# Optional: Function to show UI again
func show_ui():
	if ui_container:
		ui_container.visible = true
