extends Node2D

var score = 0
var max_score = 5   # Number of particles needed to finish

@onready var score_label = $CanvasLayer/ScoreLabel
@onready var message_label = $CanvasLayer/MessageLabel

func _ready():
	score_label.text = "Score: 0/" + str(max_score)

func on_particle_collected(particle):
	score += 1
	score_label.text = "Score: " + str(score) + "/" + str(max_score)
	
	# Show educational message
	var msg = ""
	match particle.gas_type:
		particle.GasType.OXYGEN_GREEN:
			msg = "Oxygen at 60 miles = Green Aurora!"
		particle.GasType.OXYGEN_RED:
			msg = "Oxygen at 150 miles = Red Aurora!"
		particle.GasType.NITROGEN_BLUE:
			msg = "Nitrogen = Blue/Purple Aurora!"
	message_label.text = msg
	await get_tree().create_timer(2.0).timeout
	message_label.text = ""
	
	# Check for game end
	if score >= max_score:
		_end_game()

func _end_game():
	message_label.text = "You lit up the sky!\nClick to learn more..."
	# Wait for click or automatically show info screen
	# You can trigger your info panel here
