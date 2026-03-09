extends Label

func _ready():
	visible = false

func show_text(text: String, position: Vector2):
	self.text = text
	global_position = position + Vector2(10, 10)   # Offset so it doesn't hide the mouse
	visible = true

func hide_tooltip():
	visible = false
