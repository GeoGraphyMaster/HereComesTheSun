extends Node2D

signal phase_completed

# Paths relative to Sun node (where this script is attached)
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D
@onready var camera = $"../Camera2D"  # Go up one level to SolarFlare root, then to Camera2D

var has_played: bool = false
var game_active = false

func _ready():
	print("Solar Flare: Script loaded on Sun node")
	
	# Hide main scene sun
	hide_main_sun()
	
	# Setup area
	if area:
		area.input_event.connect(_on_area_input_event)
		area.input_pickable = true
		print("Solar Flare: Area connected")
	else:
		print("Solar Flare: ERROR - Area not found")
	
	# Start camera movement
	start_camera_move()
	
	# Hide any UI elements in this scene
	hide_scene_ui()

func hide_main_sun():
	var main_scene = get_node("/root/AnalizeScene")
	if main_scene:
		var main_sun = main_scene.get_node_or_null("Sun/Node2D/AnimatedSprite2D")
		var main_mag = main_scene.get_node_or_null("Sun/SunMagnetogram")
		var main_cross = main_scene.get_node_or_null("Sun/SunCrossSection")
		
		if main_sun:
			main_sun.visible = false
		if main_mag:
			main_mag.visible = false
		if main_cross:
			main_cross.visible = false
		
		print("Solar Flare: Main sun hidden")

func hide_scene_ui():
	# Hide any UI elements in this scene (go up to root first)
	var root = $".."
	if root:
		var ui_node = root.get_node_or_null("UI")
		if ui_node:
			ui_node.visible = false
			print("Solar Flare: Scene UI hidden")

func start_camera_move():
	if not camera:
		print("Solar Flare: ERROR - Camera not found! Looking at: ../Camera2D")
		return
		
	print("Solar Flare: Starting camera move")
	print("Camera starting zoom: ", camera.zoom)
	print("Camera starting position: ", camera.position)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(camera, "zoom", Vector2(0.1, 0.1), 2.0)
	tween.tween_property(camera, "position", Vector2(0, 0), 1.5)
	
	await tween.finished
	
	print("Solar Flare: Camera ready at zoom: ", camera.zoom)
	game_active = true
	print("Solar Flare: Now click the sun!")

func _on_area_input_event(viewport, event, shape_idx):
	if not game_active or has_played:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Solar Flare: Sun clicked!")
			trigger_flare()

func trigger_flare():
	print("SOLAR FLARE TRIGGERED!")
	game_active = false
	has_played = true
	
	if sprite:
		print("Solar Flare: Playing animation")
		sprite.play("default")
		await sprite.animation_finished
		print("Solar Flare: Animation finished")
		
		# Wait then complete
		await get_tree().create_timer(1.0).timeout
		
		# Show main sun again
		show_main_sun()
		
		print("Solar Flare: Phase complete")
		phase_completed.emit()
	else:
		print("Solar Flare: ERROR - Sprite not found!")

func show_main_sun():
	var main_scene = get_node("/root/AnalizeScene")
	if main_scene:
		var main_sun = main_scene.get_node_or_null("Sun/Node2D/AnimatedSprite2D")
		if main_sun:
			main_sun.visible = true
			print("Solar Flare: Main sun shown")

func _exit_tree():
	show_main_sun()
