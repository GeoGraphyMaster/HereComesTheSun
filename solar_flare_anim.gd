extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

var has_played: bool = false

func _ready():

	area.connect("input_event", Callable(self, "_on_area_input_event"))

func _on_area_input_event(viewport, event, shape_idx):
	if has_played:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			sprite.play("default")  
			has_played = true

			await get_tree().create_timer(8).timeout
			sprite.stop()
			sprite.frame = 2
