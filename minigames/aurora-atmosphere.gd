extends Area2D

enum GasType { OXYGEN_GREEN, OXYGEN_RED, NITROGEN_BLUE }

@export var gas_type: GasType = GasType.OXYGEN_GREEN
var collected = false

func _ready():
	# Set color based on type (optional, if not set by sprite)
	match gas_type:
		GasType.OXYGEN_GREEN:
			$Sprite2D.modulate = Color.GREEN
		GasType.OXYGEN_RED:
			$Sprite2D.modulate = Color.RED
		GasType.NITROGEN_BLUE:
			$Sprite2D.modulate = Color.BLUE
	
	# Connect body_entered
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" and not collected:
		collected = true
		# Update score and show message
		var game = get_node("/root/AuroraGame") # or use an autoload
		game.on_particle_collected(self)
		# Hide or queue free
		queue_free()
