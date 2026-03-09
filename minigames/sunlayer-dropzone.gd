extends ColorRect

var layer_name: String      # Set in the inspector
var data: Dictionary        # Filled by GameManager
var occupied := false

func _ready():
	add_to_group("drop_zones")
	color = Color.DARK_GRAY   # Visual cue: empty zone

func get_data_text() -> String:
	return "Temperature: " + data["temperature"] + "\nThickness: " + data["thickness"]

func set_occupied(value: bool):
	occupied = value
	if occupied:
		color = Color.GRAY   # Optional visual feedback for filled zone
