extends Control

signal game_won

# Data for each layer (temperature and thickness)
var layers_data = {
	"Core": {"temperature": "15 million °C", "thickness": "N/A"},
	"Radiative Zone": {"temperature": "7 million °C", "thickness": "300000 km"},
	"Convective Zone": {"temperature": "2 million °C", "thickness": "200000 km"},
	"Photosphere": {"temperature": "6200~3700 °C", "thickness": "500 km"},
	"Chromosphere": {"temperature": "3700~7700 °C", "thickness": "10000 km"},
	"Corona": {"temperature": "500000 °C", "thickness": "5000000 km"}
}

# Correct order for reference
var layer_order = ["Core", "Radiative Zone", "Convective Zone", "Photosphere", "Chromosphere", "Corona"]

var drop_zones = {}        # layer_name -> DropZone node
var placed_layers = {}     # layer_name -> true when correctly placed

@onready var tooltip = $Tooltip
@onready var sun_diagram = $SunDiagram

func _ready():
	# Find all drop zones and store them with their data
	for zone in get_tree().get_nodes_in_group("drop_zones"):
		drop_zones[zone.layer_name] = zone
		zone.data = layers_data[zone.layer_name]
	
	# Initialize draggable layers
	for layer in get_tree().get_nodes_in_group("layers"):
		layer.layer_data = layers_data[layer.layer_name]
		layer.layer_name = layer.layer_name
		layer.drop_attempted.connect(_on_layer_drop_attempted)
		layer.game_manager = self

# Called when a layer is dropped
func _on_layer_drop_attempted(layer, drop_zone):
	if drop_zone and not drop_zone.occupied and drop_zone.layer_name == layer.layer_name:
		# Correct placement
		layer.place_at_drop_zone(drop_zone)
		placed_layers[layer.layer_name] = true
		drop_zone.set_occupied(true)
		check_win()
	else:
		# Wrong placement or occupied zone: snap back
		layer.reset_position()

func check_win():
	if placed_layers.size() == layer_order.size():
		game_won.emit()
		sun_diagram.light_up()

# Tooltip display functions
func show_layer_tooltip(layer):
	var text = layer.layer_name + ":\n" + \
			   "Temperature: " + layer.layer_data["temperature"] + "\n" + \
			   "Thickness: " + layer.layer_data["thickness"]
	tooltip.show_text(text, get_global_mouse_position())

func show_zone_tooltip(zone):
	tooltip.show_text(zone.get_data_text(), get_global_mouse_position())

func hide_tooltip():
	tooltip.hide_tooltip()
