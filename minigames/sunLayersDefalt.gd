extends Control

@onready var label = $CanvasLayer/LayerNameLabel

func _ready():
	label.text = ""
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_font_size_override("font_size", 100)
	label.position = Vector2(200, 200)
	print("done")

	for layer in get_tree().get_nodes_in_group("layers"):
		layer.game_manager = self

func on_layer_placed(layer_name: String):
	
	print("original: '", layer_name, "', length: ", layer_name.length())
	
	
	var cleaned = layer_name.strip_edges()
	print("cleaned: '", cleaned, "', length: ", cleaned.length())
	
	
	var lower = cleaned.to_lower()
	
	if lower == "corona":
		label.text = "Corona"
	elif lower == "chromosphere":
		label.text = "Chromosphere"
	elif lower == "photosphere":
		label.text = "Photosphere"
	elif lower == "convective zone":
		label.text = "Convective Zone"
	elif lower == "radiative zone":
		label.text = "Radiative Zone"
	elif lower == "core":
		label.text = "Core"
	else:
		label.text = "error: " + cleaned   
		print("nothing: ", cleaned)
	
