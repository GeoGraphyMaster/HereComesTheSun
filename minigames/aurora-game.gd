extends Node2D

var score = 0
var max_score = 5

func _ready():
	$CanvasLayer/ScoreLabel.text = "Score: 0/" + str(max_score)

func on_particle_collected(particle):
	score += 1
	$CanvasLayer/ScoreLabel.text = "Score: " + str(score) + "/" + str(max_score)
	
	var msg = ""
	match particle.gas_type:
		particle.GasType.OXYGEN_GREEN:
			msg = "Oxygen（60 mi）→ Green Aurora"
		particle.GasType.OXYGEN_RED:
			msg = "Oxygen（150 mi）→ Red Aurora"
		particle.GasType.NITROGEN_BLUE:
			msg = "Nitrogen → Blue/Purple Aurora"
	
	$CanvasLayer/MessageLabel1.text = msg
	await get_tree().create_timer(2.0).timeout
	$CanvasLayer/MessageLabel1.text = ""
	
	if score >= max_score:
		_end_game()

func _end_game():
	$CanvasLayer/MessageLabel1.text = "You lighted the sky up!"
