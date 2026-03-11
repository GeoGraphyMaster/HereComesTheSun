extends Control

var layers_data = {
	"Core": {"temperature": "15 million °C", "thickness": "N/A"},
	"Radiative Zone": {"temperature": "7 million °C", "thickness": "300000 km"},
	"Convective Zone": {"temperature": "2 million °C", "thickness": "200000 km"},
	"Photosphere": {"temperature": "6200~3700 °C", "thickness": "500 km"},
	"Chromosphere": {"temperature": "3700~7700 °C", "thickness": "10000 km"},
	"Corona": {"temperature": "500000 °C", "thickness": "5000000 km"}
}

@onready var info_label = $InfoLabel   # 引用屏幕上的信息显示标签

func _ready():
	# 为每个层设置数据，并传入 GameManager 引用
	for layer in get_tree().get_nodes_in_group("layers"):
		if layer.layer_name in layers_data:
			layer.layer_data = layers_data[layer.layer_name]
			layer.game_manager = self   # 让层可以调用 GameManager 的方法
		else:
			print("Warning: layer ", layer.name, " has unknown layer_name: ", layer.layer_name)

# 供 Layer 调用的方法，在屏幕上显示层信息
func display_layer_info(layer_name: String, data: Dictionary):
	var text = layer_name + ":\n" + \
			   "Temperature: " + data["temperature"] + "\n" + \
			   "Thickness: " + data["thickness"]
	info_label.text = text
