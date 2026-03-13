extends Area2D

enum GasType { OXYGEN_GREEN, OXYGEN_RED, NITROGEN_BLUE }

@export var gas_type: GasType = GasType.OXYGEN_GREEN
var collected = false

func _ready():
	match gas_type:
		GasType.OXYGEN_GREEN:
			$Sprite2D.modulate = Color.GREEN
		GasType.OXYGEN_RED:
			$Sprite2D.modulate = Color.RED
		GasType.NITROGEN_BLUE:
			$Sprite2D.modulate = Color.BLUE
	
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.name == "Player" and not collected:
		collected = true
		var game = get_tree().current_scene
		if game and game.has_method("on_particle_collected"):
			game.on_particle_collected(self)
		queue_free()
