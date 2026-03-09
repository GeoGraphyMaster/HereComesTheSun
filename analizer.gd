extends Node2D

@onready var sun_animated_sprite = get_node("Sun/Node2D/AnimatedSprite2D")
@onready var sun_magnetogram = get_node("Sun/SunMagnetogram")
@onready var magnetic_view_button = get_node("UI/Control/PanelContainer/MagneticVeiw")

func _ready():
	magnetic_view_button.pressed.connect(_on_magnetic_view_pressed)
	sun_animated_sprite.visible = true
	sun_magnetogram.visible = false

func _on_magnetic_view_pressed():
	sun_animated_sprite.visible = not sun_animated_sprite.visible
	sun_magnetogram.visible = not sun_magnetogram.visible
